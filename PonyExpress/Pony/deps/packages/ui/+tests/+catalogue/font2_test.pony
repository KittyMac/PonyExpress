use "yoga"


actor Font2Test is Controllerable
  
	fun ref mainNode():YogaNode iso^ =>
    let font:Font = Font(TestFontJson())
    //let text = "Lorem"
    let text = LoremText()
    
    recover iso 
      YogaNode.>rows().>itemsStart().>wrap().>paddingAll(12)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                        
          // lorem ipsum in 4 quadrants
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>red().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 128).>sizeToFit().>center() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>green().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 16).>sizeToFit().>right() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 32).>sizeToFit().>top() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 64).>sizeToFit().>bottom() ) )
          
          
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 64).>sizeToFit().>center() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>red().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 128).>sizeToFit().>right() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>green().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 16).>sizeToFit().>top() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 32).>sizeToFit().>bottom() ) )
          
          
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 32).>sizeToFit().>center() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 64).>sizeToFit().>right() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>red().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 128).>sizeToFit().>top() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>green().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 16).>sizeToFit().>bottom() ) )
          
          
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>green().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 16).>sizeToFit().>center() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 32).>sizeToFit().>right() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 64).>sizeToFit().>top() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>red().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 128).>sizeToFit().>bottom() ) )
                    
        ]
      )
    end
