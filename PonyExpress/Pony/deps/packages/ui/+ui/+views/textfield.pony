use "linal"
use "utility"

actor TextField is (Fontable & Buttonable)
	var _color:RGBA val = RGBA.black()
  
  fun ref start(frameContext:FrameContext val) =>
    fontable_start(frameContext)

  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    buttonable_event(frameContext, anyEvent, bounds)

  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    fontable_render(frameContext, bounds)
