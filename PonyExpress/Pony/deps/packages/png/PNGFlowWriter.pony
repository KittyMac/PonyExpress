use "fileExt"
use "flow"
use "bitmap"

use "path:/usr/lib" if osx
use "lib:png"

struct PNGWriteFnStruct
	var fd:I32
	
	new create(fd':I32) =>
		fd = fd'


primitive PNGWriter
	fun tag write(filePath:String, bitmap:Bitmap box)? =>

		let null = Pointer[None]
	
		let malloc_fn = @{(png_ptr:Pointer[_PngStruct], size:USize):Pointer[U8] =>
			if size == 0 then
				Pointer[None]
			end
			@malloc(size)
		}
		let free_fn = @{(png_ptr:Pointer[_PngStruct], ptr:Pointer[None]) => 
			@free(ptr)
		}
		let write_fn = @{(png_ptr:Pointer[_PngStruct] tag, data:Pointer[U8], length:USize) => 
			let writeStructPtr = @png_get_io_ptr[NullablePointer[PNGWriteFnStruct]](png_ptr)
			try
				var writeStruct = writeStructPtr()?
				FileExt.write(writeStruct.fd, data, length)
			end
		}
	
		var pngPtr = @png_create_write_struct_2(LIBPNG.png_libpng_ver_string().cpointer(), null, null, null, null, malloc_fn, free_fn)
		if pngPtr.is_null() then
			error
		end
	
		var infoPtr = @png_create_info_struct(pngPtr)
		if infoPtr.is_null() then
			error
		end
	
		let fd = FileExt.open(filePath)
	
		let readerInfo = PNGWriteFnStruct(fd)
		@png_set_write_fn(pngPtr, NullablePointer[PNGWriteFnStruct](readerInfo), write_fn, null)
	
		// Output is 8bit depth, RGBA format.
		@png_set_IHDR[None](
			pngPtr,
			infoPtr,
			bitmap.width, bitmap.height,
			USize(8),
			LIBPNG.png_color_type_rgba(),
			LIBPNG.png_interlace_none(),
			LIBPNG.png_compression_type_default(),
			LIBPNG.png_filter_type_default()
		)
		@png_write_info[None](pngPtr, infoPtr)
	
		let rowPointers = bitmap.rowPointers()
		@png_write_image[None](pngPtr, rowPointers)
		bitmap.rowPointersFree(rowPointers)
	
		@png_write_end[None](pngPtr, null)
		
		@png_free_data[None](pngPtr, infoPtr, U32(0x7fff), I32(-1))
		
		@png_destroy_write_struct[None](addressof pngPtr, addressof infoPtr)
	
		FileExt.close(fd)

actor PNGFlowWriter is Flowable

	let target:Flowable tag
	let filePath:String
	
	fun _tag():USize => 116

	new create(filePath':String, target':Flowable tag) =>
		target = target'
		filePath = filePath'
	
	be flowFinished() =>
		true

	be flowReceived(dataIso:Any iso) =>
		try
			let bitmap = (consume dataIso) as Bitmap
			try
				PNGWriter.write(filePath, bitmap)?
			end
		end

	
	
