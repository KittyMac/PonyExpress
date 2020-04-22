use "collections"

// an array, a string, to a file descriptor
type HttpContentResponse is (String|Array[U8]|I32)

class val HttpServiceResponse
  let statusCode:U32
  let contentType:String
  let content:HttpContentResponse val
  
  new val delayed() =>
    statusCode = 0
    contentType = ""
    content = 0
  
  new val create(statusCode':U32 val, contentType':String val, content':HttpContentResponse val) =>
    statusCode = statusCode'
    contentType = contentType'
    content = content'

type HttpService is ( HttpClassService val | HttpActorService tag )

trait HttpClassService
  """
  A service receives the parsed content of an HttpServerConnection, processes it, and returns the
  payload to be connection by calling the respond() behaviour.
  """
  fun process(connection:HttpServerConnection, url:String val, params:String val, content:Array[U8] val):HttpServiceResponse =>
    HttpServiceResponse(500, "text/html", "Service Unavailable")

trait HttpActorService
  """
  A service receives the parsed content of an HttpServerConnection, processes it, and returns the
  payload to be connection by calling the respond() behaviour
  """
  be process(connection:HttpServerConnection, url:String val, params:String val, content:Array[U8] val) =>
    connection.respond(HttpServiceResponse(500, "text/html", "Service Unavailable"))
    
  

primitive NullService is HttpClassService

primitive HttpServiceUtility
  fun httpStatusString(code:U32):String =>
    match code
    | 200 => "HTTP/1.1 200 OK"
    | 400 => "HTTP/1.1 400 Bad Request"
    | 404 => "HTTP/1.1 404 Not Found"
    | 408 => "HTTP/1.1 408 Request Timeout"
    | 413 => "HTTP/1.1 413 Request Too Large"
    else "HTTP/1.1 500 Internal Server Error" end

  fun httpStatusHtmlString(code:U32):String =>
    match code
    | 404 => "<HTML><HEAD><TITLE>Not Found</TITLE></HEAD><BODY><H2>404 Not Found</H2>The requested file could not be found.<P></BODY></HTML>"
    else "<HTML><HEAD><TITLE>Internal Server Error</TITLE></HEAD><BODY><H2>500 Internal Server Error</H2>An error occurred while attempting to process your request.<P></BODY></HTML>" end

  fun httpContentTypeForExtension(extension:String):String =>
    match extension
    | ".arc" => "application/x-freearc"
    | ".avi" => "video/x-msvideo"
    | ".azw" => "application/vnd.amazon.ebook"
    | ".bin" => "application/octet-stream"
    | ".bmp" => "image/bmp"
    | ".bz" =>  "application/x-bzip"
    | ".bz2" => "application/x-bzip2"
    | ".csh" => "application/x-csh"
    | ".css" => "text/css"
    | ".csv" => "text/csv"
    | ".doc" => "application/msword"
    | ".docx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    | ".eot" => "application/vnd.ms-fontobject"
    | ".epub" => "application/epub+zip"
    | ".gz" =>  "application/gzip"
    | ".gif" => "image/gif"
    | ".htm" => "text/html"
    | ".html" => "text/html"
    | ".ico" => "image/vnd.microsoft.icon"
    | ".ics" => "text/calendar"
    | ".jar" => "application/java-archive"
    | ".jpeg" => "image/jpeg"
    | ".jpg" => "image/jpeg"
    | ".js" => "text/javascript"
    | ".json" => "application/json"
    | ".jsonld" => "application/ld+json"
    | ".mid" => "audio/midi"
    | ".midi" => "audio/midi"
    | ".mjs" => "text/javascript"
    | ".mp3" => "audio/mpeg"
    | ".mpeg" => "video/mpeg"
    | ".mpkg" => "application/vnd.apple.installer+xml"
    | ".odp" => "application/vnd.oasis.opendocument.presentation"
    | ".ods" => "application/vnd.oasis.opendocument.spreadsheet"
    | ".odt" => "application/vnd.oasis.opendocument.text"
    | ".oga" => "audio/ogg"
    | ".ogv" => "video/ogg"
    | ".ogx" => "application/ogg"
    | ".opus" => "audio/opus"
    | ".otf" => "font/otf"
    | ".png" => "image/png"
    | ".pdf" => "application/pdf"
    | ".php" => "application/php"
    | ".ppt" => "application/vnd.ms-powerpoint"
    | ".pptx" => "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    | ".rar" => "application/x-rar-compressed"
    | ".rtf" => "application/rtf"
    | ".sh" => "application/x-sh"
    | ".svg" => "image/svg+xml"
    | ".swf" => "application/x-shockwave-flash"
    | ".tar" => "application/x-tar"
    | ".tif" => "image/tiff"
    | ".tiff" => "image/tiff"
    | ".ts" => "video/mp2t"
    | ".ttf" => "font/ttf"
    | ".txt" => "text/plain"
    | ".vsd" => "application/vnd.visio"
    | ".wav" => "audio/wav"
    | ".weba" => "audio/webm"
    | ".webm" => "video/webm"
    | ".webp" => "image/webp"
    | ".woff" => "font/woff"
    | ".woff2" => "font/woff2"
    | ".xhtml" => "application/xhtml+xml"
    | ".xls" => "application/vnd.ms-excel"
    | ".xlsx" => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    | ".xml" => "application/xml"
    | ".xul" => "application/vnd.mozilla.xul+xml"
    | ".zip" => "application/zip"
    | ".3gp" => "video/3gpp"
    | ".3g2" => "video/3gpp2"
    | ".7z" => "application/x-7z-compressed"
  else "application/octet-stream" end