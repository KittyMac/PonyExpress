use "ttimer"
use "yoga"
use "collections"
use "linal"
use "promises"
use "utility"
use "laba"

type YogaUserInfoType is Stringable
type YogaCustomLayoutCallback is {(YogaNode ref, YogaUserInfoType val)} val

type YogaNodeID is USize

class YogaNode
  var parent:(YogaNode|None) = None
  var node:YGNodeRef tag
  var _name:String val
  var _views:Array[Viewable]
  
  var children:Array[YogaNode]
  var last_bounds:R4 = R4fun.zero()
  var last_matrix:M4 = M4fun.id()
  
  var sibling_index:USize = 0
  var sibling_count:USize = 0
  
  var _started:Bool = false
  
  var _customLayoutInfo:YogaUserInfoType val = None
  var _customLayoutCallback:(YogaCustomLayoutCallback|None) = None
  
  var _content_offset:V2 = V2fun.zero()
  var _rotation:V3 = V3fun.zero()
  var _scale:V3 = V3fun(1.0, 1.0, 1.0)
  
  var _pivot:V2 = V2fun(0.5,0.5)
  var _anchor:V2 = V2fun(0.5,0.5)
  
  var _clips:Bool = false
  var _clippingGeometry:BufferedGeometry = BufferedGeometry
  var _pushedClippingVertices:FloatAlignedArray = FloatAlignedArray
  
  var _usesLeft:Bool = true
  var _usesTop:Bool = true
  
  var _safeTop:Bool = false
  var _safeLeft:Bool = false
  var _safeBottom:Bool = false
  var _safeRight:Bool = false
  
  var labaAnimations:Array[Laba] = Array[Laba](32)
  
  var _focusIdx:ISize = -1
  
  var _alpha:F32 = 1.0
  
  var _z:F32 = 0.0
  
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
  
  fun string():String iso^ =>
    let nodeTag:YGNodeRef tag = node
    recover String.copy_cstring(@YGNodePrintString(nodeTag, YGPrintOptions.layout or YGPrintOptions.style or YGPrintOptions.children)) end
  
  fun ref getChildren():Array[YogaNode] => children
  
  fun ref addChild(child:YogaNode) =>
    children.push(child)
    @YGNodeInsertChild(node, child.node, @YGNodeGetChildCount(node))
    updateSiblingCounts()
  
  fun ref addChildren(new_children:Array[YogaNode]) =>
    for child in new_children.values() do
      addChild(child)
    end
    updateSiblingCounts()
  
  fun ref removeParent() =>
    if parent as YogaNode then
      parent.removeFromParent()
    end
  
  fun ref removeFromParent() =>
    if parent as YogaNode then
      parent.removeChild(this)
    end
  
  fun ref removeChild(child:YogaNode) =>
    child.finish()
    @YGNodeRemoveChild(node, child.node)
    children.deleteOne(child)
    updateSiblingCounts()
  
  fun ref removeChildren() =>
    for child in children.values() do
      child.finish()
    end
    children.clear()
    @YGNodeRemoveAllChildren(node)
    updateSiblingCounts()
    
  
  fun ref layout() =>
    // Before we can calculate the layout, we need to see if any of our children sizeToFit their content. If we do, we need
    // to have them set the size on the appropriate yoga node
    preLayout()
    
    @YGNodeCalculateLayout(node, @YGNodeStyleGetWidthFloat(node), @YGNodeStyleGetHeightFloat(node), YGDirection.ltr)
    
    // postLayout gives the opporunity to nodes to adjust themselves based on the layout which just happened. Specifically,
    // if calls any custom() callbacks that exist on nodes
    if postLayout() then
      @YGNodeCalculateLayout(node, @YGNodeStyleGetWidthFloat(node), @YGNodeStyleGetHeightFloat(node), YGDirection.ltr)
    end
  
  
  fun ref setContentOffset(_x:F32, _y:F32) =>
    _content_offset = V2fun(_x, _y)
  
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
    if nodeID == 0 then
      return None
    end
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
  
  fun ref getNodeByFocusIdx(idx:ISize):(YogaNode|None) =>
    if idx < 0 then
      return None
    end
    if _focusIdx == idx then
      return this
    end
    for child in children.values() do
      let result = child.getNodeByFocusIdx(idx)
      if result as YogaNode then
        return result
      end
    end
    None
  
  fun ref updateSiblingCounts() =>
    var idx:USize = 0
    let n:USize = children.size()
    for child in children.values() do
      child.parent = this
      child.sibling_index = idx
      child.sibling_count = n
      idx = idx + 1
    end
  
  
  // Returns true if there are any unstarted nodes in the hierarchy
  fun ref startNeeded():Bool =>
    var startIsNeeded:Bool = (_started == false)
    for child in children.values() do
      startIsNeeded = child.startNeeded() or startIsNeeded
    end
    startIsNeeded
  
  
  // Called when the node is first added to the render engine hierarchy
  fun ref start(frameContext:FrameContext):U64 =>
    var n:U64 = frameContext.renderNumber
    
    if _started == false then
      for local_view in _views.values() do
          n = frameContext.renderNumber + 1
    
          frameContext.renderNumber = n
          frameContext.nodeID = id()
          frameContext.contentSize = contentSize()
          frameContext.nodeSize = nodeSize()
      
          local_view.viewable_start( frameContext.clone() )
      
          labaStart()
      end
      _started = true
    end
    
    for child in children.values() do
      n = child.start(frameContext)
      frameContext.renderNumber = n
    end
    n
  
  // Called when the node is removed from the render engine hierarchy
  fun ref finish() =>
    for local_view in _views.values() do    
      local_view.viewable_finish()
    end
    for child in children.values() do
      child.finish()
    end
  
  // Called on all nodes right before Yoga layout calculations are made
  fun ref preLayout() =>
    if _safeTop then padding(YGEdge.top, SafeEdges.top()) end
    if _safeLeft then padding(YGEdge.left, SafeEdges.left()) end
    if _safeBottom then padding(YGEdge.bottom, SafeEdges.bottom()) end
    if _safeRight then padding(YGEdge.right, SafeEdges.right()) end  
    
    for child in children.values() do
      child.preLayout()
    end
  
  fun ref postLayout():Bool =>
    var didDoCallback:Bool = false
    
    if _customLayoutCallback as YogaCustomLayoutCallback then
      _customLayoutCallback(this, _customLayoutInfo)
      didDoCallback = true
    end
  
    for child in children.values() do
      didDoCallback = child.postLayout() or didDoCallback
    end
    
    didDoCallback
  
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
  
  fun ref invalidate(frameContext:FrameContext) =>
    var n:U64 = frameContext.renderNumber
    
    for local_view in _views.values() do
      n = frameContext.renderNumber + 1
    
      frameContext.renderNumber = n
      frameContext.matrix = last_matrix
      frameContext.nodeID = id()
      frameContext.contentSize = contentSize()
      frameContext.nodeSize = nodeSize()
  
      local_view.viewable_invalidate( frameContext.clone())
    end
    
  
  // Called when the render engine hierarchy needs to... render
  fun ref render(frameContext:FrameContext):U64 =>
    _renderRecursive(frameContext, V2fun.zero(), M4fun.id())
    
  fun ref _renderRecursive(frameContext:FrameContext, parentContentOffset:V2, parent_matrix:M4):U64 =>    
    var n:U64 = frameContext.renderNumber
    
    let local_left:F32 = @YGNodeLayoutGetLeft(node)
    let local_top:F32 = @YGNodeLayoutGetTop(node)
    let local_width:F32 = @YGNodeLayoutGetWidth(node)
    let local_height:F32 = @YGNodeLayoutGetHeight(node)
    
    if (local_width > 0) and (local_height > 0) and (_alpha > 0) then
    
      let pivotX:F32 = _pivot._1 * local_width
      let pivotY:F32 = _pivot._2 * local_height
    
      var local_matrix:M4 = M4fun.mul_m4(
          parent_matrix,
          M4fun.trans_v3(V3fun( (local_left + (_anchor._1 * local_width)) - (local_width / 2),
                                (local_top + (_anchor._2 * local_height)) - (local_height / 2),
                                _z))
        )
    
      local_matrix = M4fun.mul_m4(
              local_matrix,
              M4fun.trans_v3(V3fun( pivotX, pivotY, 0))
            )
    
      if (_rotation._1 != 0) or (_rotation._2 != 0) or (_rotation._3 != 0) then
        local_matrix = M4fun.mul_m4(
                local_matrix,
                M4fun.rot(Q4fun.from_euler(_rotation))
              )
      end
      if (_scale._1 != 0) or (_scale._2 != 0) or (_scale._3 != 0) then
        local_matrix = M4fun.mul_m4(
                local_matrix,
                M4fun.scale_v3(_scale)
              )
      end
      
      let savedAlpha = frameContext.alpha
      
      frameContext.matrix = local_matrix
      frameContext.nodeID = id()
      frameContext.contentSize = contentSize()
      frameContext.nodeSize = nodeSize()
      frameContext.parentContentOffset = parentContentOffset
      frameContext.alpha = frameContext.alpha * _alpha
    
      last_bounds = R4fun( (-pivotX)+parentContentOffset._1, (-pivotY)-parentContentOffset._2, local_width, local_height)
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
              M4fun.trans_v3(V3fun(-pivotX, -pivotY, 0))
            )
    
      if _clips then
        frameContext.clipBounds = last_bounds
      end
      
      if (parentContentOffset._1 != 0) or (parentContentOffset._2 != 0) then
        local_matrix = M4fun.mul_m4(
            local_matrix,
            M4fun.trans_v3(V3fun(parentContentOffset._1, -parentContentOffset._2, 0))
          )
      end
      
      for child in children.values() do
        n = child._renderRecursive(frameContext, _content_offset, local_matrix)
        frameContext.renderNumber = n
      end
      
      if (parentContentOffset._1 != 0) or (parentContentOffset._2 != 0) then
        local_matrix = M4fun.mul_m4(
            local_matrix,
            M4fun.trans_v3(V3fun(-parentContentOffset._1, parentContentOffset._2, 0))
          )
      end
    
      if _clips then
        frameContext.clipBounds = savedClipBounds
      
        n = n + 1
        frameContext.renderNumber = n
      
        popClips( frameContext.clone(), last_bounds )
      end
      
      frameContext.alpha = savedAlpha
    
    end
    
    if isAnimating() then
      frameContext.engine.setNeedsLayout()
    end
    
    labaAnimate(frameContext.animation_delta)
    
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

  fun ref isAnimating():Bool =>
    labaAnimations.size() > 0
  
  fun ref labaCancel() =>
    labaAnimations.clear()
  
  fun ref laba(labaStr:String val, args:(Array[F32] box|None) = None, callback:(LabaCompleteCallback box|None) = None) =>
    labaAnimations.push(Laba(this, labaStr, args, callback))
  
  fun ref labaAnimate(delta:F32 val) =>
    try
      let n = labaAnimations.size()
      for i in Range(0,n) do
        let animation = labaAnimations((n - i) - 1)?
        if animation.animate(delta) then
          labaAnimations.deleteAll(animation)
        end
      end
    end

  fun ref labaStart() =>
    for animation in labaAnimations.values() do
      animation.animate(0)
    end
  
  fun ref custom(info:YogaUserInfoType val, c:YogaCustomLayoutCallback) =>
    _customLayoutCallback = c
    _customLayoutInfo = info
  
  fun ref view(local_view:Viewable) =>
    _views.push(local_view)
  
  fun ref name(name':String val) =>
    _name = name'
  
  fun ref clips(_clips':Bool) =>
    _clips = _clips'
  
  fun getFocusIdx():ISize =>
    _focusIdx
  
  fun ref focusIdx(idx:ISize) =>
    _focusIdx = idx.max(-1)
  
  fun getAlpha():F32 =>
    _alpha
  
  fun ref alpha(a:F32) =>
    _alpha = a
  
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
  
  fun ref bounds(_x:F32, _y:F32, w:F32, h:F32) =>
    @YGNodeStyleSetPosition(node, YGEdge.left, _x)
    @YGNodeStyleSetPosition(node, YGEdge.top, _y)
    @YGNodeStyleSetWidth(node, w)
    @YGNodeStyleSetHeight(node, h)
  
  fun ref grow(v:F32 = 1.0) => @YGNodeStyleSetFlexGrow(node, v)
  fun ref shrink(v:F32 = 1.0) => @YGNodeStyleSetFlexShrink(node, v)
  
  fun ref safeTop(v:Bool=true) => _safeTop = v
  fun ref safeLeft(v:Bool=true) => _safeLeft = v
  fun ref safeBottom(v:Bool=true) => _safeBottom = v
  fun ref safeRight(v:Bool=true) => _safeRight = v
  
  fun ref pivot(_x:F32, _y:F32) => _pivot = V2fun(_x, _y)
  fun ref anchor(_x:F32, _y:F32) => _anchor = V2fun(_x, _y)
  
  fun ref scaleX(v:F32) => _scale = V3fun(v, _scale._2, _scale._3)
  fun ref scaleY(v:F32) => _scale = V3fun(_scale._1, v, _scale._3)
  fun ref scaleZ(v:F32) => _scale = V3fun(_scale._1, _scale._2, v)
  fun ref scaleAll(v:F32) => _scale = V3fun(v, v, v)
  fun ref scale(v:V3) => _scale = v
  
  fun ref rotateX(v:F32) => _rotation = V3fun(v, _rotation._2, _rotation._3)
  fun ref rotateY(v:F32) => _rotation = V3fun(_rotation._1, v, _rotation._3)
  fun ref rotateZ(v:F32) => _rotation = V3fun(_rotation._1, _rotation._2, v)
  fun ref rotate(v:V3) => _rotation = v
  
  fun ref rows() => @YGNodeStyleSetFlexDirection(node, YGFlexDirection.row)
  fun ref columns() => @YGNodeStyleSetFlexDirection(node, YGFlexDirection.column)
  
  fun ref rowsReversed() => @YGNodeStyleSetFlexDirection(node, YGFlexDirection.rowreverse)
  fun ref columnsReversed() => @YGNodeStyleSetFlexDirection(node, YGFlexDirection.columnreverse)
  
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
  
  fun ref selfAuto(v:U32) => @YGNodeStyleSetAlignSelf(node, YGAlign.auto)
  fun ref selfStart() => @YGNodeStyleSetAlignSelf(node, YGAlign.flexstart)
  fun ref selfCenter() => @YGNodeStyleSetAlignSelf(node, YGAlign.center)
  fun ref selfEnd() => @YGNodeStyleSetAlignSelf(node, YGAlign.flexend)
  fun ref selfBetween() => @YGNodeStyleSetAlignSelf(node, YGAlign.spacebetween)
  fun ref selfAround() => @YGNodeStyleSetAlignSelf(node, YGAlign.spacearound)
  fun ref selfBaseline() => @YGNodeStyleSetAlignSelf(node, YGAlign.baseline)  
  fun ref selfStretch() => @YGNodeStyleSetAlignSelf(node, YGAlign.stretch)
  
  fun ref absolute() => @YGNodeStyleSetPositionType(node, YGPositionType.absolute)
  fun ref relative() => @YGNodeStyleSetPositionType(node, YGPositionType.relative)
  
  fun ref origin(_x:F32, _y:F32) => @YGNodeStyleSetPosition(node, YGEdge.left, _x); @YGNodeStyleSetPosition(node, YGEdge.top, _y); _usesLeft = true; _usesTop = true
  fun ref originPercent(_x:F32, _y:F32) => @YGNodeStyleSetPositionPercent(node, YGEdge.left, _x); @YGNodeStyleSetPositionPercent(node, YGEdge.top, _y); _usesLeft = true; _usesTop = true
  
  fun ref top(p:F32) => @YGNodeStyleSetPosition(node, YGEdge.top, p); _usesTop = true
  fun ref left(p:F32) => @YGNodeStyleSetPosition(node, YGEdge.left, p); _usesLeft = true
  fun ref bottom(p:F32) => @YGNodeStyleSetPosition(node, YGEdge.bottom, p); _usesTop = false
  fun ref right(p:F32) => @YGNodeStyleSetPosition(node, YGEdge.right, p); _usesLeft = false
  
  fun ref topPercent(p:F32) => @YGNodeStyleSetPositionPercent(node, YGEdge.top, p); _usesTop = true
  fun ref leftPercent(p:F32) => @YGNodeStyleSetPositionPercent(node, YGEdge.left, p); _usesLeft = true
  fun ref bottomPercent(p:F32) => @YGNodeStyleSetPositionPercent(node, YGEdge.bottom, p); _usesTop = false
  fun ref rightPercent(p:F32) => @YGNodeStyleSetPositionPercent(node, YGEdge.right, p); _usesLeft = false
  
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
  
  
  fun _handleNAN(v:F32):F32 => if v.nan() then 0.0 else v end
  
  fun getRotateX():F32 => _rotation._1
  fun getRotateY():F32 => _rotation._2
  fun getRotateZ():F32 => _rotation._3
  
  fun getPivot():V2 => _pivot
  fun getAnchor():V2 => _anchor
  fun getScale():V3 => _scale
  fun getWidth():F32 => _handleNAN(@YGNodeLayoutGetWidth(node))
  fun getHeight():F32 => _handleNAN(@YGNodeLayoutGetHeight(node))
  
  
  fun ref getZ():F32 => _z
  fun ref z(v:F32) => _z = v
  
  // These overloaded methods try to determine in what aspect "X" and "Y" are meant in the node's style, and then gets or sets those
  // in that manner. This is used by Laba when animating so that it doesn't need to worry about how the user set those in the style
  fun getY():F32 => if _usesTop then _handleNAN(@YGNodeStyleGetPositionFloat(node, YGEdge.top)) else _handleNAN(@YGNodeStyleGetPositionFloat(node, YGEdge.bottom)) end
  fun getX():F32 => if _usesLeft then _handleNAN(@YGNodeStyleGetPositionFloat(node, YGEdge.left)) else _handleNAN(@YGNodeStyleGetPositionFloat(node, YGEdge.right)) end
  fun ref y(v:F32) => if _usesTop then top(v) else bottom(v) end
  fun ref x(v:F32) => if _usesLeft then left(v) else @YGNodeStyleSetPosition(node, YGEdge.right, v) end
  
  
  
  
  