use "yoga"
use "collections"
use "utility"

actor ButtonTest is Controllerable
  
  let font:Font = Font(TestFontJson())
  
	fun ref mainNode():YogaNode iso^ =>
    recover iso 
      YogaNode.>rows().>justifyStart().>itemsStart().>wrap().>paddingAll(12)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                      
          // the big, red button
          YogaNode.>size(100, 100)
                  .>view( Button.>onClick({ () => @printf("clicked 1!\n".cstring()) }) )
                  .>addChildren([
              YogaNode.>view( Color.>red() )
              YogaNode.>view( Color.>blue() )
          ])
          
          // clear tap area
          YogaNode.>size(200, 60)
                  .>view( ClearButton.>onClick({ () => @printf("clicked 2!\n".cstring()) }) )
                  .>addChildren([
                YogaNode.>view( Color.>gray() )
                        .>addChild( YogaNode.>view( Label.>value("Clear Tap Area").>font(font).>center().>blue() ) )
          ])
          
          // button with images for up and down states
          YogaNode.>view( ImageButton.>sizeToFit()
                                     .>unpressedPath("unpressed_button")
                                     .>pressedPath("pressed_button")
                                     .>onClick({ () => @printf("clicked 3!\n".cstring()) }) )
          
          
          // button with a stretchable image
          YogaNode.>size(300, 80)
                  .>view( ImageButton.>stretchAll(32)
                                     .>path("stretch_button")
                                     .>pressedColor(RGBA(0.8, 0.8, 1.0, 1.0))
                                     .>onClick({ () => @printf("clicked 4!\n".cstring()) }) )
                  .>addChild( YogaNode.>view( Label.>value("Click me!").>font(font, 28).>center() ) )
          
        ]
      )
    end
    
