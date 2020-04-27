use "ttimer"
use "yoga"
use "linal"
use "stringext"
use "utility"

use @RenderEngine_init[RenderContextRef](engine:RenderEngine tag)
use @RenderEngine_destroy[None](ctx:RenderContextRef tag)

use @RenderEngine_beginKeyboardInput[None](ctx:RenderContextRef tag)
use @RenderEngine_endKeyboardInput[None](ctx:RenderContextRef tag)

use @RenderEngine_safeTop[F32]()
use @RenderEngine_safeLeft[F32]()
use @RenderEngine_safeBottom[F32]()
use @RenderEngine_safeRight[F32]()

primitive RenderContext
type RenderContextRef is Pointer[RenderContext]

primitive LayoutNeeded
primitive RenderNeeded
type RenderEngineCommandReturn is (None | LayoutNeeded | RenderNeeded)

type GetYogaNodeCallback is {((YogaNode ref | None)):RenderEngineCommandReturn} val

type RunCallback is {(RenderEngine ref)} val

primitive SafeEdges
  fun top():F32 => @RenderEngine_safeTop()
  fun left():F32 => @RenderEngine_safeLeft()
  fun bottom():F32 => @RenderEngine_safeBottom()
  fun right():F32 => @RenderEngine_safeRight()


// Context passed to all views when they are told to render. It contains information
// used by the RenderPrimitive but isn't necessary for the view itself to worry about
class FrameContext
  var engine:RenderEngine tag
  var renderContext:RenderContextRef tag
  var frameNumber:U64
  var renderNumber:U64
  var matrix:M4
  var clipBounds:R4
  var screenBounds:R4
  var animation_delta:F32
  var parentContentOffset:V2
  var contentSize:V2
  var nodeSize:V2
  var nodeID:YogaNodeID
  var focusedNodeID:YogaNodeID
  
  new ref create(engine':RenderEngine tag, renderContext':RenderContextRef tag, nodeID':YogaNodeID, focusedNodeID':YogaNodeID, frameNumber':U64, renderNumber':U64, matrix':M4, parentContentOffset':V2, nodeSize':V2, contentSize':V2, clipBounds':R4, screenBounds':R4, animation_delta':F32) =>
    engine = engine'
    renderContext = renderContext'
    frameNumber = frameNumber'
    renderNumber = renderNumber'
    matrix = matrix'
    nodeID = nodeID'
    focusedNodeID = focusedNodeID'
    clipBounds = clipBounds'
    screenBounds = screenBounds'
    animation_delta = animation_delta'
    contentSize = contentSize'
    nodeSize = nodeSize'
    parentContentOffset = parentContentOffset'
  
  fun calcRenderNumber(frameContext:FrameContext val, partNum:U64, internalOffset:U64):U64 =>
    // Each view receives 100 "render slots" for submitting geometry. The first 10 and the last 10
    // of those render slots are reserved for internal use only (for things like stencil
    // buffer clipping).
    ((frameContext.renderNumber * 100) + (10 + partNum)) - internalOffset
  
  fun clone():FrameContext val =>
    recover val
      FrameContext(engine, renderContext, nodeID, focusedNodeID, frameNumber, renderNumber, matrix, parentContentOffset, nodeSize, contentSize, clipBounds, screenBounds, animation_delta)
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
  
  var focusedNodeID:YogaNodeID = 0
  
  var layoutNeeded:Bool = false
  var renderNeeded:Bool = false
  var startNeeded:Bool = false
  
  var screenBounds:R4 = R4fun.zero()
  
  var frameNumber:U64 = 0
  var waitingOnViewsToRender:U64 = 0
  var waitingOnViewsToStart:U64 = 0
  
  var last_focus_clear_time:U64 = @ponyint_cpu_tick()
  var last_focus_request_time:U64 = @ponyint_cpu_tick()
  
  var last_animation_time:U64 = @ponyint_cpu_tick()
  var last_animation_delta:F32 = 0
  
  fun _tag():U64 => 2002
  fun _batch():U64 => 5_000_000
  fun _priority():U64 => 999
  
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
    
    // TODO: this doesn't work right, fix in ponyc!
    /*
    if found_node as YogaNode then
      found_node.addChild( consume yoga )
    end
    */
    handleNewNodeAdded()
    
  
  be addNode(yoga:YogaNode iso) =>
    node.addChild( consume yoga )
    handleNewNodeAdded()
  
  be run(callback:RunCallback) =>
    callback(this)
  
  be getNodeByName(nodeName:String val, callback:GetYogaNodeCallback) =>
    match callback(node.getNodeByName(nodeName))
    | LayoutNeeded => layoutNeeded = true
    | RenderNeeded => renderNeeded = true
    end
  
  be getNodeByID(id:YogaNodeID, callback:GetYogaNodeCallback) =>
    match callback(node.getNodeByID(id))
    | LayoutNeeded => layoutNeeded = true
    | RenderNeeded => renderNeeded = true
    end
  
  fun ref invalidateNodeByID(id:YogaNodeID) =>
    let otherNode = node.getNodeByID(id)
    if otherNode as YogaNode then
      let frameContext = FrameContext(this, renderContext, node.id(), focusedNodeID, 0, 0, M4fun.id(), V2fun.zero(), node.nodeSize(), node.contentSize(), R4fun.big(), screenBounds, last_animation_delta)
      otherNode.invalidate(frameContext)
    end
  
  be requestFocus(id:YogaNodeID) =>
    last_focus_request_time = @ponyint_cpu_tick()
    
    if focusedNodeID != id then
      invalidateNodeByID(focusedNodeID)
      invalidateNodeByID(id)
      focusedNodeID = id
      renderNeeded = true
    
      // If this node required access to the keyboard...
      if focusedNodeID != 0 then
        @RenderEngine_beginKeyboardInput(renderContext)
      end
    end
    
  be releaseFocus(id:YogaNodeID) =>
    if focusedNodeID == id then
      focusedNodeID = 0      
      invalidateNodeByID(id)
      renderNeeded = true
      
      @RenderEngine_endKeyboardInput(renderContext)
    end
  
  be advanceFocus() =>
    let focusNode = node.getNodeByID(focusedNodeID)
    if focusNode as YogaNode then
      let nextNode = node.getNodeByFocusIdx(focusNode.getFocusIdx() + 1)
      releaseFocus(focusedNodeID)
      if nextNode as YogaNode then
        requestFocus(nextNode.id())
      end
    else
      releaseFocus(focusedNodeID)
    end
  
  be updateBounds(w:F32, h:F32, safeTop:F32, safeLeft:F32, safeBottom:F32, safeRight:F32) =>
    // update the size of my node to match the window, then relayout everything
    screenBounds = R4fun(0,0,w,h)
    node.>width(w).>height(h)
    layout()
      
  fun ref layout() =>
    layoutNeeded = false
    renderNeeded = true
    node.layout()
    //node.print()
  
  fun ref markRenderFinished() =>
    @RenderEngine_render(renderContext, frameNumber, U64.max_value(), ShaderType.finished, 0, UnsafePointer[F32], 0, 1.0, 1.0, 1.0, 1.0, Pointer[U8])
  
  fun nanoToSec(nano:U64):F32 =>
    nano.f32() / 1_000_000_000.0
  
  be renderAll() =>
    // run through all yoga nodes and render their associated views
    // keep track of how many views were told to render so we can know when they're all done
    
    let now = @ponyint_cpu_tick()
    last_animation_delta = nanoToSec(now - last_animation_time)
    last_animation_time = now
    
    // Check if we need to clear focus: has it been sufficient time since the last request to
    // clear focus event
    if (focusedNodeID != 0) and (last_focus_clear_time > last_focus_request_time) and (nanoToSec(last_animation_time - last_focus_clear_time) > 0.125) then
      releaseFocus(focusedNodeID)
    end
        
    if startNeeded then
      if (waitingOnViewsToStart == 0) then
        
        // In order to provide *some* level of layout information to the views when they load, we call layout here fully expecting that
        // we will need to layout again once the starts are done
        node.layout()
        
        let frameContext = FrameContext(this, renderContext, node.id(), focusedNodeID, 0, 0, M4fun.id(), V2fun.zero(), node.nodeSize(), node.contentSize(), R4fun.big(), screenBounds, last_animation_delta)
        waitingOnViewsToStart = node.start(frameContext)
        startNeeded = false
        layoutNeeded = false
        renderNeeded = false
      else
        Log.println("startNeeded required but waitingOnViewsToStart is not 0 (it is %s) \n", waitingOnViewsToStart)
        markRenderFinished()
        return
      end
    end
    
    if layoutNeeded then
      layout()
    end
        
    if renderNeeded then
      if (waitingOnViewsToRender == 0) then
        renderNeeded = false
            
        frameNumber = frameNumber + 1
      
        let frameContext = FrameContext(this, renderContext, node.id(), focusedNodeID, frameNumber, 0, M4fun.id(), V2fun.zero(), node.nodeSize(), node.contentSize(), R4fun.big(), screenBounds, last_animation_delta)
        waitingOnViewsToRender = node.render(frameContext)
                
      else
        Log.println("renderNeeded required but waitingOnViewsToRender is not 0 (it is %s) \n", waitingOnViewsToRender)
        markRenderFinished()
      end
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
        renderNeeded = true
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
  
  be renderAbort() =>
    // For some reason we want to skip rendering this frame!
    @RenderEngine_render(renderContext, frameNumber, U64.max_value(), ShaderType.abort, 0, UnsafePointer[F32], 0, 1.0, 1.0, 1.0, 1.0, Pointer[U8])
  
  be touchEvent(id:USize, pressed:Bool, x:F32, y:F32) =>
    // Tapping outside of the focused item should result in it no longer having focus, but we can't really know
    // if/when no one else will respond to this event saying they want the focus. So we set a flag to check
    // in the future, if no one responds requesting the focus in that time then we clear the focus
    if pressed and (focusedNodeID != 0) then
      last_focus_clear_time = @ponyint_cpu_tick()
    end
    
    let frameContext = FrameContext(this, renderContext, node.id(), focusedNodeID, 0, 0, M4fun.id(), V2fun.zero(), node.nodeSize(), node.contentSize(), R4fun.big(), screenBounds, last_animation_delta)
    node.event(frameContext, TouchEvent(id, pressed, x, y))
  
  be scrollEvent(id:USize, dx:F32, dy:F32, px:F32, py:F32) =>
    let frameContext = FrameContext(this, renderContext, node.id(), focusedNodeID, 0, 0, M4fun.id(), V2fun.zero(), node.nodeSize(), node.contentSize(), R4fun.big(), screenBounds, last_animation_delta)
    node.event(frameContext, ScrollEvent(id, dx, dy, px, py))
  
  be keyEvent(pressed:Bool, keyCode:U16, charactersPtr:Pointer[U8] val, x:F32, y:F32) =>
    let frameContext = FrameContext(this, renderContext, node.id(), focusedNodeID, 0, 0, M4fun.id(), V2fun.zero(), node.nodeSize(), node.contentSize(), R4fun.big(), screenBounds, last_animation_delta)
    node.event(frameContext, KeyEvent(pressed, keyCode, recover String.copy_cstring(charactersPtr) end, x, y))
  
  be createTextureFromBytes(name:Pointer[U8] tag, bytes:Pointer[U8] tag, bytesCount:USize) =>
    @RenderEngine_createTextureFromBytes(renderContext, name, bytes, bytesCount)
  
  be createTextureFromUrl(url:String val) =>
    @RenderEngine_createTextureFromUrl(renderContext, url.cstring())