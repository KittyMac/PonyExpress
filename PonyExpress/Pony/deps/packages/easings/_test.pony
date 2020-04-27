use "ponytest"


actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
	test(_Test1)
		
	
 	fun @runtime_override_defaults(rto: RuntimeOptions) =>
		rto.ponyanalysis = 1
		rto.ponynoblock = true
		rto.ponygcinitial = 0
		rto.ponygcfactor = 1.0


class iso _Test1 is UnitTest
	fun name(): String => "placeholder"
  
  //fun printTestCode(f:String, v1:F32, v2:F32) =>
  //  @fprintf[I32](@pony_os_stdout[Pointer[U8]](), "if %s(%s).string() != \"%s\" then error end\n".cstring(), f.cstring(), v1.string().cstring(), v2.string().cstring())
    
  
	fun apply(h: TestHelper) =>
    try
    
      //printTestCode("Easing.bounceIn", 0.25, Easing.bounceIn(0.25))
      //printTestCode("Easing.bounceOut", 0.25, Easing.bounceOut(0.25))
      //printTestCode("Easing.bounceInOut", 0.25, Easing.bounceInOut(0.25))
      
      if Easing[F32].linear(0.25).string() != "0.25" then error end
      if Easing[F64].linear(0.25).string() != "0.25" then error end
        
      if Easing.linear(0.25).string() != "0.25" then error end
      
      if Easing.quadraticIn(0.25).string() != "0.0625" then error end
      if Easing.quadraticOut(0.25).string() != "0.4375" then error end
      if Easing.quadraticInOut(0.25).string() != "0.125" then error end
      
      if Easing.cubicIn(0.25).string() != "0.015625" then error end
      if Easing.cubicOut(0.25).string() != "0.578125" then error end
      if Easing.cubicInOut(0.25).string() != "0.0625" then error end
      
      if Easing.quarticIn(0.25).string() != "0.00390625" then error end
      if Easing.quarticOut(0.25).string() != "0.683594" then error end
      if Easing.quarticInOut(0.25).string() != "0.03125" then error end
      
      if Easing.quinticIn(0.25).string() != "0.000976562" then error end
      if Easing.quinticOut(0.25).string() != "0.762695" then error end
      if Easing.quinticInOut(0.25).string() != "0.015625" then error end
      
      if Easing.sineIn(0.25).string() != "0.0761205" then error end
      if Easing.sineOut(0.25).string() != "0.382683" then error end
      if Easing.sineInOut(0.25).string() != "0.146447" then error end
      
      if Easing.circularIn(0.25).string() != "0.0317541" then error end
      if Easing.circularOut(0.25).string() != "0.661438" then error end
      if Easing.circularInOut(0.25).string() != "0.0669873" then error end
      
      if Easing.exponentialIn(0.25).string() != "0.00552427" then error end
      if Easing.exponentialOut(0.25).string() != "0.823223" then error end
      if Easing.exponentialInOut(0.25).string() != "0.015625" then error end
      
      if Easing.elasticIn(0.25).string() != "-0.00510376" then error end
      if Easing.elasticOut(0.25).string() != "0.932351" then error end
      if Easing.elasticInOut(0.25).string() != "-0.0110485" then error end
      
      if Easing.backIn(0.25).string() != "-0.161152" then error end
      if Easing.backOut(0.25).string() != "1.10846" then error end
      if Easing.backInOut(0.25).string() != "-0.1875" then error end
      
      if Easing.bounceIn(0.25).string() != "0.0411367" then error end
      if Easing.bounceOut(0.25).string() != "0.472656" then error end
      if Easing.bounceInOut(0.25).string() != "0.140625" then error end
      
      if Easing.tweenQuadraticIn(0,1,1) != 1 then error end
      if Easing.tweenQuadraticOut(0,1,1) != 1 then error end
      if Easing.tweenQuadraticInOut(0,1,1) != 1 then error end
      
      if Easing.tweenCubicIn(0,1,1) != 1 then error end
      if Easing.tweenCubicOut(0,1,1) != 1 then error end
      if Easing.tweenCubicInOut(0,1,1) != 1 then error end
      
      if Easing.tweenQuarticIn(0,1,1) != 1 then error end
      if Easing.tweenQuarticOut(0,1,1) != 1 then error end
      if Easing.tweenQuarticInOut(0,1,1) != 1 then error end
      
      if Easing.tweenQuinticIn(0,1,1) != 1 then error end
      if Easing.tweenQuinticOut(0,1,1) != 1 then error end
      if Easing.tweenQuinticInOut(0,1,1) != 1 then error end
      
      if Easing.tweenSineIn(0,1,1) != 1 then error end
      if Easing.tweenSineOut(0,1,1) != 1 then error end
      if Easing.tweenSineInOut(0,1,1) != 1 then error end
      
      if Easing.tweenCircularIn(0,1,1) != 1 then error end
      if Easing.tweenCircularOut(0,1,1) != 1 then error end
      if Easing.tweenCircularInOut(0,1,1) != 1 then error end
      
      if Easing.tweenExponentialIn(0,1,1) != 1 then error end
      if Easing.tweenExponentialOut(0,1,1) != 1 then error end
      if Easing.tweenExponentialInOut(0,1,1) != 1 then error end
      
      if Easing.tweenElasticIn(0,1,1) != 1 then error end
      if Easing.tweenElasticOut(0,1,1) != 1 then error end
      if Easing.tweenElasticInOut(0,1,1) != 1 then error end
      
      if (Easing.tweenBackIn(0,1,1) - 1).abs() > 0.01 then error end
      if (Easing.tweenBackOut(0,1,1) - 1).abs() > 0.01 then error end
      if (Easing.tweenBackInOut(0,1,1) - 1).abs() > 0.01 then error end
      
      if (Easing.tweenBounceIn(0,1,1) - 1).abs() > 0.01 then error end
      if (Easing.tweenBounceOut(0,1,1) - 1).abs() > 0.01 then error end
      if (Easing.tweenBounceInOut(0,1,1) - 1).abs() > 0.01 then error end
    
      h.complete( true )
    else
      
      h.env.out.print(recover val String.copy_cstring(__error_loc) end)
      
      h.complete( false )
    end
