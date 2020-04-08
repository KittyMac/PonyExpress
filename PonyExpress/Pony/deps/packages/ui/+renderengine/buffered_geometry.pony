use "collections"
use "linal"

use @RenderEngine_maxConcurrentFrames[USize]()

class Geometry
  """
  One unit of geometry. Hash needs to uniquely represent the buffered content in order to allow for reuse of geometric
  data if nothing has changed
  """
  var vertices:FloatAlignedArray = FloatAlignedArray
  var bounds:R4 = R4fun.zero()
  var matrix:M4 = M4fun.id()
  
  fun ref invalidate() =>
    bounds = R4fun.zero()
  
  fun ref check(frameContext:FrameContext box, new_bounds:R4):Bool =>
    if R4fun.eq(bounds, new_bounds) and M4fun.eq(matrix, frameContext.matrix) then
      return true
    end
    bounds = new_bounds
    matrix = frameContext.matrix
    false

class BufferedGeometry
  """
  Memory allocations for large amounts of geometry can get expensive. So the ideal circumstance is we allocate it once and it can be
  used by the native renderer without any copying required. To do this and allow multiple frames to be rendered simultaneously (ie
  the buffer is being used by the renderer for the previous frame while we are filling it out for the next frame) we need to
  have a rotating system of buffers.  This class facilitates that.
  """
  
  var buffers:Array[Geometry]
  var bufferIdx:USize = 0
  var maxBuffers:USize = 1
  
  new create() =>
    maxBuffers = @RenderEngine_maxConcurrentFrames()
    buffers = Array[Geometry]
    for _ in Range(0, maxBuffers) do
      buffers.push(Geometry)
    end
  
  fun ref invalidate() =>
    for buffer in buffers.values() do
      buffer.invalidate()
    end
  
  fun ref next():Geometry =>
    bufferIdx = bufferIdx + 1
    try
      buffers(bufferIdx % maxBuffers)?
    else
      Geometry
    end
