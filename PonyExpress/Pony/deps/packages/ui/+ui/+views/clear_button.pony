use "linal"
use "stringext"

actor ClearButton is Buttonable
  """
  A button which has no visuals at all. You can use this to make invisible click areas wrapping other parts of your UI.

  Example:
  
  let font:Font = Font(TestFontJson())
  YogaNode.>width(200)
          .>height(60)
          .>view( ClearButton.>onClick({ () => @printf("clicked!\n".cstring()) }) )
          .>addChildren([
            YogaNode.>view( Color.>grey() )
            YogaNode.>view( Label("Clear Tap Area", font) )
          ])
  """
    
  fun ref updateButton(pressed:Bool) =>
    None

  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    buttonable_event(frameContext, anyEvent, bounds)
    