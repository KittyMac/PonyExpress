use "ponytest"

actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
		test(_TestFlow)
	
	// Required to keep pony memory usage down when dealing with large chunks of memory,
	// especially when dealing with "processor" actors who don't allocate memory themselves
	// they just pass messages
 	fun @runtime_override_defaults(rto: RuntimeOptions) =>
		rto.ponynoblock = true
		rto.ponygcinitial = 0
		rto.ponygcfactor = 1.0


// ********************** BASIC FLOW **********************

primitive Data
	fun size():USize => 1024*1024*4

actor Producer
	
	let target:Flowable tag
	var count:USize
	
	fun _tag():USize => 1
	
	fun _freed(wasRemote:Bool) =>
		if wasRemote then
			produce()
		end
	
	new create(target':Flowable tag) =>
		target = target'
		count = 0
		
		// "prime the pump" to allow for concurrency
		produce()
		produce()
	
	be produce() =>
		count = count + 1
		if count < 20 then
			let msg = "x".mul(Data.size())
			@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "produced %d bytes of data, count = %d\n".cstring(), Data.size(), count)
			target.flowReceived(consume msg)
		else
			target.flowFinished()
		end	

actor Consumer is Flowable

	fun _tag():USize => 2
	
	be flowFinished() =>
		@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "flow finished\n".cstring())
	
	be flowReceived(dataIso: Any iso) =>
		try
			@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "begin consuming %d bytes of data\n".cstring(), (dataIso as String iso).size())
			@sleep[U32](U32(1))
			@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "end consuming %d bytes of data\n".cstring(), (dataIso as String iso).size())
		end

class iso _TestFlow is UnitTest
	fun name(): String => "good flow"

	fun apply(h: TestHelper) =>
		Producer(Consumer)

// ************************************************************
