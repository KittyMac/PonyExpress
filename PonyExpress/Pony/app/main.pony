use "ui"
use "utility"

actor Main
  let renderEngine:RenderEngine
  
  fun _tag():U32 => 2001
  
	new create(env:Env) =>
    PlatformIOS(env)
    PlatformOSX(env)
    
    env.out.print("Hello from Main!")
    
    renderEngine = RenderEngine
    
    //FontTest.load(renderEngine, "Root")
    Catalog.load(renderEngine, "Root")
    
        

  fun @runtime_override_defaults(rto: RuntimeOptions) =>
    rto.ponyanalysis = 0
    rto.ponynoscale = true
    rto.ponynoblock = true
    rto.ponygcinitial = 0
    rto.ponygcfactor = 1.0
    
