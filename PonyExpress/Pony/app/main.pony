use "ui"
use "utility"
use "ponyapp"

actor Main    
	new create(env:Env) =>
    PlatformIOS(env)
    PlatformOSX(env)
    
    PonyApp(env, RenderEngine)
    
        

  fun @runtime_override_defaults(rto: RuntimeOptions) =>
    rto.ponyanalysis = 0
    rto.ponynoscale = true
    rto.ponynoblock = true
    rto.ponygcinitial = 0
    rto.ponygcfactor = 1.0
    
