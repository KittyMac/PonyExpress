use "ttimer"
use "yoga"
use "linal"
use "stringext"
use "utility"

trait Controllerable
  var renderEngine:(RenderEngine tag|None) = None
  var nodeNamed:String = "Root"    
  
  fun ref mainNode():YogaNode iso^ =>
    recover iso YogaNode end
    
  fun ref reload() =>
    if renderEngine as RenderEngine then
      renderEngine.addToNodeByName(nodeNamed, mainNode())
    end
  
  be load(renderEngine':RenderEngine tag, nodeNamed':String val) =>
    renderEngine = renderEngine'
    nodeNamed = nodeNamed'
    reload()
    
  
  be action(evt:Action) =>
    None
