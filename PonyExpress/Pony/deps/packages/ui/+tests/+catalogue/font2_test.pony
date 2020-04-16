use "yoga"


actor Font2Test is Controllerable
  
	fun ref mainNode():YogaNode iso^ =>
    let font:Font = Font(TestFontJson())    
    recover iso 
      YogaNode.>alignItems(YGAlign.flexstart)
              .>flexDirection(YGFlexDirection.row)
              .>flexWrap(YGWrap.wrap)
              .>padding(YGEdge.all, 12)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                        
          // lorem ipsum in 4 quadrants
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>red().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(128).>center() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>green().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16).>right() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(32).>top() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(64).>bottom() ) )
          
          
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(64).>center() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>red().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(128).>right() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>green().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16).>top() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(32).>bottom() ) )
          
          
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(32).>center() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(64).>right() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>red().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(128).>top() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>green().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16).>bottom() ) )
          
          
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>green().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(16).>center() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(32).>right() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(64).>top() ) )
          YogaNode.>widthPercent(25)
                  .>heightPercent(25)
                  .>view( Color.>red().>alpha(0.1) )
                  .>addChild( YogaNode.>view( Label(LoremText(), font).>size(128).>bottom() ) )
                    
        ]
      )
    end
