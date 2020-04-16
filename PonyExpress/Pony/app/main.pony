use "ui"
use "utility"
use "ponyapp"

actor Main
  let renderEngine:RenderEngine = RenderEngine
  
	new create(env:Env) =>
    PlatformIOS(env)
    PlatformOSX(env)
    
    PonyApp(env, renderEngine)
        

  fun @runtime_override_defaults(rto: RuntimeOptions) =>
    rto.ponyanalysis = 0
    rto.ponynoscale = true
    rto.ponynoblock = true
    rto.ponymainthread = true
    //rto.ponygcinitial = 0
    //rto.ponygcfactor = 1.0
    