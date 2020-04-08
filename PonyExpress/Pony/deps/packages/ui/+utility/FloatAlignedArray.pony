use "linal"

//use @RenderEngine_malloc[UnsafePointer[None]](size:UnsafePointer[USize])
//use @RenderEngine_free[None](ptr:UnsafePointer[None])

class FloatAlignedArray
  """
  Liek AlignedArray, but optimized for floating point geomtry submission
  """  
  var _size: USize
  var _alloc: USize
  var _ptr: UnsafePointer[F32] ref = UnsafePointer[F32]
  
  fun _final() =>
    @RenderEngine_release[None](_ptr, _alloc)
    
  new create(len: USize = 0) =>
    """
    Create an array with zero elements, but space for len elements.
    """
    _size = 0
    
    if len > 0 then
      _alloc = len
      _ptr = @RenderEngine_malloc[UnsafePointer[F32]](addressof _alloc)
    else
      _alloc = 0
      _ptr = UnsafePointer[F32]
    end
    
  fun ref free() =>
    """
    For completeness, you can manually free the non-Pony memory using this method.
    """
    if _alloc > 0 then
      @RenderEngine_release[None](_ptr, _alloc)
    end
    _alloc = 0
    _ptr = UnsafePointer[F32]
	
  fun apply(i: USize): F32 ? =>
    """
    Get the i-th element, raising an error if the index is out of bounds.
    """
    if i < _size then
      _ptr.apply(i)
    else
      error
    end
  
  
  fun ref pushQuadVCT(v0:V3, v1:V3, v2:V3, v3:V3, r:F32, g:F32, b:F32, a:F32, st0:V2, st1:V2, st2:V2, st3:V2) =>
    _size = _size + 54
    if _size >= _alloc then
      reserve(_size)
    end
    
    _ptr.update(_size-54, v0._1); _ptr.update(_size-53, v0._2); _ptr.update(_size-52, v0._3)
    _ptr.update(_size-51, r); _ptr.update(_size-50, g); _ptr.update(_size-49, b); _ptr.update(_size-48, a)
    _ptr.update(_size-47, st0._1); _ptr.update(_size-46, st0._2)
    
    _ptr.update(_size-45, v1._1); _ptr.update(_size-44, v1._2); _ptr.update(_size-43, v1._3)
    _ptr.update(_size-42, r); _ptr.update(_size-41, g); _ptr.update(_size-40, b); _ptr.update(_size-39, a)
    _ptr.update(_size-38, st1._1); _ptr.update(_size-37, st1._2)
    
    _ptr.update(_size-36, v2._1); _ptr.update(_size-35, v2._2); _ptr.update(_size-34, v2._3)
    _ptr.update(_size-33, r); _ptr.update(_size-32, g); _ptr.update(_size-31, b); _ptr.update(_size-30, a)
    _ptr.update(_size-29, st2._1); _ptr.update(_size-28, st2._2)
    
    _ptr.update(_size-27, v2._1); _ptr.update(_size-26, v2._2); _ptr.update(_size-25, v2._3)
    _ptr.update(_size-24, r); _ptr.update(_size-23, g); _ptr.update(_size-22, b); _ptr.update(_size-21, a)
    _ptr.update(_size-20, st2._1); _ptr.update(_size-19, st2._2)
    
    _ptr.update(_size-18, v3._1); _ptr.update(_size-17, v3._2); _ptr.update(_size-16, v3._3)
    _ptr.update(_size-15, r); _ptr.update(_size-14, g); _ptr.update(_size-13, b); _ptr.update(_size-12, a)
    _ptr.update(_size-11, st3._1); _ptr.update(_size-10, st3._2)
    
    _ptr.update(_size-9, v0._1); _ptr.update(_size-8, v0._2); _ptr.update(_size-7, v0._3)
    _ptr.update(_size-6, r); _ptr.update(_size-5, g); _ptr.update(_size-4, b); _ptr.update(_size-3, a)
    _ptr.update(_size-2, st0._1); _ptr.update(_size-1, st0._2)
  
  
  fun ref pushQuadVT(v0:V3, v1:V3, v2:V3, v3:V3, st0:V2, st1:V2, st2:V2, st3:V2) =>
    _size = _size + 30
    if _size >= _alloc then
      reserve(_size)
    end
  
    _ptr.update(_size-30, v0._1); _ptr.update(_size-29, v0._2); _ptr.update(_size-28, v0._3)
    _ptr.update(_size-27, st0._1); _ptr.update(_size-26, st0._2)
  
    _ptr.update(_size-25, v1._1); _ptr.update(_size-24, v1._2); _ptr.update(_size-23, v1._3)
    _ptr.update(_size-22, st1._1); _ptr.update(_size-21, st1._2)
  
    _ptr.update(_size-20, v2._1); _ptr.update(_size-19, v2._2); _ptr.update(_size-18, v2._3)
    _ptr.update(_size-17, st2._1); _ptr.update(_size-16, st2._2)
    
    _ptr.update(_size-15, v2._1); _ptr.update(_size-14, v2._2); _ptr.update(_size-13, v2._3)
    _ptr.update(_size-12, st2._1); _ptr.update(_size-11, st2._2)
    
    _ptr.update(_size-10, v3._1); _ptr.update(_size-9, v3._2); _ptr.update(_size-8, v3._3)
    _ptr.update(_size-7, st3._1); _ptr.update(_size-6, st3._2)
  
    _ptr.update(_size-5, v0._1); _ptr.update(_size-4, v0._2); _ptr.update(_size-3, v0._3)
    _ptr.update(_size-2, st0._1); _ptr.update(_size-1, st0._2)
  
  
  fun ref pushQuadVC(v0:V3, v1:V3, v2:V3, v3:V3, r:F32, g:F32, b:F32, a:F32) =>
    _size = _size + 42
    if _size >= _alloc then
      reserve(_size)
    end
  
    _ptr.update(_size-42, v0._1); _ptr.update(_size-41, v0._2); _ptr.update(_size-40, v0._3)
    _ptr.update(_size-39, r); _ptr.update(_size-38, g); _ptr.update(_size-37, b); _ptr.update(_size-36, a)
  
    _ptr.update(_size-35, v1._1); _ptr.update(_size-34, v1._2); _ptr.update(_size-33, v1._3)
    _ptr.update(_size-32, r); _ptr.update(_size-31, g); _ptr.update(_size-30, b); _ptr.update(_size-29, a)
  
    _ptr.update(_size-28, v2._1); _ptr.update(_size-27, v2._2); _ptr.update(_size-26, v2._3)
    _ptr.update(_size-25, r); _ptr.update(_size-24, g); _ptr.update(_size-23, b); _ptr.update(_size-22, a)
    
    _ptr.update(_size-21, v2._1); _ptr.update(_size-20, v2._2); _ptr.update(_size-19, v2._3)
    _ptr.update(_size-18, r); _ptr.update(_size-17, g); _ptr.update(_size-16, b); _ptr.update(_size-15, a)
    
    _ptr.update(_size-14, v3._1); _ptr.update(_size-13, v3._2); _ptr.update(_size-12, v3._3)
    _ptr.update(_size-11, r); _ptr.update(_size-10, g); _ptr.update(_size-9, b); _ptr.update(_size-8, a)
  
    _ptr.update(_size-7, v0._1); _ptr.update(_size-6, v0._2); _ptr.update(_size-5, v0._3)
    _ptr.update(_size-4, r); _ptr.update(_size-3, g); _ptr.update(_size-2, b); _ptr.update(_size-1, a)
  
  
  
  
  
  fun ref push(value: F32) =>
    """
    Add an element to the end of the array.
    """
    _size = _size + 1
    if _size >= _alloc then
      reserve(_size)
    end
    _ptr.update(_size-1, consume value)
  
  fun ref update(i: USize, value: F32): F32^ ? =>
    """
    Change the i-th element, raising an error if the index is out of bounds.
    """
    if i < _size then
      _ptr.update(i, consume value)
    else
      error
    end
  
  fun ref pop(): F32^ ? =>
    """
    Remove an element from the end of the array.
    The removed element is returned.
    """
    delete(_size - 1)?
  
  fun ref insert(i: USize, value: F32) ? =>
    """
    Insert an element into the array. Elements after this are moved up by one
    index, extending the array.
    An out of bounds index raises an error.
    """
    if i <= _size then
      reserve(_size + 1)
      _ptr.offset(i).insert(1, _size - i)
      _ptr.update(i, consume value)
      _size = _size + 1
    else
      error
    end
  
  fun ref delete(i: USize): F32^ ? =>
    error

  fun ref unshift(value: F32) =>
    """
    Add an element to the beginning of the array.
    """
    try
      insert(0, consume value)?
    end

  fun ref shift(): F32^ ? =>
    """
    Remove an element from the beginning of the array.
    The removed element is returned.
    """
    delete(0)?

  fun ref append(
    seq: (ReadSeq[F32] & ReadElement[F32^]),
    offset: USize = 0,
    len: USize = -1)
  =>
    """
    Append the elements from a sequence, starting from the given offset.
    """
    if offset >= seq.size() then
      return
    end

    let copy_len = len.min(seq.size() - offset)
    reserve(_size + copy_len)

    var n = USize(0)

    try
      while n < copy_len do
        _ptr.update(_size + n, seq(offset + n)?)

        n = n + 1
      end
    end

    _size = _size + n

  fun ref concat(iter: Iterator[F32^], offset: USize = 0, len: USize = -1) =>
    """
    Add len iterated elements to the end of the array, starting from the given
    offset.
    """

    var n = USize(0)

    try
      while n < offset do
        if iter.has_next() then
          iter.next()?
        else
          return
        end

        n = n + 1
      end
    end

    n = 0

    // If a concrete len is specified, we take the caller at their word
    // and reserve that much space, even though we can't verify that the
    // iterator actually has that many elements available. Reserving ahead
    // of time lets us take a fast path of direct pointer access.
    if len != -1 then
      reserve(_size + len)

      try
        while n < len do
          if iter.has_next() then
            _ptr.update(_size + n, iter.next()?)
          else
            break
          end

          n = n + 1
        end
      end

      _size = _size + n
    else
      try
        while n < len do
          if iter.has_next() then
            push(iter.next()?)
          else
            break
          end

          n = n + 1
        end
      end
    end
  
  fun ref reserve(len: USize) =>
    """
    Reserve space for len elements, including whatever elements are already in
    the array. Array space grows geometrically.
    """
    let alignedLen = @RenderEngine_alignedSize[USize](len)
    
    if _alloc < alignedLen then
      let old_ptr = _ptr
      let old_alloc = _alloc
      
      _alloc = len
      _ptr = @RenderEngine_malloc[UnsafePointer[F32]](addressof _alloc)
      
      if old_ptr.is_null() == false then
        old_ptr.copy_to(_ptr, _size)
      end
      
      @RenderEngine_release[None](old_ptr, old_alloc)
    end
  
  fun ref clear() =>
    """
    Remove all elements from the array.
    """
    _size = 0

  fun ref truncate(len: USize) =>
    """
    Truncate an array to the given length, discarding excess elements. If the
    array is already smaller than len, do nothing.
    """
    _size = _size.min(len)
  
  fun size(): USize =>
    """
    The number of elements in the array.
    """
    _size
  
  fun reserved(): USize =>
    """
    The number of elements in the array.
    """
    _alloc
  
  fun cpointer(offset: USize = 0): UnsafePointer[F32] tag =>
    """
    Return the underlying C-style pointer.
    """
    _ptr.offset(offset)
  
  fun values(): FloatAlignedArrayValues^ =>
    """
    Return an iterator over the values in the array.
    """
    FloatAlignedArrayValues(this, 0)
  
  
class FloatAlignedArrayValues is Iterator[F32]
  let _array: FloatAlignedArray box
  var _i: USize

  new create(array: FloatAlignedArray box, offset:USize) =>
    _array = array
    _i = offset

  fun has_next(): Bool =>
    _i < _array.size()

  fun ref next(): F32 ? =>
    _array(_i = _i + 1)?

  fun ref rewind(): FloatAlignedArrayValues =>
    _i = 0
    this
