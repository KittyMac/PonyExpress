use "linal"

actor SampleRainbow is Viewable
  // Example of a view animating itself (without the intervention of a controller)
  
  var bufferedGeometry:BufferedGeometry = BufferedGeometry
  
  var _animationRed:F32 = 0
  var _animationGreen:F32 = 0
  var _animationBlue:F32 = 0
  
  fun ref animate(delta:F32 val) =>
    _animationRed = _animationRed + (delta * 0.1)
    _animationGreen = _animationGreen + (delta * 0.1 * 7)
    _animationBlue = _animationBlue + (delta * 0.1 * 3)
    bufferedGeometry.invalidate()
    setNeedsRendered()
  
  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    let geom = bufferedGeometry.next()
    let vertices = geom.vertices

    if geom.check(frameContext, bounds) == false then
    
      vertices.reserve(6 * 7)
      vertices.clear()
    
      let x_min = R4fun.x_min(bounds)
      let y_min = R4fun.y_min(bounds)
      let x_max = R4fun.x_max(bounds)
      let y_max = R4fun.y_max(bounds)
      
      let color = RGBA((_animationRed.sin() * 0.5) + 0.5, (_animationGreen.sin() * 0.5) + 0.5, (_animationBlue.sin() * 0.5) + 0.5, 1.0)
    
      RenderPrimitive.quadVC(frameContext, vertices,   
                             V3fun(x_min,  y_min, 0.0), 
                             V3fun(x_max,  y_min, 0.0),
                             V3fun(x_max,  y_max, 0.0),
                             V3fun(x_min,  y_max, 0.0),
                             color )
    end
  
    RenderPrimitive.renderCachedGeometry(frameContext, 0, ShaderType.flat, vertices, RGBA.white(), None)