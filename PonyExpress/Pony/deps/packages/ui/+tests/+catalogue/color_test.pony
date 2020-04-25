use "yoga"
use "collections"
use "utility"

actor ColorTest is Controllerable
  
	fun ref mainNode():YogaNode iso^ =>    
    recover iso 
      YogaNode.>rows().>itemsStart().>wrap().>paddingAll(12)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                      
            YogaNode.>sizePercent(50, 50)
                    .>view( Color.>red() )
            YogaNode.>sizePercent(50, 50)
                    .>view( Color.>green() )
            YogaNode.>sizePercent(50, 50)
                    .>view( Color.>blue() )
            YogaNode.>sizePercent(50, 50)
                    .>view( Color.>yellow() )
          ])
      end
