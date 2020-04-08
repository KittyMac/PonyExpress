use "ponytest"
use "time"

actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
	
		test(_TestFormatStringFieldSize)
		test(_TestFormatString)
		test(_TestParseDate)
		test(_TestContains)
		



class iso _TestFormatStringFieldSize is UnitTest
	fun name(): String => "format string field size"

	fun apply(h: TestHelper) =>
		h.env.out.print( StringExt.format("+----------+----------+") )
		h.env.out.print( StringExt.format("+%10s+%10s+", "hello", "world") )
		h.env.out.print( StringExt.format("+----------+----------+") )
		h.env.out.print( StringExt.format("+%-10s+%+10s+", "hello", "world") )
		h.env.out.print( StringExt.format("+----------+----------+") )
		h.env.out.print( StringExt.format("+%-10.5s+%+10.2s+", "21.123456789", "1.123456789") )
		h.env.out.print( StringExt.format("+%-10.5s+%+10.2s+", "21.1", "1") )
		h.env.out.print( StringExt.format("+----------+----------+") )

class iso _TestFormatString is UnitTest
	fun name(): String => "format string"
	
	fun apply(h: TestHelper) =>
		let x:U32 = 42
		let s = StringExt.format("Formatting %s is such an %s feeling", x, "awesome")
		h.env.out.print(s)

class iso _TestParseDate is UnitTest
	fun name(): String => "parse date"

	fun apply(h: TestHelper) =>
		try
			let d = StringExt.parseDate("10/21/2019 6:27:20 PM", "%m/%d/%Y %I:%M:%S %p")?
			h.env.out.print(StringExt.format("%s/%s/%s %s:%s:%s", d.month, d.day_of_month, d.year, d.hour, d.min, d.sec))
		end

class iso _TestContains is UnitTest
	fun name(): String => "contains"

	fun apply(h: TestHelper) =>
		var result = StringExt.contains("hello world", "lo wo")
		h.env.out.print(StringExt.format("contains should be true: %s", result))
		
		result = StringExt.contains("hello world", "wtf")
		h.env.out.print(StringExt.format("contains should be false: %s", result))

