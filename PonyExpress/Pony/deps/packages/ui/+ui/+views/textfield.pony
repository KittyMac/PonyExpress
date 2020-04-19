use "linal"
use "utility"

actor TextField is (Fontable & Buttonable)
	var _color:RGBA val = RGBA.black()
  
  fun ref start(frameContext:FrameContext val) =>
    fontable_start(frameContext)

  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    buttonable_event(frameContext, anyEvent, bounds)
    
    if hasFocus(frameContext) then
      match anyEvent
      | let e:KeyEvent val =>
        if e.pressed then
          if e.delete() then
            _value = _value.trim(0, _value.size()-1)
          else
            _value = _value + (e.characters)
          end
          
          Log.println("%s (%s)", e.keyCode, e.characters)
          setNeedsRendered()
        end
      end
    end
    

  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    fontable_render(frameContext, bounds)
  
  fun ref invalidate(frameContext:FrameContext val) =>
    fontable_invalidate(frameContext)
