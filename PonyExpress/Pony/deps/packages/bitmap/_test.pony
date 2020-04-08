use "fileExt"
use "ponytest"
use "files"
use "flow"
use "png"

actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
		test(_TestBitmap)


class iso _TestBitmap is UnitTest
	fun name(): String => "raw bitmap"

	fun apply(h: TestHelper) =>
		try
			let red = Bitmap(100,100)
			red.clear(RGBA.red())
			
			let blue = Bitmap(5000,5000)
			blue.clear(RGBA.blue())
			
			let yellow = Bitmap(5000,5000)
			yellow.clear(RGBA.yellow())
			
			let green = Bitmap(5000,5000)
			green.clear(RGBA.green())
			
			let black = Bitmap(5000,5000)
			black.clear(RGBA.black())
			
			red.blit(-100, -100, blue)
			red.blit(200, 200, blue)
			
			red.blit(-15, -15, blue)
			
			red.blit(100-15, 100-15, black)
			
			red.blit(-15, 100-15, green)
			red.blit(100-15, -15, yellow)
			
			
			red.blitPart(-30, -30, green, 100, 100, 35, 35)
			
			PNGWriter.write("/tmp/bitmap.png", red)?
			
			/*
			PNGWriter.write("/tmp/bitmap_blue.png", blue)?
			PNGWriter.write("/tmp/bitmap_green.png", green)?
			PNGWriter.write("/tmp/bitmap_yellow.png", yellow)?
			PNGWriter.write("/tmp/bitmap_black.png", black)?
			*/
		end
	


