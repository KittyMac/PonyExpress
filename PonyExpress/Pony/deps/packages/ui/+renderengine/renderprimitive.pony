use "ttimer"
use "yoga"
use "linal"
use "utility"

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


struct TextureInfo
  let image_width:U32 = 0
  let image_height:U32 = 0
  let texture_width:U32 = 0
  let texture_height:U32 = 0
    
primitive ShaderType
  let finished:U32 = 0
  let flat:U32 = 1
  let textured:U32 = 2
  let sdf:U32 = 3

primitive RenderPrimitive
  """
  Rendering actors can call this concurrently safely to submit geometry to the platform rendering engine
  """
  
  fun tag transform(frameContext:FrameContext val, v:V3):V3 =>
    M4fun.mul_v3_point_3x4(frameContext.matrix, v)
  
  fun tag quadVCT(frameContext:FrameContext val, vertices:FloatAlignedArray, p0:V3, p1:V3, p2:V3, p3:V3, c:RGBA, st0:V2, st1:V2, st2:V2, st3:V2) =>
    let r = frameContext.screenBounds
    let v0 = M4fun.mul_v3_point_3x4(frameContext.matrix, p0)
    let v1 = M4fun.mul_v3_point_3x4(frameContext.matrix, p1)
    let v2 = M4fun.mul_v3_point_3x4(frameContext.matrix, p2)
    let v3 = M4fun.mul_v3_point_3x4(frameContext.matrix, p3)
    if  ((r._1._1 <= v0._1) and ((r._1._1 + r._2) >= v0._1) and (r._1._2 <= v0._2) and ((r._1._2 + r._3) >= v0._2)) or
        ((r._1._1 <= v1._1) and ((r._1._1 + r._2) >= v1._1) and (r._1._2 <= v1._2) and ((r._1._2 + r._3) >= v1._2)) or
        ((r._1._1 <= v2._1) and ((r._1._1 + r._2) >= v2._1) and (r._1._2 <= v2._2) and ((r._1._2 + r._3) >= v2._2)) or
        ((r._1._1 <= v3._1) and ((r._1._1 + r._2) >= v3._1) and (r._1._2 <= v3._2) and ((r._1._2 + r._3) >= v3._2)) then
      vertices.pushQuadVCT(v0, v1, v2, v3, c.r, c.g, c.b, c.a, st0, st1, st2, st3)
    end
   
  fun tag quadVC(frameContext:FrameContext val, vertices:FloatAlignedArray, p0:V3, p1:V3, p2:V3, p3:V3, c:RGBA) =>
    let r = frameContext.screenBounds
    let v0 = M4fun.mul_v3_point_3x4(frameContext.matrix, p0)
    let v1 = M4fun.mul_v3_point_3x4(frameContext.matrix, p1)
    let v2 = M4fun.mul_v3_point_3x4(frameContext.matrix, p2)
    let v3 = M4fun.mul_v3_point_3x4(frameContext.matrix, p3)
    if  ((r._1._1 <= v0._1) and ((r._1._1 + r._2) >= v0._1) and (r._1._2 <= v0._2) and ((r._1._2 + r._3) >= v0._2)) or
        ((r._1._1 <= v1._1) and ((r._1._1 + r._2) >= v1._1) and (r._1._2 <= v1._2) and ((r._1._2 + r._3) >= v1._2)) or
        ((r._1._1 <= v2._1) and ((r._1._1 + r._2) >= v2._1) and (r._1._2 <= v2._2) and ((r._1._2 + r._3) >= v2._2)) or
        ((r._1._1 <= v3._1) and ((r._1._1 + r._2) >= v3._1) and (r._1._2 <= v3._2) and ((r._1._2 + r._3) >= v3._2)) then
      vertices.pushQuadVC(v0, v1, v2, v3, c.r, c.g, c.b, c.a) 
    end
  
  fun tag quadVT(frameContext:FrameContext val, vertices:FloatAlignedArray, p0:V3, p1:V3, p2:V3, p3:V3, st0:V2, st1:V2, st2:V2, st3:V2) =>
    let r = frameContext.screenBounds
    let v0 = M4fun.mul_v3_point_3x4(frameContext.matrix, p0)
    let v1 = M4fun.mul_v3_point_3x4(frameContext.matrix, p1)
    let v2 = M4fun.mul_v3_point_3x4(frameContext.matrix, p2)
    let v3 = M4fun.mul_v3_point_3x4(frameContext.matrix, p3)
    if  ((r._1._1 <= v0._1) and ((r._1._1 + r._2) >= v0._1) and (r._1._2 <= v0._2) and ((r._1._2 + r._3) >= v0._2)) or
        ((r._1._1 <= v1._1) and ((r._1._1 + r._2) >= v1._1) and (r._1._2 <= v1._2) and ((r._1._2 + r._3) >= v1._2)) or
        ((r._1._1 <= v2._1) and ((r._1._1 + r._2) >= v2._1) and (r._1._2 <= v2._2) and ((r._1._2 + r._3) >= v2._2)) or
        ((r._1._1 <= v3._1) and ((r._1._1 + r._2) >= v3._1) and (r._1._2 <= v3._2) and ((r._1._2 + r._3) >= v3._2)) then
      vertices.pushQuadVT(v0, v1, v2, v3, st0, st1, st2, st3) 
    end
    
  
  fun tag buildVCT(frameContext:FrameContext val, vertices:FloatAlignedArray, v:V3, c:RGBA, st:V2) =>
    let p = M4fun.mul_v3_point_3x4(frameContext.matrix, v)
    vertices.push(p._1); vertices.push(p._2); vertices.push(p._3)
    vertices.push(c.r); vertices.push(c.g); vertices.push(c.b); vertices.push(c.a)
    vertices.push(st._1); vertices.push(st._2)
  
  fun tag buildVC(frameContext:FrameContext val, vertices:FloatAlignedArray, v:V3, c:RGBA) =>
    let p = M4fun.mul_v3_point_3x4(frameContext.matrix, v)
    vertices.push(p._1); vertices.push(p._2); vertices.push(p._3)
    vertices.push(c.r); vertices.push(c.g); vertices.push(c.b); vertices.push(c.a)
    
  fun tag buildVT(frameContext:FrameContext val, vertices:FloatAlignedArray, v:V3, st:V2) =>
    let p = M4fun.mul_v3_point_3x4(frameContext.matrix, v)
    vertices.push(p._1); vertices.push(p._2); vertices.push(p._3)
    vertices.push(st._1); vertices.push(st._2)
    
  fun tag renderFinished(frameContext:FrameContext val) =>
    frameContext.engine.renderFinished()
  
  fun tag startFinished(frameContext:FrameContext val) =>
    frameContext.engine.startFinished()
  
  fun tag renderCachedGeometry(frameContext:FrameContext val, partNum:U64, shaderType:U32, vertices:FloatAlignedArray, gc:RGBA val, t:Pointer[U8] tag) =>
    if vertices.size() == 0 then
      return
    end
    @RenderEngine_render( frameContext.renderContext,
                          frameContext.frameNumber,
                          frameContext.calcRenderNumber(frameContext, partNum, 0),
                          shaderType, 
                          vertices.size().u32(), 
                          vertices.cpointer(),
                          vertices.allocSize().u32(),
                          gc.r, gc.g, gc.b, gc.a,
                          t)
    
  
  




