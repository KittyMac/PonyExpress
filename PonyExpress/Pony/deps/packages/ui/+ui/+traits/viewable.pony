use "linal"
use "utility"

trait tag Viewable
  var engine:(RenderEngine|None) = None
  var nodeID:YogaNodeID = 0
  
  var clippingGeometry:BufferedGeometry = BufferedGeometry
  var pushedClippingVertices:FloatAlignedArray = FloatAlignedArray
  
  // convert point from local coordinates to global coordinates
  fun transformPoint(frameContext:FrameContext val, point:V2):V2 =>
    V3fun.v2(M4fun.mul_v3_point_3x4(frameContext.matrix, V3fun(point._1, point._2, 0.0)))
  
  // convert point from global coordinates to local coordinates
  fun inverseTransformPoint(frameContext:FrameContext val, point:V2):V2 =>
    match M4fun.inv(frameContext.matrix)
    | let inv_matrix:M4 =>
      V3fun.v2(M4fun.mul_v3_point_3x4(inv_matrix, V3fun(point._1, point._2, 0.0)))
    else
      @printf("WARNING: unable to invert matrix in inverseTransformPoint".cstring())
      point
    end
  
  fun pointInBounds(frameContext:FrameContext val, bounds:R4, point:V2):Bool =>
    R4fun.contains(bounds, inverseTransformPoint(frameContext, point) )
  
  
  
    
  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    None
  
  be viewable_event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    event(frameContext, anyEvent, bounds)
  
  fun ref start(frameContext:FrameContext val) =>
    RenderPrimitive.startFinished(frameContext)
  
  be viewable_start(frameContext:FrameContext val) =>
    engine = frameContext.engine
    nodeID = frameContext.nodeID
    start(frameContext)
  
  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    None
  
  be viewable_render(frameContext:FrameContext val, bounds:R4) =>
    render(frameContext, bounds)    
    RenderPrimitive.renderFinished(frameContext)
  
  
  
  
  
  be viewable_pushClips(frameContext:FrameContext val, bounds:R4) =>
    
    let geom = clippingGeometry.next()
    pushedClippingVertices = geom.vertices
    
    if geom.check(frameContext, bounds) == false then
    
      pushedClippingVertices.reserve(4 * 7)
      pushedClippingVertices.clear()
    
      let x_min = R4fun.x_min(bounds)
      let y_min = R4fun.y_min(bounds)
      let x_max = R4fun.x_max(bounds)
      let y_max = R4fun.y_max(bounds)
    
      RenderPrimitive.quadVC(frameContext,    pushedClippingVertices,   
                             V3fun(x_min,  y_min, 0.0), 
                             V3fun(x_max,  y_min, 0.0),
                             V3fun(x_max,  y_max, 0.0),
                             V3fun(x_min,  y_max, 0.0),
                             RGBA.white() )
    end
    
    @RenderEngine_pushClips(frameContext.renderContext,
                            frameContext.frameNumber, 
                            frameContext.calcRenderNumber(frameContext, 0, 1),
                            pushedClippingVertices.size().u32(), 
                            pushedClippingVertices.cpointer(),
                            pushedClippingVertices.reserved().u32())
    RenderPrimitive.renderFinished(frameContext)
  
  be viewable_popClips(frameContext:FrameContext val, bounds:R4) =>
    @RenderEngine_popClips(frameContext.renderContext,
                           frameContext.frameNumber, 
                           frameContext.calcRenderNumber(frameContext, 0, 9),
                           pushedClippingVertices.size().u32(), 
                           pushedClippingVertices.cpointer(),
                           pushedClippingVertices.reserved().u32() )
    RenderPrimitive.renderFinished(frameContext)
    
