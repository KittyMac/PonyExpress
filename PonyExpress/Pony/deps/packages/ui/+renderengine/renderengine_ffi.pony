use "yoga"
use "utility"

use @RenderEngine_maxConcurrentFrames[USize]()

use @RenderEngine_init[RenderContextRef](engine:RenderEngine tag)
use @RenderEngine_destroy[None](ctx:RenderContextRef tag)

use @RenderEngine_beginKeyboardInput[None](ctx:RenderContextRef tag)
use @RenderEngine_endKeyboardInput[None](ctx:RenderContextRef tag)

use @RenderEngine_safeTop[F32]()
use @RenderEngine_safeLeft[F32]()
use @RenderEngine_safeBottom[F32]()
use @RenderEngine_safeRight[F32]()

use @RenderEngine_createTextureFromBytes[None](ctx:RenderContextRef tag, textureName:Pointer[U8] tag, widthPtr:Pointer[U8] tag, bytesCount:USize)
use @RenderEngine_createTextureFromUrl[None](ctx:RenderContextRef tag, url:Pointer[U8] tag)

use @RenderEngine_textureInfo[TextureInfo](ctx:RenderContextRef tag, textureName:Pointer[U8] tag, widthPtr:Pointer[F32], heightPtr:Pointer[F32])
use @RenderEngine_render[None]( ctx:RenderContextRef tag, 
                        frameNumber:U64, 
                       renderNumber:U64, 
                         shaderType:U32,
                        numVertices:U32,
                           vertices:UnsafePointer[F32] tag, 
                size_vertices_array:U32, 
                            globalR:F32, 
                            globalG:F32, 
                            globalB:F32, 
                            globalA:F32, 
                           cullMode:U32,
                        textureName:Pointer[U8] tag)
use @RenderEngine_pushClips[None](ctx:RenderContextRef tag,
                          frameNumber:U64, 
                         renderNumber:U64, 
                          numVertices:U32,
                             vertices:UnsafePointer[F32] tag, 
                  size_vertices_array:U32)
use @RenderEngine_popClips[None](ctx:RenderContextRef tag,
                         frameNumber:U64, 
                        renderNumber:U64,
                         numVertices:U32,
                            vertices:UnsafePointer[F32] tag, 
                 size_vertices_array:U32)