use "time"

// char * strptime(const char * restrict buf, const char * restrict format, struct tm * restrict timeptr);
use @strptime[Pointer[U8]](buffer:Pointer[U8] tag, format:Pointer[U8] tag, tm:NullablePointer[TM] ref)
use @timegm[I64](tm:NullablePointer[TM] ref)

use @strnstr[Pointer[U8]](haystack:Pointer[U8] tag, needle:Pointer[U8] tag, len:USize)

struct TM
	var tm_sec:U32 = 0
	var tm_min:U32 = 0
	var tm_hour:U32 = 0
	var tm_mday:U32 = 0
	var tm_mon:U32 = 0
	var tm_year:U32 = 0
	var tm_wday:U32 = 0
	var tm_yday:U32 = 0
	var tm_isdst:U32 = 0

primitive StringExt

	fun baseDirectory(path:String):String =>
		var startIdx:ISize = 0
		var endIdx:ISize = path.size().isize()
		try
			endIdx = path.rfind("/")?
		end
		path.substring(startIdx, endIdx)

	fun lastPathComponent(path:String):String =>
		var startIdx:ISize = 0
		try
			startIdx = path.rfind("/")?
		end
		var endIdx:ISize = path.size().isize()
		path.substring(startIdx, endIdx)
	
	fun pathExtension(path:String box):String =>
		var startIdx:ISize = 0
		try
			startIdx = path.rfind(".")?
		end
		var endIdx:ISize = path.size().isize()
		path.substring(startIdx, endIdx)

	fun contains(haystack:String box, needle:String box):Bool =>
		@strnstr(haystack.cpointer(0), needle.cpointer(0), haystack.size()).is_null() == false
		

	fun endswith(string:String box, other:String box) : Bool =>
		string.at(other, (string.size() - other.size()).isize() )

	fun startswith(string:String box, other:String box) : Bool =>
		string.at(other, 0)

	fun parseDate(date:String, fmt:String):PosixDate? =>
		// parse a date string into the PosixDate format
		var tm:TM ref = TM
		let ret:Pointer[U8] = @strptime(date.cpointer(), fmt.cpointer(), NullablePointer[TM](tm))
		if ret.is_null() then
			error
		end
		let time_t:I64 = @timegm(NullablePointer[TM](tm))
		PosixDate(time_t, 0)

		
		

	fun format(	fmt:String, 
				arg0:Stringable box = "",
				arg1:Stringable box = "", 
				arg2:Stringable box = "",
				arg3:Stringable box = "",
				arg4:Stringable box = "",
				arg5:Stringable box = "",
				arg6:Stringable box = "",
				arg7:Stringable box = "",
				arg8:Stringable box = "",
				arg9:Stringable box = "",
				arg10:Stringable box = "",
				arg11:Stringable box = "", 
				arg12:Stringable box = "",
				arg13:Stringable box = "",
				arg14:Stringable box = "",
				arg15:Stringable box = "",
				arg16:Stringable box = "",
				arg17:Stringable box = "",
				arg18:Stringable box = "",
				arg19:Stringable box = ""):String =>
		// I'm not super proud of this, but it works and it should be fairly efficient
		// StringExt.format("Such %s formatting", "awesome")
		let string0:String val = arg0.string()
		let string1:String val = arg1.string()
		let string2:String val = arg2.string()
		let string3:String val = arg3.string()
		let string4:String val = arg4.string()
		let string5:String val = arg5.string()
		let string6:String val = arg6.string()
		let string7:String val = arg7.string()
		let string8:String val = arg8.string()
		let string9:String val = arg9.string()
		let string10:String val = arg10.string()
		let string11:String val = arg11.string()
		let string12:String val = arg12.string()
		let string13:String val = arg13.string()
		let string14:String val = arg14.string()
		let string15:String val = arg15.string()
		let string16:String val = arg16.string()
		let string17:String val = arg17.string()
		let string18:String val = arg18.string()
		let string19:String val = arg19.string()
		
		let targetSize = 	fmt.size() + 
							string0.size() + 
							string1.size() + 
							string2.size() + 
							string3.size() + 
							string4.size() + 
							string5.size() + 
							string6.size() + 
							string7.size() + 
							string8.size() + 
							string9.size() +
							string10.size() + 
							string11.size() + 
							string12.size() + 
							string13.size() + 
							string14.size() + 
							string15.size() + 
							string16.size() + 
							string17.size() + 
							string18.size() + 
							string19.size()
	
		recover val
			var newString = String(targetSize)
		
			try
				var i_arg:USize = 0
				var i:USize = 0
				var opt = String(128)
				
				while i < fmt.size() do
					let c = fmt(i)?
					if i == (fmt.size()-1) then
						newString.push(c)
					else						
						if (c == '%') then
							// search forward for an 's', bail if we hit a space
							var j:USize = i
							
							opt.clear()
							while j < fmt.size() do
								let e = fmt(j)?
								opt.push(e)
								if (e == 's') then
									i = j
									break
								end
								if (e == ' ') or (e == '\n') then
									break
								end
								
								j = j + 1
							end
														
							var nextString = ""
							match i_arg
							| 0 => nextString = string0
							| 1 => nextString = string1
							| 2 => nextString = string2
							| 3 => nextString = string3
							| 4 => nextString = string4
							| 5 => nextString = string5
							| 6 => nextString = string6
							| 7 => nextString = string7
							| 8 => nextString = string8
							| 9 => nextString = string9
							| 10 => nextString = string10
							| 11 => nextString = string11
							| 12 => nextString = string12
							| 13 => nextString = string13
							| 14 => nextString = string14
							| 15 => nextString = string15
							| 16 => nextString = string16
							| 17 => nextString = string17
							| 18 => nextString = string18
							| 19 => nextString = string19
							end
							i_arg = i_arg + 1
							
							if opt.size() == 2 then
								newString.append(nextString)
							else
								try
									// the numbers between the % and the s is a field size
									opt.shift()?
									opt.pop()?
								
									if opt.contains(".") then
										// %10.3s means "field width of 10, with 3 units of precision"
										// This handles the "3 units of precision" part
									    let optParts: Array[String] = opt.split(".")
										var right = optParts(1)?.isize()?
										
										try
											let dotIdx = nextString.find(".") ?
											let endIdx = dotIdx + right + 1
											nextString = nextString.substring(0, endIdx)
										else
											// there's no '.' Let's just add one...
											nextString = nextString + ".0"
										end
										
										opt.clear()
										opt.append(optParts(0)?)
									end
								
									let kLeft:USize = 0
									let kCenter:USize = 1
									let kRight:USize = 2
														
									// %+10s means right aligned, 10 characters wide
									// %-10s means left aligned, 10 characters wide
									// %10s means center aligned, 10 characters wide
									var direction = kCenter
									if opt(0)? == '+' then
										opt.shift()?
										direction = kRight
									end
									if opt(0)? == '-' then
										opt.shift()?
										direction = kLeft
									end									
							
									let nextStringSize = nextString.size()
									let fieldSize = opt.usize()?
									let padding = (fieldSize - nextStringSize) / 2
							
									var k:USize = 0
																
									if direction == kCenter then
										while k < fieldSize do
											if (k == padding) and (nextStringSize != 0) then
												newString.append(nextString)
												k = k + nextStringSize
											else
												newString.push(' ')
												k = k + 1
											end
										end
									end
							
									if direction == kLeft then
										while k < fieldSize do
											if (k == 0) and (nextStringSize != 0) then
												newString.append(nextString)
												k = k + nextStringSize
											else
												newString.push(' ')
												k = k + 1
											end
										end
									end
							
									if direction == kRight then
										while k < fieldSize do
											if (k == (fieldSize - nextStringSize)) and (nextStringSize != 0) then
												newString.append(nextString)
												k = k + nextStringSize
											else
												newString.push(' ')
												k = k + 1
											end
										end
									end
							
								else
									newString.append(nextString)
								end
							
							end
							
						else
							newString.push(c)
						end
					end
					i = i + 1
				end
			else
				newString.append("(string format conversion failed)")
			end
		
			newString
		end
	
