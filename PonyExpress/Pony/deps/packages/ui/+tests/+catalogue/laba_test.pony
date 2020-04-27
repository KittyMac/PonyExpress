use "yoga"
use "utility"
use "collections"
use "laba"

primitive PerformLabaAnimation is Action

actor LabaTest is Controllerable
  """
  Most image search APIs require you to pay to call them, and that's too rediculous to contemplate for this little example program. 
  So I have included a save search for kittens, which will be loaded no matter what yiou put in the field.
  http://api.qwant.com/api/search/images?count=250&q=kittens&t=images&local=en_US&uiv=4
  """
  
  let font:Font = Font(TestFontJson())
  
  let labaKey:String = "laba_key"
  
	fun ref mainNode():YogaNode iso^ =>
    
    recover iso 
      let sample1 = {(laba1:String val): YogaNode =>
        YogaNode.>center().>size(200,200)
                .>addChildren([
                    YogaNode.>name("Red")
                            .>size(50,50)
                            .>laba(laba1)
                            .>view( Color.>red() )
                ])
      }
      /*
      let sample2 = {(laba1:String val, laba2:String val): YogaNode =>
        YogaNode.>center().>size(200,200)
                .>addChildren([
                    YogaNode.>size(50,50)
                            .>laba(laba1)
                            .>view( Color.>blue() )
                    YogaNode.>size(50,50)
                            .>laba(laba2)
                            .>view( Color.>red() )
                ])
      }
      */
      let sample3 = {(laba1:String val, laba2:String val, laba3:String val): YogaNode =>
        YogaNode.>center().>size(200,200)
                .>addChildren([
                    YogaNode.>size(50,50)
                            .>laba(laba1)
                            .>view( Color.>blue() )
                    YogaNode.>size(50,50)
                            .>laba(laba2)
                            .>view( Color.>red() )
                    YogaNode.>size(50,50)
                            .>laba(laba3)
                            .>view( Color.>yellow() )
                ])
      }
      
      
      
      YogaNode.>paddingAll(6).>columns().>columnsReversed()
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
            
            // Scroll view containing all of the examples
            YogaNode.>paddingLeft(6).>paddingRight(6).>shrink()
                    .>clips(true)
                    .>view( Scroll.>horizontal(false) )
                    .>addChildren([
                  
                      YogaNode.>fit().>rows().>wrap()
                              .>addChildren([
                                  sample3("!~!>", "!~!>", "!~!>")
                                  sample1("<|^|>|v")
                                  sample1("e0<|^|>|v")
                              ])
                          
                    ])
            
            /*
            // Top bar containing the search field
            YogaNode.>height(60).>minWidth(200).>rows().>paddingAll(6)
                    .>view( Image.>path("dialog_background").>stretchAll(12).>renderInset(-100,-200,-5,-30) )
                    .>addChildren( [ 
                      
                        YogaNode.>focusIdx(0).>itemsStart().>justifyCenter()
                                .>view( Image.>path("dialog_field").>pathFocused("dialog_field_focused").>stretchAll(5).>renderInset(0,0,0,-6) )
                                .>view( TextField.>placeholder("Enter a Laba string here").>font(font, 18).>renderInset(2,50,2,4).>eventInsetAll(-6).>action(this, PerformLabaAnimation).>sync(this, labaKey) )
                                .>addChild(
                                  YogaNode.>left(10).>size(24,24)
                                          .>view( Image.>path("search").>aspectFit().>renderInset(0,0,0,0) )
                                
                                )
                      
                      ] )
            */     
             
          ])
      end
    
  be action(evt:Action) =>
    if engine as RenderEngine then
        match evt
        | PerformLabaAnimation => performLabaAnimation()
        end
    end
  
  fun ref performLabaAnimation() =>
    try
      match getSyncData(labaKey)?
      | let labaString:String val =>
        if engine as RenderEngine then
          engine.getNodeByName("Red", { (node) =>
            if node as YogaNode then
              // reset the node, then set the laba animation
              node.>left(0).>top(0).>size(200,200)
                  .>laba(labaString)
            end
            LayoutNeeded
          })
        end
      end
    end
    