use "fileExt"
use "flow"
use "bitmap"

use "lib:yoga-osx" if osx
use "lib:yoga-ios" if ios

use "lib:c++"


class SampleYogaNode
  """
  Given how closely tied a layout engine might be to its view framework, this "YGNode" class is here simply
  as an example of how one might wrap libyoga in Pony.
  """
  let node:YGNodeRef
  
  new create() =>
    node = @YGNodeNew()
  
  fun ref setWidth(w:F32) =>
    @YGNodeStyleSetWidth(node, w)
  
  fun ref setHeight(h:F32) =>
    @YGNodeStyleSetHeight(node, h)
  
  fun addChild(child:SampleYogaNode) =>
    @YGNodeInsertChild(node, child.node, @YGNodeGetChildCount(node))
  
  fun layout() =>
    @YGNodeCalculateLayout(node, 800, 600, YGDirection.ltr)
  
  fun print() =>
    @YGNodePrint(node, YGPrintOptions.layout or YGPrintOptions.style or YGPrintOptions.children)

    
    
    
    
    
    
    

