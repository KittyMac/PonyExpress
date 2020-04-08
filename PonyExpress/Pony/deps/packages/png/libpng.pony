use "path:/usr/lib" if osx
use "lib:png"

use @malloc[Pointer[U8]](bytes: USize)
use @free[None](pointer: Pointer[None] tag)
use @memcpy[Pointer[None]](dst: Pointer[None], src: Pointer[None], n: USize)

// PNG_EXPORT(int,png_sig_cmp) PNGARG((png_bytep sig, png_size_t start, png_size_t num_to_check));
use @png_sig_cmp[I32](sig:Pointer[U8] tag, start:USize, num_to_check:USize)

// PNG_EXPORT(png_structp,png_create_read_struct) PNGARG((png_const_charp user_png_ver, png_voidp error_ptr, png_error_ptr error_fn, png_error_ptr warn_fn)) PNG_ALLOCATED;
use @png_create_read_struct_2[Pointer[_PngStruct]](user_png_ver:Pointer[U8] tag, error_ptr:Pointer[None] tag, error_fn:Pointer[None] tag, warn_fn:Pointer[None] tag, mem_ptr:Pointer[None] tag, malloc_fn:Pointer[None] tag, free_fn:Pointer[None] tag)

// (png_const_charp user_png_ver, png_voidp error_ptr, png_error_ptr error_fn, png_error_ptr warn_fn, png_voidp mem_ptr, png_malloc_ptr malloc_fn, png_free_ptr free_fn)
use @png_create_write_struct_2[Pointer[_PngStruct]](user_png_ver:Pointer[U8] tag, error_ptr:Pointer[None] tag, error_fn:Pointer[None] tag, warn_fn:Pointer[None] tag, mem_ptr:Pointer[None] tag, malloc_fn:Pointer[None] tag, free_fn:Pointer[None] tag)

// PNG_EXPORT(png_infop,png_create_info_struct) PNGARG((png_structp png_ptr)) PNG_ALLOCATED;
use @png_create_info_struct[Pointer[_PngInfo]](png_ptr:Pointer[_PngStruct] tag)

// PNG_EXPORT(void,png_set_read_fn) PNGARG((png_structp png_ptr, png_voidp io_ptr, png_rw_ptr read_data_fn));
use @png_set_read_fn[None](png_ptr:Pointer[_PngStruct] tag, io_ptr:Pointer[None] tag, read_data_fn:Pointer[None] tag)

// PNG_EXPORT(void,png_set_write_fn) PNGARG((png_structp png_ptr, png_voidp io_ptr, png_rw_ptr write_data_fn, png_flush_ptr output_flush_fn));
use @png_set_write_fn[None](png_ptr:Pointer[_PngStruct] tag, io_ptr:Pointer[None] tag, write_data_fn:Pointer[None] tag, png_flush_ptr:Pointer[None] tag)

// PNG_EXPORT(png_voidp,png_get_io_ptr) PNGARG((png_structp png_ptr));
//use @png_get_io_ptr[Pointer[U8]](png_ptr:Pointer[_PngStruct] tag)

// PNG_EXPORT(void,png_set_sig_bytes) PNGARG((png_structp png_ptr, int num_bytes));
use @png_set_sig_bytes[None](png_ptr:Pointer[_PngStruct] tag, num_bytes:USize)

// PNG_EXPORT(void,png_read_info) PNGARG((png_structp png_ptr, png_infop info_ptr));
use @png_read_info[None](png_ptr:Pointer[_PngStruct] tag, info_ptr:Pointer[_PngInfo] tag)

use @png_get_bit_depth[USize](png_ptr:Pointer[_PngStruct] tag, info_ptr:Pointer[_PngInfo] tag)
use @png_get_channels[USize](png_ptr:Pointer[_PngStruct] tag, info_ptr:Pointer[_PngInfo] tag)
use @png_get_color_type[USize](png_ptr:Pointer[_PngStruct] tag, info_ptr:Pointer[_PngInfo] tag)

primitive _PngStruct
primitive _PngInfo
primitive _JmpBuf

primitive LIBPNG
	// Note: You might need to replace the png_libpng_ver_string with the value of PNG_LIBPNG_VER_STRING in your png.h
	fun png_libpng_ver_string():String => "1.6.37"
	fun png_sig_size():USize => 8
	
	fun png_color_mask_palette():USize => 1
	fun png_color_mask_color():USize => 2
	fun png_color_mask_alpha():USize => 4

	/* color types.  Note that not all combinations are legal */
	fun png_color_type_gray():USize => 0
	fun png_color_type_palette():USize => (png_color_mask_color() or png_color_mask_palette())
	fun png_color_type_rgb():USize => (png_color_mask_color())
	fun png_color_type_rgb_alpha():USize => (png_color_mask_color() or png_color_mask_alpha())
	fun png_color_type_gray_alpha():USize => (png_color_mask_alpha())
	/* aliases */
	fun png_color_type_rgba():USize => png_color_type_rgb_alpha()
	fun png_color_type_ga():USize => png_color_type_gray_alpha()
	
	fun png_info_trns():USize => 0x0010
	
	fun png_interlace_none():USize => 0
	fun png_interlace_adam7():USize => 1
	fun png_interlace_last():USize => 2

	fun png_compression_type_base():USize => 0
	fun png_compression_type_default():USize => png_compression_type_base()

	fun png_filter_type_base():USize => 0
	fun png_intrapixel_differencing():USize => 64
	fun png_filter_type_default():USize => png_filter_type_base()