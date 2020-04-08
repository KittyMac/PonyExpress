use "StringExt"

use @printf[U32](format:Pointer[U8] tag, ...)

primitive Log

	fun printHeader(string:String) =>
		let s = string.size() + 16
		let bar = "-".mul(s)
		let space = " ".mul(8)
		@printf("\n".cstring())
		@printf("\r+%s+\n".cstring(), bar.cstring())
		@printf("\r|%s%s%s|\n".cstring(), space.cstring(), string.cstring(), space.cstring())
		@printf("\r+%s+\n".cstring(), bar.cstring())
		@printf("\n".cstring())

	fun println(fmt:String, 
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
      				arg19:Stringable box = "") =>
		@printf("%s\n".cstring(), StringExt.format(fmt, arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19).cstring())
		
	fun print(fmt:String, 
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
      				arg19:Stringable box = "") =>
		@printf("%s".cstring(), StringExt.format(fmt, arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19).cstring())
		
		