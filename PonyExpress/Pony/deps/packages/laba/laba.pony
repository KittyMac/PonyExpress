/* The Labal notation is very minimalistic. Each command is a single, non numerical character (excluding +/-).
 * Each command can optionally be followed by a single numerical value, which makes sense only in the context of the command. For example,
 * "<120" would mean animate left 120 units.
 *
 * ? argument replacement, replaced in order by arguments supplied to the constructor such as node.laba("d?<?", duration, movement)
 *
 * ~ delay (inverted means staggered based on child index)
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
 * d duration for current pipe (inverted means staggered based on child index)
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

// Note: we cannot just use None here, because None is Stringable
type LabaArgument is (F32|None)

primitive LabaConst
  let duration:F32 = 0.87
  let delay:F32 = 0.27

class LabaActionGroup
  let actions:Array[LabaAction]
  var duration:F32 = LabaConst.duration
  var delay:F32 = 0.0
  var easing:U32 = EasingID.cubicInOut
  
  new create() =>
    actions = Array[LabaAction](32)
    
  fun ref push(action:LabaAction) =>
    actions.push(action)
    
  fun values():ArrayValues[LabaAction, this->Array[LabaAction]]^ =>
    actions.values()
  
  fun totalDuration():F32 =>
    delay + duration
    
  fun ref commit(target:LabaTarget) =>
    for action in actions.values() do
      action.update(target, 1.0)
    end
    
  fun ref update(target:LabaTarget, animationValue:F32):Bool =>
    let normalizedValue = ( (animationValue - delay) / duration ).min(1.0).max(0.0)
    for action in actions.values() do
      action.update(target, normalizedValue)
    end
    target.syncToNode()
    (normalizedValue >= 1.0)
    
  fun ref toString(string:String ref) =>
    for action in actions.values() do
      action.toString(string)
    end
    string.push('|')
    
    
class LabaTarget
"""
  Stores and then simulates changes to target animatable properties over time
"""
  let target:YogaNode
  var _x:F32 = 0
  var _y:F32 = 0
  var _w:F32 = 0
  var _h:F32 = 0
  
  var x_sync:Bool = false
  var y_sync:Bool = false
  var w_sync:Bool = false
  var h_sync:Bool = false

  new create(target':YogaNode) =>
    target = target'
  
  fun ref getSiblingIdx():USize => 
    target.sibling_index + 1
  
  fun ref getX():F32 => _x
  fun ref setX(x:F32) => _x = x; x_sync = true
  
  fun ref getY():F32 => _y
  fun ref setY(y:F32) => _y = y; y_sync = true
  
  fun ref getWidth():F32 => _w
  fun ref setWidth(w:F32) => _w = w; w_sync = true
  
  fun ref getHeight():F32 => _h
  fun ref setHeight(h:F32) => _h = h; h_sync = true
  
  fun ref syncFromNode() =>
    _x = target.getLeft()
    _y = target.getTop()
    _w = target.getWidth()
    _h = target.getHeight()
  
  fun ref syncToNode() =>
    if x_sync then target.left(_x); x_sync = false end
    if y_sync then target.top(_y); y_sync = false end
    if w_sync then target.width(_w); w_sync = false end
    if h_sync then target.height(_h); h_sync = false end


class Laba
"""
  Parses a Laba animation string into groups of Laba actions and effectuates the
  actual animation process (an outside entity calls animate with timing deltas)
"""  
  let groups:Array[LabaActionGroup]
  let target:LabaTarget
  let animationString:String val
  
  var lazyInit:Bool = true
  var animationValue:F32 = 0.0
  
  
  new create(node:YogaNode, animationString':String val,  arg0:LabaArgument = None,
                                                  				arg1:LabaArgument = None, 
                                                  				arg2:LabaArgument = None,
                                                  				arg3:LabaArgument = None,
                                                  				arg4:LabaArgument = None,
                                                  				arg5:LabaArgument = None,
                                                  				arg6:LabaArgument = None,
                                                  				arg7:LabaArgument = None,
                                                  				arg8:LabaArgument = None,
                                                  				arg9:LabaArgument = None,
                                                  				arg10:LabaArgument = None,
                                                  				arg11:LabaArgument = None, 
                                                  				arg12:LabaArgument = None,
                                                  				arg13:LabaArgument = None,
                                                  				arg14:LabaArgument = None,
                                                  				arg15:LabaArgument = None,
                                                  				arg16:LabaArgument = None,
                                                  				arg17:LabaArgument = None,
                                                  				arg18:LabaArgument = None,
                                                  				arg19:LabaArgument = None) =>
        
    if arg0 as F32 then
      // User supplied arguments exist, we need to replace ? in the animation strings with those arguments
      let newAnimationString:String trn = animationString'.clone()
      
      newAnimationString.replace("?", arg0.string(), 1)
      
      if arg1 as F32 then newAnimationString.replace("?", arg1.string(), 1) end
      if arg2 as F32 then newAnimationString.replace("?", arg2.string(), 1) end
      if arg3 as F32 then newAnimationString.replace("?", arg3.string(), 1) end
      if arg4 as F32 then newAnimationString.replace("?", arg4.string(), 1) end
      if arg5 as F32 then newAnimationString.replace("?", arg5.string(), 1) end
      if arg6 as F32 then newAnimationString.replace("?", arg6.string(), 1) end
      if arg7 as F32 then newAnimationString.replace("?", arg7.string(), 1) end
      if arg8 as F32 then newAnimationString.replace("?", arg8.string(), 1) end
      if arg9 as F32 then newAnimationString.replace("?", arg9.string(), 1) end
      if arg10 as F32 then newAnimationString.replace("?", arg10.string(), 1) end
      if arg11 as F32 then newAnimationString.replace("?", arg11.string(), 1) end
      if arg12 as F32 then newAnimationString.replace("?", arg12.string(), 1) end
      if arg13 as F32 then newAnimationString.replace("?", arg13.string(), 1) end
      if arg14 as F32 then newAnimationString.replace("?", arg14.string(), 1) end
      if arg15 as F32 then newAnimationString.replace("?", arg15.string(), 1) end
      if arg16 as F32 then newAnimationString.replace("?", arg16.string(), 1) end
      if arg17 as F32 then newAnimationString.replace("?", arg17.string(), 1) end
      if arg18 as F32 then newAnimationString.replace("?", arg18.string(), 1) end
      if arg19 as F32 then newAnimationString.replace("?", arg19.string(), 1) end
      
      animationString = consume newAnimationString
    else
      animationString = animationString'
    end

    
    target = LabaTarget(node)
    groups = Array[LabaActionGroup](32)
  
  fun ref print() =>
    var string:String ref = String(2048)
    string.push('[')
    for group in groups.values() do
      group.toString(string)
    end
    try string.pop()? end
    string.push(']')
    Log.println("%s", string)
  
  fun ref parse() =>
    // parse the laba string into a series of LabaActions which can be used to
    // make the animation happen. Note that we cannot do this in create(), because
    // the node as not yet been laid out. So we do it on the first call to animate.
    let parser = StringParser(animationString)
    var easing:U32 = EasingID.cubicInOut
    var inverted:Bool = false
    var action:(LabaAction|None) = None
    var group = LabaActionGroup
    
    target.syncFromNode()
    
    groups.push(group)
    
    while true do
      try
        let c = parser.u8()?
        match c
        | '!' => inverted = true
        | '<' => action = LabaActionMoveX(c, target, parser, -1, inverted, group.easing)
        | '>' => action = LabaActionMoveX(c, target, parser, 1, inverted, group.easing)
        | '^' => action = LabaActionMoveY(c, target, parser, -1, inverted, group.easing)
        | 'v' => action = LabaActionMoveY(c, target, parser, 1, inverted, group.easing)
        
        | 'e' => easing = try parser.i32()?.u32() else EasingID.cubicInOut end; group.easing = easing
        
        | 'd' => 
          if inverted then
            group.duration = (try parser.f32()? else LabaConst.duration end) * target.getSiblingIdx().f32()
          else
            group.duration = try parser.f32()? else LabaConst.duration end
          end
          inverted = false
        
        | '~' =>
          if inverted then
            group.delay = (try parser.f32()? else LabaConst.delay end) * target.getSiblingIdx().f32()
          else
            group.delay = try parser.f32()? else LabaConst.delay end
          end
          inverted = false
        
        | '|' =>
          group.commit(target)
          group = LabaActionGroup
          group.easing = easing
          groups.push(group)
        end
      
        if action as LabaAction then
          group.push(action)
          inverted = false
        end
        action = None

      else
        break
      end
    end
    
    target.syncFromNode()
    
    //print()
  
  fun ref animate(delta:F32 val):Bool =>
    
    if lazyInit then
      parse()
      lazyInit = false
    end
    
    animationValue = (animationValue + delta)
    
    try
      let group = groups(0)?
      
      if group.update(target, animationValue) then
        animationValue = animationValue - group.totalDuration()
        groups.delete(0)?
      end
      
    else
      Log.println("animate failed with %s", animationValue)
      return true
    end
    
    (groups.size() == 0)    
  


	
  
	


