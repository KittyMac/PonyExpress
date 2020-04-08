class val Env
  """
  An environment holds the command line and other values injected into the
  program by default by the runtime.
  """
  let root: (AmbientAuth | None)
    """
    The root capability.

    Can be `None` for artificially constructed `Env` instances.
    """

  let input: InputStream
    """
    Stdin represented as an actor.
    """

  let cpu_count:U32

  let out: OutStream
    """Stdout"""

  let err: OutStream
    """Stderr"""

  let args: Array[String] val
    """The command line used to start the program."""

  let vars: Array[String] val
    """The program's environment variables."""

  let argc:U32
    """The raw argc passed in from main(). Useful for directly passing to FFI code"""
	
  let argv:Pointer[Pointer[U8]] val
    """The raw argv passed in from main(). Useful for directly passing to FFI code"""

  let exitcode: {(I32)} val
    """
    Sets the environment's exit code. The exit code of the root environment will
    be the exit code of the application, which defaults to 0.
    """

  new _create(
    argc': U32,
    argv': Pointer[Pointer[U8]] val,
    envp: Pointer[Pointer[U8]] val)
  =>
    """
    Builds an environment from the command line. This is done before the Main
    actor is created.
    """
    root = AmbientAuth._create()
    @pony_os_stdout_setup[None]()

	cpu_count = @ponyint_cpu_count[U32]()
    input = Stdin._create(@pony_os_stdin_setup[Bool]())
    out = StdStream._out()
    err = StdStream._err()
	
	argc = argc'
	argv = argv'

    args = _strings_from_pointers(argv, argc.usize())
    vars = _strings_from_pointers(envp, _count_strings(envp))

    exitcode = {(code: I32) => @pony_exitcode[None](code) }

  new val create(
    root': (AmbientAuth | None),
    input': InputStream, out': OutStream,
    err': OutStream, args': Array[String] val,
    vars': Array[String] val,
    exitcode': {(I32)} val)
  =>
    """
    Build an artificial environment. A root capability may be supplied.
    """
    root = root'
    input = input'
    out = out'
    err = err'
	argc = 0
	argv = recover val Pointer[Pointer[U8]] end
    args = args'
    vars = vars'
    exitcode = exitcode'
	cpu_count = @ponyint_cpu_count[U32]()

  fun tag _count_strings(data: Pointer[Pointer[U8]] val): USize =>
    if data.is_null() then
      return 0
    end

    var i: USize = 0

    while
      let entry = data._apply(i)
      not entry.is_null()
    do
      i = i + 1
    end
    i

  fun tag _strings_from_pointers(
    data: Pointer[Pointer[U8]] val,
    len: USize)
    : Array[String] iso^
  =>
    let array = recover Array[String](len) end
    var i: USize = 0

    while i < len do
      let entry = data._apply(i = i + 1)
      array.push(recover String.copy_cstring(entry) end)
    end

    array
