use "linal"
use "utility"

actor Label is (Viewable & Colorable)
	
  var _sizeToFit:Bool = false
  var _sizedAtWidth:F32 = 0
  
  var value:String
  
  var fontRender:FontRender
  	
  new empty() =>
    value = ""
    _color = RGBA.black()
    fontRender = FontRender.empty()
  
	new create(value':String, font:Font val, fontSize':F32 = 16) =>
    value = value'
    
    _color = RGBA.black()
    fontRender = FontRender(font, fontSize', RGBA.black())
  
  be sizeToFit() =>
    _sizeToFit = true
    fontRender.invalidate()
  
  be left() =>
    fontRender.fontAlignment = Alignment.left
  be center() =>
    fontRender.fontAlignment = Alignment.center
  be right() =>
    fontRender.fontAlignment = Alignment.right
  
  be top() =>
    fontRender.fontVerticalAlignment = VerticalAlignment.top
  be middle() =>
    fontRender.fontVerticalAlignment = VerticalAlignment.middle
  be bottom() =>
    fontRender.fontVerticalAlignment = VerticalAlignment.bottom
  
  be size(fontSize:F32) =>
    fontRender.fontSize = fontSize
  
  fun ref start(frameContext:FrameContext val) =>
    if _sizeToFit then
      resizeToFit(frameContext, true)
    else
      RenderPrimitive.startFinished(frameContext)
    end
  
  fun ref resizeToFit(frameContext:FrameContext val, isStart:Bool):F32 =>
    if _sizedAtWidth != frameContext.nodeSize._1 then
      _sizedAtWidth = frameContext.nodeSize._1
          
      let height = fontRender.measureHeight(frameContext, value, _sizedAtWidth)
      if height != frameContext.nodeSize._2 then
        frameContext.engine.getNodeByID(frameContext.nodeID, { (node) =>
            if node as YogaNode then
              node.>height(height).>widthPercent(100)
            end
            if isStart then
              RenderPrimitive.startFinished(frameContext)
            end
            LayoutNeeded
          })
      end
      height
    else
      frameContext.nodeSize._2
    end
  
  	fun ref render(frameContext:FrameContext val, bounds:R4) =>    
      // If our layout has changed since the last time we measured our height, then we need to re-measure
      // it and fix our bounds (for this render) to match the corrected bounds (for the upcoming render)
      var topOffset:F32 = 0
    
      if _sizeToFit and (_sizedAtWidth != frameContext.nodeSize._1) then
        let real_height = resizeToFit(frameContext, false)
        let old_height = R4fun.height(bounds)
      
        if real_height < old_height then
          topOffset = -((old_height - real_height) / 2).round()
        end
      end
    
      fontRender.fontColor = _color
      let geom = fontRender.geometry(frameContext, value, bounds, topOffset)
      RenderPrimitive.renderCachedGeometry(frameContext, 0, ShaderType.sdf, geom.vertices, fontRender.fontColor, fontRender.font.name.cpointer())
	
