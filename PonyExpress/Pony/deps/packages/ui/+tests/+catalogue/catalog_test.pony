use "utility"
use "yoga"

primitive SwitchToColors is Action
primitive SwitchToButtons is Action
primitive SwitchToImages is Action
primitive SwitchToFonts is Action
primitive SwitchToFonts2 is Action
primitive SwitchToClips is Action
primitive SwitchToScroll is Action
primitive SwitchToAnimation is Action
primitive SwitchToTextField is Action

type CatalogAction is (SwitchToColors | SwitchToButtons | SwitchToImages | SwitchToFonts | SwitchToFonts2 | SwitchToClips | SwitchToScroll | SwitchToAnimation | SwitchToTextField)
  

actor Catalog is Controllerable
  // Our UI is a side-bar of menu items and a right panel which switches between the various tests
  
  let font:Font = Font(TestFontJson())
  
  fun ref mainNode():YogaNode iso^ =>
    let main = recover iso
      YogaNode.>rows().>itemsStart().>rightToLeft()
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
          
          // Panel
          YogaNode.>leftToRight().>safeTop().>flexGrow(1.0).>flexShrink(1.0)
                  .>name("Panel")
                  .>view( Clear )
          
          // Sidebar
          YogaNode.>leftToRight().>width(110).>safeTop()
                  .>view( Image("sidebar").>stretch(10,10,10,10) )
                  .>addChildren([
              menuButton("Colors", font, SwitchToColors)
              menuButton("Buttons", font, SwitchToButtons)
              menuButton("Images", font, SwitchToImages)
              menuButton("Fonts 1", font, SwitchToFonts)
              menuButton("Fonts 2", font, SwitchToFonts2)
              menuButton("Clip", font, SwitchToClips)
              menuButton("Scroll", font, SwitchToScroll)
              menuButton("Animation", font, SwitchToAnimation)
              menuButton("Text Field", font, SwitchToTextField)
          ])
          
        ]
      )
    end
    
    action(SwitchToColors)
    
    main
  
  fun tag menuButton(title:String, font':Font, evt:CatalogAction):YogaNode =>
    YogaNode.>width(104)
            .>height(36)
            .>padding(YGEdge.all, 6)
            .>padding(YGEdge.left, 12)
            .>view( ImageButton( "white", "white").>pressedColor(RGBA.u32( 0x98cbf3ff ))
                                                  .>color(RGBA.u32( 0xffffff00 ))
                                                  .>action(this, evt) )
            .>addChild( YogaNode.>view( Label(title, font', 18).>left() ) )
  
  be action(evt:Action) =>
    if engine as RenderEngine then
        match evt
        | SwitchToColors => ColorTest.load(engine, "Panel")
        | SwitchToButtons => ButtonTest.load(engine, "Panel")
        | SwitchToImages => ImageTest.load(engine, "Panel")
        | SwitchToFonts => FontTest.load(engine, "Panel")
        | SwitchToFonts2 => Font2Test.load(engine, "Panel")
        | SwitchToClips => ClipTest.load(engine, "Panel")
        | SwitchToScroll => ScrollTest.load(engine, "Panel")
        | SwitchToAnimation => AnimationTest.load(engine, "Panel")
        | SwitchToTextField => TextFieldTest.load(engine, "Panel")
        end
    end
    
    
