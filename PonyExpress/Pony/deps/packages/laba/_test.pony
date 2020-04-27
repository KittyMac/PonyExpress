use "ponytest"
use "collections"

use "easings"
use "linal"
use "utility"
use "ui"

actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
		test(_TestLaba1)
    test(_TestLaba2)
    test(_TestLaba3)
    test(_TestLaba4)


primitive LabaTestShared
  let delta_time:F32 = 0.1
  fun compareResults(idx:USize, s1:String, s2:String, t1:F32, t2:F32):Bool =>
    if ((s1 == s2) and ((t1 - t2).abs() < delta_time)) == false then
      Log.println("[%s] %s != %s: %s", idx, t1, t2, s1)
      return false
    end
    true
    
  fun advanceLabaAnimationOnNode(node:YogaNode ref):F32 =>
    node.layout()
    
    var total_time:F32 = 0.0
    while node.isAnimating() do
      total_time = total_time + delta_time
      node.animate(delta_time)
      node.layout()
    end
    
    total_time
    

class iso _TestLaba1 is UnitTest
	fun name(): String => "Test 1: basic ui functionality"

	fun apply(h: TestHelper) =>
    h.long_test(30_000_000_000)
    let result = """<div layout="width: 100; height: 100; top: 0; left: 0;" style="width: 100px; height: 100px; " ></div>"""
    let node = YogaNode.>size(100,100).>view( Clear )
    let t = LabaTestShared.advanceLabaAnimationOnNode(node)
    h.complete(LabaTestShared.compareResults(0, node.string(), result, 0.0, t))
	

class iso _TestLaba2 is UnitTest
  fun name(): String => "Test 2: duration, delay, <, >, ^, v"

  fun apply(h: TestHelper) =>
    h.long_test(30_000_000_000)
    
    //"!>300!f"
    
    let tests:Array[(F32,String,String)] = [
      (LabaConst.duration, "", """<div layout="width: 100; height: 100; top: 0; left: 0;" style="width: 100px; height: 100px; " ></div>""")
      (0.27+0.1+0.2+0.3, "~d0.1|d0.2|d0.3", """<div layout="width: 100; height: 100; top: 0; left: 0;" style="width: 100px; height: 100px; " ></div>""")
      (0.5+0.1+0.2+0.3, "~0.5d0.1|d0.2|d0.3", """<div layout="width: 100; height: 100; top: 0; left: 0;" style="width: 100px; height: 100px; " ></div>""")
      (0.1+0.2+0.3, "d0.1|d0.2|d0.3", """<div layout="width: 100; height: 100; top: 0; left: 0;" style="width: 100px; height: 100px; " ></div>""")
      (0.23, "d0.23<100", """<div layout="width: 100; height: 100; top: 0; left: -100;" style="width: 100px; height: 100px; left: -100px; " ></div>""")
      (0.23+0.7, "d0.23<100|d0.7>100", """<div layout="width: 100; height: 100; top: 0; left: 0;" style="width: 100px; height: 100px; left: 0px; " ></div>""")
      (LabaConst.duration*1, "<100", """<div layout="width: 100; height: 100; top: 0; left: -100;" style="width: 100px; height: 100px; left: -100px; " ></div>""")
      (LabaConst.duration*1, ">100", """<div layout="width: 100; height: 100; top: 0; left: 100;" style="width: 100px; height: 100px; left: 100px; " ></div>""")
      (LabaConst.duration*1, "^100", """<div layout="width: 100; height: 100; top: -100; left: 0;" style="width: 100px; height: 100px; top: -100px; " ></div>""")
      (LabaConst.duration*1, "v100", """<div layout="width: 100; height: 100; top: 100; left: 0;" style="width: 100px; height: 100px; top: 100px; " ></div>""")
      (LabaConst.duration*1, "!<100", """<div layout="width: 100; height: 100; top: 0; left: 0;" style="width: 100px; height: 100px; left: 0px; " ></div>""")
      (LabaConst.duration*1, "!>100", """<div layout="width: 100; height: 100; top: 0; left: 0;" style="width: 100px; height: 100px; left: 0px; " ></div>""")
      (LabaConst.duration*1, "!^100", """<div layout="width: 100; height: 100; top: 0; left: 0;" style="width: 100px; height: 100px; top: 0px; " ></div>""")
      (LabaConst.duration*1, "!v100", """<div layout="width: 100; height: 100; top: 0; left: 0;" style="width: 100px; height: 100px; top: 0px; " ></div>""")
      (LabaConst.duration*1, "<100^100", """<div layout="width: 100; height: 100; top: -100; left: -100;" style="width: 100px; height: 100px; left: -100px; top: -100px; " ></div>""")
      (LabaConst.duration*4, "<100|>100|^50|v50", """<div layout="width: 100; height: 100; top: 0; left: 0;" style="width: 100px; height: 100px; left: 0px; top: 0px; " ></div>""")
    ]
    
    var testIdx:USize = 0
    for (duration, labaString, compare) in tests.values() do
      let node = YogaNode.>laba(labaString).>size(100,100)
      let t = LabaTestShared.advanceLabaAnimationOnNode(node)
      if LabaTestShared.compareResults(testIdx, node.string(), compare, duration, t) == false then
        h.complete(false)
        return
      end
      testIdx = testIdx + 1
    end
    
    h.complete(true)

class iso _TestLaba3 is UnitTest
  fun name(): String => "Test 3: staggered duration"

  fun apply(h: TestHelper) =>
    h.long_test(30_000_000_000)

    let tests:Array[(F32,String,String)] = [
      (3.0*2, "D3.0", """<div layout="width: 100; height: 100; top: 200; left: 0;" style="width: 100px; height: 100px; " ></div>""")
    ]

    var testIdx:USize = 0
    for (duration, labaString, compare) in tests.values() do
      let node = YogaNode.>laba(labaString).>size(100,100)
      let parent = YogaNode.>size(100,100)
                         .>addChildren([
                    YogaNode.>size(100,100)
                    YogaNode.>size(100,100)
                    node
                 ])
      
      parent.layout()
      
      let t = LabaTestShared.advanceLabaAnimationOnNode(node)
      if LabaTestShared.compareResults(testIdx, node.string(), compare, duration, t) == false then
        h.complete(false)
        return
      end
      testIdx = testIdx + 1
    end

    h.complete(true)
    
class iso _TestLaba4 is UnitTest
  fun name(): String => "Test 4: parameters"

  fun apply(h: TestHelper) =>
    h.long_test(30_000_000_000)

    let compare = """<div layout="width: 100; height: 100; top: 0; left: -999;" style="width: 100px; height: 100px; left: -999px; " ></div>"""

    let node = YogaNode.>laba("d?<?", 5.0, 999.0).>size(100,100)

    let t = LabaTestShared.advanceLabaAnimationOnNode(node)
    if LabaTestShared.compareResults(0, node.string(), compare, 5.0, t) == false then
      h.complete(false)
      return
    end

    h.complete(true)