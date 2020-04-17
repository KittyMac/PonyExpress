use "collections"
use "linal"
use "stringext"
use "utility"

type FontWrapType is U32
primitive FontWrap
  let character:U32 = 0
  let word:U32 = 1

type AlignmentType is U32
primitive Alignment
  let left:U32 = 0
  let center:U32 = 1
  let right:U32 = 2

type VerticalAlignmentType is U32
primitive VerticalAlignment
  let top:U32 = 0
  let middle:U32 = 1
  let bottom:U32 = 2


class GlyphRenderData
  var bx:F32 = 0
  var by:F32 = 0
  var bw:F32 = 0
  var bh:F32 = 0
  var tx:F32 = 0
  var ty:F32 = 0
  var tw:F32 = 0
  var th:F32 = 0
  var skip:Bool = false
  
  new zero() =>
    skip = true
  
  new create(bx':F32, by':F32, bw':F32, bh':F32, tx':F32, ty':F32, tw':F32, th':F32) =>
    bx = bx'
    by = by'
    bw = bw'
    bh = bh'
    tx = tx'
    ty = ty'
    tw = tw'
    th = th'


class FontRender
  var font:Font
  var fontSize:F32 = 18
  var fontColor:RGBA = RGBA.black()
  var fontWrap:FontWrapType = FontWrap.word
  var fontAlignment:AlignmentType = Alignment.left
  var fontVerticalAlignment:VerticalAlignmentType = VerticalAlignment.middle

  var bufferedGeometry:BufferedGeometry = BufferedGeometry
  
  var glyphRenderData:Array[GlyphRenderData] = Array[GlyphRenderData]
  
  new empty() =>
    font = Font.empty()
  
  new create(font':Font, fontSize':F32, fontColor':RGBA) =>
    font = font'
    fontSize = fontSize'
    fontColor = fontColor'
  
  fun calcHash(bounds:R4):USize =>
    ((R4fun.x_min(bounds) + 0) + (R4fun.y_min(bounds) * 14639) + (R4fun.width(bounds) * 27143) + (R4fun.height(bounds) * 46811)).abs().usize()
  
  fun ref invalidate() =>
    bufferedGeometry.invalidate()
  
  
  fun ref measureNextTextLine(text:String, start_index:USize, start_pen:V2, bounds_xmax:F32, createRenderData:Bool):(F32,USize) =>
    var i:USize = start_index
    var pen_x:F32 = start_pen._1
    var pen_y:F32 = start_pen._2
    
    let fontAtlas = font.fontAtlas
    let glyphData = font.glyphData
    var glyph:GlyphData val = recover GlyphData.empty() end
    
    var start_of_word_index:USize = start_index
    var end_of_word_pen_x:F32 = pen_x
        
    let space_advance = fontAtlas.space_advance * fontSize
    var localWrap = FontWrap.character
    
    let zeroGlyph = GlyphRenderData.zero()
        
    try
      
      let text_size = text.size()
      while i < text_size do
        let c = text(i)?
        i = i + 1
        
        if c == '\n' then
          end_of_word_pen_x = pen_x
          localWrap = fontWrap
          start_of_word_index = i
          if createRenderData then 
            glyphRenderData.push(zeroGlyph)
          end
          break
        elseif c == ' ' then
          end_of_word_pen_x = pen_x
          pen_x = pen_x + space_advance
          localWrap = fontWrap
          start_of_word_index = i
          if createRenderData then 
            glyphRenderData.push(zeroGlyph)
          end
          continue
        elseif c == '\t' then
          pen_x = pen_x + (space_advance * 2)
          localWrap = fontWrap
          start_of_word_index = i
          if createRenderData then 
            glyphRenderData.push(zeroGlyph)
          end
          continue
        end
        
        glyph = try 
          glyphData(c.usize())?
        else
          end_of_word_pen_x = pen_x
          localWrap = fontWrap
          start_of_word_index = i
          if createRenderData then 
            glyphRenderData.push(zeroGlyph)
          end
          continue
        end
        
        
        let g_width = glyph.bbox_width * fontSize
        let g_bearing_x = glyph.bearing_x * fontSize
        let g_advance_x = (glyph.advance_x * fontSize).floor()

        var x = pen_x + g_bearing_x
        let w = g_width
        
        // if drawing this glyph will exceed the width of our draw box...
        if (x + w) >= bounds_xmax then
          if localWrap == FontWrap.word then
            pen_x = end_of_word_pen_x
            i = start_of_word_index
          else
            i = i - 1
          end
          break
        end
        
        if createRenderData then
          let g_height = glyph.bbox_height * fontSize
          let g_bearing_y = glyph.bearing_y * fontSize
          var y = pen_y - g_bearing_y
          let h = g_height
          
          let s0 = glyph.s0
          let s1 = glyph.s1
          let t0 = glyph.t0
          let t1 = glyph.t1
    
          let sW = s1 - s0
          let sH = t1 - t0
          
          glyphRenderData.push(
            GlyphRenderData(x, y, w, h,
                            s0, t0, sW, sH
            )
          )
        end
        
        pen_x = pen_x + g_advance_x
        
      end
    end
    
    if i == start_index then
      i = start_index + 1
    end
    
    if createRenderData then
      glyphRenderData.truncate(i)
    end
    
    (pen_x - start_pen._1, i - start_index)
  
  
  fun ref measureHeight(frameContext:FrameContext val,
                        text:String,
                        width:F32):F32 =>
    // Find the minimum height needed in order to contain this text given the width provided
    let fontAtlas = font.fontAtlas
    let advance_y = (fontAtlas.height * fontSize).floor()
    
    let end_index:USize = text.size()
    var start_index:USize = 0
    var pen:V2 = V2fun(0, fontSize)
    
    while start_index < end_index do
      (let _, let next_index) = measureNextTextLine(text, start_index, pen, width, false)
      
      pen = V2fun(pen._1, pen._2 + advance_y)
      
      start_index = start_index + next_index
    end
        
    (pen._2 - fontSize)
  
  fun ref geometry( frameContext:FrameContext val, 
                    text:String, 
                    bounds:R4,
                    topOffset:F32 = 0.0):Geometry =>
    """
    Generate a mesh for rendering the string. Wrap words before maxWidth is encountered

    topOffset: if the bounds needs "fudged" in order to account for dynamic size to fit, this value
    can be set to adjust for the expected differences in height
    """
    
    let local_bounds = R4fun( R4fun.x_min(bounds),
                              R4fun.y_min(bounds) + topOffset,
                              R4fun.width(bounds),
                              R4fun.height(bounds))
    
    let local_height = R4fun.height(bounds)
    
    let geom = bufferedGeometry.next()
    if geom.check(frameContext, local_bounds) then
      return geom
    end
    
    let vertices = geom.vertices
    
    // 6 vertices for each character, x,y,z,u,t
    vertices.reserve(text.size() * 6 * 5)
    vertices.clear()
    
    glyphRenderData.reserve(text.size() * 2)
    glyphRenderData.clear()
    
    let fontAtlas = font.fontAtlas
    let advance_y = (fontAtlas.height * fontSize).floor()
    
    // Take the interactions of the clip bounds and our bounds, only generate geometry for
    // the visible region. The "clipBounds" is essentially the size of the parent
    // centered in the bounds    
    let bounds_xmin = R4fun.x_min(local_bounds)
    let bounds_xmax = R4fun.x_max(local_bounds)
    let bounds_ymin = R4fun.y_min(local_bounds)
    let bounds_ymax = R4fun.y_max(local_bounds)
    
    let visbounds_xmax = R4fun.x_max(frameContext.clipBounds)
    let visbounds_ymin = R4fun.y_min(frameContext.clipBounds) - (((R4fun.height(local_bounds) - R4fun.height(frameContext.clipBounds)) / 2) - topOffset)
    let visbounds_ymax = R4fun.y_max(frameContext.clipBounds) - (((R4fun.height(local_bounds) - R4fun.height(frameContext.clipBounds)) / 2) - topOffset)
            
    let end_index:USize = text.size()
    var start_index:USize = 0
    var pen:V2 = V2fun(bounds_xmin, bounds_ymin + fontSize)
    
    var vis_ymin = bounds_ymin
    var vis_ymax = bounds_ymax
    if visbounds_xmax < 999999 then
      vis_ymin = visbounds_ymin
      vis_ymax = visbounds_ymax
    end
    
    // measure out all lines of text (each character saved to glyphRenderData)
    while start_index < end_index do
      
      if (pen._2 - advance_y) >= bounds_ymax then
        break
      end
      
      let line_is_visible = (pen._2 >= vis_ymin) and ((pen._2 - advance_y) <= vis_ymax)
      
      let start_glyph_idx = glyphRenderData.size()
      
      (let renderWidth, let next_index) = measureNextTextLine(text, start_index, pen, bounds_xmax, line_is_visible)
      
      let x_off:F32 = (match fontAlignment
      | Alignment.left => 0
      | Alignment.center => ((bounds_xmax - bounds_xmin) - renderWidth) / 2.0
      | Alignment.right => ((bounds_xmax - bounds_xmin) - renderWidth)
      else 0.0 end).max(0.0)

      
      // update each glyph in this line with the x_off
      if x_off != 0 then
        for g in glyphRenderData.valuesAfter(start_glyph_idx) do
          g.bx = g.bx + x_off
        end
      end
      
      pen = V2fun(pen._1, pen._2 + advance_y)
      
      start_index = start_index + next_index
    end
    
    let renderHeight = pen._2 - (bounds_ymin + fontSize)
    
    var y_off:F32 = (match fontVerticalAlignment
    | VerticalAlignment.top => 0
    | VerticalAlignment.middle => (local_height - renderHeight) / 2.0
    | VerticalAlignment.bottom => (local_height - renderHeight)
    else 0.0 end).max(0.0)
    
    
    // So, the interesting bit is that if we're a label that sizes to fit, then
    // vertical alignment is meaningless (as our size will match our render)
    // size.
    if topOffset != 0 then
      y_off = (local_height - renderHeight) / 2.0
    end
        
    // commit all glyphs in glyphRenderData to geometry
    for g in glyphRenderData.values() do
    
      if g.skip then
          continue
      end
      
      var x_min = g.bx
      var x_max = g.bx + g.bw
      var y_min = g.by + y_off
      var y_max = g.by + g.bh + y_off
      
      var st_x_min = g.tx
      var st_x_max = g.tx + g.tw
      var st_y_min = g.ty
      var st_y_max = g.ty + g.th
      
      // Our text is allowed to extend outside of the bounds up until this point.
      // Now need to check to see if they need cropped, and then crop them
      let w_mod = if x_max >= bounds_xmax then
                    1.0 - ((x_max - bounds_xmax) / g.bw)
                  else
                    1.0
                  end
      let h_mod = if y_max >= bounds_ymax then
                    1.0 - ((y_max - bounds_ymax) / g.bh)
                  else
                    1.0
                  end
      
      
      x_max = g.bx + (g.bw * w_mod)
      y_max = g.by + y_off + (g.bh * h_mod)
      
      st_x_max = g.tx + (g.tw * w_mod)
      st_y_max = g.ty + (g.th * h_mod)
      
      if (x_max > x_min) and (y_max > y_min) then
        RenderPrimitive.quadVT(frameContext, vertices,   
                                V3fun(x_min, y_min, 0.0), 
                                V3fun(x_max, y_min, 0.0),
                                V3fun(x_max, y_max, 0.0),
                                V3fun(x_min, y_max, 0.0),
                                V2fun(st_x_min, 1.0 - st_y_min),
                                V2fun(st_x_max, 1.0 - st_y_min),
                                V2fun(st_x_max, 1.0 - st_y_max),
                                V2fun(st_x_min, 1.0 - st_y_max) )
      end
    end
        
    geom
    
