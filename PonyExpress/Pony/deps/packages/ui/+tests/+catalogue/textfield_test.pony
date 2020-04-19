use "yoga"

actor TextFieldTest is Controllerable
  
	fun ref mainNode():YogaNode iso^ =>
    let font:Font = Font(TestFontJson())
    recover iso 
      YogaNode.>center()
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                
            YogaNode.>fit().>width(500).>columns().>center().>paddingAll(40)
                    .>view( Image.>path("dialog_background").>stretchAll(12) )
                    .>addChildren( [
                      
                      
                      YogaNode.>view( Label.>value("Email").>font(font, 18).>sizeToFit() )
                      
                      YogaNode.>height(44).>marginBottom(16)
                              .>view( Image.>path("dialog_field").>pathFocused("dialog_field_focused").>stretchAll(5) )
                              .>view( TextField.>value("(insert email here)").>font(font, 18).>insetAll(6) )
                      
                      YogaNode.>view( Label.>value("Password").>font(font, 18).>sizeToFit() )
              
                      YogaNode.>height(44).>marginBottom(36)
                              .>view( Image.>path("dialog_field").>pathFocused("dialog_field_focused").>stretchAll(5) )
                              .>view( TextField.>value("(insert password here)").>font(font, 18).>insetAll(6) )
                      
                      YogaNode.>height(50)
                              .>view( ImageButton( "dialog_button", "dialog_button" ).>stretchAll(12).>pressedColor(RGBA.u32(0x6eb8e5ff)) )
                              .>view( Label.>value("Continue").>font(font, 24).>center() )
                      
              ])
             
          ])
      end
