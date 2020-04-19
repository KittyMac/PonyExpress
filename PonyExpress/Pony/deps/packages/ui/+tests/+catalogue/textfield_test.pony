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
                      
                      
                      YogaNode.>view( Label("Email", font).>size(18).>sizeToFit() )
                      
                      YogaNode.>height(44).>marginBottom(16)
                              .>view( Image.>path("dialog_field").>stretchAll(3) )
                              .>view( Label("(insert email here)", font).>size(18).>insetAll(6) )
                      
                      YogaNode.>view( Label("Password", font).>size(18).>sizeToFit() )
              
                      YogaNode.>height(44).>marginBottom(36)
                              .>view( Image.>path("dialog_field").>stretchAll(3) )
                              .>view( Label("(insert password here)", font).>size(18).>insetAll(6) )
                      
                      YogaNode.>height(50)
                              .>view( ImageButton( "dialog_button", "dialog_button" ).>stretchAll(12).>pressedColor(RGBA(0.8, 0.8, 1.0, 1.0)) )
                              .>view( Label("Continue", font).>size(24).>center() )
                      
              ])
             
          ])
      end
