use "linal"

type SyncType is (None|String|I32|U32|F32|I64|U64|F64)

trait Syncable
  """
  For things which want to sync a mutable value to a controller, like a text field may want
  to keep the controller informed as to what its current value is.
  """
  var target:(Controllerable tag | None) = None
  var controllerKey:String val = ""
  
  be sync(target':Controllerable tag, controllerKey':String val) =>
    target = target'
    controllerKey = controllerKey'
  
  fun ref updateSync(value:SyncType val) =>
    match target
    | let t:Controllerable tag => t.sync(controllerKey, value)
    else None end