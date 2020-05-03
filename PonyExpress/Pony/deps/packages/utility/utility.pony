use "files"
use "collections"
use "regex"

primitive Utility
	
	fun errorLoc():String val =>
		recover val String.copy_cstring(__error_loc) end
	
	fun fatal(string:String) =>
		Log.println("FATAL ABORT: " + string)
		@exit[None](I32(99))
  
	fun exit(string:String) =>
		Log.println("ABORT: " + string)
		@exit[None](I32(0))
	  
	fun confirmDirExists(env: Env, path:String) =>
		try
			let filePath = FilePath(env.root as AmbientAuth, path, FileCaps.>all())?
			if filePath.exists() == false then
				filePath.mkdir()
			end
		else
			env.err.print("Failed to create output directory " + path)
		end

	fun confirmFullPathExists(env: Env, path:String) =>
		// check that each directory level in the path exists, if it does not create it
		try
			for i in Range[USize](2,32) do
				let slashIdx = path.find("/", 0, i)?
				if slashIdx >= 0 then
					let subpath = path.trim(0, slashIdx.usize())
					confirmDirExists(env, subpath)
				end
			end
		else
			// finally, check that the full path exists
			confirmDirExists(env, path)
		end
  
  fun isValidEmail(email:String)? =>
    // throws an error if the email is not valid (or failed while checking it)
    let emailRegex = Regex("([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+)")?
    let matched = emailRegex(email)?
    if matched(0)? != email then error end