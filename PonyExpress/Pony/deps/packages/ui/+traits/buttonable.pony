use "linal"

type ButtonClickedCallback is {()}

trait Buttonable is (Viewable & Actionable)
  """
  For button-like things which need to track when they are being pressed and perform action when they are unpressed
  """
  var clickedCallback:ButtonClickedCallback val = {()=>None}
  
  var ignoreTouches:Array[USize] = Array[USize](32)
  var insideTouches:Array[USize] = Array[USize](32)
  var outsideTouches:Array[USize] = Array[USize](32)
  var buttonPressed:Bool = false
  
  fun ref performClick() =>
    performAction()
    clickedCallback()
  
  fun ref updateButton(pressed:Bool) =>
    None    
  
  be onClick(clickedCallback':ButtonClickedCallback val) =>
    clickedCallback = clickedCallback'
  
  fun ref buttonable_event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
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
      
      if e.pressed and (insideTouches.contains(e.id) == false) and (outsideTouches.contains(e.id) == false) then
        // This is an untracked touch. If it is pressed and inside our button, start tracking it
        if inside then
          insideTouches.push(e.id)
        else
          ignoreTouches.push(e.id)
          return
        end
      else
        // This is a touch we are tracking, check when it goes inside and outside of our rect
        if (inside == true) and outsideTouches.contains(e.id) then
          outsideTouches.deleteOne(e.id)
          insideTouches.push(e.id)
        elseif (inside == false) and insideTouches.contains(e.id) then
          insideTouches.deleteOne(e.id)
          outsideTouches.push(e.id)
        end
        
        // check when it goes away entirely
        if e.pressed == false then
          outsideTouches.deleteOne(e.id)
          insideTouches.deleteOne(e.id)
        end
      end
      
      if (buttonPressed == true) and (insideTouches.size() == 0) then
        buttonPressed = false
        updateButton(false)
        
        if (insideTouches.size() == 0) and (outsideTouches.size() == 0) then
          performClick()
        end
        
      elseif (buttonPressed == false) and (insideTouches.size() != 0) then
        buttonPressed = true
        updateButton(true)
      end
      
      if (buttonPressed == true) and (insideTouches.size() > 0) then
        if engine as RenderEngine then
          engine.requestFocus(nodeID)
        end
      end
      
      
      
    else
      None
    end