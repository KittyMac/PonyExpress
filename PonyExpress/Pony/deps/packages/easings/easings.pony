
// Ported from: https://github.com/warrenm/AHEasing/blob/master/AHEasing/easing.c

primitive EasingID
  let linear:U32 = 0
  let quadraticIn:U32 = 1
  let quadraticOut:U32 = 2
  let quadraticInOut:U32 = 3
  let cubicIn:U32 = 4
  let cubicOut:U32 = 5
  let cubicInOut:U32 = 6
  let quarticIn:U32 = 7
  let quarticOut:U32 = 8
  let quarticInOut:U32 = 9
  let quinticIn:U32 = 10
  let quinticOut:U32 = 11
  let quinticInOut:U32 = 12
  let sineIn:U32 = 13
  let sineOut:U32 = 14
  let sineInOut:U32 = 15
  let circularIn:U32 = 16
  let circularOut:U32 = 17
  let circularInOut:U32 = 18
  let exponentialIn:U32 = 19
  let exponentialOut:U32 = 20
  let exponentialInOut:U32 = 21
  let elasticIn:U32 = 22
  let elasticOut:U32 = 23
  let elasticInOut:U32 = 24
  let backIn:U32 = 25
  let backOut:U32 = 26
  let backInOut:U32 = 27
  let bounceIn:U32 = 28
  let bounceOut:U32 = 29
  let bounceInOut:U32 = 30
  

primitive Easing[T: (FloatingPoint[T] val & Float) = F32]
  let pi:T = 3.14159265358979323846
  let pi_2:T = 1.570796326794897
  
  
  // MARK: ------------- BY EasingID -------------
  
  fun tween(id:U32, a:T, b:T, t:T):T => 
    match id
    | EasingID.linear => tweenLinear(a, b, t)
    | EasingID.quadraticIn => tweenQuadraticIn(a, b, t)
    | EasingID.quadraticOut => tweenQuadraticOut(a, b, t)
    | EasingID.quadraticInOut => tweenQuadraticInOut(a, b, t)
    | EasingID.cubicIn => tweenCubicIn(a, b, t)
    | EasingID.cubicOut => tweenCubicOut(a, b, t)
    | EasingID.cubicInOut => tweenCubicInOut(a, b, t)
    | EasingID.quarticIn => tweenQuarticIn(a, b, t)
    | EasingID.quarticOut => tweenQuarticOut(a, b, t)
    | EasingID.quarticInOut => tweenQuarticInOut(a, b, t)
    | EasingID.quinticIn => tweenQuinticIn(a, b, t)
    | EasingID.quinticOut => tweenQuinticOut(a, b, t)
    | EasingID.quinticInOut => tweenQuinticInOut(a, b, t)
    | EasingID.sineIn => tweenSineIn(a, b, t)
    | EasingID.sineOut => tweenSineOut(a, b, t)
    | EasingID.sineInOut => tweenSineInOut(a, b, t)
    | EasingID.circularIn => tweenCircularIn(a, b, t)
    | EasingID.circularOut => tweenCircularOut(a, b, t)
    | EasingID.circularInOut => tweenCircularInOut(a, b, t)
    | EasingID.exponentialIn => tweenExponentialIn(a, b, t)
    | EasingID.exponentialOut => tweenExponentialOut(a, b, t)
    | EasingID.exponentialInOut => tweenExponentialInOut(a, b, t)
    | EasingID.elasticIn => tweenElasticIn(a, b, t)
    | EasingID.elasticOut => tweenElasticOut(a, b, t)
    | EasingID.elasticInOut => tweenElasticInOut(a, b, t)
    | EasingID.backIn => tweenBackIn(a, b, t)
    | EasingID.backOut => tweenBackOut(a, b, t)
    | EasingID.backInOut => tweenBackInOut(a, b, t)
    | EasingID.bounceIn => tweenBounceIn(a, b, t)
    | EasingID.bounceOut => tweenBounceOut(a, b, t)
    | EasingID.bounceInOut => tweenBounceInOut(a, b, t)
    else 0.0 end
  

  // Modeled after the line y = x
  fun linear(p:T):T =>
    p
  
  fun tweenLinear(a:T, b:T, t:T):T => a + (t * (b - a))
	
  // MARK: ------------- QUADRATIC -------------
  
  // Modeled after the parabola y = x^2
  fun quadraticIn(p:T):T =>
  	p * p
  
  // Modeled after the parabola y = -x^2 + 2x
  fun quadraticOut(p:T):T =>
  	-(p * (p - 2))
  
  // Modeled after the piecewise quadratic
  // y = (1/2)((2x)^2)             ; [0, 0.5)
  // y = -(1/2)((2x-1)*(2x-3) - 1) ; [0.5, 1]
  fun quadraticInOut(p:T):T =>
  	if p < 0.5 then
  		return 2 * (p * p)
  	else
  		return ((-2 * (p * p)) + (4 * p)) - 1
    end
  
  fun tweenQuadraticIn(a:T, b:T, t:T):T => a + (quadraticIn(t) * (b - a))
  fun tweenQuadraticOut(a:T, b:T, t:T):T => a + (quadraticOut(t) * (b - a))
  fun tweenQuadraticInOut(a:T, b:T, t:T):T => a + (quadraticInOut(t) * (b - a))
  
  
  // MARK: ------------- CUBIC -------------
  
  // Modeled after the cubic y = x^3
  fun cubicIn(p:T):T =>
  	(p * p) * p

  // Modeled after the cubic y = (x - 1)^3 + 1
  fun cubicOut(p:T):T =>
  	let f = (p - 1)
  	((f * f) * f) + 1

  // Modeled after the piecewise cubic
  // y = (1/2)((2x)^3)       ; [0, 0.5)
  // y = (1/2)((2x-2)^3 + 2) ; [0.5, 1]
  fun cubicInOut(p:T):T =>
  	if p < 0.5 then
  		return (4 * p) * (p * p)
  	else
  		let f = ((2 * p) - 2)
  		return ((0.5 * f) * (f * f)) + 1
    end
  
  fun tweenCubicIn(a:T, b:T, t:T):T => a + (cubicIn(t) * (b - a))
  fun tweenCubicOut(a:T, b:T, t:T):T => a + (cubicOut(t) * (b - a))
  fun tweenCubicInOut(a:T, b:T, t:T):T => a + (cubicInOut(t) * (b - a))

  
  // MARK: ------------- QUARTIC -------------
  
  // Modeled after the quartic x^4
  fun quarticIn(p:T):T =>
  	(p * p) * (p * p)

  // Modeled after the quartic y = 1 - (x - 1)^4
  fun quarticOut(p:T):T =>
  	let f = (p - 1)
  	((f * f) * (f * (1 - p))) + 1

  // Modeled after the piecewise quartic
  // y = (1/2)((2x)^4)        ; [0, 0.5)
  // y = -(1/2)((2x-2)^4 - 2) ; [0.5, 1]
  fun quarticInOut(p:T):T =>
  	if p < 0.5 then
  		return ((8 * p) * (p * p)) * p
  	else
  		let f = (p - 1)
  		return (((-8 * f) * (f * f)) * f) + 1
    end
  
  fun tweenQuarticIn(a:T, b:T, t:T):T => a + (quarticIn(t) * (b - a))
  fun tweenQuarticOut(a:T, b:T, t:T):T => a + (quarticOut(t) * (b - a))
  fun tweenQuarticInOut(a:T, b:T, t:T):T => a + (quarticInOut(t) * (b - a))
  
  
  // MARK: ------------- QUINTIC -------------
  
  // Modeled after the quintic y = x^5
  fun quinticIn(p:T):T =>
  	((p * p) * (p * p)) * p

  // Modeled after the quintic y = (x - 1)^5 + 1
  fun quinticOut(p:T):T =>
  	let f = (p - 1)
  	(((f * f) * (f * f)) * f) + 1

  // Modeled after the piecewise quintic
  // y = (1/2)((2x)^5)       ; [0, 0.5)
  // y = (1/2)((2x-2)^5 + 2) ; [0.5, 1]
  fun quinticInOut(p:T):T =>
  	if p < 0.5 then
  		return 16 * (((p * p) * (p * p)) * p)
  	else
  		let f = ((2 * p) - 2)
  		return  (0.5 * (((f * f) * (f * f)) * f)) + 1
    end
  
  fun tweenQuinticIn(a:T, b:T, t:T):T => a + (quinticIn(t) * (b - a))
  fun tweenQuinticOut(a:T, b:T, t:T):T => a + (quinticOut(t) * (b - a))
  fun tweenQuinticInOut(a:T, b:T, t:T):T => a + (quinticInOut(t) * (b - a))
  
  
  // MARK: ------------- SINE -------------
  
  // Modeled after quarter-cycle of sine wave
  fun sineIn(p:T):T =>
  	((p - 1) * pi_2).sin() + 1

  // Modeled after quarter-cycle of sine wave (different phase)
  fun sineOut(p:T):T =>
  	(p * pi_2).sin()

  // Modeled after half sine wave
  fun sineInOut(p:T):T =>
  	0.5 * (1 - (p * pi).cos() )
  
  fun tweenSineIn(a:T, b:T, t:T):T => a + (sineIn(t) * (b - a))
  fun tweenSineOut(a:T, b:T, t:T):T => a + (sineOut(t) * (b - a))
  fun tweenSineInOut(a:T, b:T, t:T):T => a + (sineInOut(t) * (b - a))
  
  
  // MARK: ------------- CIRCULAR -------------
  
  // Modeled after shifted quadrant IV of unit circle
  fun circularIn(p:T):T =>
  	1 - (1 - (p * p)).sqrt()

  // Modeled after shifted quadrant II of unit circle
  fun circularOut(p:T):T =>
  	((2 - p) * p).sqrt()

  // Modeled after the piecewise circular function
  // y = (1/2)(1 - sqrt(1 - 4x^2))           ; [0, 0.5)
  // y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1) ; [0.5, 1]
  fun circularInOut(p:T):T =>
  	if p < 0.5 then
  		return 0.5 * (1 - (1 - (4 * (p * p))).sqrt())
  	else
  		return 0.5 * ((-((2 * p) - 3) * ((2 * p) - 1)).sqrt() + 1)
    end
  
  fun tweenCircularIn(a:T, b:T, t:T):T => a + (circularIn(t) * (b - a))
  fun tweenCircularOut(a:T, b:T, t:T):T => a + (circularOut(t) * (b - a))
  fun tweenCircularInOut(a:T, b:T, t:T):T => a + (circularInOut(t) * (b - a))
  
  
  // MARK: ------------- EXPONENTIAL -------------
  
  // Modeled after the exponential function y = 2^(10(x - 1))
  fun exponentialIn(p:T):T =>
  	if p == 0.0 then 
      p 
    else
      T(2).pow(10 * (p - 1))
    end

  // Modeled after the exponential function y = -2^(-10x) + 1
  fun exponentialOut(p:T):T =>
  	if p == 1.0 then
      p
    else
      1 - T(2).pow(-10 * p)
    end

  // Modeled after the piecewise exponential
  // y = (1/2)2^(10(2x - 1))         ; [0,0.5)
  // y = -(1/2)*2^(-10(2x - 1))) + 1 ; [0.5,1]
  fun exponentialInOut(p:T):T =>
  	if (p == 0.0) or (p == 1.0) then
      return p
    end

  	if p < 0.5 then
  		return 0.5 * T(2).pow((20 * p) - 10)
    else
  		return (-0.5 * T(2).pow((-20 * p) + 10)) + 1
    end
  
  fun tweenExponentialIn(a:T, b:T, t:T):T => a + (exponentialIn(t) * (b - a))
  fun tweenExponentialOut(a:T, b:T, t:T):T => a + (exponentialOut(t) * (b - a))
  fun tweenExponentialInOut(a:T, b:T, t:T):T => a + (exponentialInOut(t) * (b - a))
  
  
  
  // MARK: ------------- ELASTIC -------------
  
  // Modeled after the damped sine wave y = sin(13pi/2*x)*pow(2, 10 * (x - 1))
  fun elasticIn(p:T):T =>
  	(13 * pi_2 * p).sin() * T(2).pow(10 * (p - 1))

  // Modeled after the damped sine wave y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1
  fun elasticOut(p:T):T =>
  	((-13 * pi_2 * (p + 1)).sin() * T(2).pow(-10 * p)) + 1

  // Modeled after the piecewise exponentially-damped sine wave:
  // y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))      ; [0,0.5)
  // y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2) ; [0.5, 1]
  fun elasticInOut(p:T):T =>
  	if p < 0.5 then
  		return 0.5 * (13 * pi_2 * (2 * p)).sin() * T(2).pow(10 * ((2 * p) - 1))
  	else
  		return 0.5 * ( ((-13 * pi_2 * (((2 * p) - 1) + 1)).sin() * T(2).pow(-10 * ((2 * p) - 1))) + 2 )
    end
  
  fun tweenElasticIn(a:T, b:T, t:T):T => a + (elasticIn(t) * (b - a))
  fun tweenElasticOut(a:T, b:T, t:T):T => a + (elasticOut(t) * (b - a))
  fun tweenElasticInOut(a:T, b:T, t:T):T => a + (elasticInOut(t) * (b - a))

  
  // MARK: ------------- BACK -------------
  
  // Modeled after the overshooting cubic y = x^3-x*sin(x*pi)
  fun backIn(p:T):T =>
  	((p * p) * p) - (p * (p * pi).sin())

  // Modeled after overshooting cubic y = 1-((1-x)^3-(1-x)*sin((1-x)*pi))
  fun backOut(p:T):T =>
  	let f = (1 - p)
  	1 - (  ((f * f) * f) - (f * (f * pi).sin() ) )

  // Modeled after the piecewise overshooting cubic function:
  // y = (1/2)*((2x)^3-(2x)*sin(2*x*pi))           ; [0, 0.5)
  // y = (1/2)*(1-((1-x)^3-(1-x)*sin((1-x)*pi))+1) ; [0.5, 1]
  fun backInOut(p:T):T =>
  	if p < 0.5 then
  		let f = 2 * p
  		return 0.5 * (((f * f) * f) - (f * (f * pi).sin()) )
    else
  		let f = (1 - ((2 * p) - 1))
  		return (0.5 * (1 - (((f * f) * f) - (f * (f * pi).sin())  ))) + 0.5
    end
  
  fun tweenBackIn(a:T, b:T, t:T):T => a + (backIn(t) * (b - a))
  fun tweenBackOut(a:T, b:T, t:T):T => a + (backOut(t) * (b - a))
  fun tweenBackInOut(a:T, b:T, t:T):T => a + (backInOut(t) * (b - a))

  
  // MARK: ------------- BOUNCE -------------
  
  fun bounceIn(p:T):T =>
  	1 - bounceOut(1 - p)

  fun bounceOut(p:T):T =>
  	if p < (4 / 11.0) then
  		return ((121.0 * p) * p) / 16.0
    elseif p < (8.0 / 11.0) then
  		return (((363.0 / 40.0) * p * p) - ((99.0 / 10.0) * p)) + (17.0 / 5.0)
    elseif p < (9.0 / 10.0) then
  		return (((4356.0 / 361.0) * p * p) - ((35442.0 / 1805.0) * p)) + (16061.0 / 1805.0)
    else
  		return (((54.0 / 5.0) * p * p) - ((513.0 / 25.0) * p)) + (268.0 / 25.0)
    end

  fun bounceInOut(p:T):T =>
  	if p < 0.5 then
  		return (0.5 * bounceIn(p * 2))
    else
  		return (0.5 * bounceOut((p * 2) - 1)) + 0.5
    end
  
  fun tweenBounceIn(a:T, b:T, t:T):T => a + (bounceIn(t) * (b - a))
  fun tweenBounceOut(a:T, b:T, t:T):T => a + (bounceOut(t) * (b - a))
  fun tweenBounceInOut(a:T, b:T, t:T):T => a + (bounceInOut(t) * (b - a))

  
