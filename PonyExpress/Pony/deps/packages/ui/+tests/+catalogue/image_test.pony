use "yoga"


actor ImageTest is Controllerable
  
  fun ref mainNode():YogaNode iso^ =>    
    recover iso 
      YogaNode.>alignItems(YGAlign.flexstart)
              .>flexDirection(YGFlexDirection.row)
              .>flexWrap(YGWrap.wrap)
              .>padding(YGEdge.all, 12)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                        
          YogaNode.>width(256).>height(256).>view( Image( "unpressed_button" ).>sizeToFit().>color(RGBA(1,1,1,1.0 )) )
          YogaNode.>width(256).>height(256).>view( Image( "unpressed_button" ).>sizeToFit().>color(RGBA(1,0,0,1.0 )) )
          YogaNode.>width(256).>height(256).>view( Image( "unpressed_button" ).>sizeToFit().>color(RGBA(0,1,0,1.0 )) )
          YogaNode.>width(256).>height(256).>view( Image( "unpressed_button" ).>sizeToFit().>color(RGBA(0,0,1,1.0 )) )
          YogaNode.>width(256).>height(256).>view( Image( "unpressed_button" ).>sizeToFit().>color(RGBA(1,1,1,0.25)) )
          
          
          YogaNode.>width(256)
                  .>height(512)
                  .>view( Image( "landscape_desert" ).>fill() )
          
          YogaNode.>width(256)
                  .>height(512)
                  .>view( Color.>gray() )
                  .>addChild( YogaNode.>view( Image( "landscape_desert" ).>aspectFit() ) )
          
          YogaNode.>width(256)
                  .>height(512)
                  .>view( Image( "landscape_desert" ).>aspectFill() )
          
          YogaNode.>width(512)
                  .>height(256)
                  .>view( Image( "landscape_desert" ).>fill() )
          
          YogaNode.>width(512)
                  .>height(256)
                  .>view( Color.>gray() )
                  .>addChild( YogaNode.>view( Image( "landscape_desert" ).>aspectFit() ) )
          
          YogaNode.>width(512)
                  .>height(256)
                  .>view( Image( "landscape_desert" ).>aspectFill() )
          
          YogaNode.>view( Image( "landscape_desert" ).>sizeToFit() )
          
        ]
      )
    end
