use "collections"
use "fileext"

use @strncmp[I32](s1:Pointer[U8] tag, s2:Pointer[U8] tag, size:USize)
use @pony_os_errno[I32]()

primitive HttpServerConnectionState
  fun header():U32 => 0
  fun content():U32 => 1
  fun finished():U32 => 2

actor HttpServerConnection
  """
  Handles a single HTTP server connection.  Read buffer has a single max size to it, if we read more than that we
  close the connection.
  """
  let server:HttpServer
  
  var event:AsioEventID = AsioEvent.none()
  var socket:U32 = 0
  
  var state:U32 = HttpServerConnectionState.header()
  
  var serviceMap:HttpServiceMap val
  
  let maxReadBufferSize:USize = 4 * 1024 * 1024
  var readBuffer:Array[U8]
  var scanOffset:USize = 0
  var scanContentLength:USize = 0
  
  var prevScanCharA:U8 = 0
  var prevScanCharB:U8 = 0
  
  var httpCommand:U32 = HTTPCommand.none()
  var httpCommandUrl:String trn
  var httpCommandParameters:String trn
  var httpContentLength:String trn
  var httpContentType:String trn
  var httpContent:Array[U8] trn
  
  let maxHttpResponse:USize = 5 * 1024 * 1024
  let httpResponse:Array[U8] ref
  var httpResponseWriteOffset:USize = 0
  
  var httpRequestTimeoutPeriodInNanoseconds:U64 = 10_000_000_000
  var nanosecondsLastActivity:U64 = 0
  
  var fileReadFD:I32
  var fileReadBuffer:Array[U8]
  
  var response_count:U64 = 0
  
  fun _tag():USize => 2
  fun _batch():USize => 5_000
  fun _priority():USize => 1
  
  new create(server':HttpServer, httpRequestTimeoutPeriodInMilliseconds:U64) =>
    server = server'
    httpRequestTimeoutPeriodInNanoseconds = httpRequestTimeoutPeriodInMilliseconds * 1_000_000
    
    serviceMap = recover HttpServiceMap(0) end
    readBuffer = Array[U8](maxReadBufferSize)
    fileReadBuffer = Array[U8](maxReadBufferSize)
    fileReadFD = 0
    
    httpCommandUrl = recover trn String(1024) end
    httpCommandParameters = recover trn String(1024) end
    httpContentLength = recover trn String(1024) end
    httpContentType = recover trn String(1024) end
    httpContent = recover trn Array[U8](maxReadBufferSize) end
    httpResponse = Array[U8](maxHttpResponse)
    
    markTimeoutActivity()
    
  be process(socket':U32, serviceMap':HttpServiceMap val) =>
    socket = socket'
    serviceMap = serviceMap'
    
    //@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "connection open %d\n".cstring(), socket)
    
    scanOffset = 0
    scanContentLength = 0
    readBuffer.clear()
    
    httpCommand = HTTPCommand.none()
    httpCommandUrl.clear()
    httpCommandParameters.clear()
    httpContentLength.clear()
    httpContentType.clear()
    httpContent.clear()
    httpResponse.clear()
    
    event = @pony_asio_event_create(this, socket, AsioEvent.read_write_oneshot(), 0, true)
    @pony_asio_event_set_writeable(event, true)
  
  fun ref markTimeoutActivity() =>
    nanosecondsLastActivity = @ponyint_cpu_tick[U64]()
  
  be heartbeat() =>
    // check to see if this connection should timeout
    let now = @ponyint_cpu_tick[U64]()
    if (now - nanosecondsLastActivity) > httpRequestTimeoutPeriodInNanoseconds then
      timeout()
    end
  
  fun ref handleResponseWrites() =>
    try
      while (httpResponseWriteOffset < httpResponse.size()) or readNextChunkOfResponseContent() do
        let n = @pony_os_send[USize](event, httpResponse.cpointer(httpResponseWriteOffset), httpResponse.size() - httpResponseWriteOffset)?
        if n == 0 then
          @pony_asio_event_set_writeable(event, false)
          @pony_asio_event_resubscribe_write(event)
          return
        end
        httpResponseWriteOffset = httpResponseWriteOffset + n
      end
      
      response_count = response_count + 1
      resetWriteForNextResponse()
    else
      httpResponseWriteOffset = 0
      httpResponse.clear()
    end
  
  fun ref readNextChunkOfResponseContent():Bool =>
    if fileReadFD <= 0 then
      return false
    end
    
    if httpResponseWriteOffset >= httpResponse.size() then
      httpResponse.clear()
      httpResponseWriteOffset = 0
    end
    
    let n = FileExt.read(fileReadFD, fileReadBuffer.cpointer(), maxReadBufferSize)
    if n <= 0 then
      FileExt.close(fileReadFD)
      fileReadFD = 0
      return false
    end
    
    fileReadBuffer.undefined(n.usize())
    httpResponse.append(fileReadBuffer)
    fileReadBuffer.clear()
    
    true
    
  
  fun ref consumeFieldArray(fieldVal:Array[U8] val):(Array[U8] trn^, Array[U8] val) =>
    (recover trn Array[U8] end, fieldVal)
  
  fun ref consumeFieldString(fieldVal:String val):(String trn^, String val) =>
    (recover trn String end, fieldVal)

  
  be respond(response:HttpServiceResponse val) =>
    respondNow(response)
  
  fun ref respondNow(response:HttpServiceResponse val) =>
    if response.statusCode == 0 then
      // special code means this is a delayed response and someone will call respond()
      // in the future with the full response.
      return
    end
    
    var responseContent = response.content
    if response.statusCode != 200 then
      responseContent = HttpServiceUtility.httpStatusHtmlString(response.statusCode)
    end
    
    httpResponse.clear()
    httpResponse.append(HttpServiceUtility.httpStatusString(response.statusCode))
    httpResponse.push('\r')
    httpResponse.push('\n')
    httpResponse.append("Content-Type: ")
    httpResponse.append(response.contentType)
    httpResponse.push('\r')
    httpResponse.push('\n')
    httpResponse.append("Content-Length: ")

    match responseContent
    | let fd:I32 val =>
      httpResponse.append(FileExt.size(fd).string())
    | let string:String val =>
      httpResponse.append(string.size().string())
    | let array:Array[U8] val =>
      httpResponse.append(array.size().string())
    end

    httpResponse.push('\r')
    httpResponse.push('\n')
    httpResponse.push('\r')
    httpResponse.push('\n')

    match responseContent
    | let fd:I32 val =>
      fileReadFD = fd
      readNextChunkOfResponseContent()
    | let string:String val =>
      httpResponse.append(string)
    | let array:Array[U8] val =>
      httpResponse.append(array)
    end

    handleResponseWrites()
  
  be _event_notify(event': AsioEventID, flags: U32, arg: U32) =>
    if AsioEvent.disposable(flags) then
      @pony_asio_event_destroy(event')
      return
    end
  
    if event is event' then
      markTimeoutActivity()
      
      // perform our writes?
      if AsioEvent.writeable(flags) then
        handleResponseWrites()
      end
    
      if AsioEvent.readable(flags) then
        if read() then
                    
          (httpCommandUrl, let httpCommandUrlVal) = consumeFieldString(consume httpCommandUrl)
          (httpCommandParameters, let httpCommandParametersVal) = consumeFieldString(consume httpCommandParameters)
          (httpContent, let httpContentVal) = consumeFieldArray(consume httpContent)
          
          // First we check class services (they're more performant), then check actor services, then fallback to null service
          try
            match serviceMap.typeOfService(httpCommandUrlVal)
            | 0 => respondNow(NullService.process(this, httpCommandUrlVal, httpCommandParametersVal, httpContentVal))
            | 1 => respondNow(serviceMap.getClassService(httpCommandUrlVal)?.process(this, httpCommandUrlVal, httpCommandParametersVal, httpContentVal))
            | 2 => serviceMap.getActorService(httpCommandUrlVal)?.process(this, httpCommandUrlVal, httpCommandParametersVal, httpContentVal)
            end
          else
            @fprintf[I32](@pony_os_stdout[Pointer[U8]](), ("Error while mapping service for " + httpCommandUrlVal).cstring())
          end
                
        end
        
        // If we get here and we're still active, we need to reschedule ourselves for more data
        if event != AsioEvent.none() then
          @pony_asio_event_set_readable[None](event, false)
          @pony_asio_event_resubscribe_read(event)
        end
      end
    end
    
    // if we have an open connection, we want to remain scheduled until we're not so we can respond quickly
    if event != AsioEvent.none() then
      @ponyint_actor_yield[None](this)
    end
  
  fun ref matchScan(string:String):Bool =>
    (@strncmp(readBuffer.cpointer((scanOffset-string.size())+1), string.cstring(), string.size()) == 0)
  
  fun ref scanURL(offset:USize, string:String trn):String trn^ =>
    var spaceCount:USize = 0
    string.clear()
    for c in readBuffer.valuesAfter(offset) do
      if (c == '?') then
        return consume string
      end
      if (c == ' ') or (c == '\n') or (c == '\r') then
        spaceCount = spaceCount + 1
        if spaceCount == 2 then
          return consume string
        end
        continue
      end
      if (spaceCount == 1) then
        string.push(c)
      end
    end
    consume string
  
  fun ref scanParameters(offset:USize, string:String trn):String trn^ =>
    var spaceCount:USize = 0
    var questionCount:USize = 0
    string.clear()
    for c in readBuffer.valuesAfter(offset) do
      if (c == ' ') or (c == '\n') or (c == '\r') then
        spaceCount = spaceCount + 1
        if spaceCount == 2 then
          return consume string
        end
        continue
      end
      if ((questionCount == 1) and (spaceCount == 1)) then
        string.push(c)
      end
      if c == '?' then
        questionCount = questionCount + 1
      end
    end
    consume string

  fun ref scanHeader(offset:USize, string:String trn):String trn^ =>
    var separatorCount:USize = 0
    string.clear()
    for c in readBuffer.valuesAfter(offset) do
      if (separatorCount == 0) then
        if c == ':' then
          separatorCount = 1
        end
        continue
      end
      if (separatorCount == 1) then
        if (c == '\n') or (c == '\r') then
          return consume string
        end
      end
      if (c != ' ') and (separatorCount == 1) then
        string.push(c)
      end
    end
    consume string
  
  
  fun ref resetWriteForNextResponse() =>
    httpResponseWriteOffset = 0
    httpCommand = HTTPCommand.none()
    httpCommandUrl.clear()
    httpContentLength.clear()
    httpContentType.clear()
    httpContent.clear()
    
    httpResponse.clear()
  
  fun ref resetReadForNextRequest() =>
    // we can't just clear the buffer, there might be more request right after this one...
    scanOffset = 0
    readBuffer.clear()
    scanContentLength = 0
    state = HttpRequestState.header()
    
  
  fun ref read():Bool =>
    try
      while true do
      
        match state
        | HttpServerConnectionState.header() =>
          // Process the HTTP header as it arrives.  We're looking for several key this:
          // POST/PUT/GET/DELETE requests and the URL associated with them
          // Content-Length field, so we know how many bytes to read after then end of the header
          // 2x CRLF to signify the end of the HTTP header
          //
          // Example:
          //   POST /test.html HTTP/1.1
          //   Host: 127.0.0.1:8080
          //   User-Agent: curl/7.54.0
          //   Accept: */*
          //   Content-Type: application/json
          //   Content-Length: 26
          //   
          //   {"id":9,"name":"baeldung"}
          
          let len = @pony_os_recv[USize](event, readBuffer.cpointer(readBuffer.size()), maxReadBufferSize - readBuffer.size())?
          if len == 0 then
            return false
          end
          readBuffer.undefined(readBuffer.size() + len)
          
          for c in readBuffer.valuesAfter(scanOffset) do
            //@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "%c".cstring(), c)
            if state == HttpRequestState.content() then
              httpContent.push(c)
              continue
            end

            if  (prevScanCharA == 'O') and (prevScanCharB == 'S') and (c == 'T') and matchScan("POST") then
              httpCommand = HTTPCommand.post()
              httpCommandUrl = scanURL(scanOffset-3, consume httpCommandUrl)
              httpCommandParameters = scanParameters(scanOffset-3, consume httpCommandParameters)
            elseif (prevScanCharA == 'U') and (prevScanCharB == 'T') and (c == ' ') and matchScan("PUT ") then
              httpCommand = HTTPCommand.put()
              httpCommandUrl = scanURL(scanOffset-3, consume httpCommandUrl)
              httpCommandParameters = scanParameters(scanOffset-3, consume httpCommandParameters)
            elseif (prevScanCharA == 'E') and (prevScanCharB == 'T') and (c == ' ') and matchScan("GET ") then
              httpCommand = HTTPCommand.get()
              httpCommandUrl = scanURL(scanOffset-3, consume httpCommandUrl)
              httpCommandParameters = scanParameters(scanOffset-3, consume httpCommandParameters)
            elseif (prevScanCharA == 'E') and (prevScanCharB == 'T') and (c == 'E') and matchScan("DELETE") then
              httpCommand = HTTPCommand.delete()
              httpCommandUrl = scanURL(scanOffset-5, consume httpCommandUrl)
              httpCommandParameters = scanParameters(scanOffset-5, consume httpCommandParameters)
            elseif (prevScanCharA == 't') and (prevScanCharB == 'h') and (c == ':') and matchScan("Content-Length:") then
              httpContentLength = scanHeader(scanOffset-5, consume httpContentLength)
              try scanContentLength = httpContentLength.usize()? end
              httpContent.reserve(scanContentLength)
            elseif (prevScanCharA == 'p') and (prevScanCharB == 'e') and (c == ':') and matchScan("Content-Type:") then
              httpContentType = scanHeader(scanOffset-5, consume httpContentType)
            elseif (prevScanCharA == '\n') and (prevScanCharB == '\r') and (c == '\n') then
              if scanContentLength == 0 then
                resetReadForNextRequest()
                return true
              end
              state = HttpRequestState.content()
              
              continue
            end
          
            prevScanCharA = prevScanCharB
            prevScanCharB = c
        
            scanOffset = scanOffset + 1
          end
          
          if httpContent.size() >= scanContentLength then
            resetReadForNextRequest()
            return true
          end
        
        
        | HttpServerConnectionState.content() =>
          let len = @pony_os_recv[USize](event, httpContent.cpointer(httpContent.size()), scanContentLength - httpContent.size())?
          if len == 0 then
            return false
          end
          httpContent.undefined(httpContent.size() + len)
          
          if httpContent.size() >= scanContentLength then
            resetReadForNextRequest()
            return true
          end
        end
                
      end
    else
      closeNow()
    end
    
    false
  
  fun ref writeError(status:U32) =>
    httpResponse.clear()
    httpResponse.append(HttpServiceUtility.httpStatusString(status))
    httpResponse.push('\r')
    httpResponse.push('\n')
    httpResponse.append("Connection: close")
    httpResponse.push('\r')
    httpResponse.push('\n')
    httpResponse.push('\r')
    httpResponse.push('\n')
    
    handleResponseWrites()
  
  fun ref timeout() =>
    writeError(408)
    close()
  
  be close() =>
    writeError(500)
    closeNow()
  
  fun ref closeNow() =>
    if event != AsioEvent.none() then
      @pony_asio_event_unsubscribe(event)
      //@pony_asio_event_destroy(event)
      event = AsioEvent.none()
      
      @printf[I32]("response_count: %llu\n".cstring(), response_count)
    
      @pony_os_socket_close[None](socket)     
      socket = 0
    
      server.connectionFinished(this)
    end
