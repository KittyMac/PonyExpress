use "linal"
use "utility"

trait tag Viewable
  var engine:(RenderEngine|None) = None
  var nodeID:YogaNodeID = 0
  
  
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
  
