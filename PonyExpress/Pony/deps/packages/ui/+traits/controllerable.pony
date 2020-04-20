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
  
  be sync(key:String val, value:SyncType val) =>
    syncData(key)? = value
