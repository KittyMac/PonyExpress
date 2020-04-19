use "yoga"


actor ButtonTest is Controllerable
  
  let font:Font = Font(TestFontJson())
  
	fun ref mainNode():YogaNode iso^ =>
    recover iso 
      YogaNode.>rows().>justifyStart().>itemsStart().>wrap().>paddingAll(12)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                      
          // the big, red button
          YogaNode.>size(100, 100)
                  .>view( Button.empty().>onClick({ () => @printf("clicked 1!\n".cstring()) }) )
                  .>addChildren([
              YogaNode.>view( Color.>red() )
              YogaNode.>view( Color.>blue() )
          ])
          
          // clear tap area
          YogaNode.>size(200, 60)
                  .>view( ClearButton.empty().>onClick({ () => @printf("clicked 2!\n".cstring()) }) )
                  .>addChildren([
                YogaNode.>view( Color.>gray() )
                        .>addChild( YogaNode.>view( Label("Clear Tap Area", font).>center().>blue() ) )
          ])
          
          // button with images for up and down states
          YogaNode.>view( ImageButton( "unpressed_button", "pressed_button" ).>sizeToFit()
                                                                             .>onClick({ () => @printf("clicked 3!\n".cstring()) }) )
          
          
          // button with a stretchable image
          YogaNode.>size(300, 80)
                  .>view( ImageButton( "stretch_button", "stretch_button" ).>stretchAll(32)
                                                                           .>pressedColor(RGBA(0.8, 0.8, 1.0, 1.0))
                                                                           .>onClick({ () => @printf("clicked 4!\n".cstring()) }) )
                  .>addChild( YogaNode.>view( Label("Click me!", font, 28).>center() ) )
          
        ]
      )
    end
    
