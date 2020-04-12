use "linal"

actor Scroll is (Viewable & Scrollable)
  
  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    scrollable_event(frameContext, anyEvent, bounds)
  