use "yoga"

actor ScrollTest is Controllerable
  
	fun ref mainNode():YogaNode iso^ =>
    let font:Font = Font(TestFontJson())
    recover iso 
      YogaNode.>rows().>itemsStart().>paddingAll(12)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                
            YogaNode.>view( Scroll.>horizontal(false) )
                    .>clips(true)
                    .>addChild(
                      
                      YogaNode.>view( Label.>value(LoremText()).>font(font, 24).>sizeToFit() )
                      
              )
             
          ])
      end
