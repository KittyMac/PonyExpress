use "ponytest"

actor Main
	var count:U64 = 0
	
	be timerNotify(timer:TTimer tag) =>
		@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "timer fired!\n".cstring())
		count = count + 1
		if count >= 3 then
			timer.cancel()
		end
	
	new create(env: Env) =>
		@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "timer created!\n".cstring())
		TTimer(1000, this)
