use "ttimer"
use "yoga"
use "linal"
use "stringext"
use "utility"
use "collections"

trait Controllerable
  var engine:(RenderEngine tag|None) = None
  var nodeNamed:String = "Root"
  
  var syncData:Map[String,SyncType] = Map[String,SyncType](32)
  var syncObservers:Map[String,Array[Syncable tag]] = Map[String,Array[Syncable tag]](32)
  
  fun ref mainNode():YogaNode iso^ =>
    recover iso YogaNode end
    
  fun ref reload() =>
    if engine as RenderEngine then
      engine.addToNodeByName(nodeNamed, mainNode())
    end
  
  be load(engine':RenderEngine tag, nodeNamed':String val) =>
    engine = engine'
    nodeNamed = nodeNamed'
    reload()
  
  be animate(delta:F32) =>
    None
  
  be action(evt:Action) =>
    None
  
  
  fun ref getSyncData(key:String val):SyncType? =>
    syncData(key)?
  
  fun ref setSyncData(key:String val, value:SyncType val) =>
    syncData(key) = value
    try
      for observer in syncObservers(key)?.values() do
        observer.sync_update(key, value)
      end
    end
  
  be sync_register(key:String val, observer:Syncable tag) =>
    if syncObservers.contains(key) == false then
      syncObservers(key) = Array[Syncable tag](32)
    end
    try
      let observers = syncObservers(key)?
      observers.push(observer)
    end
  
  be sync_unregister(key:String val, observer:Syncable tag) =>
    try
     syncObservers(key)?.deleteAll(observer)
    end
  
  be sync_update(key:String val, value:SyncType val) =>
    syncData(key) = value
