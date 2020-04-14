use "linal"
use "utility"
use "easings"

actor Scroll is (Viewable & Scrollable)
  
  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    scrollable_event(frameContext, anyEvent, bounds)
  
  fun ref animate(delta:F32 val) =>
    scrollable_animate(delta)
  
  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    scrollable_render(frameContext, bounds)