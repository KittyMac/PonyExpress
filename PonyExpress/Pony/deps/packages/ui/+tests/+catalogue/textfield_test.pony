use "yoga"

actor TextFieldTest is Controllerable
  
	fun ref mainNode():YogaNode iso^ =>
    let font:Font = Font(TestFontJson())
    recover iso 
      YogaNode.>center()
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                
            YogaNode.>size(600,400).>columns().>center().>paddingAll(20)
                    .>view( Color.>gray() )
                    .>addChildren( [
                      
                      
                      YogaNode.>height(60).>rows().>center().>marginBottom(10)
                              .>addChildren([
                                  YogaNode.>width(100)
                                          .>view( Color.>blue() )
                                          .>view( Label("Email:", font).>size(18).>right() )
                      
                                  YogaNode.>widthPercent(100).>shrink()
                                          .>view( Color.>red() )
                                          .>view( Label("(insert email here)", font).>size(18) )
                      ])
                      
                      YogaNode.>height(60).>rows().>center()
                              .>addChildren([
                                  YogaNode.>width(100)
                                          .>view( Color.>blue() )
                                          .>view( Label("Password:", font).>size(18).>right() )
            
                                  YogaNode.>widthPercent(100).>shrink()
                                          .>view( Color.>red() )
                                          .>view( Label("(insert password here)", font).>size(18) )
                      ])
                      
              ])
             
          ])
      end
