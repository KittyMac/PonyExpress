use "linal"
use "stringext"
use "yoga"

actor Button is Buttonable
  """
  A bare-bones button which relies on you (the UI developer) to YogaNodes which represent its pressed and unpressed states. These
  states are simply the first and second children of this button, and they are hidden or shown based on user events.
  
  Example:
  
  YogaNode.>width(100)
          .>height(100)
          .>view( Button.>onClick({ () => @printf("clicked!\n".cstring()) }) )
          .>addChildren([
            YogaNode( Color.>red() )  // Red when not pressed
            YogaNode( Color.>blue() ) // Blue when pressed
          ])
  """
  
  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    buttonable_event(frameContext, anyEvent, bounds)
  
  fun ref updateChildren(showChildIdx:USize, isStart:Bool = false) =>
    if engine as RenderEngine then
        engine.getNodeByID(nodeID, { (node) =>
          if node as YogaNode then
            var childIdx:USize = 0
            for child in node.getChildren().values() do
              if showChildIdx == childIdx then
                child.>display(YGDisplay.flex)
              else
                child.>display(YGDisplay.none)
              end
              childIdx = childIdx + 1
            end
          end
          if isStart then
            if engine as RenderEngine then
              engine.startFinished()
            end
          end
          LayoutNeeded
        })
    end
  
  fun ref start(frameContext:FrameContext val) =>
    updateChildren(0, true)
  
  fun ref updateButton(pressed:Bool) =>
    if pressed then
      updateChildren(1)
    else
      updateChildren(0)
    end