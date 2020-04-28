use "linal"
use "utility"
use "laba"

trait tag Viewable is Animatable
  var engine:(RenderEngine|None) = None
  var nodeID:YogaNodeID = 0
  
  var renderInsets:V4 = V4fun.zero()
  var eventInsets:V4 = V4fun.zero()
  
  fun _priority():U64 => 100
  
  be renderInset(top:F32, left:F32, bottom:F32, right:F32) =>
    renderInsets = V4fun(top, left, bottom, right)
  
  be renderInsetAll(v:F32) =>
    renderInsets = V4fun(v, v, v, v)
  
  be eventInset(top:F32, left:F32, bottom:F32, right:F32) =>
    eventInsets = V4fun(top, left, bottom, right)

  be eventInsetAll(v:F32) =>
    eventInsets = V4fun(v, v, v, v)
  
  
  
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
  
  
  
  
  fun requestFocus() =>
    if engine as RenderEngine then
      engine.requestFocus(nodeID)
    end
  
  fun releaseFocus() =>
    if engine as RenderEngine then
      engine.releaseFocus(nodeID)
    end
  
  fun advanceFocus() =>
    if engine as RenderEngine then
      engine.advanceFocus()
    end
  
  fun hasFocus(frameContext:FrameContext val):Bool =>
    (nodeID == frameContext.focusedNodeID)
  
  fun setNeedsRendered() =>
    if engine as RenderEngine then
      engine.setNeedsRendered()
    end
  
  fun setNeedsLayout() =>
    if engine as RenderEngine then
      engine.setNeedsLayout()
    end
  
  fun ref invalidate(frameContext:FrameContext val) =>
    None
  
  be viewable_invalidate(frameContext:FrameContext val) =>
    invalidate(frameContext)
  
    
  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    None
  
  be viewable_event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    engine = frameContext.engine
    nodeID = frameContext.nodeID
    let local_bounds = R4fun(bounds._1._1 + eventInsets._2, bounds._1._2 + eventInsets._1, bounds._2 - (eventInsets._4 + eventInsets._2), bounds._3 - (eventInsets._3 + eventInsets._1))
    event(frameContext, anyEvent, local_bounds)
  
  fun ref start(frameContext:FrameContext val) =>
    RenderPrimitive.startFinished(frameContext)
  
  be viewable_start(frameContext:FrameContext val) =>
    engine = frameContext.engine
    nodeID = frameContext.nodeID
    start(frameContext)
  
  fun ref finish() =>
    None

  be viewable_finish() =>
    finish()
  
  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    None
  
  be viewable_render(frameContext:FrameContext val, bounds:R4) =>
    engine = frameContext.engine
    nodeID = frameContext.nodeID
    let local_bounds = R4fun(bounds._1._1 + renderInsets._2, bounds._1._2 + renderInsets._1, bounds._2 - (renderInsets._4 + renderInsets._2), bounds._3 - (renderInsets._3 + renderInsets._1))
    render(frameContext, local_bounds)
    RenderPrimitive.renderFinished(frameContext)
    performAnimation(frameContext)
  
  be labaCancel() =>
    if engine as RenderEngine then
        engine.getNodeByID(nodeID, { (node) =>
          if node as YogaNode then
            node.labaCancel()
          end
          LayoutNeeded
        })
    end

  be laba(labaStr:String val, args:(Array[F32] val|None) = None, callback:(LabaCompleteCallback val|None) = None) =>
    if engine as RenderEngine then
        engine.getNodeByID(nodeID, { (node) =>
          if node as YogaNode then
            node.laba(labaStr, args, callback)
          end
          LayoutNeeded
        })
    end
