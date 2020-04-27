use "time"

class StringParser
  let floatChars:Array[U8] val = ['0';'1';'2';'3';'4';'5';'6';'7';'8';'9';'.';'-';'+']
  let intChars:Array[U8] val = ['0';'1';'2';'3';'4';'5';'6';'7';'8';'9';'-';'+']
  let string:String val
  var idx:USize = 0
  
  new create(string':String val) =>
    string = string'
  
  fun ref u8():U8? =>
    let c = string(idx)?
    idx = idx + 1
    c
    
  fun ref advance(set:Array[U8] val):USize =>
    try
      while true do
        let c = string(idx)?
        if set.contains(c) == false then
          break
        end
        idx = idx + 1
      end
    end
    idx
  
  fun ref f32():F32? =>
    let start_idx:USize = idx
    var end_idx:USize = idx
    
    end_idx = advance(floatChars)
    if end_idx == start_idx then
      error
    end
    
    @strtod[F64](string.cpointer(start_idx), Pointer[None]).f32()
    
  fun ref i32():I32? =>
    let start_idx:USize = idx
    var end_idx:USize = idx
  
    end_idx = advance(intChars)
  
    if end_idx == start_idx then
      error
    end
  
    @strtol[I32](string.cpointer(start_idx), Pointer[None], I32(10))