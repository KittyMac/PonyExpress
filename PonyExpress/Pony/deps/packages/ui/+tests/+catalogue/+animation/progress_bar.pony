use "linal"

actor SampleProgressBar is Viewable
  
  var bufferedGeometry:BufferedGeometry = BufferedGeometry
  var _progress:F32 = 0.0
  
  var _backColor:RGBA = RGBA.u32(0xcce1f0ff)
  var _fillColor:RGBA = RGBA.u32(0x8cbadaff)
	  
  be fillColor(c:RGBA) =>
    _fillColor = c
  
  be backColor(c:RGBA) =>
    _backColor = c
  
  be progress(p:F32) =>
    _progress = p.max(0.0).min(1.0)
    bufferedGeometry.invalidate()
    setNeedsRendered()
  
  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    let geom = bufferedGeometry.next()
    let vertices = geom.vertices

    if geom.check(frameContext, bounds) == false then
    
      vertices.reserve(6 * 7 * 2)
      vertices.clear()
    
      let x_min = R4fun.x_min(bounds)
      let y_min = R4fun.y_min(bounds)
      var x_max = R4fun.x_max(bounds)
      let y_max = R4fun.y_max(bounds)
      let width = R4fun.width(bounds)
    
      RenderPrimitive.quadVC(frameContext,    vertices,   
                             V3fun(x_min,  y_min, 0.0), 
                             V3fun(x_max,  y_min, 0.0),
                             V3fun(x_max,  y_max, 0.0),
                             V3fun(x_min,  y_max, 0.0),
                             _backColor )
      
      x_max = x_min + (width * _progress)
      RenderPrimitive.quadVC(frameContext,    vertices,   
                              V3fun(x_min,  y_min, 0.0), 
                              V3fun(x_max,  y_min, 0.0),
                              V3fun(x_max,  y_max, 0.0),
                              V3fun(x_min,  y_max, 0.0),
                              _fillColor )
    end
  
    RenderPrimitive.renderCachedGeometry(frameContext, 0, ShaderType.flat, vertices, RGBA.white())