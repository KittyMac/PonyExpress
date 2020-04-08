use "time"

interface TTimerNotify
	be timerNotify(timer:TTimer tag)

class TTimerCallback is TimerNotify
	let ttimer: TTimer tag
	let target:TTimerNotify tag
	let avoidFlooding:Bool

	new iso create(ttimer': TTimer tag, target':TTimerNotify tag, avoidFlooding':Bool val) =>
		ttimer = ttimer'
		target = target'
		avoidFlooding = avoidFlooding'

	fun ref apply(timer: Timer, count: U64): Bool =>
		if avoidFlooding == false then
			target.timerNotify(ttimer)
		else
			if @ponyint_actor_num_messages[USize](target) < 4 then
				target.timerNotify(ttimer)
			end
		end
		true

	fun ref cancel(timer: Timer) =>
		None

actor TTimer
	"""
	A simple timer. Don't use it if it rubs you the wrong way.
	"""
	let target:TTimerNotify tag
	var timers: Timers tag
	var timer:Timer tag
	
	let avoidFlooding:Bool
	let milliseconds:U64
	var cancelled:Bool = false
		
	fun _priority():USize => -99
		
	new create(milliseconds':U64, target':TTimerNotify tag, avoidFlooding':Bool = false) =>
		target = target'
		
		avoidFlooding = avoidFlooding'
		milliseconds = milliseconds'
		
		timers = Timers
		
		let timerIso = Timer(TTimerCallback(this, target, avoidFlooding), milliseconds * 1_000_000, milliseconds * 1_000_000)
		timer = timerIso
		timers(consume timerIso)
	
	be resume() =>
		if cancelled == true then
			cancelled = false
			let timerIso = Timer(TTimerCallback(this, target, avoidFlooding), milliseconds * 1_000_000, milliseconds * 1_000_000)
			timer = timerIso
			timers(consume timerIso)
		end
	
	be cancel() =>
		cancelled = true
		timers.cancel(timer)
	