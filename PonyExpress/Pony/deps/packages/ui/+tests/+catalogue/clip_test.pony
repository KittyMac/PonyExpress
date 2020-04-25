use "yoga"
use "collections"
use "utility"

actor ClipTest is Controllerable
  
	fun ref mainNode():YogaNode iso^ =>    
    recover iso 
      YogaNode.>rows().>itemsStart().>paddingAll(12)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                
            YogaNode.>size(100, 100)
                    .>view( Color.>red().>alpha(0.25) )
                    .>addChild(
                      
                      YogaNode.>size(100, 100).>originPercent(50, 50)
                              .>view( Color.>green().>alpha(0.25) )
                      
              )
              
            YogaNode.>size(100, 100).>left(100)
                    .>clips(true)
                    .>view( Color.>red().>alpha(0.25) )
                    .>addChild(
                    
                      YogaNode.>size(100, 100).>originPercent(50, 50)
                              .>clips(true)
                              .>view( Color.>green().>alpha(0.25) )
                              .>addChild(
                                
                                YogaNode.>size(100, 100).>originPercent(-75, -75)
                                        .>clips(true)
                                        .>view( Color.>blue().>alpha(0.25) )
                                
                              )
                    
              )
              
              YogaNode.>size(100, 100).>left(100)
                      .>clips(true)
                      .>view( Color.>red().>alpha(0.25) )
                      .>addChild(
                    
                        YogaNode.>size(100, 100).>originPercent(50, 50)
                                .>clips(true)
                                .>view( Color.>green().>alpha(0.25) )
                                .>addChild(
                                
                                  YogaNode.>size(100, 100).>originPercent(-75, -75)
                                          .>clips(true)
                                          .>view( Color.>blue().>alpha(0.25) )
                                
                                )
                    
                )
          ])
      end
