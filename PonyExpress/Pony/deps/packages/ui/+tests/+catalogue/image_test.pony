use "yoga"
use "collections"

actor ImageTest is Controllerable
  
  fun ref mainNode():YogaNode iso^ =>    
    recover iso 
      YogaNode.>rows().>itemsStart().>wrap().>paddingAll(12)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                        
          YogaNode.>size(256,256).>view( Image.>path( "unpressed_button" ).>sizeToFit().>color(RGBA(1,1,1,1.0 )) )
          YogaNode.>size(256,256).>view( Image.>path( "unpressed_button" ).>sizeToFit().>color(RGBA(1,0,0,1.0 )) )
          YogaNode.>size(256,256).>view( Image.>path( "unpressed_button" ).>sizeToFit().>color(RGBA(0,1,0,1.0 )) )
          YogaNode.>size(256,256).>view( Image.>path( "unpressed_button" ).>sizeToFit().>color(RGBA(0,0,1,1.0 )) )
          YogaNode.>size(256,256).>view( Image.>path( "unpressed_button" ).>sizeToFit().>color(RGBA(1,1,1,0.25)) )
          
          
          YogaNode.>size(256,512)
                  .>view( Image.>path( "landscape_desert" ).>fill() )
          
          YogaNode.>size(256,512)
                  .>view( Color.>gray() )
                  .>addChild( YogaNode.>view( Image.>path( "landscape_desert" ).>aspectFit() ) )
          
          YogaNode.>size(256,512)
                  .>view( Image.>path( "landscape_desert" ).>aspectFill() )
          
          YogaNode.>size(512,256)
                  .>view( Image.>path( "landscape_desert" ).>fill() )
          
          YogaNode.>size(512,256)
                  .>view( Color.>gray() )
                  .>addChild( YogaNode.>view( Image.>path( "landscape_desert" ).>aspectFit() ) )
          
          YogaNode.>size(512,256)
                  .>view( Image.>path( "landscape_desert" ).>aspectFill() )
          
          YogaNode.>view( Image.>path( "landscape_desert" ).>sizeToFit() )
          
        ]
      )
    end
