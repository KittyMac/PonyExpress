use "files"
use "flow"

actor FileExtFlowWriterEnd is Flowable
  
  var fd:I32
  
  fun _tag():USize => 110

  new create (filePath:String) =>
    fd = FileExt.open(filePath)
  
  be flowFinished() =>
    FileExt.close(fd)
    
  be flowReceived(dataIso:Any iso) =>
    let data:Any ref = consume dataIso
    try
      let block = data as CPointer
      FileExt.write(fd, block.cpointer(0), block.size())
    else
      @fprintf[I32](@pony_os_stderr[Pointer[U8]](), "FileExtFlowWriterEnd requires a CPointer flowable\n".cstring())
    end


actor FileExtFlowWriter is Flowable

  var fd:I32
  let target:Flowable tag
  
  fun _tag():USize => 111

  new create (filePath:String, target':Flowable tag) =>
    target = target'
    fd = FileExt.open(filePath)

  be flowFinished() =>
    FileExt.close(fd)
    target.flowFinished()
  
  be flowReceived(dataIso:Any iso) =>
    try
      FileExt.write(fd, (dataIso as CPointer iso).cpointer(0), (dataIso as CPointer iso).size())
      target.flowReceived(consume dataIso)
    else
      @fprintf[I32](@pony_os_stderr[Pointer[U8]](), "FileExtFlowWriter requires a CPointer flowable\n".cstring())
    end