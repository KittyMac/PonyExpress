use "ttimer"
use "yoga"
use "linal"
use "utility"


struct TextureInfo
  let image_width:U32 = 0
  let image_height:U32 = 0
  let texture_width:U32 = 0
  let texture_height:U32 = 0
    
primitive ShaderType
  let finished:U32 = 0
  let abort:U32 = 1
  let flat:U32 = 2
  let textured:U32 = 3
  let sdf:U32 = 4
  let stencilBegin:U32 = 5
  let stencilEnd:U32 = 6

primitive CullMode
  let skip:U32 = 0
  let none:U32 = 1
  let back:U32 = 2
  let front:U32 = 3

primitive RenderPrimitive
  """
  Rendering actors can call this concurrently safely to submit geometry to the platform rendering engine
  """
  
  fun tag transform(frameContext:FrameContext val, v:V3):V3 =>
    M4fun.mul_v3_point_3x4(frameContext.matrix, v)
  
  fun tag quadVCT(frameContext:FrameContext val, vertices:FloatAlignedArray, p0:V3, p1:V3, p2:V3, p3:V3, c:RGBA, st0:V2, st1:V2, st2:V2, st3:V2):Bool =>
    let r = frameContext.screenBounds
    let v0 = M4fun.mul_v3_point_3x4(frameContext.matrix, p0)
    let v1 = M4fun.mul_v3_point_3x4(frameContext.matrix, p1)
    let v2 = M4fun.mul_v3_point_3x4(frameContext.matrix, p2)
    let v3 = M4fun.mul_v3_point_3x4(frameContext.matrix, p3)
    
    let xmin = r._1._1
    let ymin = r._1._2
    let xmax = r._1._1 + r._2
    let ymax = r._1._2 + r._3
    
    if (v0._1 < xmin) and (v1._1 < xmin) and (v2._1 < xmin) and (v3._1 < xmin) then return false end
    if (v0._1 > xmax) and (v1._1 > xmax) and (v2._1 > xmax) and (v3._1 > xmax) then return false end
    if (v0._2 < ymin) and (v1._2 < ymin) and (v2._2 < ymin) and (v3._2 < ymin) then return false end
    if (v0._2 > ymax) and (v1._2 > ymax) and (v2._2 > ymax) and (v3._2 > ymax) then return false end
    
    vertices.pushQuadVCT(v0, v1, v2, v3, c.r, c.g, c.b, c.a, st0, st1, st2, st3)
    true
   
  fun tag quadVC(frameContext:FrameContext val, vertices:FloatAlignedArray, p0:V3, p1:V3, p2:V3, p3:V3, c:RGBA):Bool =>
    let r = frameContext.screenBounds
    let v0 = M4fun.mul_v3_point_3x4(frameContext.matrix, p0)
    let v1 = M4fun.mul_v3_point_3x4(frameContext.matrix, p1)
    let v2 = M4fun.mul_v3_point_3x4(frameContext.matrix, p2)
    let v3 = M4fun.mul_v3_point_3x4(frameContext.matrix, p3)
    
    let xmin = r._1._1
    let ymin = r._1._2
    let xmax = r._1._1 + r._2
    let ymax = r._1._2 + r._3
    
    if (v0._1 < xmin) and (v1._1 < xmin) and (v2._1 < xmin) and (v3._1 < xmin) then return false end
    if (v0._1 > xmax) and (v1._1 > xmax) and (v2._1 > xmax) and (v3._1 > xmax) then return false end
    if (v0._2 < ymin) and (v1._2 < ymin) and (v2._2 < ymin) and (v3._2 < ymin) then return false end
    if (v0._2 > ymax) and (v1._2 > ymax) and (v2._2 > ymax) and (v3._2 > ymax) then return false end
    
    vertices.pushQuadVC(v0, v1, v2, v3, c.r, c.g, c.b, c.a)
    true
  
  fun tag quadVT(frameContext:FrameContext val, vertices:FloatAlignedArray, p0:V3, p1:V3, p2:V3, p3:V3, st0:V2, st1:V2, st2:V2, st3:V2):Bool =>
    let r = frameContext.screenBounds
    let v0 = M4fun.mul_v3_point_3x4(frameContext.matrix, p0)
    let v1 = M4fun.mul_v3_point_3x4(frameContext.matrix, p1)
    let v2 = M4fun.mul_v3_point_3x4(frameContext.matrix, p2)
    let v3 = M4fun.mul_v3_point_3x4(frameContext.matrix, p3)
    
    let xmin = r._1._1
    let ymin = r._1._2
    let xmax = r._1._1 + r._2
    let ymax = r._1._2 + r._3
    
    if (v0._1 < xmin) and (v1._1 < xmin) and (v2._1 < xmin) and (v3._1 < xmin) then return false end
    if (v0._1 > xmax) and (v1._1 > xmax) and (v2._1 > xmax) and (v3._1 > xmax) then return false end
    if (v0._2 < ymin) and (v1._2 < ymin) and (v2._2 < ymin) and (v3._2 < ymin) then return false end
    if (v0._2 > ymax) and (v1._2 > ymax) and (v2._2 > ymax) and (v3._2 > ymax) then return false end
    
    vertices.pushQuadVT(v0, v1, v2, v3, st0, st1, st2, st3)
    true
    
  
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
  
  fun tag createTextureFromBytes(frameContext:FrameContext val, name:Pointer[U8] tag, bytes:Pointer[U8] tag, bytesCount:USize) =>
    @RenderEngine_createTextureFromBytes(frameContext.renderContext, name, bytes, bytesCount)
  
  fun tag renderCachedGeometry(frameContext:FrameContext val, partNum:U64, shaderType:U32, vertices:FloatAlignedArray, gc:RGBA val, cullMode:U32 = CullMode.none, t:(String|None) = None) =>
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
                          gc.r, gc.g, gc.b, gc.a * frameContext.alpha,
                          cullMode,
                          if t as String then t.cpointer() else Pointer[U8] end)
    
  
  




