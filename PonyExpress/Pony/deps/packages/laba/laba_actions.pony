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
 * e easing (we allow e# for shorthand or full easeInOutQuad)
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
"""
  new create(operator':U8, target:LabaTarget, parser:StringParser, mod:F32, inverted':Bool, easing':U32) =>
    operator = operator'
    inverted = inverted'
    easing = easing'
    value = try parser.f32()? else target.getWidth() end
    if inverted then
      to = target.getX()
      from = to - (mod * value)
    else
      from = target.getX()
      to = from + (mod * value)
    end
    
  fun update(target:LabaTarget, animationValue:F32) =>
    target.setX( Easing.tween(easing,from,to,animationValue) )
    //Log.println("%s: from %s,  to %s,  v %s", target.getX(), from, to, animationValue)

class LabaActionMoveY is LabaAction
"""
  ^100 is move the target 100 units up
  v100 is move the target 100 units down
"""
  new create(operator':U8, target:LabaTarget, parser:StringParser, mod:F32, inverted':Bool, easing':U32) =>
    operator = operator'
    inverted = inverted'
    easing = easing'
    value = try parser.f32()? else target.getHeight() end
    if inverted then
      to = target.getY()
      from = to - (mod * value)
    else
      from = target.getY()
      to = from + (mod * value)
    end
    
    
  fun update(target:LabaTarget, animationValue:F32) =>
    target.setY( Easing.tween(easing,from,to,animationValue) )
    //Log.println("%s: from %s,  to %s,  v %s", target.getY(), from, to, animationValue)
