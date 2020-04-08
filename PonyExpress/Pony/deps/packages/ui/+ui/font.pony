use "collections"
use "linal"
use "utility"

class val Font
  var name:String
  var fontAtlas:FontAtlas
  var glyphData:Array[GlyphData val]
  
  new val empty() =>
    name = "empty"
    fontAtlas = FontAtlas.empty()
    glyphData = Array[GlyphData val]()
  
  new val create(fontJson:String) =>
    name = "empty"
    fontAtlas = FontAtlas.empty()
    glyphData = Array[GlyphData val](256)
    try
      fontAtlas = FontAtlas.fromString(fontJson)?
      name = fontAtlas.name
      
      for _ in Range(0,256) do
        glyphData.push(recover val GlyphData.empty() end)
      end
      
      for glyph in fontAtlas.glyph_data.values() do
        try
          let code = glyph.charcode(0)?
          glyphData(code.usize())? = glyph.clone()?
        end
      end
    end
