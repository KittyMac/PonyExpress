use "utility"

class val RGBA
  let r:F32
  let g:F32
  let b:F32
  let a:F32
  
  new val create(r':F32, g':F32, b':F32, a':F32) => r = r'; g = g'; b = b'; a = a'
  new val u32(c:U32) =>
    a = ((c >> 0) and 0xff).f32() / 255.0
    b = ((c >> 8) and 0xff).f32() / 255.0
    g = ((c >> 16) and 0xff).f32() / 255.0
    r = ((c >> 24) and 0xff).f32() / 255.0
  
  new val empty() => r = 0; g = 0; b = 0; a = 0
  new val clear() => r = 0; g = 0; b = 0; a = 0
  new val white() => r = 1; g = 1; b = 1; a = 1
  new val black() => r = 0; g = 0; b = 0; a = 1
  new val gray() => r = 0.7; g = 0.7; b = 0.7; a = 1
  new val red() => r = 1; g = 0; b = 0; a = 1
  new val green() => r = 0; g = 1; b = 0; a = 1
  new val blue() => r = 0; g = 0; b = 1; a = 1
  new val yellow() => r = 1; g = 1; b = 0; a = 1
  new val magenta() => r = 1; g = 0; b = 1; a = 1
  new val cyan() => r = 0; g = 1; b = 1; a = 1

  fun box string(): String iso^ =>
    """string format a vector"""
    recover
      var s = String(160)
      s.push('(')
      s.append(r.string())
      s.push(',')
      s.append(g.string())
      s.push(',')
      s.append(b.string())
      s.push(',')
      s.append(a.string())
      s.push(')')
      s.>recalc()
    end