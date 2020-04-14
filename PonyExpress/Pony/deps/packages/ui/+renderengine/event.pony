use "ttimer"
use "yoga"
use "collections"
use "linal"

type AnyEvent is (NullEvent | TouchEvent | ScrollEvent)

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
