use "collections"
use "stringext"
use "net"
use "regex"

actor HttpClient
  """
  Makes connection to server, handles sending and receiving HTTP 1.1 requests.
  """
  
  var httpHost:String = ""
  
  var event:AsioEventID = AsioEvent.none()
  var socket:U32 = 0
  
  var pendingRequestWrites:Array[HttpRequest]
  var pendingRequestReads:Array[HttpRequest]
  
  fun _tag():USize => 11
  
  new create() =>
    pendingRequestWrites = Array[HttpRequest](128)
    pendingRequestReads = Array[HttpRequest](128)
  
  new connect(host:String, port:String, from: String = "")? =>
    pendingRequestWrites = Array[HttpRequest](128)
    pendingRequestReads = Array[HttpRequest](128)
    
    _connect(host, port, from)
    
    if false then error end
  
  new download(url:String, callback:HttpRequestCallback val)? =>
    // a "one shot" method to download the content of a url
    pendingRequestWrites = Array[HttpRequest](128)
    pendingRequestReads = Array[HttpRequest](128)
        
    // 1. parse the relevant information from the url
    let userAgentRegex = try Regex("^((http[s]?|ftp):\\/)?\\/?([^:\\/\\s]+)((\\/\\w+)*\\/)([\\w\\-\\.]+[^#?\\s]+)(.*)?(#[\\w\\-]+)?$")? else Regex.empty() end
    let matched = userAgentRegex(url)?
    
    let protocol:String val = matched(2)?
    let host:String val = matched(3)?
    let path:String val = matched(4)?
    let file:String val = matched(6)?
    //let query:String val = try matched(7)? else "" end
    //let hash:String val = try matched(8)? else "" end
    
    let port = match protocol
    | "http" => "80"
    | "https" => "443"
    else error end
    
    //@printf[I32]("%s | %s | %s | %s | %s | %s\n".cstring(), protocol.cstring(), host.cstring(), path.cstring(), file.cstring(), query.cstring(), hash.cstring())
    
    // 2. connect to the host
    _connect(host, port, "")?
    
    // 3. request the desired information
    httpGet(path + file, callback)
    
  
  be _connect(host:String, port:String, from: String = "") =>
    let addresses:Array[NetAddress] val = DNS(None, host, port)
    var hostString = host
    var portString = port
    for address in addresses.values() do
      try
        (hostString, portString) = address.name(None)?
        break
      end
    end
  
    httpHost = StringExt.format("Host: %s\r\n", host)
  
    @pony_os_connect_tcp4[U32](this, hostString.cstring(), portString.cstring(), from.cstring(), AsioEvent.read_write_oneshot())  
  
  fun _is_sock_connected(fd: U32): Bool =>
    (let errno: U32, let value: U32) = OSSocket.get_so_error(fd)
    (errno == 0) and (value == 0)
  
  be _event_notify(event': AsioEventID, flags: U32, arg: U32) =>
    if AsioEvent.disposable(flags) then
      @pony_asio_event_destroy(event')
      return
    end
    
    // if we receive an event and its writable, this is the clue we need that
    // the tcp connection has completed successfully
    if event isnt event' then
      if AsioEvent.writeable(flags) and (socket == 0) then
        event = event'
        socket = @pony_asio_event_fd(event)
        if _is_sock_connected(socket) then
          //@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "socket connected on fd %d\n".cstring(), socket)
          @pony_asio_event_set_writeable(event, false)
          @pony_asio_event_resubscribe_write(event)
        else
          close()
        end
      end
    else
      if AsioEvent.writeable(flags) then
        try
          let request = pendingRequestWrites(0)?
          if request.write(event) then
            pendingRequestWrites.shift()?
            pendingRequestReads.push(request)
            
            @pony_asio_event_set_readable[None](event, false)
            @pony_asio_event_resubscribe_read(event)
          end
        end
      end
      
      if AsioEvent.readable(flags) then
        try
          let request = pendingRequestReads(0)?
          if request.read(event) then
            pendingRequestReads.shift()?
            
            @pony_asio_event_set_writeable(event, false)
            @pony_asio_event_resubscribe_write(event)
          end
        end
      end
      
      if event != AsioEvent.none() then
        @ponyint_actor_yield[None](this)
      end
    end
  
    
  be httpGet(urlPath:String, callback:HttpRequestCallback val) =>
    let request = HttpRequest(StringExt.format("GET %s HTTP/1.1\r\n%sUser-Agent: Pony/0.1\r\n\r\n", urlPath, httpHost), callback)
    pendingRequestWrites.push(request)
  
  be httpPost(urlPath:String, content:String, callback:HttpRequestCallback val) =>
    let postString = StringExt.format("POST %s HTTP/1.1\r\n%sUser-Agent: Pony/0.1\r\nContent-Type: application/json\r\nContent-Length: %s\r\n\r\n%s", urlPath, httpHost, content.size(), content)
    let request = HttpRequest(postString, callback)
    pendingRequestWrites.push(request)
  
  be httpPut(urlPath:String, content:String, callback:HttpRequestCallback val) =>
    let request = HttpRequest(StringExt.format("PUT %s HTTP/1.1\r\n%sUser-Agent: Pony/0.1\r\n\r\n%s", urlPath, httpHost, content), callback)
    pendingRequestWrites.push(request)
    
  fun ref close() =>
    if event != AsioEvent.none() then
          @pony_asio_event_unsubscribe(event)
      //@pony_asio_event_destroy(event)
      event = AsioEvent.none()
  
      @pony_os_socket_close[None](socket)     
      socket = 0
    end
    