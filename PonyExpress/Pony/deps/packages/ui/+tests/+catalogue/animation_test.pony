use "yoga"
use "utility"
use "collections"

primitive RedSquareAnimation is Action

actor AnimationTest is Controllerable
  // There are several forms of animation:
  // 1. Controllers may want to animate UI elements themselves. This will likely take the form of
  // assigning Laba animation strings to individual yoga nodes. But it could also take the form
  // of a update() callback in which the controller provides custom animation logic
  // 2. Views themselves may have inherent animations, of which the controller doesn't need
  // knowledge or care of (think of an infinite progress bar). We need an optimal way for
  // individual views to handle their own animation (probably as a conseqence of their
  // render time!)
  
  var animation:F32 = 0
  
  let progressView:SampleProgressBar = SampleProgressBar
  
	fun ref mainNode():YogaNode iso^ =>    
    recover iso 
      YogaNode.>rows().>itemsCenter().>justifyCenter().>paddingAll(12)
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)).>animation(this) )
              .>addChildren( [
            
            YogaNode.>name("Progress")
                    .>size(400,40)
                    .>view( progressView )
            
            YogaNode.>name("Square")
                    .>size(200,200)
                    .>view( Color.>red() )
            
            YogaNode.>name("Rainbow")
                    .>size(50,200)
                    .>view( SampleRainbow )
          ])
      end
  
  be animate(delta:F32) =>
    animation = animation + delta
    
    progressView.progress(animation % 1.0)
    
    if engine as RenderEngine then
      engine.getNodeByName("Square", { (node) =>
        if node as YogaNode then
          node.rotateY( 6.28 * animation.sin() )
          RenderNeeded
        else        
          None
        end
      })
    end
    