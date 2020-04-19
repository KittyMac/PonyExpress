use "linal"
use "utility"

trait tag Viewable is Animatable
  var engine:(RenderEngine|None) = None
  var nodeID:YogaNodeID = 0
  var insets:V4 = V4fun.zero()
  
  be inset(top:F32, left:F32, bottom:F32, right:F32) =>
    insets = V4fun(top, left, bottom, right)
  
  be insetAll(v:F32) =>
    insets = V4fun(v, v, v, v)
  
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
    engine = frameContext.engine
    nodeID = frameContext.nodeID
    let local_bounds = R4fun(bounds._1._1 + insets._2, bounds._1._2 + insets._1, bounds._2 - (insets._4 + insets._2), bounds._3 - (insets._3 + insets._1))
    event(frameContext, anyEvent, local_bounds)
  
  fun ref start(frameContext:FrameContext val) =>
    RenderPrimitive.startFinished(frameContext)
  
  be viewable_start(frameContext:FrameContext val) =>
    engine = frameContext.engine
    nodeID = frameContext.nodeID
    start(frameContext)
  
  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    None
  
  be viewable_render(frameContext:FrameContext val, bounds:R4) =>
    engine = frameContext.engine
    nodeID = frameContext.nodeID
    let local_bounds = R4fun(bounds._1._1 + insets._2, bounds._1._2 + insets._1, bounds._2 - (insets._4 + insets._2), bounds._3 - (insets._3 + insets._1))
    render(frameContext, local_bounds)
    RenderPrimitive.renderFinished(frameContext)
    performAnimation(frameContext)
  
    
