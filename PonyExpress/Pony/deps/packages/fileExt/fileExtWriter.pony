use "files"
use "collections"

actor FileExtWriter

  fun _tag():USize => 113
  
  be writeString (filePath:String, fileContents:String, completionVal: {(FileExtError val)} val) =>
    try
      FileExt.stringToFile(fileContents, filePath)?
      completionVal(None)
    else
      completionVal("Failed to write file " + filePath)
    end
  
  be writeArray (filePath:String, fileContents:Array[U8] val, completionVal: {(FileExtError val)} val) =>
    try
      FileExt.arrayToFile(fileContents, filePath)?
      completionVal(None)
    else
      completionVal("Failed to write file " + filePath)
    end
  