use "ttimer"
use "yoga"
use "linal"
use "stringext"
use "utility"

use @RenderEngine_init[RenderContextRef](engine:RenderEngine tag)
use @RenderEngine_destroy[None](ctx:RenderContextRef tag)

primitive RenderContext
type RenderContextRef is Pointer[RenderContext]

type GetYogaNodeCallback is {((YogaNode ref | None)):Bool} val


// Context passed to all views when they are told to render. It contains information
// used by the RenderPrimitive but isn't necessary for the view itself to worry about
class FrameContext
  var engine:RenderEngine tag
  var renderContext:RenderContextRef tag
  var frameNumber:U64
  var renderNumber:U64
  var matrix:M4
  var nodeID:YogaNodeID
  
  new ref create(engine':RenderEngine tag, renderContext':RenderContextRef tag, nodeID':YogaNodeID, frameNumber':U64, renderNumber':U64, matrix':M4) =>
    engine = engine'
    renderContext = renderContext'
    frameNumber = frameNumber'
    renderNumber = renderNumber'
    matrix = matrix'
    nodeID = nodeID'
  
  fun calcRenderNumber(frameContext:FrameContext val, partNum:U64, internalOffset:U64):U64 =>
    // Each view receives 100 "render slots" for submitting geometry. The first 10 and the last 10
    // of those render slots are reserved for internal use only (for things like stencil
    // buffer clipping).
    ((frameContext.renderNumber * 100) + (10 + partNum)) - internalOffset
  
  fun clone():FrameContext val =>
    recover val
      FrameContext(engine, renderContext, nodeID, frameNumber, renderNumber, matrix)
    end

actor@ RenderEngine
  """
  The render engine is responsible for sending "renderable chunks" across the FFI to the 3D engine
  one whatever platform we are on. A renderable chunk consists of
  1. all geometric data, already transformed and ready to render
  2. information regarding what shader it should be rendered with
  3. information regarding what textures should be active for its rendering
  
  For each frame of the rendering, the render engine is responsible for passing these 
  chunks across the FFI. Each chunk is tagged with a unique frame number. The frame
  number allows the Pony render engine and the platform render engine to run
  completely independently of each other.
  
  Each series of renderable chunks must end with the "end chunk", which lets the
  platform render engine know that all of the rendering for this frame has been
  completed.
  
  In our view hierarchy, the render engine can be seen as the "root" view under
  which all renderable views are placed. The render engine's bounds alway match
  the renderable area of the "window" it is in.
  
  The view hierarchy built using yoga nodes. Each yoga node has a View actor 
  associated with it. The render engine stores the entirety of the yoga
  hierarchy.
  
  This has the distinct advantage that when rendering needs to happen,
  the render engine can iterate quickly over all nodes and ask their
  actors to render themselves. The render engine then knows exactly how
  many actors it should expect to hear from to know that all rendering
  for this frame has been completed.
  
  View inherently know nothing about how they are laid out. They are
  simply told to render in a Rect, and they need to do that to the
  best of their ability.
  
  YogaNodes are responsible for supplying information about how their
  associated view should be laid out.
  """
  let renderContext:RenderContextRef tag
	let node:YogaNode
  
  var layoutNeeded:Bool = false
  var renderNeeded:Bool = false
  var startNeeded:Bool = false
  
  var frameNumber:U64 = 0
  var waitingOnViewsToRender:U64 = 0
  var waitingOnViewsToStart:U64 = 0
  
  var variable_cpu_throttle:U64 = 25
  
  fun _tag():U32 => 2002
  fun _batch():U32 => 5_000_000
  fun _prioritiy():U32 => -1
  
  fun tag root():String val => "Root"
  
  fun _final() =>
    @RenderEngine_destroy(renderContext)
  
  new empty() =>
    node = YogaNode.>name(root())
    renderContext = RenderContextRef
  
	new create() =>
    node = YogaNode.>name(root())
    renderContext = @RenderEngine_init(this)
  
  fun ref handleNewNodeAdded() =>
    startNeeded = true
  
  be addToNodeByName(nodeName:String val, yoga:YogaNode iso) =>
    let found_node = node.getNodeByName(nodeName)
    
    match found_node
    | let n:YogaNode => 
      n.removeChildren()
      n.addChild( consume yoga )
    end
    
    // TODO: this doesn't compile, fix!
    /*
    if found_node as YogaNode then
      found_node.addChild( consume yoga )
    end
    */
    handleNewNodeAdded()
    
  
  be addNode(yoga:YogaNode iso) =>
    node.addChild( consume yoga )
    handleNewNodeAdded()
  
  be getNodeByName(nodeName:String val, callback:GetYogaNodeCallback) =>
    layoutNeeded = callback(node.getNodeByName(nodeName)) or layoutNeeded
  
  be getNodeByID(id:YogaNodeID, callback:GetYogaNodeCallback) =>
    layoutNeeded = callback(node.getNodeByID(id)) or layoutNeeded
  
  be updateBounds(w:F32, h:F32) =>
    // update the size of my node to match the window, then relayout everything
    node.>width(w).>height(h)
    layout()
      
  fun ref layout() =>
    layoutNeeded = false
    renderNeeded = true
    node.layout()
    //node.print()
  
  fun ref markRenderFinished() =>
    @RenderEngine_render(renderContext, frameNumber, U64.max_value(), ShaderType.finished, 0, UnsafePointer[F32], 0, 1.0, 1.0, 1.0, 1.0, Pointer[U8])
    
  be renderAll() =>
    // run through all yoga nodes and render their associated views
    // keep track of how many views were told to render so we can know when they're all done
        
    if startNeeded then
      if (waitingOnViewsToStart == 0) then
        let frameContext = FrameContext(this, renderContext, node.id(), 0, 0, M4fun.id())
        waitingOnViewsToStart = node.start(frameContext)
        startNeeded = false
      else
        Log.println("startNeeded required but waitingOnViewsToStart is not 0 (is it %s) \n", waitingOnViewsToStart)
        markRenderFinished()
        return
      end
    end
    
    if layoutNeeded then
      layout()
    end
        
    if renderNeeded and (waitingOnViewsToRender == 0) then
      renderNeeded = false
            
      frameNumber = frameNumber + 1
      
      let frameContext = FrameContext(this, renderContext, node.id(), frameNumber, 0, M4fun.id())
      waitingOnViewsToRender = node.render(frameContext)
    else
      markRenderFinished()
    end
  
  be setNeedsRendered() =>
    renderNeeded = true
  
  be setNeedsLayout() =>
    layoutNeeded = true
  
  
  be startFinished() =>
    if waitingOnViewsToStart <= 0 then
      waitingOnViewsToStart = 0
    else
      waitingOnViewsToStart = waitingOnViewsToStart - 1
      if waitingOnViewsToStart == 0 then
        layoutNeeded = true
      end
    end
  
  be renderFinished() =>
    if waitingOnViewsToRender <= 0 then
      waitingOnViewsToRender = 0
      Log.println("Error: renderFinished called but waitingOnViewsToRender is 0")
    else
      waitingOnViewsToRender = waitingOnViewsToRender - 1
      if waitingOnViewsToRender == 0 then
        markRenderFinished()
      end
    end
  
  be touchEvent(id:USize, pressed:Bool, x:F32, y:F32) =>
    let frameContext = FrameContext(this, renderContext, node.id(), 0, 0, M4fun.id())
    node.event(frameContext, TouchEvent(id, pressed, x, y))
  
