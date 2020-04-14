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
    
      //printTestCode("Easing.bounceEaseIn", 0.25, Easing.bounceEaseIn(0.25))
      //printTestCode("Easing.bounceEaseOut", 0.25, Easing.bounceEaseOut(0.25))
      //printTestCode("Easing.bounceEaseInOut", 0.25, Easing.bounceEaseInOut(0.25))
      
      if Easing[F32].linear(0.25).string() != "0.25" then error end
      if Easing[F64].linear(0.25).string() != "0.25" then error end
        
      if Easing.linear(0.25).string() != "0.25" then error end
      
      if Easing.quadraticEaseIn(0.25).string() != "0.0625" then error end
      if Easing.quadraticEaseOut(0.25).string() != "0.4375" then error end
      if Easing.quadraticEaseInOut(0.25).string() != "0.125" then error end
      
      if Easing.cubicEaseIn(0.25).string() != "0.015625" then error end
      if Easing.cubicEaseOut(0.25).string() != "0.578125" then error end
      if Easing.cubicEaseInOut(0.25).string() != "0.0625" then error end
      
      if Easing.quarticEaseIn(0.25).string() != "0.00390625" then error end
      if Easing.quarticEaseOut(0.25).string() != "0.683594" then error end
      if Easing.quarticEaseInOut(0.25).string() != "0.03125" then error end
      
      if Easing.quinticEaseIn(0.25).string() != "0.000976562" then error end
      if Easing.quinticEaseOut(0.25).string() != "0.762695" then error end
      if Easing.quinticEaseInOut(0.25).string() != "0.015625" then error end
      
      if Easing.sineEaseIn(0.25).string() != "0.0761205" then error end
      if Easing.sineEaseOut(0.25).string() != "0.382683" then error end
      if Easing.sineEaseInOut(0.25).string() != "0.146447" then error end
      
      if Easing.circularEaseIn(0.25).string() != "0.0317541" then error end
      if Easing.circularEaseOut(0.25).string() != "0.661438" then error end
      if Easing.circularEaseInOut(0.25).string() != "0.0669873" then error end
      
      if Easing.exponentialEaseIn(0.25).string() != "0.00552427" then error end
      if Easing.exponentialEaseOut(0.25).string() != "0.823223" then error end
      if Easing.exponentialEaseInOut(0.25).string() != "0.015625" then error end
      
      if Easing.elasticEaseIn(0.25).string() != "-0.00510376" then error end
      if Easing.elasticEaseOut(0.25).string() != "0.932351" then error end
      if Easing.elasticEaseInOut(0.25).string() != "-0.0110485" then error end
      
      if Easing.backEaseIn(0.25).string() != "-0.161152" then error end
      if Easing.backEaseOut(0.25).string() != "1.10846" then error end
      if Easing.backEaseInOut(0.25).string() != "-0.1875" then error end
      
      if Easing.bounceEaseIn(0.25).string() != "0.0411367" then error end
      if Easing.bounceEaseOut(0.25).string() != "0.472656" then error end
      if Easing.bounceEaseInOut(0.25).string() != "0.140625" then error end
      
      if Easing.tweenQuadraticEaseIn(0,1,1) != 1 then error end
      if Easing.tweenQuadraticEaseOut(0,1,1) != 1 then error end
      if Easing.tweenQuadraticEaseInOut(0,1,1) != 1 then error end
      
      if Easing.tweenCubicEaseIn(0,1,1) != 1 then error end
      if Easing.tweenCubicEaseOut(0,1,1) != 1 then error end
      if Easing.tweenCubicEaseInOut(0,1,1) != 1 then error end
      
      if Easing.tweenQuarticEaseIn(0,1,1) != 1 then error end
      if Easing.tweenQuarticEaseOut(0,1,1) != 1 then error end
      if Easing.tweenQuarticEaseInOut(0,1,1) != 1 then error end
      
      if Easing.tweenQuinticEaseIn(0,1,1) != 1 then error end
      if Easing.tweenQuinticEaseOut(0,1,1) != 1 then error end
      if Easing.tweenQuinticEaseInOut(0,1,1) != 1 then error end
      
      if Easing.tweenSineEaseIn(0,1,1) != 1 then error end
      if Easing.tweenSineEaseOut(0,1,1) != 1 then error end
      if Easing.tweenSineEaseInOut(0,1,1) != 1 then error end
      
      if Easing.tweenCircularEaseIn(0,1,1) != 1 then error end
      if Easing.tweenCircularEaseOut(0,1,1) != 1 then error end
      if Easing.tweenCircularEaseInOut(0,1,1) != 1 then error end
      
      if Easing.tweenExponentialEaseIn(0,1,1) != 1 then error end
      if Easing.tweenExponentialEaseOut(0,1,1) != 1 then error end
      if Easing.tweenExponentialEaseInOut(0,1,1) != 1 then error end
      
      if Easing.tweenElasticEaseIn(0,1,1) != 1 then error end
      if Easing.tweenElasticEaseOut(0,1,1) != 1 then error end
      if Easing.tweenElasticEaseInOut(0,1,1) != 1 then error end
      
      if (Easing.tweenBackEaseIn(0,1,1) - 1).abs() > 0.01 then error end
      if (Easing.tweenBackEaseOut(0,1,1) - 1).abs() > 0.01 then error end
      if (Easing.tweenBackEaseInOut(0,1,1) - 1).abs() > 0.01 then error end
      
      if (Easing.tweenBounceEaseIn(0,1,1) - 1).abs() > 0.01 then error end
      if (Easing.tweenBounceEaseOut(0,1,1) - 1).abs() > 0.01 then error end
      if (Easing.tweenBounceEaseInOut(0,1,1) - 1).abs() > 0.01 then error end
    
      h.complete( true )
    else
      
      h.env.out.print(recover val String.copy_cstring(__error_loc) end)
      
      h.complete( false )
    end
