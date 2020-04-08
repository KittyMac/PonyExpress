use "flow"
use "files"

interface tag FileExtReaderCallback
  be fileExtReaderReadComplete(sender:FileExtFlowReader tag, done:Bool val)


actor FileExtFlowReader
  
  let target:Flowable tag
  let controller:(None|FileExtReaderCallback tag)
  
  var fd:I32
  let bufferSize:USize
  let isAutomatic:Bool
  
  fun _tag():USize => 109
  
  fun _freed(wasRemote:Bool) =>
    if isAutomatic and wasRemote then
      _automaticReadNextChunk()
    end
  
  new create (filePath:String, bufferSize':USize, target':Flowable tag) =>
    bufferSize = bufferSize'
    target = target'
    controller = None

    fd = FileExt.open(filePath, FileExt.pRead())
    isAutomatic = true
    
    // We "prime the pump" by reading the first few chunks and sending them along.
    // After that, we rely on the _freed() method to tell us when a chunk has
    // finished processing.  When it has, then we read a chunk to replace it.
    _automaticReadNextChunk()
    _automaticReadNextChunk()
    _automaticReadNextChunk()
  
  new manual (filePath:String, bufferSize':USize, controller':FileExtReaderCallback tag, target':Flowable tag) =>
    bufferSize = bufferSize'
    target = target'
    controller = controller'

    fd = FileExt.open(filePath, FileExt.pRead())
    isAutomatic = false
    
  
  fun ref _readNextChunk():Bool =>
    if fd >= 0 then
      var bufferIso = recover iso Array[U8](bufferSize) end
  
      let bytesRead = FileExt.read(fd, bufferIso.cpointer(0), bufferSize)
      if bytesRead >= 0 then
        bufferIso.undefined(bytesRead.usize())
      else
        bufferIso.undefined(0)
      end
  
      if bufferIso.size() > 0 then
        target.flowReceived(consume bufferIso)
      else
        FileExt.close(fd)
        fd = -9999
        target.flowFinished()
        return true
      end
    else
      if fd != -9999 then
        let errno = @pony_os_errno[I32]()
        @fprintf[I32](@pony_os_stdout[Pointer[U8]](), ("FileExtFlowReader failed to open, errno is " + errno.string() + "\n").cstring())
        target.flowFinished()
      end
      return true
    end
    false
  
  be _automaticReadNextChunk() =>
    _readNextChunk()
  
  be read() =>
    if isAutomatic then
      match controller
      | let c:FileExtReaderCallback => c.fileExtReaderReadComplete(this, true)
      end
      return
    end
    
    let done = _readNextChunk()
    match controller
    | let c:FileExtReaderCallback => c.fileExtReaderReadComplete(this, done)
    end
