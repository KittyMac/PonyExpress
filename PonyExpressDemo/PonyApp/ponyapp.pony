use "ui"
use "utility"

actor PonyApp  
  let renderEngine:RenderEngine
  
  new create(env:Env, renderEngine':RenderEngine) =>
    renderEngine = renderEngine'
        
    ScrollTest.load(renderEngine, "Root")
    
    
