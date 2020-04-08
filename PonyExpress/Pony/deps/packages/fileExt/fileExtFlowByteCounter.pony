use "files"
use "flow"

actor FileExtFlowByteCounter is Flowable
  
  var bytesRead:USize = 0
  var target:Flowable tag
  fun _tag():USize => 105
  
  new create(target':Flowable tag) =>
    target = target'
  
  be flowFinished() =>
    @fprintf[I32](@pony_os_stdout[Pointer[U8]](), "Flow closed, %d bytes were read\n".cstring(), bytesRead)
    target.flowFinished()

  be flowReceived(dataIso:Any iso) =>
    try
      bytesRead = bytesRead + (dataIso as CPointer iso).size()
    else
      @fprintf[I32](@pony_os_stderr[Pointer[U8]](), "FileExtFlowByteCounter requires a CPointer flowable\n".cstring())
    end
    target.flowReceived(consume dataIso)
  
    