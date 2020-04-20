use "yoga"
use "collections"

actor FontTest is Controllerable
  
	fun ref mainNode():YogaNode iso^ =>
    let font:Font = Font(TestFontJson())
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
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>green().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          
          
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>red().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>green().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          
          
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>red().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>green().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          
          
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>green().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>blue().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>yellow().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
          YogaNode.>sizePercent(25,25)
                  .>clips(true)
                  .>view( Color.>red().>alpha(0.1) )
                  .>view( Scroll.>horizontal(false) )
                  .>addChild( YogaNode.>view( Label.>value(text).>font(font, 12).>sizeToFit() ) )
                    
        ]
      )
    end
