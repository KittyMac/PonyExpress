/* The Labal notation is very minimalistic. Each command is a single, non numerical character (excluding +/-).
 * Each command can optionally be followed by a single numerical value, which makes sense only in the context of the command. For example,
 * "<120" would mean animate left 120 units.
 *
 * ~ delay
 *
 * w width
 * h height
 *
 * x move to x
 * y move to y
 *
 * < move left
 * > move right
 * ^ move up
 * v move down
 *
 * f alpha fade
 *
 * s uniform scale
 *
 * r roll
 * p pitch
 * a yaw
 *
 * d duration for current pipe
 *
 * D staggaered duration based on sibling/child index
 *
 * L loop (absolute) this segment (value is number of times to loop, -1 means loop infinitely)
 *
 * l loop (relative) this segment (value is number of times to loop, -1 means loop infinitely)
 *
 * e easing (the value is the numeric constant equavalent in pony.easings)
 *
 * | pipe animations (chain)
 *
 * ! invert an action (instead of move left, its move to current position from the right)
 *
 * [] concurrent Laba animations ( example: [>d2][!fd1] )
 *
 */

use "ponytest"

use "ui"
use "easings"
use "linal"
use "utility"
use "stringext"

trait LabaAction
"""
  actions are animatable commands. All of them store their from and to values, and provide the
  interpolated animation value using the easing function provided
"""
  var operator:U8 = 0
  var value:F32 = 0.0
  var from:F32 = 0.0
  var to:F32 = 0.0
  var inverted:Bool = false
  var easing:U32 = EasingID.cubicInOut
  
  fun update(target:LabaTarget, animationValue:F32)
  
  fun ref simpleRelativeValue(parser:StringParser, target:F32, defaultValue:F32, mod:F32 = 1.0) =>
    value = try parser.f32()? else defaultValue end
    if inverted then
      to = target
      from = to - (mod * value)
    else
      from = target
      to = from + (mod * value)
    end
  
  fun ref simpleAbsoluteValue(parser:StringParser, target:F32, defaultValue:F32) =>
    value = try parser.f32()? else defaultValue end
    if inverted then
      to = target
      from = value
    else
      from = target
      to = value
    end
  
  fun ref toString(string:String ref) =>
    if inverted then
      string.push('!')
    end
    string.push(operator)
    string.append(value.string())

class LabaActionMoveX is LabaAction
"""
  <100 is move the target 100 units to the left
  >100 is move the target 100 units to the right
  x100 is move the target to x position 100
"""
  new create(operator':U8, target:LabaTarget, parser:StringParser, mod:F32, inverted':Bool, easing':U32) =>
    operator = operator'
    inverted = inverted'
    easing = easing'
    if mod == 0.0 then
      simpleAbsoluteValue(parser, target.getX(), 0.0)
    else
      simpleRelativeValue(parser, target.getX(), target.getWidth(), mod)
    end
    
  fun update(target:LabaTarget, animationValue:F32) =>
    target.setX( Easing.tween(easing,from,to,animationValue) )
    //Log.println("%s: from %s,  to %s,  v %s", target.getX(), from, to, animationValue)

class LabaActionMoveY is LabaAction
"""
  ^100 is move the target 100 units up
  v100 is move the target 100 units down
  y100 is move the target to y position 100
"""
  new create(operator':U8, target:LabaTarget, parser:StringParser, mod:F32, inverted':Bool, easing':U32) =>
    operator = operator'
    inverted = inverted'
    easing = easing'
    if mod == 0.0 then
      simpleAbsoluteValue(parser, target.getY(), 0.0)
    else
      simpleRelativeValue(parser, target.getY(), target.getHeight(), mod)    
    end
    
  fun update(target:LabaTarget, animationValue:F32) =>
    target.setY( Easing.tween(easing,from,to,animationValue) )
    //Log.println("%s: from %s,  to %s,  v %s", target.getY(), from, to, animationValue)

class LabaActionMoveZ is LabaAction
"""
  y100 is move the target to z position 100
"""
  new create(operator':U8, target:LabaTarget, parser:StringParser, mod:F32, inverted':Bool, easing':U32) =>
    operator = operator'
    inverted = inverted'
    easing = easing'
    if mod == 0.0 then
      simpleAbsoluteValue(parser, target.getZ(), 0.0)
    else
      simpleRelativeValue(parser, target.getZ(), (target.getHeight() + target.getWidth()) / 2, mod)    
    end

  fun update(target:LabaTarget, animationValue:F32) =>
    target.setZ( Easing.tween(easing,from,to,animationValue) )
    //Log.println("%s: from %s,  to %s,  v %s", target.getY(), from, to, animationValue)

class LabaActionFade is LabaAction
"""
  f0 is fade the alpha from current value to zero
  f1 is fade the alpha from current value to one
  !f is fade alpha from zero to current value
"""
  new create(operator':U8, target:LabaTarget, parser:StringParser, inverted':Bool, easing':U32) =>
    operator = operator'
    inverted = inverted'
    easing = easing'
    let v = target.getAlpha()
    value = try parser.f32()? else v end
    if inverted then
      to = v
      from = if to > 0.5 then 0.0 else 1.0 end
    else
      from = v
      to = value
    end
    
    
  fun update(target:LabaTarget, animationValue:F32) =>
    target.setAlpha( Easing.tween(easing,from,to,animationValue) )
    //Log.println("%s: from %s,  to %s,  v %s", target.getAlpha(), from, to, animationValue)

class LabaActionWidth is LabaAction
"""
  w100 is animate the width to 100 units wide
  !w100 is animate the width from 100 units wide to the current width
"""
  new create(operator':U8, target:LabaTarget, parser:StringParser, inverted':Bool, easing':U32) =>
    operator = operator'
    inverted = inverted'
    easing = easing'
    simpleAbsoluteValue(parser, target.getWidth(), target.getWidth())

  fun update(target:LabaTarget, animationValue:F32) =>
    target.setWidth( Easing.tween(easing,from,to,animationValue) )
    //Log.println("%s: from %s,  to %s,  v %s", target.getAlpha(), from, to, animationValue)

class LabaActionHeight is LabaAction
"""
  w100 is animate the high to 100 units wide
  !w100 is animate the high from 100 units wide to the current high
"""
  new create(operator':U8, target:LabaTarget, parser:StringParser, inverted':Bool, easing':U32) =>
    operator = operator'
    inverted = inverted'
    easing = easing'
    simpleAbsoluteValue(parser, target.getHeight(), target.getHeight())

  fun update(target:LabaTarget, animationValue:F32) =>
    target.setHeight( Easing.tween(easing,from,to,animationValue) )
    //Log.println("%s: from %s,  to %s,  v %s", target.getAlpha(), from, to, animationValue)

class LabaActionScale is LabaAction
"""
  s0.8 is animate to 0.8 scale
  !s0.8 is animate from 0.8 scale to the current scale
"""
  new create(operator':U8, target:LabaTarget, parser:StringParser, inverted':Bool, easing':U32) =>
    operator = operator'
    inverted = inverted'
    easing = easing'
    simpleAbsoluteValue(parser, target.getScale(), target.getScale())

  fun update(target:LabaTarget, animationValue:F32) =>
    target.setScale( Easing.tween(easing,from,to,animationValue) )
    //Log.println("%s: from %s,  to %s,  v %s", target.getAlpha(), from, to, animationValue)

class LabaActionRoll is LabaAction
"""
  Z axis rotation
  r0.8 is rotate to 0.8 scale
  !r0.8 is animate from 0.8 scale to the current scale
"""
  new create(operator':U8, target:LabaTarget, parser:StringParser, inverted':Bool, easing':U32) =>
    operator = operator'
    inverted = inverted'
    easing = easing'
    simpleRelativeValue(parser, target.getRoll(), 0.0)

  fun update(target:LabaTarget, animationValue:F32) =>
    target.setRoll( Easing.tween(easing,from,to,animationValue) )
    //Log.println("%s: from %s,  to %s,  v %s", target.getAlpha(), from, to, animationValue)

class LabaActionPitch is LabaAction
"""
  X axis rotation
  p0.8 is rotate by 0.8 scale
  !p0.8 is animate from 0.8 scale to the current scale
"""
  new create(operator':U8, target:LabaTarget, parser:StringParser, inverted':Bool, easing':U32) =>
    operator = operator'
    inverted = inverted'
    easing = easing'
    simpleRelativeValue(parser, target.getPitch(), 0.0)

  fun update(target:LabaTarget, animationValue:F32) =>
    target.setPitch( Easing.tween(easing,from,to,animationValue) )
    //Log.println("%s: from %s,  to %s,  v %s", target.getAlpha(), from, to, animationValue)

class LabaActionYaw is LabaAction
"""
  Y axis rotation
  a0.8 is rotate by 0.8 scale
  !a0.8 is animate from 0.8 scale to the current scale
"""
  new create(operator':U8, target:LabaTarget, parser:StringParser, inverted':Bool, easing':U32) =>
    operator = operator'
    inverted = inverted'
    easing = easing'
    simpleRelativeValue(parser, target.getYaw(), 0.0)

  fun update(target:LabaTarget, animationValue:F32) =>
    target.setYaw( Easing.tween(easing,from,to,animationValue) )
    //Log.println("%s: from %s,  to %s,  v %s", target.getAlpha(), from, to, animationValue)