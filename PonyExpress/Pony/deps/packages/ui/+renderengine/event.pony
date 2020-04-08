use "ttimer"
use "yoga"
use "collections"
use "linal"

type AnyEvent is (NullEvent | TouchEvent)

class NullEvent

class TouchEvent
  let position:V2
  let pressed:Bool
  let id:USize
    
  new val create(id':USize, pressed':Bool, x:F32, y:F32) =>
    id = id'
    pressed = pressed'
    position = V2fun(x, y)
