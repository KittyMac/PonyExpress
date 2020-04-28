use "linal"
use "utility"

trait Fontable is (Colorable & Viewable)
  var _sizeToFit:Bool = false
  var _sizedAtWidth:F32 = 0
  
  var _value:String = ""
  var _placeholder:String = ""
  
  var _placeholderColor:RGBA = RGBA.gray()
  
  var _secure:Bool = false
  
  var fontRender:FontRender = FontRender.empty()
  
  
  be secure(b:Bool = true) =>
    _secure = b
  
  be fontColor(color:RGBA) =>
    fontRender.fontColor = color
    
  be fontSize(fontSize':F32) =>
    fontRender.fontSize = fontSize'
  
  be font(font':Font val, fontSize':F32 = 0) =>
    fontRender.font = font'
    if fontSize' != 0 then
      fontRender.fontSize = fontSize'
    end
  
  be value(value':String) =>
    _value = value'
    fontRender.invalidate()
  
  be placeholder(placeholder':String val) =>
    _placeholder = placeholder'
    fontRender.invalidate()
  
  be sizeToFit() =>
    _sizeToFit = true
    fontRender.invalidate()
  
  be left() =>
    fontRender.fontAlignment = Alignment.left
    fontRender.invalidate()
  be center() =>
    fontRender.fontAlignment = Alignment.center
    fontRender.invalidate()
  be right() =>
    fontRender.fontAlignment = Alignment.right
    fontRender.invalidate()
  
  be top() =>
    fontRender.fontVerticalAlignment = VerticalAlignment.top
    fontRender.invalidate()
  be middle() =>
    fontRender.fontVerticalAlignment = VerticalAlignment.middle
    fontRender.invalidate()
  be bottom() =>
    fontRender.fontVerticalAlignment = VerticalAlignment.bottom
    fontRender.invalidate()
  
  fun actualValue(frameContext:FrameContext val):String =>
    if hasFocus(frameContext) or (_value.size() > 0) then 
      _value
    else
      _placeholder
    end
  
  fun actualColor(frameContext:FrameContext val):RGBA =>
    if hasFocus(frameContext) or (_value.size() > 0) then 
      _color
    else
      _placeholderColor
    end
  
  fun actualSecure(frameContext:FrameContext val):Bool =>
    if hasFocus(frameContext) or (_value.size() > 0) then 
      _secure
    else
      false
    end
  
  fun ref resizeToFit(frameContext:FrameContext val, isStart:Bool):F32 =>
    if _sizedAtWidth != frameContext.nodeSize._1 then
      _sizedAtWidth = frameContext.nodeSize._1
      
      (let width, let height) = fontRender.measure(frameContext, actualValue(frameContext), _sizedAtWidth)
      if height != frameContext.nodeSize._2 then
        frameContext.engine.getNodeByID(frameContext.nodeID, { (node) =>
            if node as YogaNode then
              node.>height(height)
            end
            if isStart then
              RenderPrimitive.startFinished(frameContext)
            end
            LayoutNeeded
          })
      end
      width
      height
    else
      frameContext.nodeSize._2
    end


  fun ref fontable_start(frameContext:FrameContext val) =>
    if _sizeToFit then
      resizeToFit(frameContext, true)
    else
      RenderPrimitive.startFinished(frameContext)
    end
  
	fun ref fontable_render(frameContext:FrameContext val, bounds:R4) =>    
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
    
    fontRender.secure = actualSecure(frameContext)
    fontRender.fontColor = actualColor(frameContext)
    let geom = fontRender.geometry(frameContext, actualValue(frameContext), bounds, topOffset)
    RenderPrimitive.renderCachedGeometry(frameContext, 0, ShaderType.sdf, geom.vertices, fontRender.fontColor, fontRender.font.name)
	
  fun ref fontable_invalidate(frameContext:FrameContext val) =>
    fontRender.invalidate()
  
  
  
  fun ref invalidate(frameContext:FrameContext val) =>
    fontable_invalidate(frameContext)
  
  fun ref start(frameContext:FrameContext val) =>
    fontable_start(frameContext)

  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    fontable_render(frameContext, bounds)