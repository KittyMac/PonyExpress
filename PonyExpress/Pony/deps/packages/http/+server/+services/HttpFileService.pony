use "collections"
use "stringext"
use "fileext"

class HttpFileService is HttpClassService
  let webRoot:String
  let allowDotFiles:Bool

  new val default() =>
    webRoot = "./public_html/"
    allowDotFiles = false

  new val create(webRoot':String, allowDotFiles':Bool) =>
    webRoot = webRoot'
    allowDotFiles = allowDotFiles'
    

  fun process(connection:HttpServerConnection, url:String val, params:String val, content:Array[U8] val):HttpServiceResponse =>
    // 1. construct the path to the local file
    var fileURL = String(1024)
    fileURL.append(webRoot)
    fileURL.append(url)
    if StringExt.endswith(fileURL, "/") then
      fileURL.append("index.html")
    end
    
    // 2. Disallow going up directories (replace all .. with blanks)
    fileURL.replace("..", "", USize.max_value())
    
    // 3. Don't allow downloading of hidden files or directories?
    if (allowDotFiles == false) and fileURL.contains("/.") then
      HttpServiceResponse(404, "text/html; charset=UTF-8", "")
    end
    
    // 3. determine the content-type from the extension
    let extension = StringExt.pathExtension(fileURL)
    let contentType = HttpServiceUtility.httpContentTypeForExtension(extension)
    
    // 4. load file contents
    let fd = FileExt.open(fileURL, FileExt.pRead())
          
    // 5. return results
    if fd > 0 then
      HttpServiceResponse(200, contentType, fd)
    else
      HttpServiceResponse(404, "text/html; charset=UTF-8", "")
    end