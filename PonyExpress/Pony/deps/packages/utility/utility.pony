use "files"
use "collections"

primitive Utility
	
	fun errorLoc():String val =>
		recover val String.copy_cstring(__error_loc) end
	
	fun fatal(string:String) =>
		Log.println("FATAL ABORT: " + string)
		@exit[None](I32(99))
  
	fun exit(string:String) =>
		Log.println("ABORT: " + string)
		@exit[None](I32(0))
	