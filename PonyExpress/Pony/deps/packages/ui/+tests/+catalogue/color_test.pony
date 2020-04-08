use "yoga"

actor ColorTest is Controllerable
  
	fun ref mainNode():YogaNode iso^ =>    
    recover iso 
      YogaNode.>alignItems(YGAlign.flexstart)
              .>flexDirection(YGFlexDirection.row)
              .>flexWrap(YGWrap.wrap)
              .>padding(YGEdge.all, 40)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                      
            YogaNode.>widthPercent(50)
                    .>heightPercent(50)
                    .>view( Color.>red() )
            YogaNode.>widthPercent(50)
                    .>heightPercent(50)
                    .>view( Color.>green() )
            YogaNode.>widthPercent(50)
                    .>heightPercent(50)
                    .>view( Color.>blue() )
            YogaNode.>widthPercent(50)
                    .>heightPercent(50)
                    .>view( Color.>yellow() )
          ])
      end
