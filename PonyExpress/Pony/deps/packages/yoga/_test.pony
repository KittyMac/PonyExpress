use "fileExt"
use "ponytest"
use "files"
use "flow"
use "bitmap"

actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
		test(_TestYoga1)


class iso _TestYoga1 is UnitTest
	fun name(): String => "Test 1: do something trivial in yoga"

	fun apply(h: TestHelper) =>
    let result = """
<div layout="width: 800; height: 600; top: 0; left: 0;" style="" >
  <div layout="width: 800; height: 0; top: 0; left: 0;" style="" >
    <div layout="width: 800; height: 0; top: 0; left: 0;" style="" ></div>
  </div>
</div>"""
    h.long_test(30_000_000_000)
    
    let renderEngineNode = SampleYogaNode
    let fullScreenColorNode = SampleYogaNode
    let centerColorNode = SampleYogaNode
    
    renderEngineNode.addChild(fullScreenColorNode)
    fullScreenColorNode.addChild(centerColorNode)
    
    renderEngineNode.layout()
        
    h.complete(renderEngineNode.string() == result)
	


