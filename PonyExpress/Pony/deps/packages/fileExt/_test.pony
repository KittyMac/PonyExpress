use "ponytest"
use "files"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestFileReadArray)
    test(_TestFileReadString)
    test(_TestFileReadError)
        
    test(_TestFileWriteArray)
    test(_TestFileWriteString)
        
    test(_TestFileExtFlowing)
    test(_TestFileExtFlowingManual)
  
  fun @runtime_override_defaults(rto: RuntimeOptions) =>
    //rto.ponyanalysis = true
    rto.ponyminthreads = 2
    rto.ponynoblock = true
    rto.ponygcinitial = 0
    rto.ponygcfactor = 1.0


// ******************* Non-Streaming Tests *******************

class iso _TestFileReadArray is UnitTest
  fun name(): String => "readAsArray"

  fun apply(h: TestHelper) =>
    h.long_test(2_000_000_000_000)

    FileExtReader.readAsArray(h.env, "test.txt", {(fileArrayIso:Array[U8] iso, err: FileExtError val) =>
      match (err)
      | let _: String val =>
        h.complete(false)
      | None =>
        let fileArray:Array[U8] ref = consume fileArrayIso
        h.complete(fileArray.size() == 24)
          end
    } val)

class iso _TestFileReadString is UnitTest
  fun name(): String => "readAsString"

  fun apply(h: TestHelper) =>
    h.long_test(2_000_000_000_000)
    
    FileExtReader.readAsString(h.env, "test.txt", {(fileStringIso:String iso, err: FileExtError val) =>
      match (err)
      | let _: String val =>
        h.complete(false)
      | None =>
        //This is a test document.
        let fileString:String ref = consume fileStringIso
        h.complete(fileString == "This is a test document.")
          end
    } val)

class iso _TestFileReadError is UnitTest
  fun name(): String => "readAsString returning an error"

  fun apply(h: TestHelper) =>
    h.long_test(2_000_000_000_000)

    FileExtReader.readAsString(h.env, "some_file_does_not_exist.txt", {(fileStringIso:String iso, err: FileExtError val) =>
      match (err)
      | let _: String val =>
        h.complete(true)
      | None =>
        h.complete(false)
          end
    } val)



class iso _TestFileWriteArray is UnitTest
  fun name(): String => "writeAsArray"

  fun apply(h: TestHelper) =>
    h.long_test(2_000_000_000_000)

    FileExtWriter.writeArray("/tmp/test1.txt", "Hello, World!".array(), {(err: FileExtError val) =>
      match (err)
      | let _: String val =>
        h.complete(false)
      | None =>
      
      // Read the file back in and confirm it worked
      FileExtReader.readAsArray(h.env, "/tmp/test1.txt", {(fileArrayIso:Array[U8] iso, err: FileExtError val) =>
        let fileString = String.from_iso_array(consume fileArrayIso)
        h.complete(fileString == "Hello, World!")
      } val)
      
          end
    } val)

class iso _TestFileWriteString is UnitTest


  fun name(): String => "writeString"

  fun apply(h: TestHelper) =>
    h.long_test(2_000_000_000_000)
    
    FileExtWriter.writeString("/tmp/test2.txt", "Hello, World!", {(err: FileExtError val) =>
      match (err)
      | let _: String val =>
        h.complete(false)
      | None =>
    
      // Read the file back in and confirm it worked
      FileExtReader.readAsString(h.env, "/tmp/test2.txt", {(fileStringIso:String iso, err: FileExtError val) =>
        h.complete(fileStringIso == "Hello, World!")
      } val)
    
          end
    } val)


// ********************************************************

class iso _TestFileExtFlowing is UnitTest
  fun name(): String => "read file as stream"
  
  fun apply(h: TestHelper) => 
    h.long_test(2_000_000_000)
  
    let callback = object val is FlowFinished
      fun flowFinished() =>
        h.complete(true)
        true
    end
    
    var inFilePath = "test_large.txt"
    var outFilePath = "/tmp/test_large.txt"
    
    FileExtFlowReader(inFilePath, 512,
      FileExtFlowPassthru(
        FileExtFlowByteCounter(
          FileExtFlowPassthru(
            FileExtFlowWriter(outFilePath,
              FileExtFlowByteCounter(
                FileExtFlowFinished(callback, FileExtFlowEnd)
              )
            )
          )
        )
      )
    )


class iso _TestFileExtFlowingManual is UnitTest
  fun name(): String => "read file as stream at manually controlled rate"

  fun apply(h: TestHelper) => 
    h.long_test(2_000_000_000)
    
    _TestFileExtFlowingManualActor(h)
    

actor _TestFileExtFlowingManualActor is FileExtReaderCallback
  
  let h:TestHelper
  
  be fileExtReaderReadComplete(sender:FileExtFlowReader tag, done:Bool val) =>
    if done == false then
      sender.read()
    end
  
  new create(h': TestHelper) =>
    h = h'
  
    let callback = object val is FlowFinished
      fun flowFinished() =>
        h.complete(true)
        true
    end

    var inFilePath = "test_large.txt"
    var outFilePath = "/tmp/test_large.txt"

    let reader = FileExtFlowReader.manual(inFilePath, 512, this,
      FileExtFlowPassthru(
        FileExtFlowByteCounter(
          FileExtFlowPassthru(
            FileExtFlowWriter(outFilePath,
              FileExtFlowByteCounter(
                FileExtFlowFinished(callback, FileExtFlowEnd)
              )
            )
          )
        )
      )
    )
    
    reader.read()


