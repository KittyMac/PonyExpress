
use "path:/usr/lib" if osx
use "lib:ponybitmap-osx" if osx
use "lib:ponybitmap-ios" if ios


use @memcpy[Pointer[None]](dst: Pointer[U8] tag, src: Pointer[U8] tag, n: USize)

use @pony_bitmap_fillRect[None](s:Pointer[U8] tag, width:USize, height:USize, rX:I64, rY:I64, rW:USize, rH:USize, cR:U8, cG:U8, cB:U8, cA:U8)
use @pony_bitmap_blit[None](	d_ptr:Pointer[U8] tag, d_width:USize, d_height:USize, 
								s_ptr:Pointer[U8] tag, s_width:USize, s_height:USize,
								d_x:I64, d_y:I64,
								s_x:I64, s_y:I64, r_width:USize, r_height:USize)
use @pony_bitmap_blit_over[None](	d_ptr:Pointer[U8] tag, d_width:USize, d_height:USize, 
									s_ptr:Pointer[U8] tag, s_width:USize, s_height:USize,
									d_x:I64, d_y:I64,
									s_x:I64, s_y:I64, r_width:USize, r_height:USize)

struct RGBA
	var r:U8 = 0
	var g:U8 = 0
	var b:U8 = 0
	var a:U8 = 0
	
	new create(r':U8, g':U8, b':U8, a':U8) =>
		r = r'
		g = g'
		b = b'
		a = a'
	
	new clear() => r = 0; g = 0; b = 0; a = 0
	new black() => r = 0; g = 0; b = 0; a = 255
	new red() => r = 255; g = 0; b = 0; a = 255
	new green() => r = 0; g = 255; b = 0; a = 255
	new blue() => r = 0; g = 0; b = 255; a = 255
	new yellow() => r = 255; g = 255; b = 0; a = 255

struct Rect
	var x:I64 = 0
	var y:I64 = 0
	var w:USize = 0
	var h:USize = 0

	new create(x':I64, y':I64, w':USize, h':USize) =>
		x = x'
		y = y'
		w = w'
		h = h'


class val Bitmap
	"""
	A contiguos, non-resizable block of memory representing an RGBA image.  Memory for this
	is allocated outside of pony's normal memory system.
	"""

	var width:USize
	var height:USize
	var bytes: Array[U8] ref
		
	new create(width':USize, height':USize) =>
		width = width'
		height = height'
		bytes = Array[U8](width * height * 4)
		bytes.undefined(width * height * 4)
	
	new copy(width':USize, height':USize, bytes':Pointer[U8] tag) =>
		width = width'
		height = height'
		bytes = Array[U8](width * height * 4)
		bytes.undefined(width * height * 4)
		@memcpy(bytes.cpointer(0), bytes', width * height * 4)
	
	fun size(): USize =>
		width * height * 4
	
	fun cpointer(offset: USize = 0): Pointer[U8] tag =>
		bytes.cpointer(0)
	
	fun ref clear(c:RGBA box) =>
		@pony_bitmap_fillRect[None](bytes.cpointer(0), width, height, 0, 0, width, height, c.r, c.g, c.b, c.a)
	
	fun ref getPixel(x: I64, y: I64):RGBA =>
		let i = ((y * width.i64() * 4) + (x * 4)).usize()
		if (i >= 0) and (i <= ((width * height * 4) - 4)) then
			try
				return RGBA(
						bytes(i + 0)?,
						bytes(i + 1)?,
						bytes(i + 2)?,
						bytes(i + 3)?
					)
			end
		end
		RGBA.clear()
	
	fun ref setPixel(x: I64, y: I64, c:RGBA box) =>
		try
			let i = ((y * width.i64() * 4) + (x * 4)).usize()
			if (i >= 0) and (i <= ((width * height * 4) - 4)) then
				bytes(i + 0)? = c.r
				bytes(i + 1)? = c.g
				bytes(i + 2)? = c.b
				bytes(i + 3)? = c.a
			end
		end
		
	fun ref fillRect(r:Rect box, c:RGBA box) =>
		@pony_bitmap_fillRect[None](bytes.cpointer(0), width, height, r.x, r.y, r.w, r.h, c.r, c.g, c.b, c.a)
	
	fun ref blit(x:I64, y:I64, o:Bitmap box) =>
		"""
		blit the entire destination bitmap into the source bitmap at x,y
		"""
		@pony_bitmap_blit(	bytes.cpointer(0), width, height, 
							o.bytes.cpointer(0), o.width, o.height,
							x, y,
							0, 0, o.width, o.height)
	
	fun ref blitPart(d_x:I64, d_y:I64, o:Bitmap box, s_x:I64, s_y:I64, s_width:USize, s_height:USize) =>
		"""
		blit the a subrect of the destination bitmap into the source bitmap at x,y
		"""
		@pony_bitmap_blit(	bytes.cpointer(0), width, height, 
							o.bytes.cpointer(0), o.width, o.height,
							d_x, d_y,
							s_x, s_y, s_width, s_height)
	
	
	fun ref blitOver(x:I64, y:I64, o:Bitmap box) =>
		"""
		blit the entire destination bitmap into the source bitmap at x,y. Performs alpha blending.
		"""
		@pony_bitmap_blit_over(	bytes.cpointer(0), width, height, 
								o.bytes.cpointer(0), o.width, o.height,
								x, y,
								0, 0, o.width, o.height)
	
	fun ref blitPartOver(d_x:I64, d_y:I64, o:Bitmap box, s_x:I64, s_y:I64, s_width:USize, s_height:USize) =>
		"""
		blit the a subrect of the destination bitmap into the source bitmap at x,y. Performs alpha blending.
		"""
		@pony_bitmap_blit_over(	bytes.cpointer(0), width, height, 
								o.bytes.cpointer(0), o.width, o.height,
								d_x, d_y,
								s_x, s_y, s_width, s_height)
	
	
	fun rowPointers():Pointer[None] =>
		@pony_bitmap_row_pointers[Pointer[None]](bytes.cpointer(0), width, height)
	
	fun rowPointersFree(ptr:Pointer[None]) =>
		@pony_bitmap_row_pointers_free[None](ptr)

	