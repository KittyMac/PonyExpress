use "linal"
use "utility"

type ImageModeType is U32

primitive ImageMode
  let fill:ImageModeType = 0
  let aspectFit:ImageModeType = 1
  let aspectFill:ImageModeType = 2
  let stretch:ImageModeType = 3

trait Imageable is (Viewable & Colorable)
  var _textureName:String = ""
  var _focusTextureName:String = ""
  var _mode:ImageModeType = ImageMode.fill
  var _sizeToFit:Bool = false
  var stretch_insets:V4 = V4fun.zero()
  
  var bufferedGeometry:BufferedGeometry = BufferedGeometry
  
  be path(textureName:String val) =>
    _textureName = textureName
  
  be pathFocused(textureName:String val) =>
    _focusTextureName = textureName
  
  be sizeToFit() =>
    _sizeToFit = true
    bufferedGeometry.invalidate()
  
  be fill() =>
    _mode = ImageMode.fill
    bufferedGeometry.invalidate()
  
  be aspectFit() =>
    _mode = ImageMode.aspectFit
    bufferedGeometry.invalidate()
  
  be aspectFill() =>
    _mode = ImageMode.aspectFill
    bufferedGeometry.invalidate()
  
  be stretch(top:F32, left:F32, bottom:F32, right:F32) =>
    _mode = ImageMode.stretch
    stretch_insets = V4fun(top, left, bottom, right)
    bufferedGeometry.invalidate()
  
  be stretchAll(v:F32) =>
    _mode = ImageMode.stretch
    stretch_insets = V4fun(v, v, v, v)
    bufferedGeometry.invalidate()
    
  fun ref imageable_start(frameContext:FrameContext val) =>
    if _sizeToFit then
      var image_width:F32 = 0
      var image_height:F32 = 0
      @RenderEngine_textureInfo(frameContext.renderContext, _textureName.cpointer(), addressof image_width, addressof image_height)
    
      frameContext.engine.getNodeByID(frameContext.nodeID, { (node) =>
          if node as YogaNode then
            node.>width(image_width).>height(image_height)
          end
          RenderPrimitive.startFinished(frameContext)
          LayoutNeeded
        })
    else
      RenderPrimitive.startFinished(frameContext)
    end
  
  fun ref start(frameContext:FrameContext val) =>
    imageable_start(frameContext)
  
  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    imageable_render(frameContext, bounds)
  
  fun ref imageable_render(frameContext:FrameContext val, bounds:R4) =>
    if _mode == ImageMode.stretch then
      imageable_render_stretch(frameContext, bounds)
      return
    end
    
    let geom = bufferedGeometry.next()
    let vertices = geom.vertices
    
    if geom.check(frameContext, bounds) == false then
      
      vertices.reserve(6 * 9)
      vertices.clear()
            
      var image_width:F32 = 0
      var image_height:F32 = 0
      @RenderEngine_textureInfo(frameContext.renderContext, _textureName.cpointer(), addressof image_width, addressof image_height)
      
      let image_aspect = image_width / image_height
      
      let bounds_aspect = R4fun.width(bounds) / R4fun.height(bounds)
    
      var x_min = R4fun.x_min(bounds)
      var y_min = R4fun.y_min(bounds)
      var x_max = R4fun.x_max(bounds)
      var y_max = R4fun.y_max(bounds)
      
      var s_min:F32 = 0.0
      var s_max:F32 = 1.0
      var t_min:F32 = 0.0
      var t_max:F32 = 1.0
            
      match _mode
      | ImageMode.aspectFit =>
        
        if image_aspect > bounds_aspect then
          let c = (y_min + y_max) / 2
          let h = (x_max - x_min) / image_aspect
          y_min = c - (h / 2)
          y_max = c + (h / 2)
        else
          let c = (x_min + x_max) / 2
          let w = (y_max - y_min) * image_aspect
          x_min = c - (w / 2)
          x_max = c + (w / 2)
        end
        
      | ImageMode.aspectFill =>
        
        let combined_aspect = (image_aspect / bounds_aspect)
        if combined_aspect > 1.0 then
          s_min = 0.5 - ((1.0 / combined_aspect) / 2)
          s_max = 0.5 + ((1.0 / combined_aspect) / 2)
        else
          t_min = 0.5 - (combined_aspect / 2)
          t_max = 0.5 + (combined_aspect / 2)
        end
        
      else
        None
      end
      
      RenderPrimitive.quadVCT(frameContext,    vertices,   
                              V3fun(x_min,  y_min, 0.0), 
                              V3fun(x_max,  y_min, 0.0),
                              V3fun(x_max,  y_max, 0.0),
                              V3fun(x_min,  y_max, 0.0),
                              _color,   
                              V2fun(s_min, t_min),
                              V2fun(s_max, t_min),
                              V2fun(s_max, t_max),
                              V2fun(s_min, t_max) )
                              
    end
    
    if hasFocus(frameContext) and (_focusTextureName.size() > 0) then
      RenderPrimitive.renderCachedGeometry(frameContext, 0, ShaderType.textured, vertices, RGBA.white(), _focusTextureName.cpointer())
    else
      RenderPrimitive.renderCachedGeometry(frameContext, 0, ShaderType.textured, vertices, RGBA.white(), _textureName.cpointer())
    end


  fun ref imageable_render_stretch(frameContext:FrameContext val, bounds:R4) =>
    // For rendering the 9-point stretchable images.  We are render 9 separate
    // quads in order to draw one stretched image
    let geom = bufferedGeometry.next()
    let vertices = geom.vertices

    vertices.reserve(6 * 9 * 9)
    vertices.clear()
    
    var image_width:F32 = 0
    var image_height:F32 = 0
    @RenderEngine_textureInfo(frameContext.renderContext, _textureName.cpointer(), addressof image_width, addressof image_height)
    
    let x = R4fun.x_min(bounds)
    let y = R4fun.y_min(bounds)
    let w = R4fun.width(bounds)
    let h = R4fun.height(bounds)
    
    var x_min = x
    var y_min = y
    var x_max = x + w
    var y_max = y + h
    
    var s_min:F32 = 0.0
    var s_max:F32 = 1.0
    var t_min:F32 = 0.0
    var t_max:F32 = 1.0
            
    // stretch_insets is (top, left, bottom, right)
    var row:USize = 0
    while row < 3 do
      match row
      | 0 =>
        y_max = y + stretch_insets._1
        t_max = stretch_insets._1 / image_height
      | 1 =>
        y_min = y_max
        y_max = y + (h - stretch_insets._3)
        t_min = t_max
        t_max = (image_height - stretch_insets._3) / image_height
      | 2 =>
        y_min = y_max
        y_max = y + h
        t_min = t_max
        t_max = 1.0
      end
      row = row + 1
      
      // left
      x_min = x
      x_max = x + stretch_insets._2
      s_min = 0
      s_max = stretch_insets._2 / image_width
      
      RenderPrimitive.quadVCT(frameContext,    vertices,   
                              V3fun(x_min,  y_min, 0.0), 
                              V3fun(x_max,  y_min, 0.0),
                              V3fun(x_max,  y_max, 0.0),
                              V3fun(x_min,  y_max, 0.0),
                              _color,
                              V2fun(s_min, t_min),
                              V2fun(s_max, t_min),
                              V2fun(s_max, t_max),
                              V2fun(s_min, t_max) )
    
      // center
      x_min = x_max
      x_max = x + (w - stretch_insets._4)
      s_min = s_max
      s_max = (image_width - stretch_insets._4) / image_width
    
      RenderPrimitive.quadVCT(frameContext,    vertices,   
                              V3fun(x_min,  y_min, 0.0), 
                              V3fun(x_max,  y_min, 0.0),
                              V3fun(x_max,  y_max, 0.0),
                              V3fun(x_min,  y_max, 0.0),
                              _color,
                              V2fun(s_min, t_min),
                              V2fun(s_max, t_min),
                              V2fun(s_max, t_max),
                              V2fun(s_min, t_max) )
    
      // right
      x_min = x_max
      x_max = x + w
      s_min = s_max
      s_max = 1.0
    
      RenderPrimitive.quadVCT(frameContext,    vertices,   
                              V3fun(x_min,  y_min, 0.0), 
                              V3fun(x_max,  y_min, 0.0),
                              V3fun(x_max,  y_max, 0.0),
                              V3fun(x_min,  y_max, 0.0),
                              _color,
                              V2fun(s_min, t_min),
                              V2fun(s_max, t_min),
                              V2fun(s_max, t_max),
                              V2fun(s_min, t_max) )
    end
    
    if hasFocus(frameContext) and (_focusTextureName.size() > 0) then
      RenderPrimitive.renderCachedGeometry(frameContext, 0, ShaderType.textured, vertices, RGBA.white(), _focusTextureName.cpointer())
    else
      RenderPrimitive.renderCachedGeometry(frameContext, 0, ShaderType.textured, vertices, RGBA.white(), _textureName.cpointer())
    end
    
    