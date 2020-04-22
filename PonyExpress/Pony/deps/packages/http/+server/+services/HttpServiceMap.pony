use "collections"

class HttpServiceMap
  let n:USize
  let classServices:Map[String val,HttpClassService val]
  let actorServices:Map[String val,HttpActorService tag]
  var wildcardClassService:(HttpClassService val|None)
  var wildcardActorService:(HttpActorService tag|None)
  
  new create(n':USize) =>
    n = n'
    classServices = Map[String,HttpClassService val](n)
    actorServices = Map[String,HttpActorService tag](n)
    wildcardClassService = None
    wildcardActorService = None
  
  fun ref registerClassService(url:String val, service:HttpClassService val) =>
    if url == "*" then
      wildcardClassService = service
    else
      classServices(url) = service
    end
  
  fun ref registerActorService(url:String val, service:HttpActorService tag) =>
    if url == "*" then
      wildcardActorService = service
    else
      actorServices(url) = service
    end
  
  fun getClassService(url:String val):HttpClassService val? =>
    if classServices.contains(url) then
      return classServices(url)?
    end
    match wildcardClassService
    | None => error
    | let s:HttpClassService val => s
    end
  
  fun getActorService(url:String val):HttpActorService tag? =>
    if actorServices.contains(url) then
      return actorServices(url)?
    end
    match wildcardActorService
    | None => error
    | let s:HttpActorService tag => s
    end
  
  fun typeOfService(url:String val):U32 =>
    if classServices.contains(url) then return 1 end
    if actorServices.contains(url) then return 2 end
    match wildcardClassService
    | let _:HttpClassService val => return 1
    end
    match wildcardActorService
    | let _:HttpActorService tag => return 2
    end
    0
  
  fun ref clone():HttpServiceMap val =>
    let other:HttpServiceMap trn = recover trn HttpServiceMap(n) end
    
    // Copy over all of the existing services
    for (k, v) in classServices.pairs() do
      other.registerClassService(k, v)
    end
    for (k, v) in actorServices.pairs() do
      other.registerActorService(k, v)
    end
    other.wildcardClassService = wildcardClassService
    other.wildcardActorService = wildcardActorService
        
    consume other