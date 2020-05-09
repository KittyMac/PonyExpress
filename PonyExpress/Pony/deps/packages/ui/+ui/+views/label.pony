use "linal"
use "utility"

actor Label is (Fontable & Syncable)
	var _color:RGBA val = RGBA.black()
  
  fun ref start(frameContext:FrameContext val) =>
    fontable_start(frameContext)
  
  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    fontable_render(frameContext, bounds)
  
  fun ref syncDidUpdate(value:SyncType val) =>
    _value = value.string()
    fontRender.invalidate()
    setNeedsRendered()

  fun ref finish() =>
    syncable_finish()