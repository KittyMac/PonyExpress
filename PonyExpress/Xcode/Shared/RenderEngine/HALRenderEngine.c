#include "HALRenderEngine.h"
#include <string.h>
#include <unistd.h>
#include <pthread.h>

#define RESOLVE_CONTEXT() { if(context == NULL) { context = sharedContext; if (sharedContext == NULL) { return; } } }
#define RESOLVE_CONTEXT_RET(x) { if(context == NULL) { context = sharedContext; if (sharedContext == NULL) { return (x); } } }

#define FENCE_FOR_RENDERER() while(ctx->_getTextureInfo == NULL) { usleep(500); }

static HALRenderContext * sharedContext = NULL;

extern PlatformOSX * platformActor;

#pragma mark - C API meant to be called by Pony code

#define USE_MEMORY_MUTEX 1

pthread_mutex_t memory_mutex;

#if USE_MEMORY_MUTEX
    #define MEMORY_MUTEX_INIT() pthread_mutex_init(&memory_mutex, NULL)
    #define MEMORY_MUTEX_LOCK() pthread_mutex_lock(&memory_mutex)
    #define MEMORY_MUTEX_UNLOCK() pthread_mutex_unlock(&memory_mutex)
#else
    #define MEMORY_MUTEX_INIT() ((void)memory_mutex)
    #define MEMORY_MUTEX_LOCK() ((void)memory_mutex)
    #define MEMORY_MUTEX_UNLOCK() ((void)memory_mutex)
#endif

size_t METAL_PAGE_ALIGNMENT = 4096;

#define COUNT_OF_RETAIN_PTR(x, s) ( ((int8_t *)ptr)[s-1] )
#define INIT_RETAIN_PTR(x, s) ( COUNT_OF_RETAIN_PTR(x, s) = 0 )
#define FREE_RETAIN_POINTER(x, s) free(ptr)
#define INCREMENT_RETAIN_PTR(x, s) ( COUNT_OF_RETAIN_PTR(x, s) += 1 )
#define DECREMENT_RETAIN_PTR(x, s) ( COUNT_OF_RETAIN_PTR(x, s) -= 1 )

size_t RenderEngine_alignedSize(size_t size) {
    size += 1;
    return (size + METAL_PAGE_ALIGNMENT - 1) & (~(METAL_PAGE_ALIGNMENT - 1));
}

void * RenderEngine_malloc(size_t * size) {
    if(*size == 0) {
        return NULL;
    }
    
    void * ptr = NULL;
    *size = RenderEngine_alignedSize(*size);
    if(posix_memalign(&ptr, METAL_PAGE_ALIGNMENT, *size) != 0) {
        return NULL;
    }
    
    INIT_RETAIN_PTR(ptr, *size);
    INCREMENT_RETAIN_PTR(ptr, *size);
    
    //fprintf(stderr, "malloc: %d (ptr: %d, size: %d // %d)\n", COUNT_OF_RETAIN_PTR(ptr, *size), (int)ptr, (int)original_size, (int)*size);
    
    return ptr;
}

void * RenderEngine_retain(void * ptr, size_t size) {
    if(ptr != NULL) {
        MEMORY_MUTEX_LOCK();
        INCREMENT_RETAIN_PTR(ptr, size);
        //fprintf(stderr, "retain: %d (ptr: %d, size: %d)\n", COUNT_OF_RETAIN_PTR(ptr, size), (int)ptr, (int)size);
        MEMORY_MUTEX_UNLOCK();
    }
    return ptr;
}

void RenderEngine_release(void * ptr, size_t size) {
    if(ptr != NULL) {
        MEMORY_MUTEX_LOCK();
        //fprintf(stderr, "release: %d (ptr: %d, size: %d)\n", COUNT_OF_RETAIN_PTR(ptr, size), (int)ptr, (int)size);
        DECREMENT_RETAIN_PTR(ptr, size);
        if(COUNT_OF_RETAIN_PTR(ptr, size) <= 0) {
            //fprintf(stderr, "free: %d (ptr: %d, size: %d)\n", COUNT_OF_RETAIN_PTR(ptr, size), (int)ptr, (int)size);
            FREE_RETAIN_POINTER(ptr, size);
        }
        MEMORY_MUTEX_UNLOCK();
    }
}

size_t RenderEngine_maxConcurrentFrames() {
    return 3;
}

HALRenderContext * RenderEngine_init(ui_RenderEngine * ponyRenderEngine) {
    HALRenderContext * ctx = (HALRenderContext *)calloc(sizeof(HALRenderContext), 1);
    ponyint_messageq_init(&ctx->renderUnitQueue);
    ctx->ponyRenderEngine = ponyRenderEngine;
        
    if(sharedContext == NULL) {
        MEMORY_MUTEX_INIT();
        sharedContext = ctx;
        METAL_PAGE_ALIGNMENT = getpagesize();
    }
    return ctx;
}

void RenderEngine_destroy(HALRenderContext * ctx) {
    if(sharedContext == ctx) {
        sharedContext = NULL;
    }
    
    if (ctx != NULL) {
        ponyint_messageq_destroy(&ctx->renderUnitQueue);
        free(ctx);
    }
}

void RenderEngine_textureInfo(HALRenderContext * ctx, const char * textureName, float * width, float * height) {
    FENCE_FOR_RENDERER();
    
    ctx->_getTextureInfo(ctx->classPtr, textureName, width, height);
}

void RenderEngine_pushClips(HALRenderContext * ctx,
                            uint64_t frameNumber,
                            uint64_t renderNumber,
                            uint32_t num_floats,
                            void * vertices,
                            uint32_t size_vertices_array)
{
    RenderEngine_render(ctx,
                        frameNumber,
                        renderNumber,
                        ShaderType_Stencil_Begin,
                        num_floats,
                        vertices,
                        size_vertices_array,
                        1.0,
                        1.0,
                        1.0,
                        1.0,
                        NULL);
}

void RenderEngine_popClips(HALRenderContext * ctx,
                           uint64_t frameNumber,
                           uint64_t renderNumber,
                           uint32_t num_floats,
                           void * vertices,
                           uint32_t size_vertices_array)
{
    RenderEngine_render(ctx,
                        frameNumber,
                        renderNumber,
                        ShaderType_Stencil_End,
                        num_floats,
                        vertices,
                        size_vertices_array,
                        1.0,
                        1.0,
                        1.0,
                        1.0,
                        NULL);
}

void RenderEngine_render(HALRenderContext * ctx,
                         uint64_t frameNumber,
                         uint64_t renderNumber,
                         uint32_t shaderType,
                         uint32_t num_floats,
                         void * vertices,
                         uint32_t size_vertices_array,
                         float globalR,
                         float globalG,
                         float globalB,
                         float globalA,
                         const char * textureName) {
    // Note: this message can be called concurrently from any thread
    RenderUnit * unit = (RenderUnit*) pony_alloc_msg(ponyint_pool_index(sizeof(RenderUnit)), 0);
    
    unit->frameNumber = frameNumber;
    unit->renderNumber = renderNumber;
        
    unit->shaderType = shaderType;
    
    unit->textureName = textureName;
    
    unit->globalR = globalR;
    unit->globalG = globalG;
    unit->globalB = globalB;
    unit->globalA = globalA;
    
    // Each shader expects specific geometry
    switch(shaderType){
        case ShaderType_Finished:
        case ShaderType_Abort:
            unit->bytes_vertices = 0;
            unit->bytes_per_vertex = 0;
            unit->num_vertices = 0;
            break;
        case ShaderType_Flat:
        case ShaderType_Stencil_Begin:
        case ShaderType_Stencil_End:
            unit->bytes_per_vertex = sizeof(float) * 7;
            unit->bytes_vertices = num_floats * sizeof(float);
            unit->num_vertices = num_floats / 7;
            break;
        case ShaderType_Textured:
            unit->bytes_per_vertex = sizeof(float) * 9;
            unit->bytes_vertices = num_floats * sizeof(float);
            unit->num_vertices = num_floats / 9;
            break;
        case ShaderType_SDF:
            unit->bytes_per_vertex = sizeof(float) * 5;
            unit->bytes_vertices = num_floats * sizeof(float);
            unit->num_vertices = num_floats / 5;
            break;
    }
    unit->bytes_vertices = RenderEngine_alignedSize(unit->bytes_vertices);
    unit->size_vertices_array = size_vertices_array;
    unit->vertices = RenderEngine_retain(vertices, unit->size_vertices_array);
            
    ponyint_thread_messageq_push(&ctx->renderUnitQueue, (pony_msg_t*)unit, (pony_msg_t*)unit);
}





#pragma mark - Callbacks to Swift/Vulkan which allow use to communicate with Renderer.swift

void RenderEngineInternal_registerAPICallbacks(HALRenderContext * context,
                                               void * classPtr,
                                               REAPI_getTextureInfo _getTextureInfo) {
    RESOLVE_CONTEXT();
    
    context->classPtr = classPtr;
    
    // Method for retrieving texture information given a texture name
    context->_getTextureInfo = _getTextureInfo;
}

#pragma mark - Used either internally in C RenderEngine or called by Swift code

RenderUnit * RenderEngineInternal_cloneRenderUnit(RenderUnit * other) {
    RenderUnit * mine = malloc(sizeof(RenderUnit));
    memcpy(mine, other, sizeof(RenderUnit));
    return mine;
}

void RenderEngineInternal_renderUnitFree(RenderUnit * unit) {
    // Note: The Pony code allocates the buffers.  They are then captured by metal and free'd there when completed
    unit->vertices = NULL;
    
    free(unit);
}

void RenderEngineInternal_updateBounds(HALRenderContext * context, float width, float height) {
    RESOLVE_CONTEXT();
    
    ui_RenderEngine_tag_updateBounds_ffo__send(context->ponyRenderEngine, width, height);
}

void RenderEngineInternal_renderAll(HALRenderContext * context) {
    RESOLVE_CONTEXT();
    
    context->didCallRenderAll = true;
    ui_RenderEngine_tag_renderAll_o__send(context->ponyRenderEngine);
}

bool RenderEngineInternal_hasRenderUnits(HALRenderContext * context) {
    RESOLVE_CONTEXT_RET(false);
    
    //fprintf(stderr, "sharedContext->renderUnitQueue.num_messages: %lld\n", sharedContext->renderUnitQueue.num_messages);
    return context->renderUnitQueue.num_messages > 0;
}

void RenderEngineInternal_Poll() {
    PlatformOSX_val_poll_o(platformActor);
}

#define RenderUnitFromNode(__node) avl_tree_entry(__node, RenderUnit, node)
#define INT_VALUE(node) TEST_NODE(node)->n

static int cmp_render_unit_nodes(const struct avl_tree_node *node1, const struct avl_tree_node *node2)
{
    return (int)((int64_t)(RenderUnitFromNode(node1)->renderNumber) - (int64_t)(RenderUnitFromNode(node2)->renderNumber));
}


void RenderEngineInternal_frameFinished(HALRenderContext * context) {
    RESOLVE_CONTEXT();
    
    if (context->lastRenderUnit != NULL) {
        RenderEngineInternal_renderUnitFree(context->lastRenderUnit);
        context->lastRenderUnit = NULL;
    }
}

bool RenderEngineInternal_gatherAllRenderUnitsForNextFrame(HALRenderContext * context) {
    // This function gathers all of the render units for this specific frame, and reorders them
    // in the order in which they need to be drawn.  Returns "true" if there are renderable units
    // "false" if the only render unit is the "finished" command (marking an empty frame).
    RESOLVE_CONTEXT_RET(false);
    
    if (context->didCallRenderAll == false) {
        // We should only expect a new frame of data IF we asked for it. So if we didn't, then we shouldn't wait for nothing
        return false;
    }
    
    // Give the platform actor time to process
    RenderEngineInternal_Poll();
    
    // reset the binary tree
    context->unit_tree_root = NULL;
    
    RenderUnit * msg_unit = NULL;
    bool captureRenderFrameNumber = true;
    int scaling_sleep = 1;
    int time_spent_sleeping = 0;
    
    // Note: we want to stay in this loop until we receive the finished commmand
    bool didReceiveCompleteFrame = false;
    while(didReceiveCompleteFrame == false) {
        
        while ((msg_unit = (RenderUnit*)ponyint_thread_messageq_pop(&sharedContext->renderUnitQueue)) != NULL) {
            scaling_sleep = 1;
            
            // Technically, we have no control over WHEN pony will dealloc the message memory
            // so we make sure to make our own copy in our own memory space
            RenderUnit * cloned_unit = RenderEngineInternal_cloneRenderUnit(msg_unit);
            
            if (captureRenderFrameNumber) {
                context->renderFrameNumber = cloned_unit->frameNumber;
                captureRenderFrameNumber = false;
            }
            
            if(context->renderFrameNumber != cloned_unit->frameNumber) {
                fprintf(stderr, "Warning: render unit for new frame encountered prior to the end unit of the current frame (%llu != %llu).\n", context->renderFrameNumber, cloned_unit->frameNumber);
                RenderEngineInternal_renderUnitFree(cloned_unit);
                didReceiveCompleteFrame = true;
                break;
            }
            
            if(cloned_unit->shaderType == ShaderType_Finished) {
                RenderEngineInternal_renderUnitFree(cloned_unit);
                didReceiveCompleteFrame = true;
                break;
            }
            
            avl_tree_insert(&context->unit_tree_root, &cloned_unit->node, cmp_render_unit_nodes);
        }
        
        if(didReceiveCompleteFrame == false) {
            //RenderEngineInternal_Poll();
            
            // Sanity check: if for whatever reason we get stuck waiting "forever" for the frame to end, exit without waiting for the end frame
            //if (time_spent_sleeping > 1000000) {
            //    break;
            //}
            
            scaling_sleep += 50;
            if(scaling_sleep > 500) {
                scaling_sleep = 500;
            }
            time_spent_sleeping += scaling_sleep;
            usleep(scaling_sleep);
        }
    }
    
    context->didCallRenderAll = false;
    
    struct avl_tree_node * first = avl_tree_first_in_order(context->unit_tree_root);
    
    // the "finished" unit doesn't get put in the tree, so if the tree is empty
    // then we have an empty frame and we shouldn't rerender the screen
    return (first != NULL);
}

RenderUnit * RenderEngineInternal_nextRenderUnit(HALRenderContext * context) {
    // How this works:
    // 1. firstCall is set to true when we want call this the first time when rendering a new frame
    // 2. If firstCall is true, we pop all of he messages off of the queue which match the frameNumber of the first item
    //   a. We sort the render units by their renderNumber
    //   b. We provide the first renderNumber render unit as the return of this call
    // 3. If firstCall is false, then
    //   a. We return the next lowest number renderNumber
    //   b. We return null if we run out of render units for this frame
    RESOLVE_CONTEXT_RET(NULL);
    
    if (context->lastRenderUnit != NULL) {
        RenderEngineInternal_renderUnitFree(context->lastRenderUnit);
        context->lastRenderUnit = NULL;
    }
    
    RenderUnit * unit = NULL;
    
    // grab the next lowest item off of the tree
    struct avl_tree_node * first = avl_tree_first_in_order(context->unit_tree_root);
    if (first != NULL) {
        unit = RenderUnitFromNode(first);
        avl_tree_remove(&context->unit_tree_root, first);
    }
    
    context->lastRenderUnit = unit;
    
    return unit;
}

#pragma mark - Events

void RenderEngineInternal_touchEvent(HALRenderContext * context, size_t touchID, bool pressed, float x, float y) {
    RESOLVE_CONTEXT();
    
    ui_RenderEngine_tag_touchEvent_Zbffo__send(context->ponyRenderEngine, touchID, pressed, x, y);
}

void RenderEngineInternal_scrollEvent(HALRenderContext * context, size_t touchID, float sx, float sy, float mx, float my) {
    RESOLVE_CONTEXT();
    
    ui_RenderEngine_tag_scrollEvent_Zffffo__send(context->ponyRenderEngine, touchID, sx, sy, mx, my);
}
