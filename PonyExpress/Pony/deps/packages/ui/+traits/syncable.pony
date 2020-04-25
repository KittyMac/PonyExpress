use "linal"

type SyncType is (None|String|I32|U32|F32|I64|U64|F64)

trait Syncable
  """
  For things which want to sync a mutable value to a controller, like a text field may want
  to keep the controller informed as to what its current value is.
  """
  var target:(Controllerable tag | None) = None
  var controllerKey:String val = ""
  
  fun ref syncDidUpdate(value:SyncType val)
  
  be sync(target':Controllerable tag, controllerKey':String val) =>
    target = target'
    controllerKey = controllerKey'
    registerSync()
  
  be sync_update(controllerKey':String val, value:SyncType val) =>
    if controllerKey == controllerKey' then
      syncDidUpdate(value)
    end
  
  fun ref registerSync() =>
    match target
    | let t:Controllerable tag => t.sync_register(controllerKey, this)
    else None end
  
  fun ref unregisterSync() =>
    match target
    | let t:Controllerable tag => t.sync_unregister(controllerKey, this)
    else None end
  
  fun ref updateSync(value:SyncType val) =>
    match target
    | let t:Controllerable tag => t.sync_update(controllerKey, value)
    else None end
  
  fun ref syncable_finish() =>
    unregisterSync()

  fun ref finish() =>
    syncable_finish()