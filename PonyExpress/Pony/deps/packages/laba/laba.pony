/* The Labal notation is very minimalistic. Each command is a single, non numerical character (excluding +/-).
 * Each command can optionally be followed by a single numerical value, which makes sense only in the context of the command. For example,
 * "<120" would mean animate left 120 units.
 *
 * ? argument replacement, replaced in order by arguments supplied to the constructor such as node.laba("d?<?", duration, movement)
 *
 * I staggered interlude (delay) for the current pipe. Inverting meand reverse child order.
 * i interlude (delay) for the current pipe
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
 * D staggered duration for current pipe. Inverting meand reverse child order.
 * d duration for current pipe
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
 */

use "ponytest"

use "ui"
use "easings"
use "linal"
use "utility"
use "stringext"

type LabaCompleteCallback is {(YogaNode,Laba)}

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
  var _s:F32 = 0
  var _a:F32 = 0
  
  var x_sync:Bool = false
  var y_sync:Bool = false
  var w_sync:Bool = false
  var h_sync:Bool = false
  var s_sync:Bool = false
  var a_sync:Bool = false

  new create(target':YogaNode) =>
    target = target'
  
  fun ref getSiblingIdx(inverted:Bool = false):USize => 
    if inverted then
      (target.sibling_count + 1) - (target.sibling_index + 1)
    else
      target.sibling_index + 1
    end
  
  fun ref getSiblingCount():USize => 
    target.sibling_count + 1
  
  fun ref getX():F32 => _x
  fun ref setX(x:F32) => _x = x; x_sync = true
  
  fun ref getY():F32 => _y
  fun ref setY(y:F32) => _y = y; y_sync = true
  
  fun ref getWidth():F32 => _w
  fun ref setWidth(w:F32) => _w = w; w_sync = true
  
  fun ref getHeight():F32 => _h
  fun ref setHeight(h:F32) => _h = h; h_sync = true
  
  fun ref getScale():F32 => _s
  fun ref setScale(s:F32) => _s = s; s_sync = true
  
  fun ref getAlpha():F32 => _a
  fun ref setAlpha(a:F32) => _a = a; a_sync = true
  
  fun ref syncFromNode() =>
    _x = target.getLeft()
    _y = target.getTop()
    _w = target.getWidth()
    _h = target.getHeight()
    _s = target.getScale()._1
    _a = target.getAlpha()
  
  fun ref syncToNode() =>
    if x_sync then target.left(_x); x_sync = false end
    if y_sync then target.top(_y); y_sync = false end
    if w_sync then target.width(_w); w_sync = false end
    if h_sync then target.height(_h); h_sync = false end
    if s_sync then target.scaleAll(_s); s_sync = false end
    if a_sync then target.alpha(_a); a_sync = false end


class Laba
"""
  Parses a Laba animation string into groups of Laba actions and effectuates the
  actual animation process (an outside entity calls animate with timing deltas)
"""  
  let onCompleteCallback:(LabaCompleteCallback|None)
  let groups:Array[LabaActionGroup]
  let target:LabaTarget
  let animationString:String val
  
  var lazyInit:Bool = true
  var animationValue:F32 = 0.0
  
  
  new create(node:YogaNode, animationString':String val, args:(Array[F32]|None) = None, onCompleteCallback':(LabaCompleteCallback|None) = None) =>
    onCompleteCallback = onCompleteCallback'
    
    if args as Array[F32] then
      // User supplied arguments exist, we need to replace ? in the animation strings with those arguments
      let newAnimationString:String trn = animationString'.clone()
      
      for arg in args.values() do
        newAnimationString.replace("?", arg.string(), 1)
      end
            
      animationString = consume newAnimationString
    else
      animationString = animationString'
    end

    
    target = LabaTarget(node)
    groups = Array[LabaActionGroup](32)
    
  fun ref reset() =>
    parse()
  
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
    
    animationValue = 0.0
    
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
        | 'f' => action = LabaActionFade(c, target, parser, inverted, group.easing)
        
        | 'w' => action = LabaActionWidth(c, target, parser, inverted, group.easing)
        | 'h' => action = LabaActionHeight(c, target, parser, inverted, group.easing)
        
        | 's' => action = LabaActionScale(c, target, parser, inverted, group.easing)
        
        | 'e' => easing = try parser.i32()?.u32() else EasingID.cubicInOut end; group.easing = easing
        
        | 'D' =>
          group.duration = (try parser.f32()? else LabaConst.duration end) * target.getSiblingIdx(inverted).f32()
          inverted = false
        | 'd' =>
          group.duration = try parser.f32()? else LabaConst.duration end
          inverted = false
        
        | 'I' =>
          group.delay = (try parser.f32()? else LabaConst.delay end) * target.getSiblingIdx(inverted).f32()
        | 'i' =>
          group.delay = try parser.f32()? else LabaConst.delay end
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
    
    if (onCompleteCallback as LabaCompleteCallback) and (groups.size() == 0) then
      onCompleteCallback(target.target, this)
    end
    
    (groups.size() == 0)    
  


	
  
	


