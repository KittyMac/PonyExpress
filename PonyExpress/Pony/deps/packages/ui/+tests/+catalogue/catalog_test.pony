use "utility"
use "collections"
use "yoga"
use "laba"
use "easings"

primitive SwitchToColors is Action
primitive SwitchToButtons is Action
primitive SwitchToImages is Action
primitive SwitchToFonts is Action
primitive SwitchToFonts2 is Action
primitive SwitchToClips is Action
primitive SwitchToScroll is Action
primitive SwitchToAnimation is Action
primitive SwitchToTextField is Action
primitive SwitchToImageSearch is Action
primitive SwitchToLaba is Action

type CatalogAction is (SwitchToColors | SwitchToButtons | SwitchToImages | SwitchToFonts | SwitchToFonts2 | SwitchToClips | SwitchToScroll | SwitchToAnimation | SwitchToTextField | SwitchToImageSearch | SwitchToLaba)
  

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
                  .>laba("i1.6!f")
                  .>view( Clear )
          
          // Sidebar
          YogaNode.>leftToRight().>width(110).>safeTop()
                  .>laba("i1.6!<")
                  .>view( Image.>path("sidebar").>stretchAll(10) )
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
              menuButton("Image Search", font, SwitchToImageSearch)
              menuButton("Laba", font, SwitchToLaba)
          ])
          
          // Logo
          YogaNode.>absolute().>center()
                  .>addChild(
                      YogaNode.>size(200,200)
                              .>laba("e0d1.2!<100|e5<f0s0.6", None, {(node:YogaNode, self:Laba) => node.removeParent()})
                              .>view(Image.>path("pony_express"))
                    )
          
        ]
      )
    end
    
    action(SwitchToColors)
    
    main
  
  fun tag menuButton(title:String, font':Font, evt:CatalogAction):YogaNode =>
    YogaNode.>width(104)
            .>height(36)
            .>padding(YGEdge.all, 6)
            .>padding(YGEdge.left, 8)
            .>view( ImageButton( "white", "white").>pressedColor(RGBA.u32( 0x98cbf3ff ))
                                                  .>color(RGBA.u32( 0xffffff00 ))
                                                  .>action(this, evt) )
            .>addChild( YogaNode.>view( Label.>value(title).>font(font', 16).>left() ) )
  
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
        | SwitchToImageSearch => ImageSearchTest.load(engine, "Panel")
        | SwitchToLaba => LabaTest.load(engine, "Panel")
        end
    end
    
    
