use "collections"
use "utility"

use @memcpy[Pointer[None]](dst: Pointer[None], src: Pointer[None], n: USize)

// Memory methods called from the ObjC code to ease passing memory between the two
actor@ Memory
  fun tag arrayFromCPointer(data:Pointer[U8] tag, size:USize val):Array[U8] =>
    let p = Array[U8](size)
    p.undefined(size)
    @memcpy(p.cpointer(), data, size)
    p

  fun tag stringFromCPointer(data:Pointer[U8] box, size:USize val):String ref =>
    String.copy_cpointer(data, size)