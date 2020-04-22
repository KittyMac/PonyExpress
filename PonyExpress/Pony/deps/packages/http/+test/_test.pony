use "ponytest"
use "collections"
use "fileext"
use "stringext"

primitive HelloWorldService is HttpClassService
  fun process(connection:HttpServerConnection, url:String val, params:String val, content:Array[U8] val):HttpServiceResponse =>
    HttpServiceResponse(200, "text/plain", "Hello World")

class TestJsonAPI is HttpClassService
  // look up and return people by matching first name or last name
  let people:PersonResponse val
  
  new val create() =>
    people = try
        recover val PersonResponse.fromString(PersonDataJson())? end
      else
        recover val PersonResponse.empty() end
      end
    
  fun process(connection:HttpServerConnection, url:String val, params:String val, content:Array[U8] val):HttpServiceResponse =>
    try
      let request = PersonRequest.fromString(String.from_array(content))?
      let response = recover val 
          let response' = PersonResponse.empty()
          for person in people.values() do
            if (person.firstName == request.firstName) or (person.lastName == request.lastName) then
              response'.push(person.clone()?)
            end
          end
          response'
        end
      HttpServiceResponse(200, "application/json", response.string())
    else
      HttpServiceResponse(500, "text/html", "Service Unavailable")
    end

actor ActorJsonAPI is HttpActorService
  be process(connection:HttpServerConnection, url:String val, params:String val, content:Array[U8] val) =>
    connection.respond(HttpServiceResponse(200, "text/plain", "Hello World from an actor"))


actor Main is TestList
  var isCI:Bool = false
  
  new create(env: Env) => 
    for v in env.vars.values() do
      if StringExt.startswith(v, "CI=") then
        isCI = true
      end
    end
    PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    
    try
      let server = HttpServer.listen("0.0.0.0", "8080")?
      
      server.registerActorService("/api/actor", ActorJsonAPI)
      server.registerClassService("/api/person", TestJsonAPI)
      server.registerClassService("/hello/world", HelloWorldService)
      server.registerClassService("*", HttpFileService.default())
    end
    
    test(_Test1)
    test(_Test2)
    test(_Test3)
    test(_Test4)
    test(_Test5)
    test(_Test6)
    test(_Test7)
  
  be testsFinished(test: PonyTest, success:Bool) =>
    // is we're running on the CI, we want to end. Otherwise,
    // leave the server running
    if isCI then
      if success then
        @exit[None](I32(0))
      end
      @exit[None](I32(1))
    end
  
  fun @runtime_override_defaults(rto: RuntimeOptions) =>
    rto.ponyanalysis = 0
    rto.ponynoscale = true
    rto.ponynoblock = true
    //rto.ponynoyield = true
    rto.ponygcinitial = 0
    rto.ponygcfactor = 1.0


  
class iso _Test1 is UnitTest
  fun name(): String => "test 1 - request and compare index.html"

  fun apply(h: TestHelper) =>
    try
      h.long_test(30_000_000_000)
      
      let client = HttpClient.connect("127.0.0.1", "8080")?
      client.httpGet("/index.html", {(response:HttpResponseHeader val, content:Array[U8] val)(h) => 
        try
          if response.statusCode != 200 then
            error
          end
          h.complete(FileExt.fileToArray("./public_html/index.html")?.size() == content.size())
        else
          h.complete(false)
        end
      })
      
    else
      h.complete(false)
    end

class iso _Test2 is UnitTest
  fun name(): String => "test 2 - 404 error"

  fun apply(h: TestHelper) =>
    try
      h.long_test(30_000_000_000)
  
      let client = HttpClient.connect("127.0.0.1", "8080")?
      client.httpGet("/file_which_does_not_exist.html", {(response:HttpResponseHeader val, content:Array[U8] val)(h) => 
        h.complete((response.statusCode == 404) and (response.contentLength == 126))
      })
  
    else
      h.complete(false)
    end

class iso _Test3 is UnitTest
  fun name(): String => "test 3 - large file download"

  fun apply(h: TestHelper) =>
    try
      h.long_test(30_000_000_000)

      let client = HttpClient.connect("127.0.0.1", "8080")?
      client.httpGet("/big2.lz", {(response:HttpResponseHeader val, content:Array[U8] val)(h) => 
        try
          if response.statusCode != 200 then
            error
          end
          h.complete(FileExt.fileToArray("./public_html/big2.lz")?.size() == content.size())
        else
          @fprintf[I32](@pony_os_stdout[Pointer[U8]](), "%s\n".cstring(), __error_loc)
          h.complete(false)
        end
      })

    else
      @fprintf[I32](@pony_os_stdout[Pointer[U8]](), "%s\n".cstring(), __error_loc)
      h.complete(false)
    end

class iso _Test4 is UnitTest
  fun name(): String => "test 4 - json api request/response"

  fun apply(h: TestHelper) =>
    try
      h.long_test(30_000_000_000)

      let client = HttpClient.connect("127.0.0.1", "8080")?
      
      let request = PersonRequest.empty()
      request.firstName = "Jane"
      
      client.httpPost("/api/person", request.string(), {(response:HttpResponseHeader val, content:Array[U8] val)(h) => 
        try
          let persons = PersonResponse.fromString(String.from_array(content))?
          let person = persons(0)?
          h.complete( (person.firstName == "Jane") and (person.age == 27) and (persons.size() == 1) )
        else
          h.complete(false)
        end
      })
      
      request.firstName = "John"
      client.httpPost("/api/person", request.string(), {(response:HttpResponseHeader val, content:Array[U8] val)(h) => 
        try
          let persons = PersonResponse.fromString(String.from_array(content))?
          let person = persons(0)?
          h.complete( (person.firstName == "John") and (person.age == 24) and (persons.size() == 1) )
        else
          h.complete(false)
        end
      })

    else
      h.complete(false)
    end

class iso _Test5 is UnitTest
  fun name(): String => "test 5 - www.chimerasw.com"

  fun apply(h: TestHelper) =>
    try
      h.long_test(30_000_000_000)

      let client = HttpClient.connect("www.chimerasw.com", "80")?
      client.httpGet("/index.html", {(response:HttpResponseHeader val, content:Array[U8] val)(h) => 
        h.complete(response.statusCode == 200)
      })

    else
      h.complete(false)
    end

class iso _Test6 is UnitTest
  fun name(): String => "test 2 - actor service"

  fun apply(h: TestHelper) =>
    try
      h.long_test(30_000_000_000)

      let client = HttpClient.connect("127.0.0.1", "8080")?
      client.httpGet("/api/actor", {(response:HttpResponseHeader val, content:Array[U8] val)(h) => 
        h.complete(response.statusCode == 200)
      })

    else
      h.complete(false)
    end

class iso _Test7 is UnitTest
  fun name(): String => "test 7 - full url download"

  fun apply(h: TestHelper) =>
    try
      h.long_test(30_000_000_000)

      HttpClient.download("http://www.chimerasw.com/starbaseorion/wp-content/uploads/2011/04/starbasecommand.jpg", {(response:HttpResponseHeader val, content:Array[U8] val)(h) =>         
        h.complete(response.statusCode == 200)
      })?

    else
      h.complete(false)
    end