use "linal"
use "utility"

trait Scrollable is (Viewable & Actionable)
  """
  For things whose visual content may be larger than their layout'd size, we allow the user to scroll around nicely. Our content size
  is always the combined size of our children?
  """  
  var ignoreTouches:Array[USize] = Array[USize](32)
  var trackingTouches:Array[USize] = Array[USize](32)
  
  var previous:V2 = V2fun.zero()
        
  fun ref scrollable_event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    match anyEvent
    | let e:TouchEvent val =>
      let inside = pointInBounds(frameContext, bounds, e.position)
            
      // touches must originate inside of our button to be tracked
      if ignoreTouches.contains(e.id) then
        if (e.pressed == false) then
          ignoreTouches.deleteOne(e.id)
        end
        return
      end
      
      if e.pressed and (trackingTouches.contains(e.id) == false) then
        // This is an untracked touch.
        if inside then
        
          if trackingTouches.size() == 0 then
            previous = inverseTransformPoint(frameContext, e.position)
          end
          
          trackingTouches.push(e.id)
        else
          ignoreTouches.push(e.id)
          return
        end
      else        
        // check when it goes away entirely
        if e.pressed == false then
          trackingTouches.deleteOne(e.id)
        end
      end
      
      // When we get here, we have a list of touches (trackingTouches)
      try
        let touchID = trackingTouches(0)?
        
        if touchID == e.id then
          let current = inverseTransformPoint(frameContext, e.position)
        
          let delta = V2fun.sub(current, previous)
          
          if engine as RenderEngine then
              engine.getNodeByID(nodeID, { (node) =>
                if node as YogaNode then
                  node.scrollContent(delta)
                  return RenderNeeded
                end        
                None
              })
          end
        
          previous = current
        end
      end
      
      
    else
      None
    end