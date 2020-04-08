
//use @RenderEngine_malloc[UnsafePointer[None]](size:UnsafePointer[USize])
//use @RenderEngine_free[None](ptr:UnsafePointer[None])

class AlignedArray[A] is Seq[A]
  """
  An Array class which uses posix_memalign() to allocate its memory. Note that this currently doesn't support
  reallocating the size of the array.  Also note that we do NOT free this memory, we are creating an
  aligned buffer of memory we are sending across FFI which will deallocate it there.
  """  
  var _size: USize
  var _alloc: USize
  var _ptr: UnsafePointer[A] ref = UnsafePointer[A]
  
  fun _final() =>
    @RenderEngine_release[None](_ptr, _alloc)
    
  new create(len: USize = 0) =>
    """
    Create an array with zero elements, but space for len elements.
    """
    _size = 0
    
    if len > 0 then
      _alloc = len
      _ptr = @RenderEngine_malloc[UnsafePointer[A]](addressof _alloc)
    else
      _alloc = 0
      _ptr = UnsafePointer[A]
    end
    
  fun ref free() =>
    """
    For completeness, you can manually free the non-Pony memory using this method.
    """
    if _alloc > 0 then
      @RenderEngine_release[None](_ptr, _alloc)
    end
    _alloc = 0
    _ptr = UnsafePointer[A]
	
  fun apply(i: USize): this->A ? =>
    """
    Get the i-th element, raising an error if the index is out of bounds.
    """
    if i < _size then
      _ptr.apply(i)
    else
      error
    end
  
  fun ref push(value: A) =>
    """
    Add an element to the end of the array.
    """
    _size = _size + 1
    if _size >= _alloc then
      reserve(_size)
    end
    _ptr.update(_size-1, consume value)
  
  fun ref update(i: USize, value: A): A^ ? =>
    """
    Change the i-th element, raising an error if the index is out of bounds.
    """
    if i < _size then
      _ptr.update(i, consume value)
    else
      error
    end
  
  fun ref pop(): A^ ? =>
    """
    Remove an element from the end of the array.
    The removed element is returned.
    """
    delete(_size - 1)?
  
  fun ref insert(i: USize, value: A) ? =>
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
  
  fun ref delete(i: USize): A^ ? =>
    error

  fun ref unshift(value: A) =>
    """
    Add an element to the beginning of the array.
    """
    try
      insert(0, consume value)?
    end

  fun ref shift(): A^ ? =>
    """
    Remove an element from the beginning of the array.
    The removed element is returned.
    """
    delete(0)?

  fun ref append(
    seq: (ReadSeq[A] & ReadElement[A^]),
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

  fun ref concat(iter: Iterator[A^], offset: USize = 0, len: USize = -1) =>
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
      _ptr = @RenderEngine_malloc[UnsafePointer[A]](addressof _alloc)
      
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
  
  fun cpointer(offset: USize = 0): UnsafePointer[A] tag =>
    """
    Return the underlying C-style pointer.
    """
    _ptr.offset(offset)
  
  fun values(): AlignedArrayValues[A, this->AlignedArray[A]]^ =>
    """
    Return an iterator over the values in the array.
    """
    AlignedArrayValues[A, this->AlignedArray[A]](this, 0)
  
  
class AlignedArrayValues[A, B: AlignedArray[A] #read] is Iterator[B->A]
  let _array: B
  var _i: USize

  new create(array: B, offset:USize) =>
    _array = array
    _i = offset

  fun has_next(): Bool =>
    _i < _array.size()

  fun ref next(): B->A ? =>
    _array(_i = _i + 1)?

  fun ref rewind(): AlignedArrayValues[A, B] =>
    _i = 0
    this
