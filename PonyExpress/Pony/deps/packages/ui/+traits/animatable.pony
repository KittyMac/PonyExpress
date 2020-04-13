use "linal"

trait Animatable
  """
  For things which want to receive a callback suitable for performing animations
  """
  var animation_target:(Controllerable tag | None) = None
  
  be animate(animation_target':Controllerable tag) =>
    animation_target = animation_target'
  
  fun ref performAnimation(frameContext:FrameContext val) =>
    match animation_target
    | let t:Controllerable tag =>
      t.animate(frameContext.animation_delta)
    else None end