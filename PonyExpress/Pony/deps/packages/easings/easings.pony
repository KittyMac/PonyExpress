
// Ported from: https://github.com/warrenm/AHEasing/blob/master/AHEasing/easing.c

primitive Easing[T: (FloatingPoint[T] val & Float) = F32]

  fun pi():T => 3.14159265358979323846
  fun pi_2():T => 1.570796326794897

  // Modeled after the line y = x
  fun linear(p:T):T =>
    p
	
  // MARK: ------------- QUADRATIC -------------
  
  // Modeled after the parabola y = x^2
  fun quadraticEaseIn(p:T):T =>
  	p * p
  
  // Modeled after the parabola y = -x^2 + 2x
  fun quadraticEaseOut(p:T):T =>
  	-(p * (p - 2))
  
  // Modeled after the piecewise quadratic
  // y = (1/2)((2x)^2)             ; [0, 0.5)
  // y = -(1/2)((2x-1)*(2x-3) - 1) ; [0.5, 1]
  fun quadraticEaseInOut(p:T):T =>
  	if p < 0.5 then
  		return 2 * (p * p)
  	else
  		return ((-2 * (p * p)) + (4 * p)) - 1
    end
  
  fun tweenQuadraticEaseIn(a:T, b:T, t:T):T => a + (quadraticEaseIn(t) * (b - a))
  fun tweenQuadraticEaseOut(a:T, b:T, t:T):T => a + (quadraticEaseOut(t) * (b - a))
  fun tweenQuadraticEaseInOut(a:T, b:T, t:T):T => a + (quadraticEaseInOut(t) * (b - a))
  
  
  // MARK: ------------- CUBIC -------------
  
  // Modeled after the cubic y = x^3
  fun cubicEaseIn(p:T):T =>
  	(p * p) * p

  // Modeled after the cubic y = (x - 1)^3 + 1
  fun cubicEaseOut(p:T):T =>
  	let f = (p - 1)
  	((f * f) * f) + 1

  // Modeled after the piecewise cubic
  // y = (1/2)((2x)^3)       ; [0, 0.5)
  // y = (1/2)((2x-2)^3 + 2) ; [0.5, 1]
  fun cubicEaseInOut(p:T):T =>
  	if p < 0.5 then
  		return (4 * p) * (p * p)
  	else
  		let f = ((2 * p) - 2)
  		return ((0.5 * f) * (f * f)) + 1
    end
  
  fun tweenCubicEaseIn(a:T, b:T, t:T):T => a + (cubicEaseIn(t) * (b - a))
  fun tweenCubicEaseOut(a:T, b:T, t:T):T => a + (cubicEaseOut(t) * (b - a))
  fun tweenCubicEaseInOut(a:T, b:T, t:T):T => a + (cubicEaseInOut(t) * (b - a))

  
  // MARK: ------------- QUARTIC -------------
  
  // Modeled after the quartic x^4
  fun quarticEaseIn(p:T):T =>
  	(p * p) * (p * p)

  // Modeled after the quartic y = 1 - (x - 1)^4
  fun quarticEaseOut(p:T):T =>
  	let f = (p - 1)
  	((f * f) * (f * (1 - p))) + 1

  // Modeled after the piecewise quartic
  // y = (1/2)((2x)^4)        ; [0, 0.5)
  // y = -(1/2)((2x-2)^4 - 2) ; [0.5, 1]
  fun quarticEaseInOut(p:T):T =>
  	if p < 0.5 then
  		return ((8 * p) * (p * p)) * p
  	else
  		let f = (p - 1)
  		return (((-8 * f) * (f * f)) * f) + 1
    end
  
  fun tweenQuarticEaseIn(a:T, b:T, t:T):T => a + (quarticEaseIn(t) * (b - a))
  fun tweenQuarticEaseOut(a:T, b:T, t:T):T => a + (quarticEaseOut(t) * (b - a))
  fun tweenQuarticEaseInOut(a:T, b:T, t:T):T => a + (quarticEaseInOut(t) * (b - a))
  
  
  // MARK: ------------- QUINTIC -------------
  
  // Modeled after the quintic y = x^5
  fun quinticEaseIn(p:T):T =>
  	((p * p) * (p * p)) * p

  // Modeled after the quintic y = (x - 1)^5 + 1
  fun quinticEaseOut(p:T):T =>
  	let f = (p - 1)
  	(((f * f) * (f * f)) * f) + 1

  // Modeled after the piecewise quintic
  // y = (1/2)((2x)^5)       ; [0, 0.5)
  // y = (1/2)((2x-2)^5 + 2) ; [0.5, 1]
  fun quinticEaseInOut(p:T):T =>
  	if p < 0.5 then
  		return 16 * (((p * p) * (p * p)) * p)
  	else
  		let f = ((2 * p) - 2)
  		return  (0.5 * (((f * f) * (f * f)) * f)) + 1
    end
  
  fun tweenQuinticEaseIn(a:T, b:T, t:T):T => a + (quinticEaseIn(t) * (b - a))
  fun tweenQuinticEaseOut(a:T, b:T, t:T):T => a + (quinticEaseOut(t) * (b - a))
  fun tweenQuinticEaseInOut(a:T, b:T, t:T):T => a + (quinticEaseInOut(t) * (b - a))
  
  
  // MARK: ------------- SINE -------------
  
  // Modeled after quarter-cycle of sine wave
  fun sineEaseIn(p:T):T =>
  	((p - 1) * pi_2()).sin() + 1

  // Modeled after quarter-cycle of sine wave (different phase)
  fun sineEaseOut(p:T):T =>
  	(p * pi_2()).sin()

  // Modeled after half sine wave
  fun sineEaseInOut(p:T):T =>
  	0.5 * (1 - (p * pi()).cos() )
  
  fun tweenSineEaseIn(a:T, b:T, t:T):T => a + (sineEaseIn(t) * (b - a))
  fun tweenSineEaseOut(a:T, b:T, t:T):T => a + (sineEaseOut(t) * (b - a))
  fun tweenSineEaseInOut(a:T, b:T, t:T):T => a + (sineEaseInOut(t) * (b - a))
  
  
  // MARK: ------------- CIRCULAR -------------
  
  // Modeled after shifted quadrant IV of unit circle
  fun circularEaseIn(p:T):T =>
  	1 - (1 - (p * p)).sqrt()

  // Modeled after shifted quadrant II of unit circle
  fun circularEaseOut(p:T):T =>
  	((2 - p) * p).sqrt()

  // Modeled after the piecewise circular function
  // y = (1/2)(1 - sqrt(1 - 4x^2))           ; [0, 0.5)
  // y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1) ; [0.5, 1]
  fun circularEaseInOut(p:T):T =>
  	if p < 0.5 then
  		return 0.5 * (1 - (1 - (4 * (p * p))).sqrt())
  	else
  		return 0.5 * ((-((2 * p) - 3) * ((2 * p) - 1)).sqrt() + 1)
    end
  
  fun tweenCircularEaseIn(a:T, b:T, t:T):T => a + (circularEaseIn(t) * (b - a))
  fun tweenCircularEaseOut(a:T, b:T, t:T):T => a + (circularEaseOut(t) * (b - a))
  fun tweenCircularEaseInOut(a:T, b:T, t:T):T => a + (circularEaseInOut(t) * (b - a))
  
  
  // MARK: ------------- EXPONENTIAL -------------
  
  // Modeled after the exponential function y = 2^(10(x - 1))
  fun exponentialEaseIn(p:T):T =>
  	if p == 0.0 then 
      p 
    else
      T(2).pow(10 * (p - 1))
    end

  // Modeled after the exponential function y = -2^(-10x) + 1
  fun exponentialEaseOut(p:T):T =>
  	if p == 1.0 then
      p
    else
      1 - T(2).pow(-10 * p)
    end

  // Modeled after the piecewise exponential
  // y = (1/2)2^(10(2x - 1))         ; [0,0.5)
  // y = -(1/2)*2^(-10(2x - 1))) + 1 ; [0.5,1]
  fun exponentialEaseInOut(p:T):T =>
  	if (p == 0.0) or (p == 1.0) then
      return p
    end

  	if p < 0.5 then
  		return 0.5 * T(2).pow((20 * p) - 10)
    else
  		return (-0.5 * T(2).pow((-20 * p) + 10)) + 1
    end
  
  fun tweenExponentialEaseIn(a:T, b:T, t:T):T => a + (exponentialEaseIn(t) * (b - a))
  fun tweenExponentialEaseOut(a:T, b:T, t:T):T => a + (exponentialEaseOut(t) * (b - a))
  fun tweenExponentialEaseInOut(a:T, b:T, t:T):T => a + (exponentialEaseInOut(t) * (b - a))
  
  
  
  // MARK: ------------- ELASTIC -------------
  
  // Modeled after the damped sine wave y = sin(13pi/2*x)*pow(2, 10 * (x - 1))
  fun elasticEaseIn(p:T):T =>
  	(13 * pi_2() * p).sin() * T(2).pow(10 * (p - 1))

  // Modeled after the damped sine wave y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1
  fun elasticEaseOut(p:T):T =>
  	((-13 * pi_2() * (p + 1)).sin() * T(2).pow(-10 * p)) + 1

  // Modeled after the piecewise exponentially-damped sine wave:
  // y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))      ; [0,0.5)
  // y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2) ; [0.5, 1]
  fun elasticEaseInOut(p:T):T =>
  	if p < 0.5 then
  		return 0.5 * (13 * pi_2() * (2 * p)).sin() * T(2).pow(10 * ((2 * p) - 1))
  	else
  		return 0.5 * ( ((-13 * pi_2() * (((2 * p) - 1) + 1)).sin() * T(2).pow(-10 * ((2 * p) - 1))) + 2 )
    end
  
  fun tweenElasticEaseIn(a:T, b:T, t:T):T => a + (elasticEaseIn(t) * (b - a))
  fun tweenElasticEaseOut(a:T, b:T, t:T):T => a + (elasticEaseOut(t) * (b - a))
  fun tweenElasticEaseInOut(a:T, b:T, t:T):T => a + (elasticEaseInOut(t) * (b - a))

  
  // MARK: ------------- BACK -------------
  
  // Modeled after the overshooting cubic y = x^3-x*sin(x*pi)
  fun backEaseIn(p:T):T =>
  	((p * p) * p) - (p * (p * pi()).sin())

  // Modeled after overshooting cubic y = 1-((1-x)^3-(1-x)*sin((1-x)*pi))
  fun backEaseOut(p:T):T =>
  	let f = (1 - p)
  	1 - (  ((f * f) * f) - (f * (f * pi()).sin() ) )

  // Modeled after the piecewise overshooting cubic function:
  // y = (1/2)*((2x)^3-(2x)*sin(2*x*pi))           ; [0, 0.5)
  // y = (1/2)*(1-((1-x)^3-(1-x)*sin((1-x)*pi))+1) ; [0.5, 1]
  fun backEaseInOut(p:T):T =>
  	if p < 0.5 then
  		let f = 2 * p
  		return 0.5 * (((f * f) * f) - (f * (f * pi()).sin()) )
    else
  		let f = (1 - ((2 * p) - 1))
  		return (0.5 * (1 - (((f * f) * f) - (f * (f * pi()).sin())  ))) + 0.5
    end
  
  fun tweenBackEaseIn(a:T, b:T, t:T):T => a + (backEaseIn(t) * (b - a))
  fun tweenBackEaseOut(a:T, b:T, t:T):T => a + (backEaseOut(t) * (b - a))
  fun tweenBackEaseInOut(a:T, b:T, t:T):T => a + (backEaseInOut(t) * (b - a))

  
  // MARK: ------------- BOUNCE -------------
  
  fun bounceEaseIn(p:T):T =>
  	1 - bounceEaseOut(1 - p)

  fun bounceEaseOut(p:T):T =>
  	if p < (4 / 11.0) then
  		return ((121.0 * p) * p) / 16.0
    elseif p < (8.0 / 11.0) then
  		return (((363.0 / 40.0) * p * p) - ((99.0 / 10.0) * p)) + (17.0 / 5.0)
    elseif p < (9.0 / 10.0) then
  		return (((4356.0 / 361.0) * p * p) - ((35442.0 / 1805.0) * p)) + (16061.0 / 1805.0)
    else
  		return (((54.0 / 5.0) * p * p) - ((513.0 / 25.0) * p)) + (268.0 / 25.0)
    end

  fun bounceEaseInOut(p:T):T =>
  	if p < 0.5 then
  		return (0.5 * bounceEaseIn(p * 2))
    else
  		return (0.5 * bounceEaseOut((p * 2) - 1)) + 0.5
    end
  
  fun tweenBounceEaseIn(a:T, b:T, t:T):T => a + (bounceEaseIn(t) * (b - a))
  fun tweenBounceEaseOut(a:T, b:T, t:T):T => a + (bounceEaseOut(t) * (b - a))
  fun tweenBounceEaseInOut(a:T, b:T, t:T):T => a + (bounceEaseInOut(t) * (b - a))

  
