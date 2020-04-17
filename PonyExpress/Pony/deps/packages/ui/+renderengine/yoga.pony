use "ttimer"
use "yoga"
use "collections"
use "linal"
use "promises"
use "utility"

type YogaNodeID is USize

class YogaNode
  var node:YGNodeRef tag
  var _name:String val
  var _views:Array[Viewable]
  
  var children:Array[YogaNode]
  var last_bounds:R4 = R4fun.zero()
  var last_matrix:M4 = M4fun.id()
  
  var _content_offset:V2 = V2fun.zero()
  var _rotation:V3 = V3fun.zero()
  
  var _clips:Bool = false
  var _clippingGeometry:BufferedGeometry = BufferedGeometry
  var _pushedClippingVertices:FloatAlignedArray = FloatAlignedArray
  
  var _safeTop:Bool = false
  var _safeLeft:Bool = false
  var _safeBottom:Bool = false
  var _safeRight:Bool = false
  
  fun _final() =>
    //@printf("_final called on yoga node [%d]\n".cstring(), node)
    @YGNodeFree(node)
  
	new create() =>
    children = Array[YogaNode](32)
    node = @YGNodeNew()
    _name = ""
    _views = Array[Viewable](12)
    fill()
  
  fun id():YogaNodeID =>
    node.usize()
  
  fun ref getChildren():Array[YogaNode] => children
  
  fun ref addChild(child:YogaNode) =>
    children.push(child)
    @YGNodeInsertChild(node, child.node, @YGNodeGetChildCount(node))
  
  fun ref addChildren(new_children:Array[YogaNode]) =>
    for child in new_children.values() do
      addChild(child)
    end
  
  fun ref removeChild(child:YogaNode) =>
    @YGNodeRemoveChild(node, child.node)
    children.deleteOne(child)
  
  fun ref removeChildren() =>
    children.clear()
    @YGNodeRemoveAllChildren(node)
  
  fun ref layout() =>
    // Before we can calculate the layout, we need to see if any of our children sizeToFit their content. If we do, we need
    // to have them set the size on the appropriate yoga node
    preLayout()
    
    @YGNodeCalculateLayout(node, @YGNodeStyleGetWidth(node), @YGNodeStyleGetHeight(node), YGDirection.ltr)
  
  
  fun ref setContentOffset(x:F32, y:F32) =>
    _content_offset = V2fun(x, y)
  
  fun ref nodeSize():V2 =>
    // width/height of me
    V2fun(@YGNodeLayoutGetWidth(node), @YGNodeLayoutGetHeight(node))
  
  fun ref contentSize():V2 =>
    // width/height from the union of all children bounds
    var c = R4fun.zero()
    var first:Bool = true
    for child in children.values() do
      let r = R4fun(@YGNodeLayoutGetLeft(child.node), @YGNodeLayoutGetTop(child.node), @YGNodeLayoutGetWidth(child.node), @YGNodeLayoutGetHeight(child.node))
      if first then
        c = r
      else
        c = R4fun.union(c, r)
      end
    end
    V2fun(R4fun.width(c), R4fun.height(c))
    
  fun print() =>
    @YGNodePrint(node, YGPrintOptions.layout or YGPrintOptions.style or YGPrintOptions.children)
    @printf("\n".cstring())
  
  fun ref getNodeByName(nodeName:String val):(YogaNode|None) =>
    if _name == nodeName then
      return this
    end
    for child in children.values() do
      let result = child.getNodeByName(nodeName)
      if result as YogaNode then
        return result
      end
    end
    None
  
  fun ref getNodeByID(nodeID:YogaNodeID):(YogaNode|None) =>
    if id() == nodeID then
      return this
    end
    for child in children.values() do
      let result = child.getNodeByID(nodeID)
      if result as YogaNode then
        return result
      end
    end
    None
  
  // Called when the node is first added to the render engine hierarchy
  fun ref start(frameContext:FrameContext):U64 =>
    var n:U64 = frameContext.renderNumber
    
    for local_view in _views.values() do
      
      n = frameContext.renderNumber + 1
    
      frameContext.renderNumber = n
      frameContext.nodeID = id()
      frameContext.contentSize = contentSize()
      frameContext.nodeSize = nodeSize()
      
      local_view.viewable_start( frameContext.clone() )
      
    end
    
    for child in children.values() do
      n = child.start(frameContext)
      frameContext.renderNumber = n
    end
    n
  
  // Called on all nodes right before Yoga layout calculations are made
  fun ref preLayout() =>
    if _safeTop then padding(YGEdge.top, SafeEdges.top()) end
    if _safeLeft then padding(YGEdge.left, SafeEdges.left()) end
    if _safeBottom then padding(YGEdge.bottom, SafeEdges.bottom()) end
    if _safeRight then padding(YGEdge.right, SafeEdges.right()) end  
    
    for child in children.values() do
      child.preLayout()
    end
  
  // Called when distributing events to nodes
  fun ref event(frameContext:FrameContext, anyEvent:AnyEvent val):U64 =>
    var n:U64 = frameContext.renderNumber
    
    for local_view in _views.values() do
      n = frameContext.renderNumber + 1
      
      frameContext.renderNumber = n
      frameContext.matrix = last_matrix
      frameContext.nodeID = id()
      frameContext.contentSize = contentSize()
      frameContext.nodeSize = nodeSize()
    
      local_view.viewable_event( frameContext.clone(), anyEvent, last_bounds )
    end
  
    for child in children.values() do
      n = child.event(frameContext, anyEvent)
      frameContext.renderNumber = n
    end
    n
  
  // Called when the render engine hierarchy needs to... render
  fun ref render(frameContext:FrameContext):U64 =>
    _renderRecursive(frameContext, V2fun.zero(), M4fun.id())
    
  fun ref _renderRecursive(frameContext:FrameContext, parentContentOffset:V2, parent_matrix:M4):U64 =>    
    var n:U64 = frameContext.renderNumber
    
    let local_left:F32 = @YGNodeLayoutGetLeft(node)
    let local_top:F32 = @YGNodeLayoutGetTop(node)
    let local_width:F32 = @YGNodeLayoutGetWidth(node)
    let local_height:F32 = @YGNodeLayoutGetHeight(node)
    
    var local_matrix:M4 = M4fun.mul_m4(
        parent_matrix,
        M4fun.trans_v3(V3fun(local_left, local_top, 0))
      )
    
    local_matrix = M4fun.mul_m4(
            local_matrix,
            M4fun.trans_v3(V3fun(local_width/2, local_height/2, 0))
          )
    
    if (_rotation._1 != 0) or (_rotation._2 != 0) or (_rotation._3 != 0) then
      local_matrix = M4fun.mul_m4(
              local_matrix,
              M4fun.rot(Q4fun.from_euler(_rotation))
            )
    end
    
    frameContext.matrix = local_matrix
    frameContext.nodeID = id()
    frameContext.contentSize = contentSize()
    frameContext.nodeSize = nodeSize()
    frameContext.parentContentOffset = parentContentOffset
    
    last_bounds = R4fun( (-local_width/2)+parentContentOffset._1, (-local_height/2)-parentContentOffset._2, local_width, local_height)
    last_matrix = local_matrix
    
    let savedClipBounds = frameContext.clipBounds
    
    if _clips then
      n = frameContext.renderNumber + 1
      frameContext.renderNumber = n
      
      pushClips( frameContext.clone(), last_bounds )
    end
    
    for local_view in _views.values() do
      n = frameContext.renderNumber + 1
      frameContext.renderNumber = n      
    
      local_view.viewable_render( frameContext.clone(), last_bounds )
    end
    
    local_matrix = M4fun.mul_m4(
            local_matrix,
            M4fun.trans_v3(V3fun(-local_width/2, -local_height/2, 0))
          )
    
    if _clips then
      frameContext.clipBounds = last_bounds
    end
    
    for child in children.values() do
      n = child._renderRecursive(frameContext, _content_offset, local_matrix)
      frameContext.renderNumber = n
    end
    
    if _clips then
      frameContext.clipBounds = savedClipBounds
      
      n = n + 1
      frameContext.renderNumber = n
      
      popClips( frameContext.clone(), last_bounds )
    end
    
    n
  
  
  fun ref pushClips(frameContext:FrameContext val, local_bounds:R4) =>
  
    let geom = _clippingGeometry.next()
    _pushedClippingVertices = geom.vertices
  
    if geom.check(frameContext, local_bounds) == false then
  
      _pushedClippingVertices.reserve(6 * 7)
      _pushedClippingVertices.clear()
  
      let x_min = R4fun.x_min(local_bounds)
      let y_min = R4fun.y_min(local_bounds)
      let x_max = R4fun.x_max(local_bounds)
      let y_max = R4fun.y_max(local_bounds)
  
      RenderPrimitive.quadVC(frameContext,    _pushedClippingVertices,   
                             V3fun(x_min,  y_min, 0.0), 
                             V3fun(x_max,  y_min, 0.0),
                             V3fun(x_max,  y_max, 0.0),
                             V3fun(x_min,  y_max, 0.0),
                             RGBA.white() )
    end
  
    @RenderEngine_pushClips(frameContext.renderContext,
                            frameContext.frameNumber, 
                            frameContext.calcRenderNumber(frameContext, 0, 1),
                            _pushedClippingVertices.size().u32(), 
                            _pushedClippingVertices.cpointer(),
                            _pushedClippingVertices.allocSize().u32())
    RenderPrimitive.renderFinished(frameContext)

  fun ref popClips(frameContext:FrameContext val, local_bounds:R4) =>
    @RenderEngine_popClips(frameContext.renderContext,
                           frameContext.frameNumber, 
                           frameContext.calcRenderNumber(frameContext, 0, 9),
                           _pushedClippingVertices.size().u32(), 
                           _pushedClippingVertices.cpointer(),
                           _pushedClippingVertices.allocSize().u32() )
    RenderPrimitive.renderFinished(frameContext)
  
  
  
  fun ref view(local_view:Viewable) =>
    _views.push(local_view)
  
  fun ref name(name':String val) =>
    _name = name'
  
  fun ref clips(_clips':Bool) =>
    _clips = _clips'
  
  
  // Helper functions for more declaratively defining layouts
  
  fun ref fill() =>
    widthPercent(100)
    heightPercent(100)
  
  fun ref fit() =>
    widthAuto()
    heightAuto()
  
  fun ref center() =>
    @YGNodeStyleSetJustifyContent(node, YGJustify.center)
    @YGNodeStyleSetAlignItems(node, YGAlign.center)
  
  fun ref size(w:F32, h:F32) =>
    @YGNodeStyleSetWidth(node, w)
    @YGNodeStyleSetHeight(node, h)
  
  fun ref sizePercent(w:F32, h:F32) =>
    @YGNodeStyleSetWidthPercent(node, w)
    @YGNodeStyleSetHeightPercent(node, h)
  
  fun ref bounds(x:F32, y:F32, w:F32, h:F32) =>
    @YGNodeStyleSetPosition(node, YGEdge.left, x)
    @YGNodeStyleSetPosition(node, YGEdge.top, y)
    @YGNodeStyleSetWidth(node, w)
    @YGNodeStyleSetHeight(node, h)
  
  fun ref grow(v:F32 = 1.0) => @YGNodeStyleSetFlexGrow(node, v)
  fun ref shrink(v:F32 = 1.0) => @YGNodeStyleSetFlexShrink(node, v)
  
  fun ref safeTop(v:Bool=true) => _safeTop = v
  fun ref safeLeft(v:Bool=true) => _safeLeft = v
  fun ref safeBottom(v:Bool=true) => _safeBottom = v
  fun ref safeRight(v:Bool=true) => _safeRight = v
  
  fun ref rotateX(v:F32) => _rotation = V3fun(v, _rotation._2, _rotation._3)
  fun ref rotateY(v:F32) => _rotation = V3fun(_rotation._1, v, _rotation._3)
  fun ref rotateZ(v:F32) => _rotation = V3fun(_rotation._1, _rotation._2, v)
  fun ref rotate(v:V3) => _rotation = v
  
  fun ref rows() => @YGNodeStyleSetFlexDirection(node, YGFlexDirection.row)
  fun ref columns() => @YGNodeStyleSetFlexDirection(node, YGFlexDirection.column)
  
  fun ref rightToLeft() => @YGNodeStyleSetDirection(node, YGDirection.rtl)
  fun ref leftToRight() => @YGNodeStyleSetDirection(node, YGDirection.ltr)
  
  fun ref justifyStart() => @YGNodeStyleSetJustifyContent(node, YGJustify.flexstart)
  fun ref justifyCenter() => @YGNodeStyleSetJustifyContent(node, YGJustify.center)
  fun ref justifyEnd() => @YGNodeStyleSetJustifyContent(node, YGJustify.flexend)
  fun ref justifyBetween() => @YGNodeStyleSetJustifyContent(node, YGJustify.spacebetween)
  fun ref justifyAround() => @YGNodeStyleSetJustifyContent(node, YGJustify.spacearound)
  fun ref justifyEvenly() => @YGNodeStyleSetJustifyContent(node, YGJustify.spaceevenly)  
  
  fun ref nowrap() => @YGNodeStyleSetFlexWrap(node, YGWrap.nowrap)
  fun ref wrap() => @YGNodeStyleSetFlexWrap(node, YGWrap.wrap)
  
  fun ref itemsAuto() => @YGNodeStyleSetAlignItems(node, YGAlign.auto)
  fun ref itemsStart() => @YGNodeStyleSetAlignItems(node, YGAlign.flexstart)
  fun ref itemsCenter() => @YGNodeStyleSetAlignItems(node, YGAlign.center)
  fun ref itemsEnd() => @YGNodeStyleSetAlignItems(node, YGAlign.flexend)
  fun ref itemsBetween() => @YGNodeStyleSetAlignItems(node, YGAlign.spacebetween)
  fun ref itemsAround() => @YGNodeStyleSetAlignItems(node, YGAlign.spacearound)
  fun ref itemsBaseline() => @YGNodeStyleSetAlignItems(node, YGAlign.baseline)  
  fun ref itemsStretch() => @YGNodeStyleSetAlignItems(node, YGAlign.stretch)  
  
  fun ref absolute() => @YGNodeStyleSetPositionType(node, YGPositionType.absolute)
  fun ref relative() => @YGNodeStyleSetPositionType(node, YGPositionType.relative)
  
  fun ref origin(x:F32, y:F32) => @YGNodeStyleSetPosition(node, YGEdge.left, x); @YGNodeStyleSetPosition(node, YGEdge.top, y)
  fun ref originPercent(x:F32, y:F32) => @YGNodeStyleSetPositionPercent(node, YGEdge.left, x); @YGNodeStyleSetPositionPercent(node, YGEdge.top, y)
  
  fun ref top(p:F32) => @YGNodeStyleSetPosition(node, YGEdge.top, p)
  fun ref left(p:F32) => @YGNodeStyleSetPosition(node, YGEdge.left, p)
  fun ref bottom(p:F32) => @YGNodeStyleSetPosition(node, YGEdge.bottom, p)
  fun ref right(p:F32) => @YGNodeStyleSetPosition(node, YGEdge.right, p)
  
  fun ref topPercent(p:F32) => @YGNodeStyleSetPositionPercent(node, YGEdge.top, p)
  fun ref leftPercent(p:F32) => @YGNodeStyleSetPositionPercent(node, YGEdge.left, p)
  fun ref bottomPercent(p:F32) => @YGNodeStyleSetPositionPercent(node, YGEdge.bottom, p)
  fun ref rightPercent(p:F32) => @YGNodeStyleSetPositionPercent(node, YGEdge.right, p)
  
  fun ref paddingAll(v2:F32) => @YGNodeStyleSetPadding(node, YGEdge.all, v2)
  fun ref paddingTop(v2:F32) => @YGNodeStyleSetPadding(node, YGEdge.top, v2)
  fun ref paddingLeft(v2:F32) => @YGNodeStyleSetPadding(node, YGEdge.left, v2)
  fun ref paddingBottom(v2:F32) => @YGNodeStyleSetPadding(node, YGEdge.bottom, v2)
  fun ref paddingRight(v2:F32) => @YGNodeStyleSetPadding(node, YGEdge.right, v2)
  
  fun ref marginAll(v2:F32) => @YGNodeStyleSetMargin(node, YGEdge.all, v2)
  fun ref marginTop(v2:F32) => @YGNodeStyleSetMargin(node, YGEdge.top, v2)
  fun ref marginLeft(v2:F32) => @YGNodeStyleSetMargin(node, YGEdge.left, v2)
  fun ref marginBottom(v2:F32) => @YGNodeStyleSetMargin(node, YGEdge.bottom, v2)
  fun ref marginRight(v2:F32) => @YGNodeStyleSetMargin(node, YGEdge.right, v2)
  
  
  // These are direct calls to the Yoga methods (most of which require parameters)
  
  fun ref direction(v:U32) => @YGNodeStyleSetDirection(node, v)
  fun ref flexDirection(v:U32) => @YGNodeStyleSetFlexDirection(node, v)
  
  fun ref justifyContent(v:U32) => @YGNodeStyleSetJustifyContent(node, v)
  
  fun ref alignContent(v:U32) => @YGNodeStyleSetAlignContent(node, v)
  fun ref alignItems(v:U32) => @YGNodeStyleSetAlignItems(node, v)
  fun ref alignSelf(v:U32) => @YGNodeStyleSetAlignSelf(node, v)
  
  fun ref positionType(v:U32) => @YGNodeStyleSetPositionType(node, v)
  
  fun ref overflow(v:U32) => @YGNodeStyleSetOverflow(node, v)
  fun ref display(v:U32) => @YGNodeStyleSetDisplay(node, v)
  
  fun ref flexWrap(v:U32) => @YGNodeStyleSetFlexWrap(node, v)
  fun ref flex(v:F32) => @YGNodeStyleSetFlex(node, v)
  fun ref flexGrow(v:F32) => @YGNodeStyleSetFlexGrow(node, v)
  fun ref flexShrink(v:F32) => @YGNodeStyleSetFlexShrink(node, v)
  fun ref flexBasis(v:F32) => @YGNodeStyleSetFlexBasis(node, v)
  fun ref flexBasisPercent(v:F32) => @YGNodeStyleSetFlexBasisPercent(node, v)
  fun ref flexAuto() => @YGNodeStyleSetFlexBasisAuto(node)
  
  fun ref position(v1:U32, v2:F32) => @YGNodeStyleSetPosition(node, v1, v2)
  fun ref positionPercent(v1:U32, v2:F32) => @YGNodeStyleSetPositionPercent(node, v1, v2)
  
  fun ref margin(v1:U32, v2:F32) => @YGNodeStyleSetMargin(node, v1, v2)
  fun ref marginPercent(v1:U32, v2:F32) => @YGNodeStyleSetMarginPercent(node, v1, v2)
  fun ref marginAuto(v1:U32) => @YGNodeStyleSetMarginAuto(node, v1)
  
  fun ref padding(v1:U32, v2:F32) => @YGNodeStyleSetPadding(node, v1, v2)
  fun ref paddingPercent(v1:U32, v2:F32) => @YGNodeStyleSetPaddingPercent(node, v1, v2)
  
  fun ref border(v1:U32, v2:F32) => @YGNodeStyleSetBorder(node, v1, v2)
  
  fun ref width(v:F32) => @YGNodeStyleSetWidth(node, v)
  fun ref widthPercent(v:F32) => @YGNodeStyleSetWidthPercent(node, v)
  fun ref widthAuto() => @YGNodeStyleSetWidthAuto(node)
  
  fun ref height(v:F32) => @YGNodeStyleSetHeight(node, v)
  fun ref heightPercent(v:F32) => @YGNodeStyleSetHeightPercent(node, v)
  fun ref heightAuto() => @YGNodeStyleSetHeightAuto(node)
  
  fun ref minWidth(v:F32) => @YGNodeStyleSetMinWidth(node, v)
  fun ref minWidthPercent(v:F32) => @YGNodeStyleSetMinWidthPercent(node, v)
  
  fun ref minHeight(v:F32) => @YGNodeStyleSetMinHeight(node, v)
  fun ref minHeightPercent(v:F32) => @YGNodeStyleSetMinHeightPercent(node, v)
  
  fun ref maxWidth(v:F32) => @YGNodeStyleSetMaxWidth(node, v)
  fun ref maxWidthPercent(v:F32) => @YGNodeStyleSetMaxWidthPercent(node, v)
  
  fun ref maxHeight(v:F32) => @YGNodeStyleSetMaxHeight(node, v)
  fun ref maxHeightPercent(v:F32) => @YGNodeStyleSetMaxHeightPercent(node, v)
  
  fun ref aspectRatio(v:F32) => @YGNodeStyleSetAspectRatio(node, v)
  
  
  
  
  fun getWidth():F32 => @YGNodeStyleGetWidth(node)
  fun getHeight():F32 => @YGNodeStyleGetHeight(node)
  
  
  /*

primitive YGAlign
  let auto:U32 = 0x0
  let flexstart:U32 = 0x1
  let center:U32 = 0x2
  let flexend:U32 = 0x3
  let stretch:U32 = 0x4
  let baseline:U32 = 0x5
  let spacebetween:U32 = 0x6
  let spacearound:U32 = 0x7
primitive YGDimension
  let width:U32 = 0x0
  let height:U32 = 0x1
primitive YGDirection
  let inherit:U32 = 0x0
  let ltr:U32 = 0x1
  let rtl:U32 = 0x2
primitive YGDisplay
  let flex:U32 = 0x0
  let none:U32 = 0x1
primitive YGEdge
  let left:U32 = 0x0
  let top:U32 = 0x1
  let right:U32 = 0x2
  let bottom:U32 = 0x3
  let start:U32 = 0x4
  let end_pony:U32 = 0x5
  let horizontal:U32 = 0x6
  let vertical:U32 = 0x7
  let all:U32 = 0x8
primitive YGFlexDirection
  let column:U32 = 0x0
  let columnreverse:U32 = 0x1
  let row:U32 = 0x2
  let rowreverse:U32 = 0x3
primitive YGJustify
  let flexstart:U32 = 0x0
  let center:U32 = 0x1
  let flexend:U32 = 0x2
  let spacebetween:U32 = 0x3
  let spacearound:U32 = 0x4
  let spaceevenly:U32 = 0x5
primitive YGLogLevel
  let error_pony:U32 = 0x0
  let warn:U32 = 0x1
  let info:U32 = 0x2
  let debug:U32 = 0x3
  let verbose:U32 = 0x4
  let fatal:U32 = 0x5
primitive YGMeasureMode
  let undefined:U32 = 0x0
  let exactly:U32 = 0x1
  let atmost:U32 = 0x2
primitive YGNodeType
  let default:U32 = 0x0
  let text:U32 = 0x1
primitive YGOverflow
  let visible:U32 = 0x0
  let hidden:U32 = 0x1
  let scroll:U32 = 0x2
primitive YGPositionType
  let relative:U32 = 0x0
  let absolute:U32 = 0x1
primitive YGPrintOptions
  let layout:U32 = 0x1
  let style:U32 = 0x2
  let children:U32 = 0x4
primitive YGUnit
  let undefined:U32 = 0x0
  let point:U32 = 0x1
  let percent:U32 = 0x2
  let auto:U32 = 0x3
primitive YGWrap
  let nowrap:U32 = 0x0
  let wrap:U32 = 0x1
  let wrapreverse:U32 = 0x2
=============================================================================
========================== autogenerated pony code ==========================
// Transpiled from /Volumes/Development/Development/pony/pony.yoga/yoga/+headers/Yoga.h

use @YGNodeNew[Pointer[YGNode]]()
use @YGNodeNewWithConfig[Pointer[YGNode]](config:Pointer[YGConfig] tag)
use @YGNodeClone[Pointer[YGNode]](node:Pointer[YGNode] tag)
use @YGNodeFree[None](node:Pointer[YGNode] tag)
use @YGNodeFreeRecursiveWithCleanupFunc[None](node:Pointer[YGNode] tag, cleanup:Pointer[None] tag)
use @YGNodeFreeRecursive[None](node:Pointer[YGNode] tag)
use @YGNodeReset[None](node:Pointer[YGNode] tag)
use @YGNodeInsertChild[None](node:Pointer[YGNode] tag, child:Pointer[YGNode] tag, index:U64)
use @YGNodeSwapChild[None](node:Pointer[YGNode] tag, child:Pointer[YGNode] tag, index:U64)
use @YGNodeRemoveChild[None](node:Pointer[YGNode] tag, child:Pointer[YGNode] tag)
use @YGNodeRemoveAllChildren[None](node:Pointer[YGNode] tag)
use @YGNodeGetChild[Pointer[YGNode]](node:Pointer[YGNode] tag, index:U64)
use @YGNodeGetOwner[Pointer[YGNode]](node:Pointer[YGNode] tag)
use @YGNodeGetParent[Pointer[YGNode]](node:Pointer[YGNode] tag)
use @YGNodeGetChildCount[U64](node:Pointer[YGNode] tag)
use @YGNodeSetIsReferenceBaseline[None](node:Pointer[YGNode] tag, isReferenceBaseline:U32)
use @YGNodeIsReferenceBaseline[U32](node:Pointer[YGNode] tag)
use @YGNodeCalculateLayout[None](node:Pointer[YGNode] tag, availableWidth:F32, availableHeight:F32, ownerDirection:U32)
use @YGNodeMarkDirty[None](node:Pointer[YGNode] tag)
use @YGNodeMarkDirtyAndPropogateToDescendants[None](node:Pointer[YGNode] tag)
use @YGNodePrint[None](node:Pointer[YGNode] tag, options:U32)
use @YGFloatIsUndefined[U32](value:F32)
use @YGNodeCanUseCachedMeasurement[U32](widthMode:U32, width:F32, heightMode:U32, height:F32, lastWidthMode:U32, lastWidth:F32, lastHeightMode:U32, lastHeight:F32, lastComputedWidth:F32, lastComputedHeight:F32, marginRow:F32, marginColumn:F32, config:Pointer[YGConfig] tag)
use @YGNodeCopyStyle[None](dstNode:Pointer[YGNode] tag, srcNode:Pointer[YGNode] tag)
use @YGNodeGetContext[Pointer[None]](node:Pointer[YGNode] tag)
use @YGNodeSetContext[None](node:Pointer[YGNode] tag, context:Pointer[None] tag)
use @YGConfigSetPrintTreeFlag[None](config:Pointer[YGConfig] tag, enabled:U32)
use @YGNodeHasMeasureFunc[U32](node:Pointer[YGNode] tag)
use @YGNodeSetMeasureFunc[None](node:Pointer[YGNode] tag, measureFunc:U32)
use @YGNodeHasBaselineFunc[U32](node:Pointer[YGNode] tag)
use @YGNodeSetBaselineFunc[None](node:Pointer[YGNode] tag, baselineFunc:Pointer[None] tag)
use @YGNodeGetDirtiedFunc[Pointer[None]](node:Pointer[YGNode] tag)
use @YGNodeSetDirtiedFunc[None](node:Pointer[YGNode] tag, dirtiedFunc:Pointer[None] tag)
use @YGNodeSetPrintFunc[None](node:Pointer[YGNode] tag, printFunc:Pointer[None] tag)
use @YGNodeGetHasNewLayout[U32](node:Pointer[YGNode] tag)
use @YGNodeSetHasNewLayout[None](node:Pointer[YGNode] tag, hasNewLayout:U32)
use @YGNodeGetNodeType[U32](node:Pointer[YGNode] tag)
use @YGNodeSetNodeType[None](node:Pointer[YGNode] tag, nodeType:U32)
use @YGNodeIsDirty[U32](node:Pointer[YGNode] tag)
use @YGNodeLayoutGetDidUseLegacyFlag[U32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetDirection[None](node:Pointer[YGNode] tag, direction:U32)
use @YGNodeStyleGetDirection[U32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetFlexDirection[None](node:Pointer[YGNode] tag, flexDirection:U32)
use @YGNodeStyleGetFlexDirection[U32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetJustifyContent[None](node:Pointer[YGNode] tag, justifyContent:U32)
use @YGNodeStyleGetJustifyContent[U32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetAlignContent[None](node:Pointer[YGNode] tag, alignContent:U32)
use @YGNodeStyleGetAlignContent[U32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetAlignItems[None](node:Pointer[YGNode] tag, alignItems:U32)
use @YGNodeStyleGetAlignItems[U32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetAlignSelf[None](node:Pointer[YGNode] tag, alignSelf:U32)
use @YGNodeStyleGetAlignSelf[U32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetPositionType[None](node:Pointer[YGNode] tag, positionType:U32)
use @YGNodeStyleGetPositionType[U32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetFlexWrap[None](node:Pointer[YGNode] tag, flexWrap:U32)
use @YGNodeStyleGetFlexWrap[U32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetOverflow[None](node:Pointer[YGNode] tag, overflow:U32)
use @YGNodeStyleGetOverflow[U32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetDisplay[None](node:Pointer[YGNode] tag, display:U32)
use @YGNodeStyleGetDisplay[U32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetFlex[None](node:Pointer[YGNode] tag, flex:F32)
use @YGNodeStyleGetFlex[F32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetFlexGrow[None](node:Pointer[YGNode] tag, flexGrow:F32)
use @YGNodeStyleGetFlexGrow[F32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetFlexShrink[None](node:Pointer[YGNode] tag, flexShrink:F32)
use @YGNodeStyleGetFlexShrink[F32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetFlexBasis[None](node:Pointer[YGNode] tag, flexBasis:F32)
use @YGNodeStyleSetFlexBasisPercent[None](node:Pointer[YGNode] tag, flexBasis:F32)
use @YGNodeStyleSetFlexBasisAuto[None](node:Pointer[YGNode] tag)
use @YGNodeStyleGetFlexBasis[F32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetPosition[None](node:Pointer[YGNode] tag, edge:U32, position:F32)
use @YGNodeStyleSetPositionPercent[None](node:Pointer[YGNode] tag, edge:U32, position:F32)
use @YGNodeStyleGetPosition[F32](node:Pointer[YGNode] tag, edge:U32)
use @YGNodeStyleSetMargin[None](node:Pointer[YGNode] tag, edge:U32, margin:F32)
use @YGNodeStyleSetMarginPercent[None](node:Pointer[YGNode] tag, edge:U32, margin:F32)
use @YGNodeStyleSetMarginAuto[None](node:Pointer[YGNode] tag, edge:U32)
use @YGNodeStyleGetMargin[F32](node:Pointer[YGNode] tag, edge:U32)
use @YGNodeStyleSetPadding[None](node:Pointer[YGNode] tag, edge:U32, padding:F32)
use @YGNodeStyleSetPaddingPercent[None](node:Pointer[YGNode] tag, edge:U32, padding:F32)
use @YGNodeStyleGetPadding[F32](node:Pointer[YGNode] tag, edge:U32)
use @YGNodeStyleSetBorder[None](node:Pointer[YGNode] tag, edge:U32, border:F32)
use @YGNodeStyleGetBorder[F32](node:Pointer[YGNode] tag, edge:U32)
use @YGNodeStyleSetWidth[None](node:Pointer[YGNode] tag, width:F32)
use @YGNodeStyleSetWidthPercent[None](node:Pointer[YGNode] tag, width:F32)
use @YGNodeStyleSetWidthAuto[None](node:Pointer[YGNode] tag)
use @YGNodeStyleGetWidth[F32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetHeight[None](node:Pointer[YGNode] tag, height:F32)
use @YGNodeStyleSetHeightPercent[None](node:Pointer[YGNode] tag, height:F32)
use @YGNodeStyleSetHeightAuto[None](node:Pointer[YGNode] tag)
use @YGNodeStyleGetHeight[F32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetMinWidth[None](node:Pointer[YGNode] tag, minWidth:F32)
use @YGNodeStyleSetMinWidthPercent[None](node:Pointer[YGNode] tag, minWidth:F32)
use @YGNodeStyleGetMinWidth[F32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetMinHeight[None](node:Pointer[YGNode] tag, minHeight:F32)
use @YGNodeStyleSetMinHeightPercent[None](node:Pointer[YGNode] tag, minHeight:F32)
use @YGNodeStyleGetMinHeight[F32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetMaxWidth[None](node:Pointer[YGNode] tag, maxWidth:F32)
use @YGNodeStyleSetMaxWidthPercent[None](node:Pointer[YGNode] tag, maxWidth:F32)
use @YGNodeStyleGetMaxWidth[F32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetMaxHeight[None](node:Pointer[YGNode] tag, maxHeight:F32)
use @YGNodeStyleSetMaxHeightPercent[None](node:Pointer[YGNode] tag, maxHeight:F32)
use @YGNodeStyleGetMaxHeight[F32](node:Pointer[YGNode] tag)
use @YGNodeStyleSetAspectRatio[None](node:Pointer[YGNode] tag, aspectRatio:F32)
use @YGNodeStyleGetAspectRatio[F32](node:Pointer[YGNode] tag)
use @YGNodeLayoutGetLeft[F32](node:Pointer[YGNode] tag)
use @YGNodeLayoutGetTop[F32](node:Pointer[YGNode] tag)
use @YGNodeLayoutGetRight[F32](node:Pointer[YGNode] tag)
use @YGNodeLayoutGetBottom[F32](node:Pointer[YGNode] tag)
use @YGNodeLayoutGetWidth[F32](node:Pointer[YGNode] tag)
use @YGNodeLayoutGetHeight[F32](node:Pointer[YGNode] tag)
use @YGNodeLayoutGetDirection[U32](node:Pointer[YGNode] tag)
use @YGNodeLayoutGetHadOverflow[U32](node:Pointer[YGNode] tag)
use @YGNodeLayoutGetDidLegacyStretchFlagAffectLayout[U32](node:Pointer[YGNode] tag)
use @YGNodeLayoutGetMargin[F32](node:Pointer[YGNode] tag, edge:U32)
use @YGNodeLayoutGetBorder[F32](node:Pointer[YGNode] tag, edge:U32)
use @YGNodeLayoutGetPadding[F32](node:Pointer[YGNode] tag, edge:U32)
use @YGConfigSetLogger[None](config:Pointer[YGConfig] tag, logger:Pointer[None] tag)
use @YGAssert[None](condition:U32, message:Pointer[U8] tag)
use @YGAssertWithNode[None](node:Pointer[YGNode] tag, condition:U32, message:Pointer[U8] tag)
use @YGAssertWithConfig[None](config:Pointer[YGConfig] tag, condition:U32, message:Pointer[U8] tag)
use @YGConfigSetPointScaleFactor[None](config:Pointer[YGConfig] tag, pixelsInPoint:F32)
use @YGConfigSetShouldDiffLayoutWithoutLegacyStretchBehaviour[None](config:Pointer[YGConfig] tag, shouldDiffLayout:U32)
use @YGConfigSetUseLegacyStretchBehaviour[None](config:Pointer[YGConfig] tag, useLegacyStretchBehaviour:U32)
use @YGConfigNew[Pointer[YGConfig]]()
use @YGConfigFree[None](config:Pointer[YGConfig] tag)
use @YGConfigCopy[None](dest:Pointer[YGConfig] tag, src:Pointer[YGConfig] tag)
use @YGConfigGetInstanceCount[I64]()
use @YGConfigSetExperimentalFeatureEnabled[None](config:Pointer[YGConfig] tag, feature:U32, enabled:U32)
use @YGConfigIsExperimentalFeatureEnabled[U32](config:Pointer[YGConfig] tag, feature:U32)
use @YGConfigSetUseWebDefaults[None](config:Pointer[YGConfig] tag, enabled:U32)
use @YGConfigGetUseWebDefaults[U32](config:Pointer[YGConfig] tag)
use @YGConfigSetCloneNodeFunc[None](config:Pointer[YGConfig] tag, callback:Pointer[None] tag)
use @YGConfigGetDefault[Pointer[YGConfig]]()
use @YGConfigSetContext[None](config:Pointer[YGConfig] tag, context:Pointer[None] tag)
use @YGConfigGetContext[Pointer[None]](config:Pointer[YGConfig] tag)
use @YGRoundValueToPixelGrid[F32](value:F32, pointScaleFactor:F32, forceCeil:U32, forceFloor:U32)


primitive YGConfig
type YGConfigRef is Pointer[YGConfig]

primitive YGNode
type YGNodeRef is Pointer[YGNode]



primitive YGConfig
type YGConfigRef is Pointer[YGConfig]

primitive YGNode
type YGNodeRef is Pointer[YGNode]
  */
