use "linal"

trait Animatable
  """
  For things which want to receive a callback suitable for performing animations
  """
  var animation_target:(Controllerable tag | None) = None
  
  be animation(animation_target':Controllerable tag) =>
    animation_target = animation_target'
  
  fun ref animate(delta:F32 val) =>
    None
  
  fun ref performAnimation(frameContext:FrameContext val) =>
    animate(frameContext.animation_delta)
    match animation_target
    | let t:Controllerable tag =>
      t.animate(frameContext.animation_delta)
    else None end