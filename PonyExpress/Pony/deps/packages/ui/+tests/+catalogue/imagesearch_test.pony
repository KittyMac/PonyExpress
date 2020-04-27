use "yoga"
use "utility"
use "collections"

primitive PerformImageSearch is Action

actor ImageSearchTest is Controllerable
  """
  Most image search APIs require you to pay to call them, and that's too rediculous to contemplate for this little example program. 
  So I have included a save search for kittens, which will be loaded no matter what yiou put in the field.
  http://api.qwant.com/api/search/images?count=250&q=kittens&t=images&local=en_US&uiv=4
  """
  
  let font:Font = Font(TestFontJson())
  
  let resultsView:String = "results_view"
  let searchKey:String = "search_key"
    
	fun ref mainNode():YogaNode iso^ =>
    
    recover iso 
      YogaNode.>paddingAll(6).>columns().>columnsReversed()
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
            
            // Scroll view containing the search results
            YogaNode.>paddingLeft(6).>paddingRight(6).>shrink()
                    .>clips(true)
                    .>view( Scroll.>horizontal(false) )
                    .>addChild(
                        
                        YogaNode.>fit().>rows().>wrap().>justifyCenter()
                                .>name(resultsView)
                                
                      )
            
            // Top bar containing the search field
            YogaNode.>height(60).>minWidth(200).>rows().>paddingAll(6)
                    .>view( Image.>path("dialog_background").>stretchAll(12).>renderInset(-100,-200,-5,-30) )
                    .>addChildren( [ 
                      
                        YogaNode.>focusIdx(0).>itemsStart().>justifyCenter()
                                .>view( Image.>path("dialog_field").>pathFocused("dialog_field_focused").>stretchAll(5).>renderInset(0,0,0,-6) )
                                .>view( TextField.>placeholder("Search for kittens!").>font(font, 18).>renderInset(2,50,2,4).>eventInsetAll(-6).>action(this, PerformImageSearch).>sync(this, searchKey) )
                                .>addChild(
                                  YogaNode.>left(10).>size(24,24)
                                          .>view( Image.>path("search").>aspectFit().>renderInset(0,0,0,0) )
                                
                                )
                      
                      ] )              
             
          ])
      end
    
  be action(evt:Action) =>
    if engine as RenderEngine then
        match evt
        | PerformImageSearch => performImageSearch()
        end
    end
  
  fun ref performImageSearch() =>
    try
      var searchString = getSyncData(searchKey)?
      
      // we only allow searches for kittens, stoopid
      searchString = "kittens"
      
      setSyncData(searchKey, searchString)
      
      if (searchString as String) then
        Log.println("Search for images with the term \"%s\"", searchString)
        
        // Pretend to call the server here, then we load the results we have stored locally
        let response = recover val ImageSearchResponse.fromString(Kittens250Json())? end
        
        if engine as RenderEngine then
          
          // Changes to the node hierarchy can only be done by the RenderEngine. We want to make this 
          // an atomic operation, so we run this code as the RenderEngine (ie we do it in one message
          // instead of many)
          engine.run({ (self) =>
            let selfTag:RenderEngine tag = self
            let resultsNode = self.node.getNodeByName(resultsView)
            if resultsNode as YogaNode then
              resultsNode.removeChildren()
                            
              for item in response.data.result.items.values() do
                let mediaURL = "https:" + item.thumbnail
                
                // Before we download the image, we can check and see if the texture exists already. If it does, there
                // is no need to download it!
                var image_width:F32 = 0
                var image_height:F32 = 0
                @RenderEngine_textureInfo(self.renderContext, mediaURL.cpointer(), addressof image_width, addressof image_height)
                
                // Its ok to call this repeatedly, it won't redownload it if it already exists
                selfTag.createTextureFromUrl(mediaURL)
                
                let resultView = YogaNode.>height(200).>maxHeight(200).>widthAuto().>grow().>marginAll(2).>aspectRatio(item.thumb_width / item.thumb_height)
                                         .>view( Color.>gray() )
                                         .>view( Image.>path(mediaURL).>aspectFill() )
                                         
                resultsNode.addChild(resultView)
                
              end
              
              self.setNeedsLayout()
            end
          })
        end
        
      end
    end
    