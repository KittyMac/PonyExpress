use "utility"
use "yoga"

primitive SwitchToColors is Action
primitive SwitchToButtons is Action
primitive SwitchToImages is Action
primitive SwitchToFonts is Action
primitive SwitchToFonts2 is Action

type CatalogAction is (SwitchToColors | SwitchToButtons | SwitchToImages | SwitchToFonts | SwitchToFonts2)
  

actor Catalog is Controllerable
  // Our UI is a side-bar of menu items and a right panel which switches between the various tests
  
  let font:Font = Font(TestFontJson())
  
  fun ref mainNode():YogaNode iso^ =>
    let main = recover iso
      YogaNode.>alignItems(YGAlign.flexstart)
              .>flexDirection(YGFlexDirection.row)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
        
          // Sidebar
          YogaNode.>width(210)
                  .>heightPercent(100)
                  .>view( Image("sidebar").>stretch(10,10,10,10) )
                  .>addChildren([
              menuButton("Colors", font, SwitchToColors)
              menuButton("Buttons", font, SwitchToButtons)
              menuButton("Images", font, SwitchToImages)
              menuButton("Fonts", font, SwitchToFonts)
              menuButton("Fonts2", font, SwitchToFonts2)
          ])
        
          // Panel
          YogaNode.>name("Panel")
                  .>view( Clear )
                  .>flexGrow(1.0)
                  .>flexShrink(1.0)
                  .>fill()
          
        ]
      )
    end
    
    action(SwitchToColors)
    
    main
  
  fun tag menuButton(title:String, font':Font, evt:CatalogAction):YogaNode =>
    YogaNode.>width(204)
            .>height(46)
            .>padding(YGEdge.all, 6)
            .>padding(YGEdge.left, 12)
            .>view( ImageButton( "white", "white").>pressedColor(RGBA.u32( 0x98cbf3ff ))
                                                  .>color(RGBA.u32( 0xffffff00 ))
                                                  .>action(this, evt) )
            .>addChild( YogaNode.>view( Label(title, font', 28).>left() ) )

    
  be action(evt:Action) =>
    if renderEngine as RenderEngine then
        match evt
        | SwitchToColors => ColorTest.load(renderEngine, "Panel")
        | SwitchToButtons => ButtonTest.load(renderEngine, "Panel")
        | SwitchToImages => ImageTest.load(renderEngine, "Panel")
        | SwitchToFonts => FontTest.load(renderEngine, "Panel")
        | SwitchToFonts2 => Font2Test.load(renderEngine, "Panel")
        end
    end
    
    
