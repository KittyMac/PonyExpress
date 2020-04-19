use "ttimer"
use "yoga"
use "collections"
use "linal"

type AnyEvent is (NullEvent | TouchEvent | ScrollEvent | KeyEvent)

class NullEvent

class TouchEvent
  let position:V2
  let pressed:Bool
  let id:USize
    
  new val create(id':USize, pressed':Bool, x:F32, y:F32) =>
    id = id'
    pressed = pressed'
    position = V2fun(x, y)


class ScrollEvent
  let delta:V2
  let position:V2
  let id:USize

  new val create(id':USize, dx:F32, dy:F32, px:F32, py:F32) =>
    id = id'
    delta = V2fun(dx, dy)
    position = V2fun(px, py)



class KeyEvent
  let position:V2
  let pressed:Bool
  let keyCode:U16
  let characters:String val
  
  fun delete():Bool =>
    (keyCode == 51) or (keyCode == 117)
  
  fun tab():Bool =>
    (keyCode == 48)
  
  new val create(pressed':Bool, keyCode':U16, characters':String val, x:F32, y:F32) =>
    pressed = pressed'
    keyCode = keyCode'
    characters = characters'
    position = V2fun(x, y)