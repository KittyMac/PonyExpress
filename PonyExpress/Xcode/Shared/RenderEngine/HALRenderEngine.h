#ifndef _HAL_RENDER_ENGINE_H_
#define _HAL_RENDER_ENGINE_H_

#include "pony.h"
#include "app.h"
#include "avl_tree.h"

#include <stdio.h>
#include <stdlib.h>


// This render C API is purposefully kept to a minimum, preferring to offload the actual work to pony.render
// and ease the amount of work the vendor implementation (ie how these communicate with Metal/Vulkan/OpenGL).

// ------- Snipped from the Pony Runtime -------
// The ponyrt contains code for super efficient lock-less message
// queues. Instead of re-inventing the wheel, we use that in HALRenderEngine
// to queue up RenderUnits for processing.
typedef struct messageq_t
{
  PONY_ATOMIC(pony_msg_t*) head;
  pony_msg_t* tail;
  PONY_ATOMIC(int64_t) num_messages;
} messageq_t;

extern uint32_t ponyint_pool_index(size_t size);
extern void ponyint_messageq_init(void * q);
extern void ponyint_messageq_destroy(void * q);
extern bool ponyint_thread_messageq_push(messageq_t* q, pony_msg_t* first, pony_msg_t* last);
extern pony_msg_t* ponyint_thread_messageq_pop(messageq_t* q);

extern void stopRuntimeAnalysis(bool killed);
// ------- ----------------------------- -------

#define EventType_touch 0
#define EventType_key 1
#define EventType_scroll 2

#define ShaderType_Finished 0
#define ShaderType_Abort 1
#define ShaderType_Flat 2
#define ShaderType_Textured 3
#define ShaderType_SDF 4
#define ShaderType_Stencil_Begin 5
#define ShaderType_Stencil_End 6

#define CullMode_skip 0
#define CullMode_none 1
#define CullMode_back 2
#define CullMode_front 3

typedef struct
{
    uint32_t image_width;
    uint32_t image_height;
    uint32_t texture_width;
    uint32_t texture_height;
} TextureInfo;

typedef struct
{
    pony_msg_t msg;

    uint64_t frameNumber;
    uint64_t renderNumber;
    
    uint32_t shaderType;
        
    size_t bytes_vertices;
    uint32_t num_vertices;
    size_t bytes_per_vertex;
    void * vertices;
    size_t size_vertices_array;
        
    const char * textureName;
    
    float globalR;
    float globalG;
    float globalB;
    float globalA;
    
    uint32_t cullMode;
    
    struct avl_tree_node node;
} RenderUnit;




typedef void (*REAPI_getTextureInfo)(void *, const char *, float *, float *);
typedef void (*REAPI_createTextureFromBytes)(void *, const char *, void *, size_t countBytes);
typedef void (*REAPI_createTextureFromUrl)(void *, const char *);
typedef void (*REAPI_beginKeyboard)(void *);
typedef void (*REAPI_endKeyboard)(void *);


typedef struct {
    messageq_t renderUnitQueue;
    uint64_t renderFrameNumber;
    ui_RenderEngine * ponyRenderEngine;
        
    RenderUnit * lastRenderUnit;
    struct avl_tree_node * unit_tree_root;
    
    bool didCallRenderAll;
    
    void * classPtr;
    REAPI_getTextureInfo _getTextureInfo;
    REAPI_createTextureFromBytes _createTextureFromBytes;
    REAPI_createTextureFromUrl _createTextureFromUrl;
    REAPI_beginKeyboard _beginKeyboard;
    REAPI_endKeyboard _endKeyboard;
} HALRenderContext;


size_t RenderEngine_alignedSize(size_t size);

void * RenderEngine_malloc(size_t * size);
void * RenderEngine_retain(void * ptr, size_t size);
void RenderEngine_release(void * ptr, size_t size);

size_t RenderEngine_maxConcurrentFrames(void);

HALRenderContext * RenderEngine_init(ui_RenderEngine * ponyRenderEngine);
void RenderEngine_destroy(HALRenderContext * ctx);

void RenderEngine_textureInfo(HALRenderContext * ctx, const char * textureName, float * width, float * height);
void RenderEngine_createTextureFromBytes(HALRenderContext * ctx, const char * textureName, void * textureBytes, size_t countBytes);
void RenderEngine_createTextureFromUrl(HALRenderContext * ctx, const char * url);

void RenderEngine_beginKeyboardInput(HALRenderContext * ctx);
void RenderEngine_endKeyboardInput(HALRenderContext * ctx);

void RenderEngine_pushClips(HALRenderContext * ctx,
                            uint64_t frameNumber,
                            uint64_t renderNumber,
                            uint32_t num_floats,
                            void * vertices,
                            uint32_t size_vertices_array);

void RenderEngine_popClips(HALRenderContext * ctx,
                           uint64_t frameNumber,
                           uint64_t renderNumber,
                           uint32_t num_floats,
                           void * vertices,
                           uint32_t size_vertices_array);

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
                         uint32_t cullMode,
                         const char * textureName);

float RenderEngine_safeTop(void);
float RenderEngine_safeLeft(void);
float RenderEngine_safeBottom(void);
float RenderEngine_safeRight(void);

void RenderEngineInternal_registerAPICallbacks(HALRenderContext * context,
                                               void * classPtr,
                                               REAPI_getTextureInfo _getTextureInfo,
                                               REAPI_createTextureFromBytes _createTextureFromBytes,
                                               REAPI_createTextureFromUrl _createTextureFromUrl,
                                               REAPI_beginKeyboard _beginKeyboard,
                                               REAPI_endKeyboard _endKeyboard);

void RenderEngineInternal_renderAll(HALRenderContext * context);
void RenderEngineInternal_updateBounds(HALRenderContext * context, float width, float height, float topInset, float leftInset, float bottomInset, float rightInset);
void RenderEngineInternal_setNeedsRendered(HALRenderContext * context);
bool RenderEngineInternal_hasRenderUnits(HALRenderContext * context);

bool RenderEngineInternal_gatherAllRenderUnitsForNextFrame(HALRenderContext * context);
RenderUnit * RenderEngineInternal_nextRenderUnit(HALRenderContext * context);
void RenderEngineInternal_frameFinished(HALRenderContext * context);

void RenderEngineInternal_Poll(void);

void RenderEngineInternal_touchEvent(HALRenderContext * context, size_t touchID, bool pressed, float x, float y);
void RenderEngineInternal_scrollEvent(HALRenderContext * context, size_t touchID, float sx, float sy, float mx, float my);
void RenderEngineInternal_keyEvent(HALRenderContext * context, bool pressed, uint16_t keyCode, const char * charactersPtr, float x, float y);

#endif
