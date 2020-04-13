use "yoga"

actor ScrollTest is Controllerable
  
	fun ref mainNode():YogaNode iso^ =>
    let font:Font = Font(TestFontJson())
    recover iso 
      YogaNode.>alignItems(YGAlign.flexstart)
              .>flexDirection(YGFlexDirection.row)
              .>padding(YGEdge.all, 40)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                
            YogaNode.>view( Scroll )
                    .>clips(false)
                    .>addChild(
                      
                      YogaNode.>widthPercent(100)
                              .>heightPercent(500)
                              .>view( Label(LoremText(), font).>size(32) )
                      
              )
             
          ])
      end
