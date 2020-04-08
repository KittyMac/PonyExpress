actor@ PlatformOSX is PonyPlatform
	fun _use_main_thread():Bool => true
  
	new create(env:Env) =>
    ifdef osx then
      register(this)
  		@NSApplicationMain[I32](env.argc, env.argv)
    end
