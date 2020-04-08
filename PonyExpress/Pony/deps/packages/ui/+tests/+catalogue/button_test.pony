use "yoga"


actor ButtonTest is Controllerable
  
  let font:Font = Font(TestFontJson())
  
	fun ref mainNode():YogaNode iso^ =>
    recover iso 
      YogaNode.>alignItems(YGAlign.flexstart)
              .>flexDirection(YGFlexDirection.row)
              .>flexWrap(YGWrap.wrap)
              .>padding(YGEdge.all, 40)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                      
          // the big, red button
          YogaNode.>width(100)
                  .>height(100)
                  .>view( Button.empty().>onClick({ () => @printf("clicked 1!\n".cstring()) }) )
                  .>addChildren([
              YogaNode.>view( Color.>red() )
              YogaNode.>view( Color.>blue() )
          ])
          
          // clear tap area
          YogaNode.>width(200)
                  .>height(60)
                  .>view( ClearButton.empty().>onClick({ () => @printf("clicked 2!\n".cstring()) }) )
                  .>addChildren([
                YogaNode.>view( Color.>gray() )
                        .>addChild( YogaNode.>view( Label("Clear Tap Area", font).>center().>blue() ) )
          ])
          
          // button with images for up and down states
          YogaNode.>view( ImageButton( "unpressed_button", "pressed_button" ).>sizeToFit()
                                                                             .>onClick({ () => @printf("clicked 3!\n".cstring()) }) )
          
          
          // button with a stretchable image
          YogaNode.>width(300)
                  .>height(80)
                  .>view( ImageButton( "stretch_button", "stretch_button" ).>stretch(32,32,32,32)
                                                                           .>pressedColor(RGBA(0.8, 0.8, 1.0, 1.0))
                                                                           .>onClick({ () => @printf("clicked 4!\n".cstring()) }) )
                  .>addChild( YogaNode.>view( Label("Click me!", font, 28).>center() ) )
          
        ]
      )
    end
    
