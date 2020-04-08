type ObjectPtr is Pointer[None] tag

primitive StringEncoding
	fun utf8():U32 => 0x08000100

actor@ PlatformIOS is PonyPlatform
	fun _use_main_thread():Bool => true
  
	new create(env:Env) =>
    ifdef ios then
      register(this)

      // Swift mangles the class names of its generated classes. I had to retrieve this by looking in the Swift-generate ObjC header
      let appDelegateString = @CFStringCreateWithCString[ObjectPtr](ObjectPtr, "PonyExpressAppDelegate".cstring(), StringEncoding.utf8())
      @UIApplicationMain[U32](env.argc, env.argv, Pointer[None], appDelegateString)
    end
