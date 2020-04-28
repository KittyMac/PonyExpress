use "linal"
use "utility"

trait val Action

primitive UnknownAction is Action

trait Actionable
  """
  For things which support the Controller events system
  """
  var target:(Controllerable tag | None) = None
  var evt:Action = UnknownAction
  
  be action(target':Controllerable tag, evt':Action) =>
    target = target'
    evt = evt'
  
  fun ref performAction() =>
    match target
    | let t:Controllerable tag => t.action(evt)
    else None end