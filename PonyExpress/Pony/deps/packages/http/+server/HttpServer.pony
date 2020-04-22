use "collections"
use "ttimer"

use @pony_asio_event_create[AsioEventID](owner: AsioEventNotify, fd: U32, flags: U32, nsec: U64, noisy: Bool)
use @pony_asio_event_fd[U32](event: AsioEventID)
use @pony_asio_event_unsubscribe[None](event: AsioEventID)
use @pony_asio_event_resubscribe_read[None](event: AsioEventID)
use @pony_asio_event_resubscribe_write[None](event: AsioEventID)
use @pony_asio_event_destroy[None](event: AsioEventID)
use @pony_asio_event_get_disposable[Bool](event: AsioEventID)
use @pony_asio_event_set_writeable[None](event: AsioEventID, writeable: Bool)
use @pony_asio_event_set_readable[None](event: AsioEventID, readable: Bool)
use @ponyint_actor_num_messages[USize](anyActor:Any tag)

actor HttpServer is TTimerNotify
  """
  Listens for initial connections, then passes the connection on to a pool of HttpServerConnections
  """
  var event:AsioEventID = AsioEvent.none()
  var closed:Bool = true
  var socket: U32 = 0
  
  var freeConnectionPool:Array[HttpServerConnection]
  var activeConnectionPool:Array[HttpServerConnection]
  var totalConnections:USize = 0
  
  var httpServices:HttpServiceMap
  
  var httpRequestTimeoutPeriod:U64 = 10_000
  
  var heartbeatTimer:TTimer
  let heartbeatTimerPeriod:U64 = 5_000
  
  fun _tag():USize => 1
  fun _batch():USize => 5_000
  fun _priority():USize => -1
  
  new empty() =>
    freeConnectionPool = Array[HttpServerConnection]()
    activeConnectionPool = Array[HttpServerConnection]()
    httpServices = HttpServiceMap(0)
    heartbeatTimer = TTimer(heartbeatTimerPeriod, this, false)
    heartbeatTimer.cancel()
  
  new create() =>
    freeConnectionPool = Array[HttpServerConnection]()
    activeConnectionPool = Array[HttpServerConnection]()
    httpServices = HttpServiceMap(32)
    heartbeatTimer = TTimer(heartbeatTimerPeriod, this, false)
  
  new listen(host:String, port:String)? =>
    freeConnectionPool = Array[HttpServerConnection](2048)
    activeConnectionPool = Array[HttpServerConnection](2048)
    httpServices = HttpServiceMap(32)
    heartbeatTimer = TTimer(heartbeatTimerPeriod, this, false)
    
    event = @pony_os_listen_tcp4[AsioEventID](this, host.cstring(), port.cstring())
    socket = @pony_asio_event_fd(event)

    if socket < 0 then
      @pony_asio_event_unsubscribe(event)
      //@pony_asio_event_destroy(event)
      event = AsioEvent.none()
      error
    end
    
    closed = false
  
  be close() =>
    if closed then
      return
    end

    closed = true
    
    heartbeatTimer.cancel()
    
    for connection in activeConnectionPool.values() do
      connection.close()
    end
    for connection in freeConnectionPool.values() do
      connection.close()
    end
    activeConnectionPool.clear()
    freeConnectionPool.clear()

    if not event.is_null() then
      @pony_asio_event_unsubscribe(event)
      //@pony_asio_event_destroy(event)
      @pony_os_socket_close[None](socket)
      event = AsioEvent.none()
      socket = -1
    end
  
  be _event_notify(event': AsioEventID, flags: U32, arg: U32) =>
    //@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "server event %d == %d\n".cstring(), event', event)
    if AsioEvent.disposable(flags) then
      @pony_asio_event_destroy(event')
      return
    end
    
    if event is event' then
      if AsioEvent.readable(flags) then
        
        // accept new connections and hand them to free (or new) connection processors
        while true do
          var connectionSocket = @pony_os_accept[U32](event)
          if connectionSocket == -1 then
            continue
          elseif connectionSocket == 0 then
            return
          end
      
          if freeConnectionPool.is_empty() then
            let connection = HttpServerConnection(this, httpRequestTimeoutPeriod)
            connection.process(connectionSocket, httpServices.clone())
            activeConnectionPool.push(connection)
          else
            try 
              let connection = freeConnectionPool.pop()?
              connection.process(connectionSocket, httpServices.clone())
              activeConnectionPool.push(connection)
            end
          end
        end
        
      end
    end

  be timerNotify(timer:TTimer tag) =>
    for connection in activeConnectionPool.values() do
      if @ponyint_actor_num_messages[USize](connection) <= 2 then
        connection.heartbeat()
      end
    end
  
  be registerClassService(url:String val, service:HttpClassService val) =>
    httpServices.registerClassService(url, service)
  
  be registerActorService(url:String val, service:HttpActorService tag) =>
    httpServices.registerActorService(url, service)
    
    
  be connectionFinished(connection:HttpServerConnection) =>
    freeConnectionPool.push(connection)
    activeConnectionPool.deleteOne(connection)
