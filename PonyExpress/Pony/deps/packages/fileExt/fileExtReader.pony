use "files"

actor FileExtReader
  """
  FileExtReader is an actor which provides quick and simple functionality for reading files
  """
  
  fun _tag():USize => 112
  
  be readAsString (env:Env, filePath:String, completionVal: {(String iso, FileExtError val)} val) =>
    try
      completionVal(recover iso FileExt.fileToString(filePath)? end, None)
    else
      completionVal(recover iso String end, "Failed to read file " + filePath)
    end

  be readAsArray (env:Env, filePath:String, completionVal: {(Array[U8] iso, FileExtError val)} val) =>
    try
      completionVal(recover iso FileExt.fileToArray(filePath)? end, None)
    else
      completionVal(recover iso Array[U8] end, "Failed to read file " + filePath)
    end
  