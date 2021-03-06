#ifndef pony_app_h
#define pony_app_h

/* This is an auto-generated header file. Do not edit. */

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

#ifdef _MSC_VER
typedef struct __int128_t { uint64_t low; int64_t high; } __int128_t;
typedef struct __uint128_t { uint64_t low; uint64_t high; } __uint128_t;
#endif

typedef struct t3_t2_F32_val_F32_val_F32_val_F32_val t3_t2_F32_val_F32_val_F32_val_F32_val;

/*
y100 is move the target to z position 100
*/
typedef struct laba_LabaActionMoveZ laba_LabaActionMoveZ;

typedef struct ArrayPairs_U8_val_Array_U8_val_val ArrayPairs_U8_val_Array_U8_val_val;

typedef struct ui_$2$0 ui_$2$0;

typedef struct ui_NullEvent ui_NullEvent;

typedef struct ui_RGBA ui_RGBA;

/*
Contiguous, resizable memory to store elements of type A.

## Usage

Creating an Array of String:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  // array.size() == 3
  // array.space() >= 3
```

Creating an empty Array of String, which may hold at least 10 elements before
requesting more space:
```pony
  let array = Array[String](10)
  // array.size() == 0
  // array.space() >= 10
```

Accessing elements can be done via the `apply(i: USize): this->A ?` method.
The provided index might be out of bounds so `apply` is partial and has to be
called within a try-catch block or inside another partial method:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  let is_second_element_wobat = try
    // indexes start from 0, so 1 is the second element
    array(1)? == "wombat"
  else
    false
  end
```

Adding and removing elements to and from the end of the Array can be done via
`push` and `pop` methods. You could treat the array as a LIFO stack using
those methods:
```pony
  while (array.size() > 0) do
    let elem = array.pop()?
    // do something with element
  end
```

Modifying the Array can be done via `update`, `insert` and `delete` methods
which alter the Array at an arbitrary index, moving elements left (when
deleting) or right (when inserting) as necessary.

Iterating over the elements of an Array can be done using the `values` method:
```pony
  for element in array.values() do
      // do something with element
  end
```

## Memory allocation
Array allocates contiguous memory. It always allocates at least enough memory
space to hold all of its elements. Space is the number of elements the Array
can hold without allocating more memory. The `space()` method returns the
number of elements an Array can hold. The `size()` method returns the number
of elements the Array holds.

Different data types require different amounts of memory. Array[U64] with size
of 6 will take more memory than an Array[U8] of the same size.

When creating an Array or adding more elements will calculate the next power
of 2 of the requested number of elements and allocate that much space, with a
lower bound of space for 8 elements.

Here's a few examples of the space allocated when initialising an Array with
various number of elements:

| size | space |
|------|-------|
| 0    | 0     |
| 1    | 8     |
| 8    | 8     |
| 9    | 16    |
| 16   | 16    |
| 17   | 32    |

Call the `compact()` method to ask the GC to reclaim unused space. There are
no guarantees that the GC will actually reclaim any space.
*/
typedef struct Array_String_val Array_String_val;

/*
A quadratic probing hash map. Resize occurs at a load factor of 0.75. A
resized map has 2 times the space. The hash function can be plugged in to the
type to create different kinds of maps.
*/
typedef struct collections_HashMap_String_val_apple_$33$0_val_collections_HashEq_String_val_val collections_HashMap_String_val_apple_$33$0_val_collections_HashEq_String_val_val;

typedef struct t2_USize_val_Bool_val t2_USize_val_Bool_val;

/*
The readable interface of a sequence.
*/
typedef struct ReadSeq_U8_val ReadSeq_U8_val;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct format_PrefixSpace format_PrefixSpace;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct u2_ui_YogaNode_ref_None_val u2_ui_YogaNode_ref_None_val;

typedef struct ui_Viewable ui_Viewable;

typedef struct format_FormatHexSmallBare format_FormatHexSmallBare;

typedef struct u2_laba_$26$0_box_None_val u2_laba_$26$0_box_None_val;

/*
w100 is animate the high to 100 units wide
!w100 is animate the high from 100 units wide to the current high
*/
typedef struct laba_LabaActionHeight laba_LabaActionHeight;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct PlatformOSX PlatformOSX;

typedef struct u3_format_AlignLeft_val_format_AlignRight_val_format_AlignCenter_val u3_format_AlignLeft_val_format_AlignRight_val_format_AlignCenter_val;

typedef struct $0$16_laba_Laba_ref $0$16_laba_Laba_ref;

typedef struct format_FormatBinary format_FormatBinary;

typedef struct ui_$2$42 ui_$2$42;

/*
This type represents the root capability. When a Pony program starts, the
Env passed to the Main actor contains an instance of the root capability.

Ambient access to the root capability is denied outside of the builtin
package. Inside the builtin package, only Env creates a Root.

The root capability can be used by any package that wants to establish a
principle of least authority. A typical usage is to have a parameter on a
constructor for some resource that expects a limiting capability specific to
the package, but will also accept the root capability as representing
unlimited access.
*/
typedef struct AmbientAuth AmbientAuth;

typedef struct laba_LabaActionGroup laba_LabaActionGroup;

/*
tuple based Vector 4 functions - see VectorFun for details*/
typedef struct linal_V4fun linal_V4fun;

typedef struct format_PrefixSign format_PrefixSign;

/*
^100 is move the target 100 units up
v100 is move the target 100 units down
y100 is move the target to y position 100
*/
typedef struct laba_LabaActionMoveY laba_LabaActionMoveY;

typedef struct $0$8_laba_Laba_ref $0$8_laba_Laba_ref;

typedef struct format_AlignLeft format_AlignLeft;

typedef struct t4_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val t4_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val;

/*
tuple based Vector 2 functions - see VectorFun for details*/
typedef struct linal_V2fun linal_V2fun;

typedef struct ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_val ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_val;

typedef struct _SignedPartialArithmetic _SignedPartialArithmetic;

typedef struct format_AlignRight format_AlignRight;

typedef struct stringext_StringParser stringext_StringParser;

typedef struct u2_apple_$33$0_val_None_val u2_apple_$33$0_val_None_val;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct t2_String_val_apple_$33$0_val t2_String_val_apple_$33$0_val;

/*
Worker type providing simple to string conversions for numbers.
*/
typedef struct _ToString _ToString;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box;

typedef struct $0$9_U8_val $0$9_U8_val;

typedef struct format_FormatHexSmall format_FormatHexSmall;

typedef struct t4_F32_val_F32_val_F32_val_F32_val t4_F32_val_F32_val_F32_val_F32_val;

typedef struct collections__MapEmpty collections__MapEmpty;

/*
Contiguous, resizable memory to store elements of type A.

## Usage

Creating an Array of String:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  // array.size() == 3
  // array.space() >= 3
```

Creating an empty Array of String, which may hold at least 10 elements before
requesting more space:
```pony
  let array = Array[String](10)
  // array.size() == 0
  // array.space() >= 10
```

Accessing elements can be done via the `apply(i: USize): this->A ?` method.
The provided index might be out of bounds so `apply` is partial and has to be
called within a try-catch block or inside another partial method:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  let is_second_element_wobat = try
    // indexes start from 0, so 1 is the second element
    array(1)? == "wombat"
  else
    false
  end
```

Adding and removing elements to and from the end of the Array can be done via
`push` and `pop` methods. You could treat the array as a LIFO stack using
those methods:
```pony
  while (array.size() > 0) do
    let elem = array.pop()?
    // do something with element
  end
```

Modifying the Array can be done via `update`, `insert` and `delete` methods
which alter the Array at an arbitrary index, moving elements left (when
deleting) or right (when inserting) as necessary.

Iterating over the elements of an Array can be done using the `values` method:
```pony
  for element in array.values() do
      // do something with element
  end
```

## Memory allocation
Array allocates contiguous memory. It always allocates at least enough memory
space to hold all of its elements. Space is the number of elements the Array
can hold without allocating more memory. The `space()` method returns the
number of elements an Array can hold. The `size()` method returns the number
of elements the Array holds.

Different data types require different amounts of memory. Array[U64] with size
of 6 will take more memory than an Array[U8] of the same size.

When creating an Array or adding more elements will calculate the next power
of 2 of the requested number of elements and allocate that much space, with a
lower bound of space for 8 elements.

Here's a few examples of the space allocated when initialising an Array with
various number of elements:

| size | space |
|------|-------|
| 0    | 0     |
| 1    | 8     |
| 8    | 8     |
| 9    | 16    |
| 16   | 16    |
| 17   | 32    |

Call the `compact()` method to ask the GC to reclaim unused space. There are
no guarantees that the GC will actually reclaim any space.
*/
typedef struct Array_laba_LabaAction_ref Array_laba_LabaAction_ref;

/*
Like AlignedArray, but optimized for floating point geomtry submission
*/
typedef struct ui_FloatAlignedArray ui_FloatAlignedArray;

typedef struct ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref;

typedef struct format_FormatOctal format_FormatOctal;

/*
Contiguous, resizable memory to store elements of type A.

## Usage

Creating an Array of String:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  // array.size() == 3
  // array.space() >= 3
```

Creating an empty Array of String, which may hold at least 10 elements before
requesting more space:
```pony
  let array = Array[String](10)
  // array.size() == 0
  // array.space() >= 10
```

Accessing elements can be done via the `apply(i: USize): this->A ?` method.
The provided index might be out of bounds so `apply` is partial and has to be
called within a try-catch block or inside another partial method:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  let is_second_element_wobat = try
    // indexes start from 0, so 1 is the second element
    array(1)? == "wombat"
  else
    false
  end
```

Adding and removing elements to and from the end of the Array can be done via
`push` and `pop` methods. You could treat the array as a LIFO stack using
those methods:
```pony
  while (array.size() > 0) do
    let elem = array.pop()?
    // do something with element
  end
```

Modifying the Array can be done via `update`, `insert` and `delete` methods
which alter the Array at an arbitrary index, moving elements left (when
deleting) or right (when inserting) as necessary.

Iterating over the elements of an Array can be done using the `values` method:
```pony
  for element in array.values() do
      // do something with element
  end
```

## Memory allocation
Array allocates contiguous memory. It always allocates at least enough memory
space to hold all of its elements. Space is the number of elements the Array
can hold without allocating more memory. The `space()` method returns the
number of elements an Array can hold. The `size()` method returns the number
of elements the Array holds.

Different data types require different amounts of memory. Array[U64] with size
of 6 will take more memory than an Array[U8] of the same size.

When creating an Array or adding more elements will calculate the next power
of 2 of the requested number of elements and allocate that much space, with a
lower bound of space for 8 elements.

Here's a few examples of the space allocated when initialising an Array with
various number of elements:

| size | space |
|------|-------|
| 0    | 0     |
| 1    | 8     |
| 8    | 8     |
| 9    | 16    |
| 16   | 16    |
| 17   | 32    |

Call the `compact()` method to ask the GC to reclaim unused space. There are
no guarantees that the GC will actually reclaim any space.
*/
typedef struct Array_U8_val Array_U8_val;

typedef struct ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_box ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_box;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct laba_$26$0 laba_$26$0;

/*
Asnychronous access to some output stream.
*/
typedef struct OutStream OutStream;

/*
functions for a 4x4 matrix*/
typedef struct linal_M4fun linal_M4fun;

typedef struct $0$12_U32_val $0$12_U32_val;

typedef struct $0$6 $0$6;

typedef struct u2_ui_Controllerable_tag_None_val u2_ui_Controllerable_tag_None_val;

typedef struct ui_RenderNeeded ui_RenderNeeded;

typedef struct _UnsignedPartialArithmetic _UnsignedPartialArithmetic;

typedef struct format_PrefixDefault format_PrefixDefault;

/*
Stores and then simulates changes to target animatable properties over time
*/
typedef struct laba_LabaTarget laba_LabaTarget;

typedef struct u2_String_val_None_val u2_String_val_None_val;

/*
Contiguous, resizable memory to store elements of type A.

## Usage

Creating an Array of String:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  // array.size() == 3
  // array.space() >= 3
```

Creating an empty Array of String, which may hold at least 10 elements before
requesting more space:
```pony
  let array = Array[String](10)
  // array.size() == 0
  // array.space() >= 10
```

Accessing elements can be done via the `apply(i: USize): this->A ?` method.
The provided index might be out of bounds so `apply` is partial and has to be
called within a try-catch block or inside another partial method:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  let is_second_element_wobat = try
    // indexes start from 0, so 1 is the second element
    array(1)? == "wombat"
  else
    false
  end
```

Adding and removing elements to and from the end of the Array can be done via
`push` and `pop` methods. You could treat the array as a LIFO stack using
those methods:
```pony
  while (array.size() > 0) do
    let elem = array.pop()?
    // do something with element
  end
```

Modifying the Array can be done via `update`, `insert` and `delete` methods
which alter the Array at an arbitrary index, moving elements left (when
deleting) or right (when inserting) as necessary.

Iterating over the elements of an Array can be done using the `values` method:
```pony
  for element in array.values() do
      // do something with element
  end
```

## Memory allocation
Array allocates contiguous memory. It always allocates at least enough memory
space to hold all of its elements. Space is the number of elements the Array
can hold without allocating more memory. The `space()` method returns the
number of elements an Array can hold. The `size()` method returns the number
of elements the Array holds.

Different data types require different amounts of memory. Array[U64] with size
of 6 will take more memory than an Array[U8] of the same size.

When creating an Array or adding more elements will calculate the next power
of 2 of the requested number of elements and allocate that much space, with a
lower bound of space for 8 elements.

Here's a few examples of the space allocated when initialising an Array with
various number of elements:

| size | space |
|------|-------|
| 0    | 0     |
| 1    | 8     |
| 8    | 8     |
| 9    | 16    |
| 16   | 16    |
| 17   | 32    |

Call the `compact()` method to ask the GC to reclaim unused space. There are
no guarantees that the GC will actually reclaim any space.
*/
typedef struct Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val;

/*
Things that can be turned into a String.
*/
typedef struct Stringable Stringable;

typedef struct t2_ISize_val_USize_val t2_ISize_val_USize_val;

/*
Asynchronous access to some input stream.
*/
typedef struct InputStream InputStream;

typedef struct ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref;

typedef struct _UTF32Encoder _UTF32Encoder;

typedef struct ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_val ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_val;

typedef struct u2_ui_RenderEngine_tag_None_val u2_ui_RenderEngine_tag_None_val;

/*
An environment holds the command line and other values injected into the
program by default by the runtime.
*/
typedef struct Env Env;

/*
tuple based Vector 3 functions - see VectorFun for details*/
typedef struct linal_V3fun linal_V3fun;

typedef struct u2_ui_$2$0_val_None_val u2_ui_$2$0_val_None_val;

/*
A UnsafePointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. UnsafePointer[A]
is exactly like Pointer[A] except none of the method are private, allowing the Pony developer
the freedom to use unsafe pointer capabilities if they so choose.
*/
typedef struct ui_$2$43 ui_$2$43;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct u10_format_FormatDefault_val_format_FormatUTF32_val_format_FormatBinary_val_format_FormatBinaryBare_val_format_FormatOctal_val_format_FormatOctalBare_val_format_FormatHex_val_format_FormatHexBare_val_format_FormatHexSmall_val_format_FormatHexSmallBare_val u10_format_FormatDefault_val_format_FormatUTF32_val_format_FormatBinary_val_format_FormatBinaryBare_val_format_FormatOctal_val_format_FormatOctalBare_val_format_FormatHex_val_format_FormatHexBare_val_format_FormatHexSmall_val_format_FormatHexSmallBare_val;

typedef struct format_FormatHex format_FormatHex;

typedef struct t2_USize_val_USize_val t2_USize_val_USize_val;

/*
Contiguous, resizable memory to store elements of type A.

## Usage

Creating an Array of String:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  // array.size() == 3
  // array.space() >= 3
```

Creating an empty Array of String, which may hold at least 10 elements before
requesting more space:
```pony
  let array = Array[String](10)
  // array.size() == 0
  // array.space() >= 10
```

Accessing elements can be done via the `apply(i: USize): this->A ?` method.
The provided index might be out of bounds so `apply` is partial and has to be
called within a try-catch block or inside another partial method:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  let is_second_element_wobat = try
    // indexes start from 0, so 1 is the second element
    array(1)? == "wombat"
  else
    false
  end
```

Adding and removing elements to and from the end of the Array can be done via
`push` and `pop` methods. You could treat the array as a LIFO stack using
those methods:
```pony
  while (array.size() > 0) do
    let elem = array.pop()?
    // do something with element
  end
```

Modifying the Array can be done via `update`, `insert` and `delete` methods
which alter the Array at an arbitrary index, moving elements left (when
deleting) or right (when inserting) as necessary.

Iterating over the elements of an Array can be done using the `values` method:
```pony
  for element in array.values() do
      // do something with element
  end
```

## Memory allocation
Array allocates contiguous memory. It always allocates at least enough memory
space to hold all of its elements. Space is the number of elements the Array
can hold without allocating more memory. The `space()` method returns the
number of elements an Array can hold. The `size()` method returns the number
of elements the Array holds.

Different data types require different amounts of memory. Array[U64] with size
of 6 will take more memory than an Array[U8] of the same size.

When creating an Array or adding more elements will calculate the next power
of 2 of the requested number of elements and allocate that much space, with a
lower bound of space for 8 elements.

Here's a few examples of the space allocated when initialising an Array with
various number of elements:

| size | space |
|------|-------|
| 0    | 0     |
| 1    | 8     |
| 8    | 8     |
| 9    | 16    |
| 16   | 16    |
| 17   | 32    |

Call the `compact()` method to ask the GC to reclaim unused space. There are
no guarantees that the GC will actually reclaim any space.
*/
typedef struct Array_ui_Viewable_tag Array_ui_Viewable_tag;

typedef struct ArrayPairs_U8_val_Array_U8_val_ref ArrayPairs_U8_val_Array_U8_val_ref;

typedef struct format_FormatUTF32 format_FormatUTF32;

typedef struct StringRunes StringRunes;

typedef struct format_AlignCenter format_AlignCenter;

typedef struct yoga_YGNode yoga_YGNode;

/*
w100 is animate the width to 100 units wide
!w100 is animate the width from 100 units wide to the current width
*/
typedef struct laba_LabaActionWidth laba_LabaActionWidth;

typedef struct ui_RenderContext ui_RenderContext;

/*
Memory allocations for large amounts of geometry can get expensive. So the ideal circumstance is we allocate it once and it can be
used by the native renderer without any copying required. To do this and allow multiple frames to be rendered simultaneously (ie
the buffer is being used by the renderer for the previous frame while we are filling it out for the next frame) we need to
have a rotating system of buffers.  This class facilitates that.
*/
typedef struct ui_BufferedGeometry ui_BufferedGeometry;

typedef struct apple_URLDownload apple_URLDownload;

typedef struct t3_F32_val_F32_val_F32_val t3_F32_val_F32_val_F32_val;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
/*
One unit of geometry. Hash needs to uniquely represent the buffered content in order to allow for reuse of geometric
data if nothing has changed
*/
typedef struct ui_Geometry ui_Geometry;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct u3_format_PrefixDefault_val_format_PrefixSpace_val_format_PrefixSign_val u3_format_PrefixDefault_val_format_PrefixSpace_val_format_PrefixSign_val;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref;

typedef struct utility_Log utility_Log;

/*
Provides functions for generating formatted strings.

* fmt. Format to use.
* prefix. Prefix to use.
* prec. Precision to use. The exact meaning of this depends on the type,
but is generally the number of characters used for all, or part, of the
string. A value of -1 indicates that the default for the type should be
used.
* width. The minimum number of characters that will be in the produced
string. If necessary the string will be padded with the fill character to
make it long enough.
*align. Specify whether fill characters should be added at the beginning or
end of the generated string, or both.
*fill: The character to pad a string with if is is shorter than width.
*/
typedef struct format_Format format_Format;

typedef struct None None;

typedef struct u2_laba_LabaAction_ref_None_val u2_laba_LabaAction_ref_None_val;

typedef struct t2_U64_val_Bool_val t2_U64_val_Bool_val;

typedef struct ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_box ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_box;

/*
Worker type providing to string conversions for integers.
*/
typedef struct format__FormatInt format__FormatInt;

/*
Contiguous, resizable memory to store elements of type A.

## Usage

Creating an Array of String:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  // array.size() == 3
  // array.space() >= 3
```

Creating an empty Array of String, which may hold at least 10 elements before
requesting more space:
```pony
  let array = Array[String](10)
  // array.size() == 0
  // array.space() >= 10
```

Accessing elements can be done via the `apply(i: USize): this->A ?` method.
The provided index might be out of bounds so `apply` is partial and has to be
called within a try-catch block or inside another partial method:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  let is_second_element_wobat = try
    // indexes start from 0, so 1 is the second element
    array(1)? == "wombat"
  else
    false
  end
```

Adding and removing elements to and from the end of the Array can be done via
`push` and `pop` methods. You could treat the array as a LIFO stack using
those methods:
```pony
  while (array.size() > 0) do
    let elem = array.pop()?
    // do something with element
  end
```

Modifying the Array can be done via `update`, `insert` and `delete` methods
which alter the Array at an arbitrary index, moving elements left (when
deleting) or right (when inserting) as necessary.

Iterating over the elements of an Array can be done using the `values` method:
```pony
  for element in array.values() do
      // do something with element
  end
```

## Memory allocation
Array allocates contiguous memory. It always allocates at least enough memory
space to hold all of its elements. Space is the number of elements the Array
can hold without allocating more memory. The `space()` method returns the
number of elements an Array can hold. The `size()` method returns the number
of elements the Array holds.

Different data types require different amounts of memory. Array[U64] with size
of 6 will take more memory than an Array[U8] of the same size.

When creating an Array or adding more elements will calculate the next power
of 2 of the requested number of elements and allocate that much space, with a
lower bound of space for 8 elements.

Here's a few examples of the space allocated when initialising an Array with
various number of elements:

| size | space |
|------|-------|
| 0    | 0     |
| 1    | 8     |
| 8    | 8     |
| 9    | 16    |
| 16   | 16    |
| 17   | 32    |

Call the `compact()` method to ask the GC to reclaim unused space. There are
no guarantees that the GC will actually reclaim any space.
*/
typedef struct Array_laba_LabaActionGroup_ref Array_laba_LabaActionGroup_ref;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
/*
The render engine is responsible for sending "renderable chunks" across the FFI to the 3D engine
one whatever platform we are on. A renderable chunk consists of
1. all geometric data, already transformed and ready to render
2. information regarding what shader it should be rendered with
3. information regarding what textures should be active for its rendering

For each frame of the rendering, the render engine is responsible for passing these 
chunks across the FFI. Each chunk is tagged with a unique frame number. The frame
number allows the Pony render engine and the platform render engine to run
completely independently of each other.

Each series of renderable chunks must end with the "end chunk", which lets the
platform render engine know that all of the rendering for this frame has been
completed.

In our view hierarchy, the render engine can be seen as the "root" view under
which all renderable views are placed. The render engine's bounds alway match
the renderable area of the "window" it is in.

The view hierarchy built using yoga nodes. Each yoga node has a View actor 
associated with it. The render engine stores the entirety of the yoga
hierarchy.

This has the distinct advantage that when rendering needs to happen,
the render engine can iterate quickly over all nodes and ask their
actors to render themselves. The render engine then knows exactly how
many actors it should expect to hear from to know that all rendering
for this frame has been completed.

View inherently know nothing about how they are laid out. They are
simply told to render in a Rect, and they need to do that to the
best of their ability.

YogaNodes are responsible for supplying information about how their
associated view should be laid out.
*/
typedef struct ui_RenderEngine ui_RenderEngine;

typedef struct ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_val ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_val;

typedef struct PonyPlatform PonyPlatform;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct t5_USize_val_U8_val_U8_val_U8_val_U8_val t5_USize_val_U8_val_U8_val_U8_val_U8_val;

typedef struct PlatformIOS PlatformIOS;

/*
<100 is move the target 100 units to the left
>100 is move the target 100 units to the right
x100 is move the target to x position 100
*/
typedef struct laba_LabaActionMoveX laba_LabaActionMoveX;

/*
  A String is an ordered collection of characters.

  Strings don't specify an encoding.

  Example usage of some common String methods:

```pony
actor Main
  new create(env: Env) =>
    try
      // construct a new string
      let str = "Hello"

      // make an uppercased version
      let str_upper = str.upper()
      // make a reversed version
      let str_reversed = str.reverse()

      // add " world" to the end of our original string
      let str_new = str.add(" world")

      // count occurrences of letter "l"
      let count = str_new.count("l")

      // find first occurrence of letter "w"
      let first_w = str_new.find("w")
      // find first occurrence of letter "d"
      let first_d = str_new.find("d")

      // get substring capturing "world"
      let substr = str_new.substring(first_w, first_d+1)
      // clone substring
      let substr_clone = substr.clone()

      // print our substr
      env.out.print(consume substr)
  end
```
*/
typedef struct String String;

typedef struct t2_F32_val_F32_val t2_F32_val_F32_val;

typedef struct ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_box ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_box;

typedef struct ui_Controllerable ui_Controllerable;

/*
Contiguous, resizable memory to store elements of type A.

## Usage

Creating an Array of String:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  // array.size() == 3
  // array.space() >= 3
```

Creating an empty Array of String, which may hold at least 10 elements before
requesting more space:
```pony
  let array = Array[String](10)
  // array.size() == 0
  // array.space() >= 10
```

Accessing elements can be done via the `apply(i: USize): this->A ?` method.
The provided index might be out of bounds so `apply` is partial and has to be
called within a try-catch block or inside another partial method:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  let is_second_element_wobat = try
    // indexes start from 0, so 1 is the second element
    array(1)? == "wombat"
  else
    false
  end
```

Adding and removing elements to and from the end of the Array can be done via
`push` and `pop` methods. You could treat the array as a LIFO stack using
those methods:
```pony
  while (array.size() > 0) do
    let elem = array.pop()?
    // do something with element
  end
```

Modifying the Array can be done via `update`, `insert` and `delete` methods
which alter the Array at an arbitrary index, moving elements left (when
deleting) or right (when inserting) as necessary.

Iterating over the elements of an Array can be done using the `values` method:
```pony
  for element in array.values() do
      // do something with element
  end
```

## Memory allocation
Array allocates contiguous memory. It always allocates at least enough memory
space to hold all of its elements. Space is the number of elements the Array
can hold without allocating more memory. The `space()` method returns the
number of elements an Array can hold. The `size()` method returns the number
of elements the Array holds.

Different data types require different amounts of memory. Array[U64] with size
of 6 will take more memory than an Array[U8] of the same size.

When creating an Array or adding more elements will calculate the next power
of 2 of the requested number of elements and allocate that much space, with a
lower bound of space for 8 elements.

Here's a few examples of the space allocated when initialising an Array with
various number of elements:

| size | space |
|------|-------|
| 0    | 0     |
| 1    | 8     |
| 8    | 8     |
| 9    | 16    |
| 16   | 16    |
| 17   | 32    |

Call the `compact()` method to ask the GC to reclaim unused space. There are
no guarantees that the GC will actually reclaim any space.
*/
typedef struct Array_ui_YogaNode_ref Array_ui_YogaNode_ref;

typedef struct ui_LayoutNeeded ui_LayoutNeeded;

typedef struct ui_SafeEdges ui_SafeEdges;

/*
Z axis rotation
r0.8 is rotate to 0.8 scale
!r0.8 is animate from 0.8 scale to the current scale
*/
typedef struct laba_LabaActionRoll laba_LabaActionRoll;

typedef struct u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val;

typedef struct u2_Array_U8_val_val_String_val u2_Array_U8_val_val_String_val;

typedef struct linal_Q4fun linal_Q4fun;

/*
linear functions and helpers for linal types
*/
typedef struct linal_Linear linal_Linear;

typedef struct t2_U32_val_U8_val t2_U32_val_U8_val;

typedef struct apple_$33$0 apple_$33$0;

typedef struct u3_None_val_ui_LayoutNeeded_val_ui_RenderNeeded_val u3_None_val_ui_LayoutNeeded_val_ui_RenderNeeded_val;

typedef struct format_FormatDefault format_FormatDefault;

typedef struct collections_HashEq_String_val collections_HashEq_String_val;

typedef struct ui_FrameContext ui_FrameContext;

/*
Contiguous, resizable memory to store elements of type A.

## Usage

Creating an Array of String:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  // array.size() == 3
  // array.space() >= 3
```

Creating an empty Array of String, which may hold at least 10 elements before
requesting more space:
```pony
  let array = Array[String](10)
  // array.size() == 0
  // array.space() >= 10
```

Accessing elements can be done via the `apply(i: USize): this->A ?` method.
The provided index might be out of bounds so `apply` is partial and has to be
called within a try-catch block or inside another partial method:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  let is_second_element_wobat = try
    // indexes start from 0, so 1 is the second element
    array(1)? == "wombat"
  else
    false
  end
```

Adding and removing elements to and from the end of the Array can be done via
`push` and `pop` methods. You could treat the array as a LIFO stack using
those methods:
```pony
  while (array.size() > 0) do
    let elem = array.pop()?
    // do something with element
  end
```

Modifying the Array can be done via `update`, `insert` and `delete` methods
which alter the Array at an arbitrary index, moving elements left (when
deleting) or right (when inserting) as necessary.

Iterating over the elements of an Array can be done using the `values` method:
```pony
  for element in array.values() do
      // do something with element
  end
```

## Memory allocation
Array allocates contiguous memory. It always allocates at least enough memory
space to hold all of its elements. Space is the number of elements the Array
can hold without allocating more memory. The `space()` method returns the
number of elements an Array can hold. The `size()` method returns the number
of elements the Array holds.

Different data types require different amounts of memory. Array[U64] with size
of 6 will take more memory than an Array[U8] of the same size.

When creating an Array or adding more elements will calculate the next power
of 2 of the requested number of elements and allocate that much space, with a
lower bound of space for 8 elements.

Here's a few examples of the space allocated when initialising an Array with
various number of elements:

| size | space |
|------|-------|
| 0    | 0     |
| 1    | 8     |
| 8    | 8     |
| 9    | 16    |
| 16   | 16    |
| 17   | 32    |

Call the `compact()` method to ask the GC to reclaim unused space. There are
no guarantees that the GC will actually reclaim any space.
*/
typedef struct Array_U32_val Array_U32_val;

typedef struct ui_ScrollEvent ui_ScrollEvent;

typedef struct ui_YogaNode ui_YogaNode;

/*
An UUID. Currently it can be used to generate UUIDs of versions 3, 4 and 5.

```
use uuid = "uuid"

actor Main
  new create(env: Env) =>
    let id = uuid.UUID.v4()
    env.out.print(id.string())
```
*/
typedef struct utility_UUID utility_UUID;

typedef struct ui_TouchEvent ui_TouchEvent;

/*
X axis rotation
p0.8 is rotate by 0.8 scale
!p0.8 is animate from 0.8 scale to the current scale
*/
typedef struct laba_LabaActionPitch laba_LabaActionPitch;

typedef struct format_FormatHexBare format_FormatHexBare;

typedef struct ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref;

typedef struct $0$9_U32_val $0$9_U32_val;

typedef struct ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val;

/*
Parses a Laba animation string into groups of Laba actions and effectuates the
actual animation process (an outside entity calls animate with timing deltas)
*/
typedef struct laba_Laba laba_Laba;

typedef struct collections__MapDeleted collections__MapDeleted;

/*
Contiguous, resizable memory to store elements of type A.

## Usage

Creating an Array of String:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  // array.size() == 3
  // array.space() >= 3
```

Creating an empty Array of String, which may hold at least 10 elements before
requesting more space:
```pony
  let array = Array[String](10)
  // array.size() == 0
  // array.space() >= 10
```

Accessing elements can be done via the `apply(i: USize): this->A ?` method.
The provided index might be out of bounds so `apply` is partial and has to be
called within a try-catch block or inside another partial method:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  let is_second_element_wobat = try
    // indexes start from 0, so 1 is the second element
    array(1)? == "wombat"
  else
    false
  end
```

Adding and removing elements to and from the end of the Array can be done via
`push` and `pop` methods. You could treat the array as a LIFO stack using
those methods:
```pony
  while (array.size() > 0) do
    let elem = array.pop()?
    // do something with element
  end
```

Modifying the Array can be done via `update`, `insert` and `delete` methods
which alter the Array at an arbitrary index, moving elements left (when
deleting) or right (when inserting) as necessary.

Iterating over the elements of an Array can be done using the `values` method:
```pony
  for element in array.values() do
      // do something with element
  end
```

## Memory allocation
Array allocates contiguous memory. It always allocates at least enough memory
space to hold all of its elements. Space is the number of elements the Array
can hold without allocating more memory. The `space()` method returns the
number of elements an Array can hold. The `size()` method returns the number
of elements the Array holds.

Different data types require different amounts of memory. Array[U64] with size
of 6 will take more memory than an Array[U8] of the same size.

When creating an Array or adding more elements will calculate the next power
of 2 of the requested number of elements and allocate that much space, with a
lower bound of space for 8 elements.

Here's a few examples of the space allocated when initialising an Array with
various number of elements:

| size | space |
|------|-------|
| 0    | 0     |
| 1    | 8     |
| 8    | 8     |
| 9    | 16    |
| 16   | 16    |
| 17   | 32    |

Call the `compact()` method to ask the GC to reclaim unused space. There are
no guarantees that the GC will actually reclaim any space.
*/
typedef struct Array_laba_Laba_ref Array_laba_Laba_ref;

typedef struct ArrayPairs_U8_val_Array_U8_val_box ArrayPairs_U8_val_Array_U8_val_box;

/*
Rendering actors can call this concurrently safely to submit geometry to the platform rendering engine
*/
typedef struct ui_RenderPrimitive ui_RenderPrimitive;

typedef struct t3_U32_val_String_val_String_val t3_U32_val_String_val_String_val;

typedef struct ui_KeyEvent ui_KeyEvent;

/*
Y axis rotation
a0.8 is rotate by 0.8 scale
!a0.8 is animate from 0.8 scale to the current scale
*/
typedef struct laba_LabaActionYaw laba_LabaActionYaw;

/*
s0.8 is animate to 0.8 scale
!s0.8 is animate from 0.8 scale to the current scale
*/
typedef struct laba_LabaActionScale laba_LabaActionScale;

typedef struct utility_Size utility_Size;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct $0$12_U8_val $0$12_U8_val;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct easings_Easing_F32_val easings_Easing_F32_val;

typedef struct u4_ui_NullEvent_val_ui_TouchEvent_val_ui_ScrollEvent_val_ui_KeyEvent_val u4_ui_NullEvent_val_ui_TouchEvent_val_ui_ScrollEvent_val_ui_KeyEvent_val;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct u2_String_box_Array_U8_val_box u2_String_box_Array_U8_val_box;

/*
f0 is fade the alpha from current value to zero
f1 is fade the alpha from current value to one
!f is fade alpha from zero to current value
*/
typedef struct laba_LabaActionFade laba_LabaActionFade;

typedef struct t2_ISize_val_Bool_val t2_ISize_val_Bool_val;

/*
Produces `[min, max)` with a step of `inc` for any `Number` type.

```pony
// iterating with for-loop
for i in Range(0, 10) do
  env.out.print(i.string())
end

// iterating over Range of U8 with while-loop
let range = Range[U8](5, 100, 5)
while range.has_next() do
  handle_u8(range.next())
end
```

Supports `min` being smaller than `max` with negative `inc`
but only for signed integer types and floats:

```pony
var previous = 11
for left in Range[I64](10, -5, -1) do
  if not (left < previous) then
    error
  end
  previous = left
end
```

If the `step` is not moving `min` towards `max` or if it is `0`,
the Range is considered infinite and iterating over it
will never terminate:

```pony
let infinite_range1 = Range(0, 1, 0)
infinite_range1.is_infinite() == true

let infinite_range2 = Range[I8](0, 10, -1)
for _ in infinite_range2 do
  env.out.print("will this ever end?")
  env.err.print("no, never!")
end
```

When using `Range` with  floating point types (`F32` and `F64`)
`inc` steps < 1.0 are possible. If any of the arguments contains
`NaN`, `+Inf` or `-Inf` the range is considered infinite as operations on
any of them won't move `min` towards `max`.
The actual values produced by such a `Range` are determined by what IEEE 754
defines as the result of `min` + `inc`:

```pony
for and_a_half in Range[F64](0.5, 100) do
  handle_half(and_a_half)
end

// this Range will produce 0 at first, then infinitely NaN
let nan: F64 = F64(0) / F64(0)
for what_am_i in Range[F64](0, 1000, nan) do
  wild_guess(what_am_i)
end
```

*/
typedef struct collections_Range_USize_val collections_Range_USize_val;

typedef struct t2_USize_val_U8_val t2_USize_val_U8_val;

typedef struct stringext_StringExt stringext_StringExt;

typedef struct u2_AmbientAuth_val_None_val u2_AmbientAuth_val_None_val;

/*
actions are animatable commands. All of them store their from and to values, and provide the
interpolated animation value using the easing function provided
*/
typedef struct laba_LabaAction laba_LabaAction;

typedef struct apple_Memory apple_Memory;

/*
Contiguous, resizable memory to store elements of type A.

## Usage

Creating an Array of String:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  // array.size() == 3
  // array.space() >= 3
```

Creating an empty Array of String, which may hold at least 10 elements before
requesting more space:
```pony
  let array = Array[String](10)
  // array.size() == 0
  // array.space() >= 10
```

Accessing elements can be done via the `apply(i: USize): this->A ?` method.
The provided index might be out of bounds so `apply` is partial and has to be
called within a try-catch block or inside another partial method:
```pony
  let array: Array[String] = ["dog"; "cat"; "wombat"]
  let is_second_element_wobat = try
    // indexes start from 0, so 1 is the second element
    array(1)? == "wombat"
  else
    false
  end
```

Adding and removing elements to and from the end of the Array can be done via
`push` and `pop` methods. You could treat the array as a LIFO stack using
those methods:
```pony
  while (array.size() > 0) do
    let elem = array.pop()?
    // do something with element
  end
```

Modifying the Array can be done via `update`, `insert` and `delete` methods
which alter the Array at an arbitrary index, moving elements left (when
deleting) or right (when inserting) as necessary.

Iterating over the elements of an Array can be done using the `values` method:
```pony
  for element in array.values() do
      // do something with element
  end
```

## Memory allocation
Array allocates contiguous memory. It always allocates at least enough memory
space to hold all of its elements. Space is the number of elements the Array
can hold without allocating more memory. The `space()` method returns the
number of elements an Array can hold. The `size()` method returns the number
of elements the Array holds.

Different data types require different amounts of memory. Array[U64] with size
of 6 will take more memory than an Array[U8] of the same size.

When creating an Array or adding more elements will calculate the next power
of 2 of the requested number of elements and allocate that much space, with a
lower bound of space for 8 elements.

Here's a few examples of the space allocated when initialising an Array with
various number of elements:

| size | space |
|------|-------|
| 0    | 0     |
| 1    | 8     |
| 8    | 8     |
| 9    | 16    |
| 16   | 16    |
| 17   | 32    |

Call the `compact()` method to ask the GC to reclaim unused space. There are
no guarantees that the GC will actually reclaim any space.
*/
typedef struct Array_ui_Geometry_ref Array_ui_Geometry_ref;

typedef struct format_FormatBinaryBare format_FormatBinaryBare;

typedef struct format_FormatOctalBare format_FormatOctalBare;

/*
rectangle operations for R4*/
typedef struct linal_R4fun linal_R4fun;

typedef struct _SignedCheckedArithmetic _SignedCheckedArithmetic;

/* Allocate a t3_t2_F32_val_F32_val_F32_val_F32_val without initialising it. */
t3_t2_F32_val_F32_val_F32_val_F32_val* t3_t2_F32_val_F32_val_F32_val_F32_val_Alloc(void);

/* Allocate a laba_LabaActionMoveZ without initialising it. */
laba_LabaActionMoveZ* laba_LabaActionMoveZ_Alloc(void);

laba_LabaActionMoveZ* laba_LabaActionMoveZ_ref_create_CoofbIo(laba_LabaActionMoveZ* self, char operator_, laba_LabaTarget* target, stringext_StringParser* parser, float mod, bool inverted_, uint32_t easing_);

None* laba_LabaActionMoveZ_ref_simpleRelativeValue_offfo(laba_LabaActionMoveZ* self, stringext_StringParser* parser, float target, float defaultValue, float mod);

None* laba_LabaActionMoveZ_ref_simpleAbsoluteValue_offo(laba_LabaActionMoveZ* self, stringext_StringParser* parser, float target, float defaultValue);

None* laba_LabaActionMoveZ_box_update_ofo(laba_LabaActionMoveZ* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionMoveZ_ref_update_ofo(laba_LabaActionMoveZ* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionMoveZ_val_update_ofo(laba_LabaActionMoveZ* self, laba_LabaTarget* target, float animationValue);

/* Allocate a ArrayPairs_U8_val_Array_U8_val_val without initialising it. */
ArrayPairs_U8_val_Array_U8_val_val* ArrayPairs_U8_val_Array_U8_val_val_Alloc(void);

ArrayPairs_U8_val_Array_U8_val_val* ArrayPairs_U8_val_Array_U8_val_val_ref_create_oo(ArrayPairs_U8_val_Array_U8_val_val* self, Array_U8_val* array);

bool ArrayPairs_U8_val_Array_U8_val_val_box_has_next_b(ArrayPairs_U8_val_Array_U8_val_val* self);

bool ArrayPairs_U8_val_Array_U8_val_val_ref_has_next_b(ArrayPairs_U8_val_Array_U8_val_val* self);

bool ArrayPairs_U8_val_Array_U8_val_val_val_has_next_b(ArrayPairs_U8_val_Array_U8_val_val* self);

/* Allocate a ui_$2$0 without initialising it. */
ui_$2$0* ui_$2$0_Alloc(void);

/* Allocate a ui_NullEvent without initialising it. */
ui_NullEvent* ui_NullEvent_Alloc(void);

/* Allocate a ui_RGBA without initialising it. */
ui_RGBA* ui_RGBA_Alloc(void);

/*
string format a vector*/
String* ui_RGBA_ref_string_o(ui_RGBA* self);

/*
string format a vector*/
String* ui_RGBA_val_string_o(ui_RGBA* self);

/*
string format a vector*/
String* ui_RGBA_box_string_o(ui_RGBA* self);

ui_RGBA* ui_RGBA_val_white_o(ui_RGBA* self);

/* Allocate a Array_String_val without initialising it. */
Array_String_val* Array_String_val_Alloc(void);

/*
Reserve space for len elements, including whatever elements are already in
the array. Array space grows geometrically.
*/
None* Array_String_val_ref_reserve_Zo(Array_String_val* self, size_t len);

size_t Array_String_val_ref_next_growth_size_ZZ(Array_String_val* self, size_t s);

size_t Array_String_val_val_next_growth_size_ZZ(Array_String_val* self, size_t s);

size_t Array_String_val_box_next_growth_size_ZZ(Array_String_val* self, size_t s);

size_t Array_String_val_tag_next_growth_size_ZZ(Array_String_val* self, size_t s);

/*
Add an element to the end of the array.
*/
None* Array_String_val_ref_push_oo(Array_String_val* self, String* value);

/*
Create an array with zero elements, but space for len elements.
*/
Array_String_val* Array_String_val_ref_create_Zo(Array_String_val* self, size_t len);

double F64_box_sub_dd(double self, double y);

double F64_val_sub_dd(double self, double y);

String* F64_ref_string_o(double self);

String* F64_val_string_o(double self);

String* F64_box_string_o(double self);

double F64_val_cos_d(double self);

double F64_box_cos_d(double self);

double F64_val_add_dd(double self, double y);

double F64_box_add_dd(double self, double y);

double F64_box_mul_dd(double self, double y);

double F64_val_mul_dd(double self, double y);

float F64_val_f32_f(double self);

float F64_box_f32_f(double self);

double F64_box_sin_d(double self);

double F64_val_sin_d(double self);

double F64_val_f64_d(double self);

double F64_box_f64_d(double self);

double F64_val_create_dd(double self, double value);

/* Allocate a collections_HashMap_String_val_apple_$33$0_val_collections_HashEq_String_val_val without initialising it. */
collections_HashMap_String_val_apple_$33$0_val_collections_HashEq_String_val_val* collections_HashMap_String_val_apple_$33$0_val_collections_HashEq_String_val_val_Alloc(void);

/*
Sets a value in the map. Returns the old value if there was one, otherwise
returns None. If there was no previous value, this may trigger a resize.
*/
void* collections_HashMap_String_val_apple_$33$0_val_collections_HashEq_String_val_val_ref_update_ooo(collections_HashMap_String_val_apple_$33$0_val_collections_HashEq_String_val_val* self, String* key, apple_$33$0* value);

/*
Change the available space.
*/
None* collections_HashMap_String_val_apple_$33$0_val_collections_HashEq_String_val_val_ref__resize_Zo(collections_HashMap_String_val_apple_$33$0_val_collections_HashEq_String_val_val* self, size_t len);

/*
Create an array with space for prealloc elements without triggering a
resize. Defaults to 6.
*/
collections_HashMap_String_val_apple_$33$0_val_collections_HashEq_String_val_val* collections_HashMap_String_val_apple_$33$0_val_collections_HashEq_String_val_val_ref_create_Zo(collections_HashMap_String_val_apple_$33$0_val_collections_HashEq_String_val_val* self, size_t prealloc);

/* Allocate a t2_USize_val_Bool_val without initialising it. */
t2_USize_val_Bool_val* t2_USize_val_Bool_val_Alloc(void);

/* Allocate a ReadSeq_U8_val without initialising it. */
ReadSeq_U8_val* ReadSeq_U8_val_Alloc(void);

/*
Returns the number of elements in the sequence.
*/
size_t ReadSeq_U8_val_ref_size_Z(ReadSeq_U8_val* self);

/*
Returns the number of elements in the sequence.
*/
size_t ReadSeq_U8_val_val_size_Z(ReadSeq_U8_val* self);

/*
Returns the number of elements in the sequence.
*/
size_t ReadSeq_U8_val_box_size_Z(ReadSeq_U8_val* self);

/*
A null pointer.
*/
ui_RenderContext** Pointer_ui_RenderContext_val_ref_create_o(ui_RenderContext** self);

/* Allocate a format_PrefixSpace without initialising it. */
format_PrefixSpace* format_PrefixSpace_Alloc(void);

format_PrefixSpace* format_PrefixSpace_val_create_o(format_PrefixSpace* self);

bool format_PrefixSpace_box_eq_ob(format_PrefixSpace* self, format_PrefixSpace* that);

bool format_PrefixSpace_val_eq_ob(format_PrefixSpace* self, format_PrefixSpace* that);

/*
Space for len instances of A.
*/
char* Pointer_U8_val_ref__alloc_Zo(char* self, size_t len);

/*
Convert the pointer into an integer.
*/
size_t Pointer_U8_val_box_usize_Z(char* self);

/*
Convert the pointer into an integer.
*/
size_t Pointer_U8_val_val_usize_Z(char* self);

/*
Convert the pointer into an integer.
*/
size_t Pointer_U8_val_ref_usize_Z(char* self);

/*
Convert the pointer into an integer.
*/
size_t Pointer_U8_val_tag_usize_Z(char* self);

/*
Keep the contents, but reserve space for len instances of A.
*/
char* Pointer_U8_val_ref__realloc_Zo(char* self, size_t len);

/*
Set index i and return the previous value.
*/
char Pointer_U8_val_ref__update_ZCC(char* self, size_t i, char value);

/*
Retrieve index i.
*/
char Pointer_U8_val_val__apply_ZC(char* self, size_t i);

/*
Retrieve index i.
*/
char Pointer_U8_val_ref__apply_ZC(char* self, size_t i);

/*
Retrieve index i.
*/
char Pointer_U8_val_box__apply_ZC(char* self, size_t i);

/*
Return true for a null pointer, false for anything else.
*/
bool Pointer_U8_val_ref_is_null_b(char* self);

/*
Return true for a null pointer, false for anything else.
*/
bool Pointer_U8_val_box_is_null_b(char* self);

/*
Return true for a null pointer, false for anything else.
*/
bool Pointer_U8_val_tag_is_null_b(char* self);

/*
Return true for a null pointer, false for anything else.
*/
bool Pointer_U8_val_val_is_null_b(char* self);

/*
Return a pointer to the n-th element.
*/
char* Pointer_U8_val_val__offset_Zo(char* self, size_t n);

/*
Return a pointer to the n-th element.
*/
char* Pointer_U8_val_box__offset_Zo(char* self, size_t n);

/*
Return a pointer to the n-th element.
*/
char* Pointer_U8_val_ref__offset_Zo(char* self, size_t n);

/*
Unsafe change in reference capability.
*/
char* Pointer_U8_val_val__unsafe_o(char* self);

/*
Unsafe change in reference capability.
*/
char* Pointer_U8_val_box__unsafe_o(char* self);

/*
Unsafe change in reference capability.
*/
char* Pointer_U8_val_ref__unsafe_o(char* self);

/*
Unsafe change in reference capability.
*/
char* Pointer_U8_val_tag__unsafe_o(char* self);

/*
A null pointer.
*/
char* Pointer_U8_val_ref_create_o(char* self);

/*
Delete n elements from the head of pointer, compact remaining elements of
the underlying array. The array length before this should be n + len.
Returns the first deleted element.
*/
char Pointer_U8_val_ref__delete_ZZC(char* self, size_t n, size_t len);

/*
Copy n elements from this to that.
*/
char* Pointer_U8_val_ref__copy_to_oZo(char* self, char* that, size_t n);

/*
Copy n elements from this to that.
*/
char* Pointer_U8_val_val__copy_to_oZo(char* self, char* that, size_t n);

/*
Copy n elements from this to that.
*/
char* Pointer_U8_val_box__copy_to_oZo(char* self, char* that, size_t n);

/* Allocate a u2_ui_YogaNode_ref_None_val without initialising it. */
u2_ui_YogaNode_ref_None_val* u2_ui_YogaNode_ref_None_val_Alloc(void);

None* u2_ui_YogaNode_ref_None_val_ref_invalidate_oo(void* self, ui_FrameContext* frameContext);

ssize_t u2_ui_YogaNode_ref_None_val_val_getFocusIdx_z(void* self);

ssize_t u2_ui_YogaNode_ref_None_val_box_getFocusIdx_z(void* self);

ssize_t u2_ui_YogaNode_ref_None_val_ref_getFocusIdx_z(void* self);

size_t u2_ui_YogaNode_ref_None_val_val_id_Z(void* self);

size_t u2_ui_YogaNode_ref_None_val_box_id_Z(void* self);

size_t u2_ui_YogaNode_ref_None_val_ref_id_Z(void* self);

/* Allocate a ui_Viewable without initialising it. */
ui_Viewable* ui_Viewable_Alloc(void);

None* ui_Viewable_tag_viewable_start_oo(ui_Viewable* self, ui_FrameContext* frameContext);

None* ui_Viewable_tag_viewable_invalidate_oo(ui_Viewable* self, ui_FrameContext* frameContext);

None* ui_Viewable_ref_start_oo(ui_Viewable* self, ui_FrameContext* frameContext);

None* ui_Viewable_ref_performAnimation_oo(ui_Viewable* self, ui_FrameContext* frameContext);

None* ui_Viewable_ref_invalidate_oo(ui_Viewable* self, ui_FrameContext* frameContext);

None* ui_Viewable_ref_finish_o(ui_Viewable* self);

None* ui_Viewable_tag_viewable_finish_o(ui_Viewable* self);

None* ui_Viewable_ref_animate_fo(ui_Viewable* self, float delta);

/* Allocate a format_FormatHexSmallBare without initialising it. */
format_FormatHexSmallBare* format_FormatHexSmallBare_Alloc(void);

format_FormatHexSmallBare* format_FormatHexSmallBare_val_create_o(format_FormatHexSmallBare* self);

bool format_FormatHexSmallBare_box_eq_ob(format_FormatHexSmallBare* self, format_FormatHexSmallBare* that);

bool format_FormatHexSmallBare_val_eq_ob(format_FormatHexSmallBare* self, format_FormatHexSmallBare* that);

/* Allocate a u2_laba_$26$0_box_None_val without initialising it. */
u2_laba_$26$0_box_None_val* u2_laba_$26$0_box_None_val_Alloc(void);

None* u2_laba_$26$0_box_None_val_box_apply_ooo(void* self, ui_YogaNode* p1, laba_Laba* p2);

None* u2_laba_$26$0_box_None_val_ref_apply_ooo(void* self, ui_YogaNode* p1, laba_Laba* p2);

None* u2_laba_$26$0_box_None_val_val_apply_ooo(void* self, ui_YogaNode* p1, laba_Laba* p2);

/* Allocate a laba_LabaActionHeight without initialising it. */
laba_LabaActionHeight* laba_LabaActionHeight_Alloc(void);

laba_LabaActionHeight* laba_LabaActionHeight_ref_create_CoobIo(laba_LabaActionHeight* self, char operator_, laba_LabaTarget* target, stringext_StringParser* parser, bool inverted_, uint32_t easing_);

None* laba_LabaActionHeight_ref_simpleAbsoluteValue_offo(laba_LabaActionHeight* self, stringext_StringParser* parser, float target, float defaultValue);

None* laba_LabaActionHeight_box_update_ofo(laba_LabaActionHeight* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionHeight_ref_update_ofo(laba_LabaActionHeight* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionHeight_val_update_ofo(laba_LabaActionHeight* self, laba_LabaTarget* target, float animationValue);

uint32_t U32_val_shr_II(uint32_t self, uint32_t y);

uint32_t U32_box_shr_II(uint32_t self, uint32_t y);

uint64_t U32_val_u64_W(uint32_t self);

uint64_t U32_box_u64_W(uint32_t self);

uint32_t U32_val_op_and_II(uint32_t self, uint32_t y);

uint32_t U32_box_op_and_II(uint32_t self, uint32_t y);

uint32_t U32_box_sub_II(uint32_t self, uint32_t y);

uint32_t U32_val_sub_II(uint32_t self, uint32_t y);

uint32_t U32_val_shl_II(uint32_t self, uint32_t y);

uint32_t U32_box_shl_II(uint32_t self, uint32_t y);

bool U32_val_ne_Ib(uint32_t self, uint32_t y);

bool U32_box_ne_Ib(uint32_t self, uint32_t y);

String* U32_ref_string_o(uint32_t self);

String* U32_val_string_o(uint32_t self);

String* U32_box_string_o(uint32_t self);

uint32_t U32_val_add_II(uint32_t self, uint32_t y);

uint32_t U32_box_add_II(uint32_t self, uint32_t y);

bool U32_box_eq_Ib(uint32_t self, uint32_t y);

bool U32_val_eq_Ib(uint32_t self, uint32_t y);

char U32_box_u8_C(uint32_t self);

char U32_val_u8_C(uint32_t self);

uint32_t U32_val_create_II(uint32_t self, uint32_t value);

uint32_t U32_box_op_or_II(uint32_t self, uint32_t y);

uint32_t U32_val_op_or_II(uint32_t self, uint32_t y);

bool U32_val_lt_Ib(uint32_t self, uint32_t y);

bool U32_box_lt_Ib(uint32_t self, uint32_t y);

__uint128_t U32_box_u128_Q(uint32_t self);

__uint128_t U32_val_u128_Q(uint32_t self);

/*
Space for len instances of A.
*/
laba_LabaAction** Pointer_laba_LabaAction_ref_ref__alloc_Zo(laba_LabaAction** self, size_t len);

/*
Keep the contents, but reserve space for len instances of A.
*/
laba_LabaAction** Pointer_laba_LabaAction_ref_ref__realloc_Zo(laba_LabaAction** self, size_t len);

/*
Set index i and return the previous value.
*/
laba_LabaAction* Pointer_laba_LabaAction_ref_ref__update_Zoo(laba_LabaAction** self, size_t i, laba_LabaAction* value);

/*
Retrieve index i.
*/
laba_LabaAction* Pointer_laba_LabaAction_ref_box__apply_Zo(laba_LabaAction** self, size_t i);

/*
Retrieve index i.
*/
laba_LabaAction* Pointer_laba_LabaAction_ref_val__apply_Zo(laba_LabaAction** self, size_t i);

/*
Retrieve index i.
*/
laba_LabaAction* Pointer_laba_LabaAction_ref_ref__apply_Zo(laba_LabaAction** self, size_t i);

/*
A null pointer.
*/
laba_LabaAction** Pointer_laba_LabaAction_ref_ref_create_o(laba_LabaAction** self);

/* Allocate a PlatformOSX without initialising it. */
PlatformOSX* PlatformOSX_Alloc(void);

PlatformOSX* PlatformOSX_tag_create_oo__send(PlatformOSX* self, Env* env);

None* PlatformOSX_val_poll_o(PlatformOSX* self);

None* PlatformOSX_ref_register_oo(PlatformOSX* self, PonyPlatform* platform);

bool PlatformOSX_box__use_main_thread_b(PlatformOSX* self);

/* Allocate a u3_format_AlignLeft_val_format_AlignRight_val_format_AlignCenter_val without initialising it. */
u3_format_AlignLeft_val_format_AlignRight_val_format_AlignCenter_val* u3_format_AlignLeft_val_format_AlignRight_val_format_AlignCenter_val_Alloc(void);

/* Allocate a $0$16_laba_Laba_ref without initialising it. */
$0$16_laba_Laba_ref* $0$16_laba_Laba_ref_Alloc(void);

bool $0$16_laba_Laba_ref_val_apply_oob($0$16_laba_Laba_ref* self, laba_Laba* l, laba_Laba* r);

bool $0$16_laba_Laba_ref_ref_apply_oob($0$16_laba_Laba_ref* self, laba_Laba* l, laba_Laba* r);

bool $0$16_laba_Laba_ref_box_apply_oob($0$16_laba_Laba_ref* self, laba_Laba* l, laba_Laba* r);

$0$16_laba_Laba_ref* $0$16_laba_Laba_ref_val_create_o($0$16_laba_Laba_ref* self);

/* Allocate a format_FormatBinary without initialising it. */
format_FormatBinary* format_FormatBinary_Alloc(void);

format_FormatBinary* format_FormatBinary_val_create_o(format_FormatBinary* self);

bool format_FormatBinary_box_eq_ob(format_FormatBinary* self, format_FormatBinary* that);

bool format_FormatBinary_val_eq_ob(format_FormatBinary* self, format_FormatBinary* that);

/* Allocate a ui_$2$42 without initialising it. */
ui_$2$42* ui_$2$42_Alloc(void);

void* ui_$2$42_val_apply_oo(ui_$2$42* self, void* p1);

void* ui_$2$42_box_apply_oo(ui_$2$42* self, void* p1);

void* ui_$2$42_ref_apply_oo(ui_$2$42* self, void* p1);

/* Allocate a AmbientAuth without initialising it. */
AmbientAuth* AmbientAuth_Alloc(void);

/* Allocate a laba_LabaActionGroup without initialising it. */
laba_LabaActionGroup* laba_LabaActionGroup_Alloc(void);

bool laba_LabaActionGroup_ref_update_ofb(laba_LabaActionGroup* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionGroup_ref_commit_oo(laba_LabaActionGroup* self, laba_LabaTarget* target);

float laba_LabaActionGroup_box_totalDuration_f(laba_LabaActionGroup* self);

float laba_LabaActionGroup_ref_totalDuration_f(laba_LabaActionGroup* self);

float laba_LabaActionGroup_val_totalDuration_f(laba_LabaActionGroup* self);

None* laba_LabaActionGroup_ref_push_oo(laba_LabaActionGroup* self, laba_LabaAction* action);

laba_LabaActionGroup* laba_LabaActionGroup_ref_create_o(laba_LabaActionGroup* self);

/* Allocate a linal_V4fun without initialising it. */
linal_V4fun* linal_V4fun_Alloc(void);

linal_V4fun* linal_V4fun_val_create_o(linal_V4fun* self);

/* Allocate a format_PrefixSign without initialising it. */
format_PrefixSign* format_PrefixSign_Alloc(void);

format_PrefixSign* format_PrefixSign_val_create_o(format_PrefixSign* self);

bool format_PrefixSign_box_eq_ob(format_PrefixSign* self, format_PrefixSign* that);

bool format_PrefixSign_val_eq_ob(format_PrefixSign* self, format_PrefixSign* that);

/* Allocate a laba_LabaActionMoveY without initialising it. */
laba_LabaActionMoveY* laba_LabaActionMoveY_Alloc(void);

laba_LabaActionMoveY* laba_LabaActionMoveY_ref_create_CoofbIo(laba_LabaActionMoveY* self, char operator_, laba_LabaTarget* target, stringext_StringParser* parser, float mod, bool inverted_, uint32_t easing_);

None* laba_LabaActionMoveY_ref_simpleRelativeValue_offfo(laba_LabaActionMoveY* self, stringext_StringParser* parser, float target, float defaultValue, float mod);

None* laba_LabaActionMoveY_ref_simpleAbsoluteValue_offo(laba_LabaActionMoveY* self, stringext_StringParser* parser, float target, float defaultValue);

None* laba_LabaActionMoveY_box_update_ofo(laba_LabaActionMoveY* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionMoveY_ref_update_ofo(laba_LabaActionMoveY* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionMoveY_val_update_ofo(laba_LabaActionMoveY* self, laba_LabaTarget* target, float animationValue);

size_t USize_box_op_and_ZZ(size_t self, size_t y);

size_t USize_val_op_and_ZZ(size_t self, size_t y);

ssize_t USize_box_isize_z(size_t self);

ssize_t USize_val_isize_z(size_t self);

size_t USize_val_neg_Z(size_t self);

size_t USize_box_neg_Z(size_t self);

bool USize_val_lt_Zb(size_t self, size_t y);

bool USize_box_lt_Zb(size_t self, size_t y);

bool USize_val_le_Zb(size_t self, size_t y);

bool USize_box_le_Zb(size_t self, size_t y);

bool USize_val_ne_Zb(size_t self, size_t y);

bool USize_box_ne_Zb(size_t self, size_t y);

size_t USize_box_div_ZZ(size_t self, size_t y);

size_t USize_val_div_ZZ(size_t self, size_t y);

size_t USize_val_from_U8_val_CZ(size_t self, char a);

size_t USize_val_next_pow2_Z(size_t self);

size_t USize_box_next_pow2_Z(size_t self);

uint64_t USize_val_u64_W(size_t self);

uint64_t USize_box_u64_W(size_t self);

String* USize_ref_string_o(size_t self);

String* USize_val_string_o(size_t self);

String* USize_box_string_o(size_t self);

size_t USize_box_mul_ZZ(size_t self, size_t y);

size_t USize_val_mul_ZZ(size_t self, size_t y);

bool USize_box_eq_Zb(size_t self, size_t y);

bool USize_val_eq_Zb(size_t self, size_t y);

size_t USize_box_rem_ZZ(size_t self, size_t y);

size_t USize_val_rem_ZZ(size_t self, size_t y);

bool USize_val_gt_Zb(size_t self, size_t y);

bool USize_box_gt_Zb(size_t self, size_t y);

size_t USize_val_bitwidth_Z(size_t self);

size_t USize_box_bitwidth_Z(size_t self);

size_t USize_box_sub_ZZ(size_t self, size_t y);

size_t USize_val_sub_ZZ(size_t self, size_t y);

size_t USize_box_usize_Z(size_t self);

size_t USize_val_usize_Z(size_t self);

__uint128_t USize_box_u128_Q(size_t self);

__uint128_t USize_val_u128_Q(size_t self);

size_t USize_val_max_value_Z(size_t self);

size_t USize_val_add_ZZ(size_t self, size_t y);

size_t USize_box_add_ZZ(size_t self, size_t y);

uint32_t USize_box_u32_I(size_t self);

uint32_t USize_val_u32_I(size_t self);

size_t USize_val_create_ZZ(size_t self, size_t value);

bool USize_box_ge_Zb(size_t self, size_t y);

bool USize_val_ge_Zb(size_t self, size_t y);

size_t USize_val_shl_ZZ(size_t self, size_t y);

size_t USize_box_shl_ZZ(size_t self, size_t y);

float USize_val_f32_f(size_t self);

float USize_box_f32_f(size_t self);

size_t USize_box_clz_Z(size_t self);

size_t USize_val_clz_Z(size_t self);

size_t USize_val_max_ZZ(size_t self, size_t y);

size_t USize_box_max_ZZ(size_t self, size_t y);

size_t USize_val_min_ZZ(size_t self, size_t y);

size_t USize_box_min_ZZ(size_t self, size_t y);

/* Allocate a $0$8_laba_Laba_ref without initialising it. */
$0$8_laba_Laba_ref* $0$8_laba_Laba_ref_Alloc(void);

bool $0$8_laba_Laba_ref_val_apply_oob($0$8_laba_Laba_ref* self, laba_Laba* p1, laba_Laba* p2);

bool $0$8_laba_Laba_ref_ref_apply_oob($0$8_laba_Laba_ref* self, laba_Laba* p1, laba_Laba* p2);

bool $0$8_laba_Laba_ref_box_apply_oob($0$8_laba_Laba_ref* self, laba_Laba* p1, laba_Laba* p2);

/* Allocate a format_AlignLeft without initialising it. */
format_AlignLeft* format_AlignLeft_Alloc(void);

format_AlignLeft* format_AlignLeft_val_create_o(format_AlignLeft* self);

bool format_AlignLeft_box_eq_ob(format_AlignLeft* self, format_AlignLeft* that);

bool format_AlignLeft_val_eq_ob(format_AlignLeft* self, format_AlignLeft* that);

/* Allocate a t4_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val without initialising it. */
t4_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val* t4_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_Alloc(void);

/* Allocate a linal_V2fun without initialising it. */
linal_V2fun* linal_V2fun_Alloc(void);

linal_V2fun* linal_V2fun_val_create_o(linal_V2fun* self);

/* Allocate a ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_val without initialising it. */
ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_val* ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_val_Alloc(void);

ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_val* ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_val_ref_create_oZo(ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_val* self, Array_laba_LabaAction_ref* array, size_t offset);

/* Allocate a _SignedPartialArithmetic without initialising it. */
_SignedPartialArithmetic* _SignedPartialArithmetic_Alloc(void);

_SignedPartialArithmetic* _SignedPartialArithmetic_val_create_o(_SignedPartialArithmetic* self);

/* Allocate a format_AlignRight without initialising it. */
format_AlignRight* format_AlignRight_Alloc(void);

format_AlignRight* format_AlignRight_val_create_o(format_AlignRight* self);

bool format_AlignRight_box_eq_ob(format_AlignRight* self, format_AlignRight* that);

bool format_AlignRight_val_eq_ob(format_AlignRight* self, format_AlignRight* that);

/* Allocate a stringext_StringParser without initialising it. */
stringext_StringParser* stringext_StringParser_Alloc(void);

size_t stringext_StringParser_ref_advance_oZ(stringext_StringParser* self, Array_U8_val* set);

stringext_StringParser* stringext_StringParser_ref_create_oo(stringext_StringParser* self, String* string_);

/* Allocate a u2_apple_$33$0_val_None_val without initialising it. */
u2_apple_$33$0_val_None_val* u2_apple_$33$0_val_None_val_Alloc(void);

/*
Convert the pointer into an integer.
*/
size_t Pointer_yoga_YGNode_val_box_usize_Z(yoga_YGNode** self);

/*
Convert the pointer into an integer.
*/
size_t Pointer_yoga_YGNode_val_val_usize_Z(yoga_YGNode** self);

/*
Convert the pointer into an integer.
*/
size_t Pointer_yoga_YGNode_val_ref_usize_Z(yoga_YGNode** self);

/*
Convert the pointer into an integer.
*/
size_t Pointer_yoga_YGNode_val_tag_usize_Z(yoga_YGNode** self);

/* Allocate a t2_String_val_apple_$33$0_val without initialising it. */
t2_String_val_apple_$33$0_val* t2_String_val_apple_$33$0_val_Alloc(void);

/* Allocate a _ToString without initialising it. */
_ToString* _ToString_Alloc(void);

String* _ToString_box__u64_Wbo(_ToString* self, uint64_t x, bool neg);

String* _ToString_val__u64_Wbo(_ToString* self, uint64_t x, bool neg);

_ToString* _ToString_val_create_o(_ToString* self);

String* _ToString_val__f64_do(_ToString* self, double x);

String* _ToString_box__f64_do(_ToString* self, double x);

String* _ToString_val__u128_Qbo(_ToString* self, __uint128_t x, bool neg);

String* _ToString_box__u128_Qbo(_ToString* self, __uint128_t x, bool neg);

/*
Space for len instances of A.
*/
ui_Geometry** Pointer_ui_Geometry_ref_ref__alloc_Zo(ui_Geometry** self, size_t len);

/*
Keep the contents, but reserve space for len instances of A.
*/
ui_Geometry** Pointer_ui_Geometry_ref_ref__realloc_Zo(ui_Geometry** self, size_t len);

/*
Set index i and return the previous value.
*/
ui_Geometry* Pointer_ui_Geometry_ref_ref__update_Zoo(ui_Geometry** self, size_t i, ui_Geometry* value);

/*
Retrieve index i.
*/
ui_Geometry* Pointer_ui_Geometry_ref_box__apply_Zo(ui_Geometry** self, size_t i);

/*
Retrieve index i.
*/
ui_Geometry* Pointer_ui_Geometry_ref_val__apply_Zo(ui_Geometry** self, size_t i);

/*
Retrieve index i.
*/
ui_Geometry* Pointer_ui_Geometry_ref_ref__apply_Zo(ui_Geometry** self, size_t i);

/*
A null pointer.
*/
ui_Geometry** Pointer_ui_Geometry_ref_ref_create_o(ui_Geometry** self);

/* Allocate a ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box without initialising it. */
ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box* ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box_Alloc(void);

ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box* ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box_ref_create_oZo(ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box* self, Array_ui_YogaNode_ref* array, size_t offset);

/* Allocate a $0$9_U8_val without initialising it. */
$0$9_U8_val* $0$9_U8_val_Alloc(void);

bool $0$9_U8_val_ref_apply_CCb($0$9_U8_val* self, char p1, char p2);

bool $0$9_U8_val_val_apply_CCb($0$9_U8_val* self, char p1, char p2);

bool $0$9_U8_val_box_apply_CCb($0$9_U8_val* self, char p1, char p2);

/* Allocate a format_FormatHexSmall without initialising it. */
format_FormatHexSmall* format_FormatHexSmall_Alloc(void);

format_FormatHexSmall* format_FormatHexSmall_val_create_o(format_FormatHexSmall* self);

bool format_FormatHexSmall_box_eq_ob(format_FormatHexSmall* self, format_FormatHexSmall* that);

bool format_FormatHexSmall_val_eq_ob(format_FormatHexSmall* self, format_FormatHexSmall* that);

/* Allocate a t4_F32_val_F32_val_F32_val_F32_val without initialising it. */
t4_F32_val_F32_val_F32_val_F32_val* t4_F32_val_F32_val_F32_val_F32_val_Alloc(void);

/* Allocate a collections__MapEmpty without initialising it. */
collections__MapEmpty* collections__MapEmpty_Alloc(void);

collections__MapEmpty* collections__MapEmpty_val_create_o(collections__MapEmpty* self);

bool collections__MapEmpty_box_eq_ob(collections__MapEmpty* self, collections__MapEmpty* that);

bool collections__MapEmpty_val_eq_ob(collections__MapEmpty* self, collections__MapEmpty* that);

/* Allocate a Array_laba_LabaAction_ref without initialising it. */
Array_laba_LabaAction_ref* Array_laba_LabaAction_ref_Alloc(void);

/*
The number of elements in the array.
*/
size_t Array_laba_LabaAction_ref_ref_size_Z(Array_laba_LabaAction_ref* self);

/*
The number of elements in the array.
*/
size_t Array_laba_LabaAction_ref_val_size_Z(Array_laba_LabaAction_ref* self);

/*
The number of elements in the array.
*/
size_t Array_laba_LabaAction_ref_box_size_Z(Array_laba_LabaAction_ref* self);

/*
Return an iterator over the values in the array.
*/
ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref* Array_laba_LabaAction_ref_ref_values_o(Array_laba_LabaAction_ref* self);

/*
Return an iterator over the values in the array.
*/
ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_box* Array_laba_LabaAction_ref_box_values_o(Array_laba_LabaAction_ref* self);

/*
Return an iterator over the values in the array.
*/
ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_val* Array_laba_LabaAction_ref_val_values_o(Array_laba_LabaAction_ref* self);

/*
Reserve space for len elements, including whatever elements are already in
the array. Array space grows geometrically.
*/
None* Array_laba_LabaAction_ref_ref_reserve_Zo(Array_laba_LabaAction_ref* self, size_t len);

size_t Array_laba_LabaAction_ref_ref_next_growth_size_ZZ(Array_laba_LabaAction_ref* self, size_t s);

size_t Array_laba_LabaAction_ref_val_next_growth_size_ZZ(Array_laba_LabaAction_ref* self, size_t s);

size_t Array_laba_LabaAction_ref_box_next_growth_size_ZZ(Array_laba_LabaAction_ref* self, size_t s);

size_t Array_laba_LabaAction_ref_tag_next_growth_size_ZZ(Array_laba_LabaAction_ref* self, size_t s);

/*
Add an element to the end of the array.
*/
None* Array_laba_LabaAction_ref_ref_push_oo(Array_laba_LabaAction_ref* self, laba_LabaAction* value);

/*
Create an array with zero elements, but space for len elements.
*/
Array_laba_LabaAction_ref* Array_laba_LabaAction_ref_ref_create_Zo(Array_laba_LabaAction_ref* self, size_t len);

/* Allocate a ui_FloatAlignedArray without initialising it. */
ui_FloatAlignedArray* ui_FloatAlignedArray_Alloc(void);

/*
Remove all elements from the array.
*/
None* ui_FloatAlignedArray_ref_clear_o(ui_FloatAlignedArray* self);

/*
The number of elements in the array.
*/
size_t ui_FloatAlignedArray_ref_size_Z(ui_FloatAlignedArray* self);

/*
The number of elements in the array.
*/
size_t ui_FloatAlignedArray_val_size_Z(ui_FloatAlignedArray* self);

/*
The number of elements in the array.
*/
size_t ui_FloatAlignedArray_box_size_Z(ui_FloatAlignedArray* self);

/*
Reserve space for len elements, including whatever elements are already in
the array. Array space grows geometrically.
*/
None* ui_FloatAlignedArray_ref_reserve_Zo(ui_FloatAlignedArray* self, size_t len);

None* ui_FloatAlignedArray_box__final_o(ui_FloatAlignedArray* self);

/*
The number of byte allocated for this array
*/
size_t ui_FloatAlignedArray_ref_allocSize_Z(ui_FloatAlignedArray* self);

/*
The number of byte allocated for this array
*/
size_t ui_FloatAlignedArray_box_allocSize_Z(ui_FloatAlignedArray* self);

/*
The number of byte allocated for this array
*/
size_t ui_FloatAlignedArray_val_allocSize_Z(ui_FloatAlignedArray* self);

/*
Return the underlying C-style pointer.
*/
float* ui_FloatAlignedArray_box_cpointer_Zo(ui_FloatAlignedArray* self, size_t offset);

/*
Return the underlying C-style pointer.
*/
float* ui_FloatAlignedArray_val_cpointer_Zo(ui_FloatAlignedArray* self, size_t offset);

/*
Return the underlying C-style pointer.
*/
float* ui_FloatAlignedArray_ref_cpointer_Zo(ui_FloatAlignedArray* self, size_t offset);

/*
Create an array with zero elements, but space for len elements.
*/
ui_FloatAlignedArray* ui_FloatAlignedArray_ref_create_Zo(ui_FloatAlignedArray* self, size_t len);

/* Allocate a ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref without initialising it. */
ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref* ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref_Alloc(void);

ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref* ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref_ref_create_oZo(ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref* self, Array_laba_LabaAction_ref* array, size_t offset);

bool ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref_box_has_next_b(ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref* self);

bool ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref_ref_has_next_b(ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref* self);

bool ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref_val_has_next_b(ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_ref* self);

/* Allocate a format_FormatOctal without initialising it. */
format_FormatOctal* format_FormatOctal_Alloc(void);

format_FormatOctal* format_FormatOctal_val_create_o(format_FormatOctal* self);

bool format_FormatOctal_box_eq_ob(format_FormatOctal* self, format_FormatOctal* that);

bool format_FormatOctal_val_eq_ob(format_FormatOctal* self, format_FormatOctal* that);

/* Allocate a Array_U8_val without initialising it. */
Array_U8_val* Array_U8_val_Alloc(void);

/*
Returns true if the array contains `value`, false otherwise.

The default predicate checks for matches by identity. To search for matches
by structural equality, pass an object literal such as `{(l, r) => l == r}`.
*/
bool Array_U8_val_ref_contains_Cob(Array_U8_val* self, char value, $0$9_U8_val* predicate);

/*
Returns true if the array contains `value`, false otherwise.

The default predicate checks for matches by identity. To search for matches
by structural equality, pass an object literal such as `{(l, r) => l == r}`.
*/
bool Array_U8_val_val_contains_Cob(Array_U8_val* self, char value, $0$9_U8_val* predicate);

/*
Returns true if the array contains `value`, false otherwise.

The default predicate checks for matches by identity. To search for matches
by structural equality, pass an object literal such as `{(l, r) => l == r}`.
*/
bool Array_U8_val_box_contains_Cob(Array_U8_val* self, char value, $0$9_U8_val* predicate);

/*
Return a shared portion of this array, covering `from` until `to`.
Both the original and the new array are immutable, as they share memory.
The operation does not allocate a new array pointer nor copy elements.
*/
Array_U8_val* Array_U8_val_val_trim_ZZo(Array_U8_val* self, size_t from, size_t to);

/*
Return an iterator over the (index, value) pairs in the array.
*/
ArrayPairs_U8_val_Array_U8_val_val* Array_U8_val_val_pairs_o(Array_U8_val* self);

/*
Return an iterator over the (index, value) pairs in the array.
*/
ArrayPairs_U8_val_Array_U8_val_ref* Array_U8_val_ref_pairs_o(Array_U8_val* self);

/*
Return an iterator over the (index, value) pairs in the array.
*/
ArrayPairs_U8_val_Array_U8_val_box* Array_U8_val_box_pairs_o(Array_U8_val* self);

/*
The number of elements in the array.
*/
size_t Array_U8_val_ref_size_Z(Array_U8_val* self);

/*
The number of elements in the array.
*/
size_t Array_U8_val_val_size_Z(Array_U8_val* self);

/*
The number of elements in the array.
*/
size_t Array_U8_val_box_size_Z(Array_U8_val* self);

/*
Create an array from a C-style pointer and length. The contents are not
copied.
*/
Array_U8_val* Array_U8_val_ref_from_cpointer_oZZo(Array_U8_val* self, char* ptr, size_t len, size_t alloc);

/*
Reserve space for len elements, including whatever elements are already in
the array. Array space grows geometrically.
*/
None* Array_U8_val_ref_reserve_Zo(Array_U8_val* self, size_t len);

size_t Array_U8_val_ref_next_growth_size_ZZ(Array_U8_val* self, size_t s);

size_t Array_U8_val_val_next_growth_size_ZZ(Array_U8_val* self, size_t s);

size_t Array_U8_val_box_next_growth_size_ZZ(Array_U8_val* self, size_t s);

size_t Array_U8_val_tag_next_growth_size_ZZ(Array_U8_val* self, size_t s);

/*
Return the underlying C-style pointer.
*/
char* Array_U8_val_box_cpointer_Zo(Array_U8_val* self, size_t offset);

/*
Return the underlying C-style pointer.
*/
char* Array_U8_val_val_cpointer_Zo(Array_U8_val* self, size_t offset);

/*
Return the underlying C-style pointer.
*/
char* Array_U8_val_ref_cpointer_Zo(Array_U8_val* self, size_t offset);

/*
Resize to len elements, populating previously empty elements with random
memory. This is only allowed for an array of numbers.
*/
None* Array_U8_val_ref_undefined_U8_val_Zo(Array_U8_val* self, size_t len);

/*
Add an element to the end of the array.
*/
None* Array_U8_val_ref_push_Co(Array_U8_val* self, char value);

/*
Create an array with zero elements, but space for len elements.
*/
Array_U8_val* Array_U8_val_ref_create_Zo(Array_U8_val* self, size_t len);

/*
Copy copy_len elements from this to that at specified offsets.
*/
None* Array_U8_val_ref__copy_to_oZZZo(Array_U8_val* self, char* ptr, size_t copy_len, size_t from_offset, size_t to_offset);

/*
Copy copy_len elements from this to that at specified offsets.
*/
None* Array_U8_val_val__copy_to_oZZZo(Array_U8_val* self, char* ptr, size_t copy_len, size_t from_offset, size_t to_offset);

/*
Copy copy_len elements from this to that at specified offsets.
*/
None* Array_U8_val_box__copy_to_oZZZo(Array_U8_val* self, char* ptr, size_t copy_len, size_t from_offset, size_t to_offset);

/* Allocate a ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_box without initialising it. */
ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_box* ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_box_Alloc(void);

ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_box* ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_box_ref_create_oZo(ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_box* self, Array_laba_Laba_ref* array, size_t offset);

/*
Space for len instances of A.
*/
uint32_t* Pointer_U32_val_ref__alloc_Zo(uint32_t* self, size_t len);

/*
Keep the contents, but reserve space for len instances of A.
*/
uint32_t* Pointer_U32_val_ref__realloc_Zo(uint32_t* self, size_t len);

/*
Set index i and return the previous value.
*/
uint32_t Pointer_U32_val_ref__update_ZII(uint32_t* self, size_t i, uint32_t value);

/*
Retrieve index i.
*/
uint32_t Pointer_U32_val_ref__apply_ZI(uint32_t* self, size_t i);

/*
Retrieve index i.
*/
uint32_t Pointer_U32_val_val__apply_ZI(uint32_t* self, size_t i);

/*
Retrieve index i.
*/
uint32_t Pointer_U32_val_box__apply_ZI(uint32_t* self, size_t i);

/*
A null pointer.
*/
uint32_t* Pointer_U32_val_ref_create_o(uint32_t* self);

/* Allocate a laba_$26$0 without initialising it. */
laba_$26$0* laba_$26$0_Alloc(void);

/* Allocate a OutStream without initialising it. */
OutStream* OutStream_Alloc(void);

/* Allocate a linal_M4fun without initialising it. */
linal_M4fun* linal_M4fun_Alloc(void);

linal_M4fun* linal_M4fun_val_create_o(linal_M4fun* self);

/* Allocate a $0$12_U32_val without initialising it. */
$0$12_U32_val* $0$12_U32_val_Alloc(void);

bool $0$12_U32_val_ref_apply_IIb($0$12_U32_val* self, uint32_t l, uint32_t r);

bool $0$12_U32_val_box_apply_IIb($0$12_U32_val* self, uint32_t l, uint32_t r);

bool $0$12_U32_val_val_apply_IIb($0$12_U32_val* self, uint32_t l, uint32_t r);

$0$12_U32_val* $0$12_U32_val_val_create_o($0$12_U32_val* self);

/* Allocate a $0$6 without initialising it. */
$0$6* $0$6_Alloc(void);

/* Allocate a u2_ui_Controllerable_tag_None_val without initialising it. */
u2_ui_Controllerable_tag_None_val* u2_ui_Controllerable_tag_None_val_Alloc(void);

/* Allocate a ui_RenderNeeded without initialising it. */
ui_RenderNeeded* ui_RenderNeeded_Alloc(void);

ui_RenderNeeded* ui_RenderNeeded_val_create_o(ui_RenderNeeded* self);

bool ui_RenderNeeded_box_eq_ob(ui_RenderNeeded* self, ui_RenderNeeded* that);

bool ui_RenderNeeded_val_eq_ob(ui_RenderNeeded* self, ui_RenderNeeded* that);

/* Allocate a _UnsignedPartialArithmetic without initialising it. */
_UnsignedPartialArithmetic* _UnsignedPartialArithmetic_Alloc(void);

_UnsignedPartialArithmetic* _UnsignedPartialArithmetic_val_create_o(_UnsignedPartialArithmetic* self);

/* Allocate a format_PrefixDefault without initialising it. */
format_PrefixDefault* format_PrefixDefault_Alloc(void);

format_PrefixDefault* format_PrefixDefault_val_create_o(format_PrefixDefault* self);

/* Allocate a laba_LabaTarget without initialising it. */
laba_LabaTarget* laba_LabaTarget_Alloc(void);

float laba_LabaTarget_ref_getHeight_f(laba_LabaTarget* self);

None* laba_LabaTarget_ref_setHeight_fo(laba_LabaTarget* self, float h);

float laba_LabaTarget_ref_getY_f(laba_LabaTarget* self);

float laba_LabaTarget_ref_getScale_f(laba_LabaTarget* self);

None* laba_LabaTarget_ref_setAlpha_fo(laba_LabaTarget* self, float f);

float laba_LabaTarget_ref_getZ_f(laba_LabaTarget* self);

size_t laba_LabaTarget_ref_getSiblingIdx_bZ(laba_LabaTarget* self, bool inverted);

None* laba_LabaTarget_ref_setPitch_fo(laba_LabaTarget* self, float p);

None* laba_LabaTarget_ref_setScale_fo(laba_LabaTarget* self, float s);

None* laba_LabaTarget_ref_setX_fo(laba_LabaTarget* self, float x);

None* laba_LabaTarget_ref_setZ_fo(laba_LabaTarget* self, float z);

None* laba_LabaTarget_ref_setRoll_fo(laba_LabaTarget* self, float r);

None* laba_LabaTarget_ref_setWidth_fo(laba_LabaTarget* self, float w);

None* laba_LabaTarget_ref_syncFromNode_o(laba_LabaTarget* self);

float laba_LabaTarget_ref_getWidth_f(laba_LabaTarget* self);

float laba_LabaTarget_ref_getAlpha_f(laba_LabaTarget* self);

float laba_LabaTarget_ref_getPitch_f(laba_LabaTarget* self);

None* laba_LabaTarget_ref_setY_fo(laba_LabaTarget* self, float y);

float laba_LabaTarget_ref_getX_f(laba_LabaTarget* self);

float laba_LabaTarget_ref_getRoll_f(laba_LabaTarget* self);

float laba_LabaTarget_ref_getYaw_f(laba_LabaTarget* self);

None* laba_LabaTarget_ref_syncToNode_bo(laba_LabaTarget* self, bool print);

None* laba_LabaTarget_ref_setYaw_fo(laba_LabaTarget* self, float a);

/* Allocate a u2_String_val_None_val without initialising it. */
u2_String_val_None_val* u2_String_val_None_val_Alloc(void);

/* Allocate a Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val without initialising it. */
Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val* Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_Alloc(void);

/*
Create an array of len elements, all initialised to the given value.
*/
Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val* Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_ref_init_oZo(Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val* self, void* from, size_t len);

/*
The number of elements in the array.
*/
size_t Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_ref_size_Z(Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val* self);

/*
The number of elements in the array.
*/
size_t Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_val_size_Z(Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val* self);

/*
The number of elements in the array.
*/
size_t Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_box_size_Z(Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val* self);

size_t Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_ref_next_growth_size_ZZ(Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val* self, size_t s);

size_t Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_val_next_growth_size_ZZ(Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val* self, size_t s);

size_t Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_box_next_growth_size_ZZ(Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val* self, size_t s);

size_t Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_tag_next_growth_size_ZZ(Array_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val* self, size_t s);

/* Allocate a Stringable without initialising it. */
Stringable* Stringable_Alloc(void);

/*
Generate a string representation of this object.
*/
String* Stringable_ref_string_o(Stringable* self);

/*
Generate a string representation of this object.
*/
String* Stringable_val_string_o(Stringable* self);

/*
Generate a string representation of this object.
*/
String* Stringable_box_string_o(Stringable* self);

/* Allocate a t2_ISize_val_USize_val without initialising it. */
t2_ISize_val_USize_val* t2_ISize_val_USize_val_Alloc(void);

/* Allocate a InputStream without initialising it. */
InputStream* InputStream_Alloc(void);

/* Allocate a ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref without initialising it. */
ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref* ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref_Alloc(void);

ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref* ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref_ref_create_oZo(ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref* self, Array_ui_YogaNode_ref* array, size_t offset);

bool ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref_box_has_next_b(ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref* self);

bool ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref_ref_has_next_b(ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref* self);

bool ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref_val_has_next_b(ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref* self);

/* Allocate a _UTF32Encoder without initialising it. */
_UTF32Encoder* _UTF32Encoder_Alloc(void);

_UTF32Encoder* _UTF32Encoder_val_create_o(_UTF32Encoder* self);

String* I8_box_string_o(int8_t self);

String* I8_val_string_o(int8_t self);

String* I8_ref_string_o(int8_t self);

int64_t I8_val_i64_w(int8_t self);

int64_t I8_box_i64_w(int8_t self);

ssize_t I8_box_isize_z(int8_t self);

ssize_t I8_val_isize_z(int8_t self);

char I8_val_abs_C(int8_t self);

char I8_box_abs_C(int8_t self);

int8_t I8_val_neg_c(int8_t self);

int8_t I8_box_neg_c(int8_t self);

char I8_box_u8_C(int8_t self);

char I8_val_u8_C(int8_t self);

int8_t I8_val_create_cc(int8_t self, int8_t value);

bool I8_val_lt_cb(int8_t self, int8_t y);

bool I8_box_lt_cb(int8_t self, int8_t y);

/* Allocate a ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_val without initialising it. */
ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_val* ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_val_Alloc(void);

ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_val* ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_val_ref_create_oZo(ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_val* self, Array_laba_Laba_ref* array, size_t offset);

bool U64_box_le_Wb(uint64_t self, uint64_t y);

bool U64_val_le_Wb(uint64_t self, uint64_t y);

uint64_t U64_val_u64_W(uint64_t self);

uint64_t U64_box_u64_W(uint64_t self);

uint64_t U64_box_sub_WW(uint64_t self, uint64_t y);

uint64_t U64_val_sub_WW(uint64_t self, uint64_t y);

uint64_t U64_val_shl_WW(uint64_t self, uint64_t y);

uint64_t U64_box_shl_WW(uint64_t self, uint64_t y);

size_t U64_box_usize_Z(uint64_t self);

size_t U64_val_usize_Z(uint64_t self);

bool U64_val_ne_Wb(uint64_t self, uint64_t y);

bool U64_box_ne_Wb(uint64_t self, uint64_t y);

uint64_t U64_val_max_value_W(uint64_t self);

String* U64_ref_string_o(uint64_t self);

String* U64_val_string_o(uint64_t self);

String* U64_box_string_o(uint64_t self);

uint64_t U64_box_add_WW(uint64_t self, uint64_t y);

uint64_t U64_val_add_WW(uint64_t self, uint64_t y);

uint32_t U64_box_u32_I(uint64_t self);

uint32_t U64_val_u32_I(uint64_t self);

uint64_t U64_val_mul_WW(uint64_t self, uint64_t y);

uint64_t U64_box_mul_WW(uint64_t self, uint64_t y);

float U64_val_f32_f(uint64_t self);

float U64_box_f32_f(uint64_t self);

bool U64_val_eq_Wb(uint64_t self, uint64_t y);

bool U64_box_eq_Wb(uint64_t self, uint64_t y);

uint64_t U64_box_div_WW(uint64_t self, uint64_t y);

uint64_t U64_val_div_WW(uint64_t self, uint64_t y);

uint64_t U64_val_from_USize_val_ZW(uint64_t self, size_t a);

uint64_t U64_box_neg_W(uint64_t self);

uint64_t U64_val_neg_W(uint64_t self);

uint64_t U64_val_create_WW(uint64_t self, uint64_t value);

uint64_t U64_box_op_or_WW(uint64_t self, uint64_t y);

uint64_t U64_val_op_or_WW(uint64_t self, uint64_t y);

bool U64_val_lt_Wb(uint64_t self, uint64_t y);

bool U64_box_lt_Wb(uint64_t self, uint64_t y);

bool U64_box_gt_Wb(uint64_t self, uint64_t y);

bool U64_val_gt_Wb(uint64_t self, uint64_t y);

/* Allocate a u2_ui_RenderEngine_tag_None_val without initialising it. */
u2_ui_RenderEngine_tag_None_val* u2_ui_RenderEngine_tag_None_val_Alloc(void);

/* Allocate a Env without initialising it. */
Env* Env_Alloc(void);

/* Allocate a linal_V3fun without initialising it. */
linal_V3fun* linal_V3fun_Alloc(void);

linal_V3fun* linal_V3fun_val_create_o(linal_V3fun* self);

/* Allocate a u2_ui_$2$0_val_None_val without initialising it. */
u2_ui_$2$0_val_None_val* u2_ui_$2$0_val_None_val_Alloc(void);

None* u2_ui_$2$0_val_None_val_box_apply_ooo(void* self, ui_YogaNode* p1, Stringable* p2);

None* u2_ui_$2$0_val_None_val_ref_apply_ooo(void* self, ui_YogaNode* p1, Stringable* p2);

None* u2_ui_$2$0_val_None_val_val_apply_ooo(void* self, ui_YogaNode* p1, Stringable* p2);

/*
Set index i and return the previous value.
*/
float UnsafePointer_F32_val_ref_update_Zff(float* self, size_t i, float value);

/*
Return true for a null pointer, false for anything else.
*/
bool UnsafePointer_F32_val_ref_is_null_b(float* self);

/*
Return true for a null pointer, false for anything else.
*/
bool UnsafePointer_F32_val_box_is_null_b(float* self);

/*
Return true for a null pointer, false for anything else.
*/
bool UnsafePointer_F32_val_tag_is_null_b(float* self);

/*
Return true for a null pointer, false for anything else.
*/
bool UnsafePointer_F32_val_val_is_null_b(float* self);

/*
Copy n elements from this to that.
*/
float* UnsafePointer_F32_val_ref_copy_to_oZo(float* self, float* that, size_t n);

/*
Copy n elements from this to that.
*/
float* UnsafePointer_F32_val_val_copy_to_oZo(float* self, float* that, size_t n);

/*
Copy n elements from this to that.
*/
float* UnsafePointer_F32_val_box_copy_to_oZo(float* self, float* that, size_t n);

/*
A null pointer.
*/
float* UnsafePointer_F32_val_ref_create_o(float* self);

/*
Return a pointer to the n-th element.
*/
float* UnsafePointer_F32_val_box_offset_Zo(float* self, size_t n);

/*
Return a pointer to the n-th element.
*/
float* UnsafePointer_F32_val_ref_offset_Zo(float* self, size_t n);

/*
Return a pointer to the n-th element.
*/
float* UnsafePointer_F32_val_val_offset_Zo(float* self, size_t n);

/* Allocate a ui_$2$43 without initialising it. */
ui_$2$43* ui_$2$43_Alloc(void);

None* ui_$2$43_val_apply_oo(ui_$2$43* self, ui_RenderEngine* p1);

None* ui_$2$43_box_apply_oo(ui_$2$43* self, ui_RenderEngine* p1);

None* ui_$2$43_ref_apply_oo(ui_$2$43* self, ui_RenderEngine* p1);

/* Allocate a u10_format_FormatDefault_val_format_FormatUTF32_val_format_FormatBinary_val_format_FormatBinaryBare_val_format_FormatOctal_val_format_FormatOctalBare_val_format_FormatHex_val_format_FormatHexBare_val_format_FormatHexSmall_val_format_FormatHexSmallBare_val without initialising it. */
u10_format_FormatDefault_val_format_FormatUTF32_val_format_FormatBinary_val_format_FormatBinaryBare_val_format_FormatOctal_val_format_FormatOctalBare_val_format_FormatHex_val_format_FormatHexBare_val_format_FormatHexSmall_val_format_FormatHexSmallBare_val* u10_format_FormatDefault_val_format_FormatUTF32_val_format_FormatBinary_val_format_FormatBinaryBare_val_format_FormatOctal_val_format_FormatOctalBare_val_format_FormatHex_val_format_FormatHexBare_val_format_FormatHexSmall_val_format_FormatHexSmallBare_val_Alloc(void);

/* Allocate a format_FormatHex without initialising it. */
format_FormatHex* format_FormatHex_Alloc(void);

format_FormatHex* format_FormatHex_val_create_o(format_FormatHex* self);

bool format_FormatHex_box_eq_ob(format_FormatHex* self, format_FormatHex* that);

bool format_FormatHex_val_eq_ob(format_FormatHex* self, format_FormatHex* that);

uint64_t U8_val_u64_W(char self);

uint64_t U8_box_u64_W(char self);

bool U8_val_ge_Cb(char self, char y);

bool U8_box_ge_Cb(char self, char y);

char U8_box_op_and_CC(char self, char y);

char U8_val_op_and_CC(char self, char y);

size_t U8_box_usize_Z(char self);

size_t U8_val_usize_Z(char self);

bool U8_val_ne_Cb(char self, char y);

bool U8_box_ne_Cb(char self, char y);

String* U8_ref_string_o(char self);

String* U8_val_string_o(char self);

String* U8_box_string_o(char self);

char U8_val_add_CC(char self, char y);

char U8_box_add_CC(char self, char y);

uint32_t U8_box_u32_I(char self);

uint32_t U8_val_u32_I(char self);

bool U8_val_eq_Cb(char self, char y);

bool U8_box_eq_Cb(char self, char y);

char U8_val_op_not_C(char self);

char U8_box_op_not_C(char self);

ssize_t U8_box_isize_z(char self);

ssize_t U8_val_isize_z(char self);

char U8_val_create_CC(char self, char value);

bool U8_val_lt_Cb(char self, char y);

bool U8_box_lt_Cb(char self, char y);

char U8_val_op_or_CC(char self, char y);

char U8_box_op_or_CC(char self, char y);

bool U8_val_gt_Cb(char self, char y);

bool U8_box_gt_Cb(char self, char y);

/* Allocate a t2_USize_val_USize_val without initialising it. */
t2_USize_val_USize_val* t2_USize_val_USize_val_Alloc(void);

/* Allocate a Array_ui_Viewable_tag without initialising it. */
Array_ui_Viewable_tag* Array_ui_Viewable_tag_Alloc(void);

/*
The number of elements in the array.
*/
size_t Array_ui_Viewable_tag_ref_size_Z(Array_ui_Viewable_tag* self);

/*
The number of elements in the array.
*/
size_t Array_ui_Viewable_tag_val_size_Z(Array_ui_Viewable_tag* self);

/*
The number of elements in the array.
*/
size_t Array_ui_Viewable_tag_box_size_Z(Array_ui_Viewable_tag* self);

/*
Return an iterator over the values in the array.
*/
ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref* Array_ui_Viewable_tag_ref_values_o(Array_ui_Viewable_tag* self);

/*
Return an iterator over the values in the array.
*/
ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_box* Array_ui_Viewable_tag_box_values_o(Array_ui_Viewable_tag* self);

/*
Return an iterator over the values in the array.
*/
ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_val* Array_ui_Viewable_tag_val_values_o(Array_ui_Viewable_tag* self);

size_t Array_ui_Viewable_tag_ref_next_growth_size_ZZ(Array_ui_Viewable_tag* self, size_t s);

size_t Array_ui_Viewable_tag_val_next_growth_size_ZZ(Array_ui_Viewable_tag* self, size_t s);

size_t Array_ui_Viewable_tag_box_next_growth_size_ZZ(Array_ui_Viewable_tag* self, size_t s);

size_t Array_ui_Viewable_tag_tag_next_growth_size_ZZ(Array_ui_Viewable_tag* self, size_t s);

/*
Create an array with zero elements, but space for len elements.
*/
Array_ui_Viewable_tag* Array_ui_Viewable_tag_ref_create_Zo(Array_ui_Viewable_tag* self, size_t len);

/* Allocate a ArrayPairs_U8_val_Array_U8_val_ref without initialising it. */
ArrayPairs_U8_val_Array_U8_val_ref* ArrayPairs_U8_val_Array_U8_val_ref_Alloc(void);

ArrayPairs_U8_val_Array_U8_val_ref* ArrayPairs_U8_val_Array_U8_val_ref_ref_create_oo(ArrayPairs_U8_val_Array_U8_val_ref* self, Array_U8_val* array);

/* Allocate a format_FormatUTF32 without initialising it. */
format_FormatUTF32* format_FormatUTF32_Alloc(void);

format_FormatUTF32* format_FormatUTF32_val_create_o(format_FormatUTF32* self);

bool format_FormatUTF32_box_eq_ob(format_FormatUTF32* self, format_FormatUTF32* that);

bool format_FormatUTF32_val_eq_ob(format_FormatUTF32* self, format_FormatUTF32* that);

/* Allocate a StringRunes without initialising it. */
StringRunes* StringRunes_Alloc(void);

StringRunes* StringRunes_ref_create_oo(StringRunes* self, String* string);

bool StringRunes_box_has_next_b(StringRunes* self);

bool StringRunes_ref_has_next_b(StringRunes* self);

bool StringRunes_val_has_next_b(StringRunes* self);

uint64_t I64_val_u64_W(int64_t self);

uint64_t I64_box_u64_W(int64_t self);

String* I64_box_string_o(int64_t self);

String* I64_val_string_o(int64_t self);

String* I64_ref_string_o(int64_t self);

int64_t I64_val_i64_w(int64_t self);

int64_t I64_box_i64_w(int64_t self);

uint64_t I64_box_abs_W(int64_t self);

uint64_t I64_val_abs_W(int64_t self);

int64_t I64_box_neg_w(int64_t self);

int64_t I64_val_neg_w(int64_t self);

bool I64_val_lt_wb(int64_t self, int64_t y);

bool I64_box_lt_wb(int64_t self, int64_t y);

int64_t I64_val_create_ww(int64_t self, int64_t value);

/* Allocate a format_AlignCenter without initialising it. */
format_AlignCenter* format_AlignCenter_Alloc(void);

format_AlignCenter* format_AlignCenter_val_create_o(format_AlignCenter* self);

bool format_AlignCenter_box_eq_ob(format_AlignCenter* self, format_AlignCenter* that);

bool format_AlignCenter_val_eq_ob(format_AlignCenter* self, format_AlignCenter* that);

/* Allocate a yoga_YGNode without initialising it. */
yoga_YGNode* yoga_YGNode_Alloc(void);

/* Allocate a laba_LabaActionWidth without initialising it. */
laba_LabaActionWidth* laba_LabaActionWidth_Alloc(void);

laba_LabaActionWidth* laba_LabaActionWidth_ref_create_CoobIo(laba_LabaActionWidth* self, char operator_, laba_LabaTarget* target, stringext_StringParser* parser, bool inverted_, uint32_t easing_);

None* laba_LabaActionWidth_ref_simpleAbsoluteValue_offo(laba_LabaActionWidth* self, stringext_StringParser* parser, float target, float defaultValue);

None* laba_LabaActionWidth_box_update_ofo(laba_LabaActionWidth* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionWidth_ref_update_ofo(laba_LabaActionWidth* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionWidth_val_update_ofo(laba_LabaActionWidth* self, laba_LabaTarget* target, float animationValue);

/* Allocate a ui_RenderContext without initialising it. */
ui_RenderContext* ui_RenderContext_Alloc(void);

bool ISize_box_le_zb(ssize_t self, ssize_t y);

bool ISize_val_le_zb(ssize_t self, ssize_t y);

bool ISize_box_ge_zb(ssize_t self, ssize_t y);

bool ISize_val_ge_zb(ssize_t self, ssize_t y);

size_t ISize_val_bitwidth_Z(ssize_t self);

size_t ISize_box_bitwidth_Z(ssize_t self);

ssize_t ISize_box_sub_zz(ssize_t self, ssize_t y);

ssize_t ISize_val_sub_zz(ssize_t self, ssize_t y);

size_t ISize_box_usize_Z(ssize_t self);

size_t ISize_val_usize_Z(ssize_t self);

bool ISize_val_ne_zb(ssize_t self, ssize_t y);

bool ISize_box_ne_zb(ssize_t self, ssize_t y);

ssize_t ISize_val_max_value_z(ssize_t self);

String* ISize_ref_string_o(ssize_t self);

String* ISize_val_string_o(ssize_t self);

String* ISize_box_string_o(ssize_t self);

ssize_t ISize_box_add_zz(ssize_t self, ssize_t y);

ssize_t ISize_val_add_zz(ssize_t self, ssize_t y);

ssize_t ISize_val_mul_zz(ssize_t self, ssize_t y);

ssize_t ISize_box_mul_zz(ssize_t self, ssize_t y);

int64_t ISize_val_i64_w(ssize_t self);

int64_t ISize_box_i64_w(ssize_t self);

bool ISize_val_eq_zb(ssize_t self, ssize_t y);

bool ISize_box_eq_zb(ssize_t self, ssize_t y);

ssize_t ISize_val_div_zz(ssize_t self, ssize_t y);

ssize_t ISize_box_div_zz(ssize_t self, ssize_t y);

ssize_t ISize_box_op_xor_zz(ssize_t self, ssize_t y);

ssize_t ISize_val_op_xor_zz(ssize_t self, ssize_t y);

ssize_t ISize_val_from_I8_val_cz(ssize_t self, int8_t a);

ssize_t ISize_val_from_U8_val_Cz(ssize_t self, char a);

size_t ISize_box_abs_Z(ssize_t self);

size_t ISize_val_abs_Z(ssize_t self);

ssize_t ISize_box_neg_z(ssize_t self);

ssize_t ISize_val_neg_z(ssize_t self);

ssize_t ISize_val_min_value_z(ssize_t self);

ssize_t ISize_val_create_zz(ssize_t self, ssize_t value);

bool ISize_val_lt_zb(ssize_t self, ssize_t y);

bool ISize_box_lt_zb(ssize_t self, ssize_t y);

bool ISize_box_gt_zb(ssize_t self, ssize_t y);

bool ISize_val_gt_zb(ssize_t self, ssize_t y);

ssize_t ISize_box_shr_Zz(ssize_t self, size_t y);

ssize_t ISize_val_shr_Zz(ssize_t self, size_t y);

/* Allocate a ui_BufferedGeometry without initialising it. */
ui_BufferedGeometry* ui_BufferedGeometry_Alloc(void);

ui_Geometry* ui_BufferedGeometry_ref_next_o(ui_BufferedGeometry* self);

ui_BufferedGeometry* ui_BufferedGeometry_ref_create_o(ui_BufferedGeometry* self);

/* Allocate a apple_URLDownload without initialising it. */
apple_URLDownload* apple_URLDownload_Alloc(void);

None* apple_URLDownload_tag_put_oooo__send(apple_URLDownload* self, String* url, void* body, apple_$33$0* callback);

None* apple_URLDownload_tag_get_oooo__send(apple_URLDownload* self, String* url, void* body, apple_$33$0* callback);

None* apple_URLDownload_tag_post_oooo__send(apple_URLDownload* self, String* url, void* body, apple_$33$0* callback);

None* apple_URLDownload_tag_responseFail_ooo__send(apple_URLDownload* self, String* uuid, String* errorString);

None* apple_URLDownload_tag_responseSuccess_ooo__send(apple_URLDownload* self, String* uuid, Array_U8_val* data);

None* apple_URLDownload_ref_neverCalled_o(apple_URLDownload* self);

apple_URLDownload* apple_URLDownload_tag_create_o__send(apple_URLDownload* self);

String* I32_ref_string_o(int32_t self);

String* I32_val_string_o(int32_t self);

String* I32_box_string_o(int32_t self);

uint32_t I32_box_u32_I(int32_t self);

uint32_t I32_val_u32_I(int32_t self);

int64_t I32_val_i64_w(int32_t self);

int64_t I32_box_i64_w(int32_t self);

bool I32_val_eq_ib(int32_t self, int32_t y);

bool I32_box_eq_ib(int32_t self, int32_t y);

uint32_t I32_val_abs_I(int32_t self);

uint32_t I32_box_abs_I(int32_t self);

int32_t I32_box_neg_i(int32_t self);

int32_t I32_val_neg_i(int32_t self);

int32_t I32_val_create_ii(int32_t self, int32_t value);

bool I32_box_lt_ib(int32_t self, int32_t y);

bool I32_val_lt_ib(int32_t self, int32_t y);

/* Allocate a t3_F32_val_F32_val_F32_val without initialising it. */
t3_F32_val_F32_val_F32_val* t3_F32_val_F32_val_F32_val_Alloc(void);

/*
Space for len instances of A.
*/
ui_YogaNode** Pointer_ui_YogaNode_ref_ref__alloc_Zo(ui_YogaNode** self, size_t len);

/*
Keep the contents, but reserve space for len instances of A.
*/
ui_YogaNode** Pointer_ui_YogaNode_ref_ref__realloc_Zo(ui_YogaNode** self, size_t len);

/*
Set index i and return the previous value.
*/
ui_YogaNode* Pointer_ui_YogaNode_ref_ref__update_Zoo(ui_YogaNode** self, size_t i, ui_YogaNode* value);

/*
Retrieve index i.
*/
ui_YogaNode* Pointer_ui_YogaNode_ref_box__apply_Zo(ui_YogaNode** self, size_t i);

/*
Retrieve index i.
*/
ui_YogaNode* Pointer_ui_YogaNode_ref_val__apply_Zo(ui_YogaNode** self, size_t i);

/*
Retrieve index i.
*/
ui_YogaNode* Pointer_ui_YogaNode_ref_ref__apply_Zo(ui_YogaNode** self, size_t i);

/*
A null pointer.
*/
ui_YogaNode** Pointer_ui_YogaNode_ref_ref_create_o(ui_YogaNode** self);

/* Allocate a ui_Geometry without initialising it. */
ui_Geometry* ui_Geometry_Alloc(void);

ui_Geometry* ui_Geometry_iso_create_o(ui_Geometry* self);

/*
A null pointer.
*/
None** Pointer_None_val_ref_create_o(None** self);

/* Allocate a u3_format_PrefixDefault_val_format_PrefixSpace_val_format_PrefixSign_val without initialising it. */
u3_format_PrefixDefault_val_format_PrefixSpace_val_format_PrefixSign_val* u3_format_PrefixDefault_val_format_PrefixSpace_val_format_PrefixSign_val_Alloc(void);

/*
Space for len instances of A.
*/
laba_Laba** Pointer_laba_Laba_ref_ref__alloc_Zo(laba_Laba** self, size_t len);

/*
Retrieve index i.
*/
laba_Laba* Pointer_laba_Laba_ref_box__apply_Zo(laba_Laba** self, size_t i);

/*
Retrieve index i.
*/
laba_Laba* Pointer_laba_Laba_ref_val__apply_Zo(laba_Laba** self, size_t i);

/*
Retrieve index i.
*/
laba_Laba* Pointer_laba_Laba_ref_ref__apply_Zo(laba_Laba** self, size_t i);

/*
Return a pointer to the n-th element.
*/
laba_Laba** Pointer_laba_Laba_ref_val__offset_Zo(laba_Laba** self, size_t n);

/*
Return a pointer to the n-th element.
*/
laba_Laba** Pointer_laba_Laba_ref_box__offset_Zo(laba_Laba** self, size_t n);

/*
Return a pointer to the n-th element.
*/
laba_Laba** Pointer_laba_Laba_ref_ref__offset_Zo(laba_Laba** self, size_t n);

/*
A null pointer.
*/
laba_Laba** Pointer_laba_Laba_ref_ref_create_o(laba_Laba** self);

/*
Delete n elements from the head of pointer, compact remaining elements of
the underlying array. The array length before this should be n + len.
Returns the first deleted element.
*/
laba_Laba* Pointer_laba_Laba_ref_ref__delete_ZZo(laba_Laba** self, size_t n, size_t len);

/* Allocate a ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref without initialising it. */
ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref* ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref_Alloc(void);

ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref* ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref_ref_create_oZo(ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref* self, Array_laba_Laba_ref* array, size_t offset);

bool ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref_box_has_next_b(ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref* self);

bool ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref_ref_has_next_b(ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref* self);

bool ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref_val_has_next_b(ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref* self);

/* Allocate a utility_Log without initialising it. */
utility_Log* utility_Log_Alloc(void);

utility_Log* utility_Log_val_create_o(utility_Log* self);

None* utility_Log_val_println_oooooooooooooooooooooo(utility_Log* self, String* fmt, Stringable* arg0, Stringable* arg1, Stringable* arg2, Stringable* arg3, Stringable* arg4, Stringable* arg5, Stringable* arg6, Stringable* arg7, Stringable* arg8, Stringable* arg9, Stringable* arg10, Stringable* arg11, Stringable* arg12, Stringable* arg13, Stringable* arg14, Stringable* arg15, Stringable* arg16, Stringable* arg17, Stringable* arg18, Stringable* arg19);

None* utility_Log_box_println_oooooooooooooooooooooo(utility_Log* self, String* fmt, Stringable* arg0, Stringable* arg1, Stringable* arg2, Stringable* arg3, Stringable* arg4, Stringable* arg5, Stringable* arg6, Stringable* arg7, Stringable* arg8, Stringable* arg9, Stringable* arg10, Stringable* arg11, Stringable* arg12, Stringable* arg13, Stringable* arg14, Stringable* arg15, Stringable* arg16, Stringable* arg17, Stringable* arg18, Stringable* arg19);

/* Allocate a format_Format without initialising it. */
format_Format* format_Format_Alloc(void);

String* format_Format_val_int_U64_val_WooZZoIo(format_Format* self, uint64_t x, void* fmt, void* prefix, size_t prec, size_t width, void* align, uint32_t fill);

String* format_Format_box_int_U64_val_WooZZoIo(format_Format* self, uint64_t x, void* fmt, void* prefix, size_t prec, size_t width, void* align, uint32_t fill);

format_Format* format_Format_val_create_o(format_Format* self);

String* U16_box_string_o(uint16_t self);

String* U16_val_string_o(uint16_t self);

String* U16_ref_string_o(uint16_t self);

uint64_t U16_val_u64_W(uint16_t self);

uint64_t U16_box_u64_W(uint16_t self);

/* Allocate a None without initialising it. */
None* None_Alloc(void);

String* None_ref_string_o(None* self);

String* None_val_string_o(None* self);

String* None_box_string_o(None* self);

None* None_val_create_o(None* self);

bool None_box_eq_ob(None* self, None* that);

bool None_val_eq_ob(None* self, None* that);

/* Allocate a u2_laba_LabaAction_ref_None_val without initialising it. */
u2_laba_LabaAction_ref_None_val* u2_laba_LabaAction_ref_None_val_Alloc(void);

/* Allocate a t2_U64_val_Bool_val without initialising it. */
t2_U64_val_Bool_val* t2_U64_val_Bool_val_Alloc(void);

/* Allocate a ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_box without initialising it. */
ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_box* ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_box_Alloc(void);

ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_box* ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_box_ref_create_oZo(ArrayValues_laba_LabaAction_ref_Array_laba_LabaAction_ref_box* self, Array_laba_LabaAction_ref* array, size_t offset);

/* Allocate a format__FormatInt without initialising it. */
format__FormatInt* format__FormatInt_Alloc(void);

String* format__FormatInt_box_u64_WbooZZoIo(format__FormatInt* self, uint64_t x, bool neg, void* fmt, void* prefix, size_t prec, size_t width, void* align, uint32_t fill);

String* format__FormatInt_val_u64_WbooZZoIo(format__FormatInt* self, uint64_t x, bool neg, void* fmt, void* prefix, size_t prec, size_t width, void* align, uint32_t fill);

String* format__FormatInt_box__prefix_boo(format__FormatInt* self, bool neg, void* prefix);

String* format__FormatInt_val__prefix_boo(format__FormatInt* self, bool neg, void* prefix);

String* format__FormatInt_val__small_o(format__FormatInt* self);

String* format__FormatInt_box__small_o(format__FormatInt* self);

None* format__FormatInt_val__pad_oZoIo(format__FormatInt* self, String* s, size_t width, void* align, uint32_t fill);

None* format__FormatInt_box__pad_oZoIo(format__FormatInt* self, String* s, size_t width, void* align, uint32_t fill);

None* format__FormatInt_val__extend_digits_oZo(format__FormatInt* self, String* s, size_t digits);

None* format__FormatInt_box__extend_digits_oZo(format__FormatInt* self, String* s, size_t digits);

String* format__FormatInt_box__large_o(format__FormatInt* self);

String* format__FormatInt_val__large_o(format__FormatInt* self);

format__FormatInt* format__FormatInt_val_create_o(format__FormatInt* self);

/* Allocate a Array_laba_LabaActionGroup_ref without initialising it. */
Array_laba_LabaActionGroup_ref* Array_laba_LabaActionGroup_ref_Alloc(void);

/*
The number of elements in the array.
*/
size_t Array_laba_LabaActionGroup_ref_ref_size_Z(Array_laba_LabaActionGroup_ref* self);

/*
The number of elements in the array.
*/
size_t Array_laba_LabaActionGroup_ref_val_size_Z(Array_laba_LabaActionGroup_ref* self);

/*
The number of elements in the array.
*/
size_t Array_laba_LabaActionGroup_ref_box_size_Z(Array_laba_LabaActionGroup_ref* self);

/*
Reserve space for len elements, including whatever elements are already in
the array. Array space grows geometrically.
*/
None* Array_laba_LabaActionGroup_ref_ref_reserve_Zo(Array_laba_LabaActionGroup_ref* self, size_t len);

size_t Array_laba_LabaActionGroup_ref_ref_next_growth_size_ZZ(Array_laba_LabaActionGroup_ref* self, size_t s);

size_t Array_laba_LabaActionGroup_ref_val_next_growth_size_ZZ(Array_laba_LabaActionGroup_ref* self, size_t s);

size_t Array_laba_LabaActionGroup_ref_box_next_growth_size_ZZ(Array_laba_LabaActionGroup_ref* self, size_t s);

size_t Array_laba_LabaActionGroup_ref_tag_next_growth_size_ZZ(Array_laba_LabaActionGroup_ref* self, size_t s);

/*
Add an element to the end of the array.
*/
None* Array_laba_LabaActionGroup_ref_ref_push_oo(Array_laba_LabaActionGroup_ref* self, laba_LabaActionGroup* value);

/*
Space for len instances of A.
*/
void** Pointer_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_ref__alloc_Zo(void** self, size_t len);

/*
A null pointer.
*/
void** Pointer_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_ref_create_o(void** self);

/*
Set index i and return the previous value.
*/
void* Pointer_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_ref__update_Zoo(void** self, size_t i, void* value);

/*
Retrieve index i.
*/
void* Pointer_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_box__apply_Zo(void** self, size_t i);

/*
Retrieve index i.
*/
void* Pointer_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_val__apply_Zo(void** self, size_t i);

/*
Retrieve index i.
*/
void* Pointer_u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_ref__apply_Zo(void** self, size_t i);

/* Allocate a ui_RenderEngine without initialising it. */
ui_RenderEngine* ui_RenderEngine_Alloc(void);

None* ui_RenderEngine_tag_getNodeByName_ooo__send(ui_RenderEngine* self, String* nodeName, ui_$2$42* callback);

float ui_RenderEngine_ref_nanoToSec_Wf(ui_RenderEngine* self, uint64_t nano);

float ui_RenderEngine_box_nanoToSec_Wf(ui_RenderEngine* self, uint64_t nano);

float ui_RenderEngine_val_nanoToSec_Wf(ui_RenderEngine* self, uint64_t nano);

uint64_t ui_RenderEngine_box__priority_W(ui_RenderEngine* self);

None* ui_RenderEngine_tag_getNodeByID_Zoo__send(ui_RenderEngine* self, size_t id, ui_$2$42* callback);

None* ui_RenderEngine_ref_invalidateNodeByID_Zo(ui_RenderEngine* self, size_t id);

None* ui_RenderEngine_tag_addNode_oo__send(ui_RenderEngine* self, ui_YogaNode* yoga);

None* ui_RenderEngine_tag_scrollEvent_Zffffo__send(ui_RenderEngine* self, size_t id, float dx, float dy, float px, float py);

None* ui_RenderEngine_tag_addToNodeByName_ooo__send(ui_RenderEngine* self, String* nodeName, ui_YogaNode* yoga);

None* ui_RenderEngine_tag_touchEvent_Zbffo__send(ui_RenderEngine* self, size_t id, bool pressed, float x, float y);

String* ui_RenderEngine_ref_root_o(ui_RenderEngine* self);

String* ui_RenderEngine_val_root_o(ui_RenderEngine* self);

String* ui_RenderEngine_tag_root_o(ui_RenderEngine* self);

String* ui_RenderEngine_box_root_o(ui_RenderEngine* self);

None* ui_RenderEngine_tag_renderAll_o__send(ui_RenderEngine* self);

None* ui_RenderEngine_tag_createTextureFromBytes_ooZo__send(ui_RenderEngine* self, char* name, char* bytes, size_t bytesCount);

ui_RenderEngine* ui_RenderEngine_tag_empty_o__send(ui_RenderEngine* self);

uint64_t ui_RenderEngine_box__batch_W(ui_RenderEngine* self);

None* ui_RenderEngine_tag_createTextureFromUrl_oo__send(ui_RenderEngine* self, String* url);

None* ui_RenderEngine_tag_setNeedsRendered_o__send(ui_RenderEngine* self);

None* ui_RenderEngine_tag_run_oo__send(ui_RenderEngine* self, ui_$2$43* callback);

None* ui_RenderEngine_ref_markRenderFinished_o(ui_RenderEngine* self);

None* ui_RenderEngine_tag_renderAbort_o__send(ui_RenderEngine* self);

None* ui_RenderEngine_tag_keyEvent_bSoffo__send(ui_RenderEngine* self, bool pressed, uint16_t keyCode, char* charactersPtr, float x, float y);

None* ui_RenderEngine_ref_layout_o(ui_RenderEngine* self);

None* ui_RenderEngine_tag_requestFocus_Zo__send(ui_RenderEngine* self, size_t id);

None* ui_RenderEngine_box__final_o(ui_RenderEngine* self);

None* ui_RenderEngine_tag_renderFinished_o__send(ui_RenderEngine* self);

None* ui_RenderEngine_tag_startFinished_o__send(ui_RenderEngine* self);

None* ui_RenderEngine_tag_releaseFocus_Zo__send(ui_RenderEngine* self, size_t id);

uint64_t ui_RenderEngine_box__tag_W(ui_RenderEngine* self);

None* ui_RenderEngine_tag_setNeedsLayout_o__send(ui_RenderEngine* self);

None* ui_RenderEngine_tag_updateBounds_ffffffo__send(ui_RenderEngine* self, float w, float h, float safeTop, float safeLeft, float safeBottom, float safeRight);

ui_RenderEngine* ui_RenderEngine_tag_create_o__send(ui_RenderEngine* self);

None* ui_RenderEngine_tag_advanceFocus_o__send(ui_RenderEngine* self);

/* Allocate a ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_val without initialising it. */
ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_val* ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_val_Alloc(void);

ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_val* ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_val_ref_create_oZo(ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_val* self, Array_ui_Viewable_tag* array, size_t offset);

/* Allocate a PonyPlatform without initialising it. */
PonyPlatform* PonyPlatform_Alloc(void);

/*
Space for len instances of A.
*/
String** Pointer_String_val_ref__alloc_Zo(String** self, size_t len);

/*
Keep the contents, but reserve space for len instances of A.
*/
String** Pointer_String_val_ref__realloc_Zo(String** self, size_t len);

/*
Set index i and return the previous value.
*/
String* Pointer_String_val_ref__update_Zoo(String** self, size_t i, String* value);

/*
Retrieve index i.
*/
String* Pointer_String_val_box__apply_Zo(String** self, size_t i);

/*
Retrieve index i.
*/
String* Pointer_String_val_val__apply_Zo(String** self, size_t i);

/*
Retrieve index i.
*/
String* Pointer_String_val_ref__apply_Zo(String** self, size_t i);

/*
A null pointer.
*/
String** Pointer_String_val_ref_create_o(String** self);

/* Allocate a t5_USize_val_U8_val_U8_val_U8_val_U8_val without initialising it. */
t5_USize_val_U8_val_U8_val_U8_val_U8_val* t5_USize_val_U8_val_U8_val_U8_val_U8_val_Alloc(void);

/* Allocate a PlatformIOS without initialising it. */
PlatformIOS* PlatformIOS_Alloc(void);

PlatformIOS* PlatformIOS_tag_create_oo__send(PlatformIOS* self, Env* env);

None* PlatformIOS_val_poll_o(PlatformIOS* self);

None* PlatformIOS_ref_register_oo(PlatformIOS* self, PonyPlatform* platform);

bool PlatformIOS_box__use_main_thread_b(PlatformIOS* self);

/* Allocate a laba_LabaActionMoveX without initialising it. */
laba_LabaActionMoveX* laba_LabaActionMoveX_Alloc(void);

laba_LabaActionMoveX* laba_LabaActionMoveX_ref_create_CoofbIo(laba_LabaActionMoveX* self, char operator_, laba_LabaTarget* target, stringext_StringParser* parser, float mod, bool inverted_, uint32_t easing_);

None* laba_LabaActionMoveX_ref_simpleRelativeValue_offfo(laba_LabaActionMoveX* self, stringext_StringParser* parser, float target, float defaultValue, float mod);

None* laba_LabaActionMoveX_ref_simpleAbsoluteValue_offo(laba_LabaActionMoveX* self, stringext_StringParser* parser, float target, float defaultValue);

None* laba_LabaActionMoveX_box_update_ofo(laba_LabaActionMoveX* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionMoveX_ref_update_ofo(laba_LabaActionMoveX* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionMoveX_val_update_ofo(laba_LabaActionMoveX* self, laba_LabaTarget* target, float animationValue);

/* Allocate a String without initialising it. */
String* String_Alloc(void);

/*
Returns the space available for data, not including the null terminator.
*/
size_t String_box_space_Z(String* self);

/*
Returns the space available for data, not including the null terminator.
*/
size_t String_ref_space_Z(String* self);

/*
Returns the space available for data, not including the null terminator.
*/
size_t String_val_space_Z(String* self);

/*
Returns true if contains s as a substring, false otherwise.
*/
bool String_val_contains_ozZb(String* self, String* s, ssize_t offset, size_t nth);

/*
Returns true if contains s as a substring, false otherwise.
*/
bool String_box_contains_ozZb(String* self, String* s, ssize_t offset, size_t nth);

/*
Returns true if contains s as a substring, false otherwise.
*/
bool String_ref_contains_ozZb(String* self, String* s, ssize_t offset, size_t nth);

/*
Reserve space for len bytes. An additional byte will be reserved for the
null terminator.
*/
None* String_ref_reserve_Zo(String* self, size_t len);

/*
Add a byte to the end of the string.
*/
None* String_ref_push_Co(String* self, char value);

/*
Create a string by copying a null-terminated C string. Note that
the scan is unbounded; the pointed to data must be null-terminated
within the allocated array to preserve memory safety. If a null
pointer is given then an empty string is returned.
*/
String* String_ref_copy_cstring_oo(String* self, char* str);

/*
Return an iterator over the codepoints in the string.
*/
StringRunes* String_ref_runes_o(String* self);

/*
Return an iterator over the codepoints in the string.
*/
StringRunes* String_box_runes_o(String* self);

/*
Return an iterator over the codepoints in the string.
*/
StringRunes* String_val_runes_o(String* self);

/*
Returns a substring. Index range [`from` .. `to`) is half-open.
Returns an empty string if nothing is in the range.

Note that this operation allocates a new string to be returned. For
similar operations that don't allocate a new string, see `trim` and
`trim_in_place`.
*/
String* String_box_substring_zzo(String* self, ssize_t from, ssize_t to);

/*
Returns a substring. Index range [`from` .. `to`) is half-open.
Returns an empty string if nothing is in the range.

Note that this operation allocates a new string to be returned. For
similar operations that don't allocate a new string, see `trim` and
`trim_in_place`.
*/
String* String_val_substring_zzo(String* self, ssize_t from, ssize_t to);

/*
Returns a substring. Index range [`from` .. `to`) is half-open.
Returns an empty string if nothing is in the range.

Note that this operation allocates a new string to be returned. For
similar operations that don't allocate a new string, see `trim` and
`trim_in_place`.
*/
String* String_ref_substring_zzo(String* self, ssize_t from, ssize_t to);

/*
Recalculates the string length. This is only needed if the string is
changed via an FFI call. If a null terminator byte is not found within the
allocated length, the size will not be changed.
*/
None* String_ref_recalc_o(String* self);

size_t String_val_hash_Z(String* self);

size_t String_ref_hash_Z(String* self);

size_t String_box_hash_Z(String* self);

/*
Create a UTF-8 string from a single UTF-32 code point.
*/
String* String_ref_from_utf32_Io(String* self, uint32_t value);

/*
Unsafe update, used internally.
*/
char String_ref__set_ZCC(String* self, size_t i, char value);

/*
Reverses the byte order in the string. This needs to be changed to handle
UTF-8 correctly.
*/
None* String_ref_reverse_in_place_o(String* self);

String* String_ref_string_o(String* self);

String* String_val_string_o(String* self);

String* String_box_string_o(String* self);

/*
Truncate the string to zero length.
*/
None* String_ref_clear_o(String* self);

/*
Return true if the string is null-terminated and safe to pass to an FFI
function that doesn't accept a size argument, expecting a null-terminator.
This method checks that there is a null byte just after the final position
of populated bytes in the string, but does not check for other null bytes
which may be present earlier in the content of the string.
If you need a null-terminated copy of this string, use the clone method.
*/
bool String_ref_is_null_terminated_b(String* self);

/*
Return true if the string is null-terminated and safe to pass to an FFI
function that doesn't accept a size argument, expecting a null-terminator.
This method checks that there is a null byte just after the final position
of populated bytes in the string, but does not check for other null bytes
which may be present earlier in the content of the string.
If you need a null-terminated copy of this string, use the clone method.
*/
bool String_box_is_null_terminated_b(String* self);

/*
Return true if the string is null-terminated and safe to pass to an FFI
function that doesn't accept a size argument, expecting a null-terminator.
This method checks that there is a null byte just after the final position
of populated bytes in the string, but does not check for other null bytes
which may be present earlier in the content of the string.
If you need a null-terminated copy of this string, use the clone method.
*/
bool String_val_is_null_terminated_b(String* self);

/*
Returns true if the two strings have the same contents.
*/
bool String_ref_eq_ob(String* self, String* that);

/*
Returns true if the two strings have the same contents.
*/
bool String_box_eq_ob(String* self, String* that);

/*
Returns true if the two strings have the same contents.
*/
bool String_val_eq_ob(String* self, String* that);

String* String_iso__append_oo(String* self, String* s);

size_t String_ref_next_growth_size_ZZ(String* self, size_t s);

size_t String_val_next_growth_size_ZZ(String* self, size_t s);

size_t String_box_next_growth_size_ZZ(String* self, size_t s);

size_t String_tag_next_growth_size_ZZ(String* self, size_t s);

/*
Inserts the given string at the given offset. Appends the string if the
offset is out of bounds.
*/
None* String_ref_insert_in_place_zoo(String* self, ssize_t offset, String* that);

/*
Returns a copy of the string. The resulting string is
null-terminated even if the original is not.
*/
String* String_ref_clone_o(String* self);

/*
Returns a copy of the string. The resulting string is
null-terminated even if the original is not.
*/
String* String_val_clone_o(String* self);

/*
Returns a copy of the string. The resulting string is
null-terminated even if the original is not.
*/
String* String_box_clone_o(String* self);

/*
Append the elements from a sequence, starting from the given offset.
*/
None* String_ref_append_oZZo(String* self, ReadSeq_U8_val* seq, size_t offset, size_t len);

/*
Returns a C compatible pointer to the underlying string allocation.
*/
char* String_box_cpointer_Zo(String* self, size_t offset);

/*
Returns a C compatible pointer to the underlying string allocation.
*/
char* String_val_cpointer_Zo(String* self, size_t offset);

/*
Returns a C compatible pointer to the underlying string allocation.
*/
char* String_ref_cpointer_Zo(String* self, size_t offset);

/*
Split the string into an array of strings with any character in the
delimiter string. By default, the string is split with whitespace
characters. If `n > 0`, then the split count is limited to n.

Example:

```pony
let original: String = "name,job;department"
let delimiter: String = ".,;"
let split_array: Array[String] = original.split(delimiter)
env.out.print("OUTPUT:")
for value in split_array.values() do
  env.out.print(value)
end

// OUTPUT:
// name
// job
// department
```

Adjacent delimiters result in a zero length entry in the array. For
example, `"1,,2".split(",") => ["1", "", "2"]`.

If you want to split the string with the entire delimiter string `delim`,
use [`split_by`](#split_by).
*/
Array_String_val* String_box_split_oZo(String* self, String* delim, size_t n);

/*
Split the string into an array of strings with any character in the
delimiter string. By default, the string is split with whitespace
characters. If `n > 0`, then the split count is limited to n.

Example:

```pony
let original: String = "name,job;department"
let delimiter: String = ".,;"
let split_array: Array[String] = original.split(delimiter)
env.out.print("OUTPUT:")
for value in split_array.values() do
  env.out.print(value)
end

// OUTPUT:
// name
// job
// department
```

Adjacent delimiters result in a zero length entry in the array. For
example, `"1,,2".split(",") => ["1", "", "2"]`.

If you want to split the string with the entire delimiter string `delim`,
use [`split_by`](#split_by).
*/
Array_String_val* String_ref_split_oZo(String* self, String* delim, size_t n);

/*
Split the string into an array of strings with any character in the
delimiter string. By default, the string is split with whitespace
characters. If `n > 0`, then the split count is limited to n.

Example:

```pony
let original: String = "name,job;department"
let delimiter: String = ".,;"
let split_array: Array[String] = original.split(delimiter)
env.out.print("OUTPUT:")
for value in split_array.values() do
  env.out.print(value)
end

// OUTPUT:
// name
// job
// department
```

Adjacent delimiters result in a zero length entry in the array. For
example, `"1,,2".split(",") => ["1", "", "2"]`.

If you want to split the string with the entire delimiter string `delim`,
use [`split_by`](#split_by).
*/
Array_String_val* String_val_split_oZo(String* self, String* delim, size_t n);

/*
Return a string that is a concatenation of this and that.
*/
String* String_ref_add_oo(String* self, String* that);

/*
Return a string that is a concatenation of this and that.
*/
String* String_val_add_oo(String* self, String* that);

/*
Return a string that is a concatenation of this and that.
*/
String* String_box_add_oo(String* self, String* that);

/*
Returns the length of the string data in bytes.
*/
size_t String_ref_size_Z(String* self);

/*
Returns the length of the string data in bytes.
*/
size_t String_val_size_Z(String* self);

/*
Returns the length of the string data in bytes.
*/
size_t String_box_size_Z(String* self);

/*
Returns a C compatible pointer to a null-terminated version of the
string, safe to pass to an FFI function that doesn't accept a size
argument, expecting a null-terminator. If the underlying string
is already null terminated, this is returned; otherwise the string
is copied into a new, null-terminated allocation.
*/
char* String_box_cstring_o(String* self);

/*
Returns a C compatible pointer to a null-terminated version of the
string, safe to pass to an FFI function that doesn't accept a size
argument, expecting a null-terminator. If the underlying string
is already null terminated, this is returned; otherwise the string
is copied into a new, null-terminated allocation.
*/
char* String_val_cstring_o(String* self);

/*
Returns a C compatible pointer to a null-terminated version of the
string, safe to pass to an FFI function that doesn't accept a size
argument, expecting a null-terminator. If the underlying string
is already null terminated, this is returned; otherwise the string
is copied into a new, null-terminated allocation.
*/
char* String_ref_cstring_o(String* self);

/*
An empty string. Enough space for len bytes is reserved.
*/
String* String_ref_create_Zo(String* self, size_t len);

/*
Copy copy_len characters from this to that at specified offsets.
*/
None* String_ref__copy_to_oZZZo(String* self, char* ptr, size_t copy_len, size_t from_offset, size_t to_offset);

/*
Copy copy_len characters from this to that at specified offsets.
*/
None* String_val__copy_to_oZZZo(String* self, char* ptr, size_t copy_len, size_t from_offset, size_t to_offset);

/*
Copy copy_len characters from this to that at specified offsets.
*/
None* String_box__copy_to_oZZZo(String* self, char* ptr, size_t copy_len, size_t from_offset, size_t to_offset);

size_t String_box_offset_to_index_zZ(String* self, ssize_t i);

size_t String_val_offset_to_index_zZ(String* self, ssize_t i);

size_t String_ref_offset_to_index_zZ(String* self, ssize_t i);

/*
Create a string by copying a fixed number of bytes from a pointer.
*/
String* String_ref_copy_cpointer_oZo(String* self, char* str, size_t len);

/* Allocate a t2_F32_val_F32_val without initialising it. */
t2_F32_val_F32_val* t2_F32_val_F32_val_Alloc(void);

/* Allocate a ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_box without initialising it. */
ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_box* ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_box_Alloc(void);

ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_box* ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_box_ref_create_oZo(ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_box* self, Array_ui_Viewable_tag* array, size_t offset);

/* Allocate a ui_Controllerable without initialising it. */
ui_Controllerable* ui_Controllerable_Alloc(void);

None* ui_Controllerable_tag_animate_fo(ui_Controllerable* self, float delta);

/* Allocate a Array_ui_YogaNode_ref without initialising it. */
Array_ui_YogaNode_ref* Array_ui_YogaNode_ref_Alloc(void);

/*
Remove all elements from the array.
*/
None* Array_ui_YogaNode_ref_ref_clear_o(Array_ui_YogaNode_ref* self);

/*
Return an iterator over the values in the array.
*/
ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_ref* Array_ui_YogaNode_ref_ref_values_o(Array_ui_YogaNode_ref* self);

/*
Return an iterator over the values in the array.
*/
ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box* Array_ui_YogaNode_ref_box_values_o(Array_ui_YogaNode_ref* self);

/*
Return an iterator over the values in the array.
*/
ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val* Array_ui_YogaNode_ref_val_values_o(Array_ui_YogaNode_ref* self);

/*
The number of elements in the array.
*/
size_t Array_ui_YogaNode_ref_ref_size_Z(Array_ui_YogaNode_ref* self);

/*
The number of elements in the array.
*/
size_t Array_ui_YogaNode_ref_val_size_Z(Array_ui_YogaNode_ref* self);

/*
The number of elements in the array.
*/
size_t Array_ui_YogaNode_ref_box_size_Z(Array_ui_YogaNode_ref* self);

/*
Reserve space for len elements, including whatever elements are already in
the array. Array space grows geometrically.
*/
None* Array_ui_YogaNode_ref_ref_reserve_Zo(Array_ui_YogaNode_ref* self, size_t len);

size_t Array_ui_YogaNode_ref_ref_next_growth_size_ZZ(Array_ui_YogaNode_ref* self, size_t s);

size_t Array_ui_YogaNode_ref_val_next_growth_size_ZZ(Array_ui_YogaNode_ref* self, size_t s);

size_t Array_ui_YogaNode_ref_box_next_growth_size_ZZ(Array_ui_YogaNode_ref* self, size_t s);

size_t Array_ui_YogaNode_ref_tag_next_growth_size_ZZ(Array_ui_YogaNode_ref* self, size_t s);

/*
Add an element to the end of the array.
*/
None* Array_ui_YogaNode_ref_ref_push_oo(Array_ui_YogaNode_ref* self, ui_YogaNode* value);

/*
Create an array with zero elements, but space for len elements.
*/
Array_ui_YogaNode_ref* Array_ui_YogaNode_ref_ref_create_Zo(Array_ui_YogaNode_ref* self, size_t len);

/* Allocate a ui_LayoutNeeded without initialising it. */
ui_LayoutNeeded* ui_LayoutNeeded_Alloc(void);

ui_LayoutNeeded* ui_LayoutNeeded_val_create_o(ui_LayoutNeeded* self);

bool ui_LayoutNeeded_box_eq_ob(ui_LayoutNeeded* self, ui_LayoutNeeded* that);

bool ui_LayoutNeeded_val_eq_ob(ui_LayoutNeeded* self, ui_LayoutNeeded* that);

/* Allocate a ui_SafeEdges without initialising it. */
ui_SafeEdges* ui_SafeEdges_Alloc(void);

float ui_SafeEdges_box_right_f(ui_SafeEdges* self);

float ui_SafeEdges_val_right_f(ui_SafeEdges* self);

float ui_SafeEdges_box_bottom_f(ui_SafeEdges* self);

float ui_SafeEdges_val_bottom_f(ui_SafeEdges* self);

float ui_SafeEdges_box_left_f(ui_SafeEdges* self);

float ui_SafeEdges_val_left_f(ui_SafeEdges* self);

float ui_SafeEdges_val_top_f(ui_SafeEdges* self);

float ui_SafeEdges_box_top_f(ui_SafeEdges* self);

ui_SafeEdges* ui_SafeEdges_val_create_o(ui_SafeEdges* self);

bool F32_box_ge_fb(float self, float y);

bool F32_val_ge_fb(float self, float y);

float F32_val_sqrt_f(float self);

float F32_box_sqrt_f(float self);

float F32_val_sub_ff(float self, float y);

float F32_box_sub_ff(float self, float y);

uint32_t F32_val_bits_I(float self);

uint32_t F32_box_bits_I(float self);

bool F32_val_ne_fb(float self, float y);

bool F32_box_ne_fb(float self, float y);

String* F32_ref_string_o(float self);

String* F32_val_string_o(float self);

String* F32_box_string_o(float self);

float F32_box_add_ff(float self, float y);

float F32_val_add_ff(float self, float y);

float F32_box_cos_f(float self);

float F32_val_cos_f(float self);

/*
Minimum positive value such that (1 + epsilon) != 1.
*/
float F32_val_epsilon_f(float self);

float F32_box_mul_ff(float self, float y);

float F32_val_mul_ff(float self, float y);

float F32_box_pow_ff(float self, float y);

float F32_val_pow_ff(float self, float y);

/*
Check whether this number is NaN.
*/
bool F32_val_nan_b(float self);

/*
Check whether this number is NaN.
*/
bool F32_box_nan_b(float self);

bool F32_val_eq_fb(float self, float y);

bool F32_box_eq_fb(float self, float y);

float F32_box_sin_f(float self);

float F32_val_sin_f(float self);

float F32_val__nan_f(float self);

float F32_box_div_ff(float self, float y);

float F32_val_div_ff(float self, float y);

double F32_val_f64_d(float self);

double F32_box_f64_d(float self);

float F32_box_max_ff(float self, float y);

float F32_val_max_ff(float self, float y);

float F32_val_from_bits_If(float self, uint32_t i);

float F32_box_abs_f(float self);

float F32_val_abs_f(float self);

float F32_box_neg_f(float self);

float F32_val_neg_f(float self);

float F32_box_min_ff(float self, float y);

float F32_val_min_ff(float self, float y);

float F32_val_create_ff(float self, float value);

bool F32_box_lt_fb(float self, float y);

bool F32_val_lt_fb(float self, float y);

bool F32_box_gt_fb(float self, float y);

bool F32_val_gt_fb(float self, float y);

/* Allocate a laba_LabaActionRoll without initialising it. */
laba_LabaActionRoll* laba_LabaActionRoll_Alloc(void);

laba_LabaActionRoll* laba_LabaActionRoll_ref_create_CoobIo(laba_LabaActionRoll* self, char operator_, laba_LabaTarget* target, stringext_StringParser* parser, bool inverted_, uint32_t easing_);

None* laba_LabaActionRoll_ref_simpleRelativeValue_offfo(laba_LabaActionRoll* self, stringext_StringParser* parser, float target, float defaultValue, float mod);

None* laba_LabaActionRoll_box_update_ofo(laba_LabaActionRoll* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionRoll_ref_update_ofo(laba_LabaActionRoll* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionRoll_val_update_ofo(laba_LabaActionRoll* self, laba_LabaTarget* target, float animationValue);

/* Allocate a u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val without initialising it. */
u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val* u3_t2_String_val_apple_$33$0_val_collections__MapEmpty_val_collections__MapDeleted_val_Alloc(void);

/* Allocate a u2_Array_U8_val_val_String_val without initialising it. */
u2_Array_U8_val_val_String_val* u2_Array_U8_val_val_String_val_Alloc(void);

/* Allocate a linal_Q4fun without initialising it. */
linal_Q4fun* linal_Q4fun_Alloc(void);

linal_Q4fun* linal_Q4fun_val_create_o(linal_Q4fun* self);

/* Allocate a linal_Linear without initialising it. */
linal_Linear* linal_Linear_Alloc(void);

linal_Linear* linal_Linear_val_create_o(linal_Linear* self);

/*
floating point equality with epsilon*/
bool linal_Linear_box_eq_fffb(linal_Linear* self, float a, float b, float eps);

/*
floating point equality with epsilon*/
bool linal_Linear_val_eq_fffb(linal_Linear* self, float a, float b, float eps);

/* Allocate a t2_U32_val_U8_val without initialising it. */
t2_U32_val_U8_val* t2_U32_val_U8_val_Alloc(void);

/* Allocate a apple_$33$0 without initialising it. */
apple_$33$0* apple_$33$0_Alloc(void);

None* apple_$33$0_val_apply_oo(apple_$33$0* self, void* p1);

None* apple_$33$0_box_apply_oo(apple_$33$0* self, void* p1);

None* apple_$33$0_ref_apply_oo(apple_$33$0* self, void* p1);

/* Allocate a u3_None_val_ui_LayoutNeeded_val_ui_RenderNeeded_val without initialising it. */
u3_None_val_ui_LayoutNeeded_val_ui_RenderNeeded_val* u3_None_val_ui_LayoutNeeded_val_ui_RenderNeeded_val_Alloc(void);

/* Allocate a format_FormatDefault without initialising it. */
format_FormatDefault* format_FormatDefault_Alloc(void);

/* Allocate a collections_HashEq_String_val without initialising it. */
collections_HashEq_String_val* collections_HashEq_String_val_Alloc(void);

collections_HashEq_String_val* collections_HashEq_String_val_val_create_o(collections_HashEq_String_val* self);

/*
Use the hash function from the type parameter.
*/
size_t collections_HashEq_String_val_val_hash_oZ(collections_HashEq_String_val* self, String* x);

/*
Use the hash function from the type parameter.
*/
size_t collections_HashEq_String_val_box_hash_oZ(collections_HashEq_String_val* self, String* x);

/*
Use the structural equality function from the type parameter.
*/
bool collections_HashEq_String_val_val_eq_oob(collections_HashEq_String_val* self, String* x, String* y);

/*
Use the structural equality function from the type parameter.
*/
bool collections_HashEq_String_val_box_eq_oob(collections_HashEq_String_val* self, String* x, String* y);

/* Allocate a ui_FrameContext without initialising it. */
ui_FrameContext* ui_FrameContext_Alloc(void);

uint64_t ui_FrameContext_ref_calcRenderNumber_oWWW(ui_FrameContext* self, ui_FrameContext* frameContext, uint64_t partNum, uint64_t internalOffset);

uint64_t ui_FrameContext_box_calcRenderNumber_oWWW(ui_FrameContext* self, ui_FrameContext* frameContext, uint64_t partNum, uint64_t internalOffset);

uint64_t ui_FrameContext_val_calcRenderNumber_oWWW(ui_FrameContext* self, ui_FrameContext* frameContext, uint64_t partNum, uint64_t internalOffset);

ui_FrameContext* ui_FrameContext_ref_clone_o(ui_FrameContext* self);

ui_FrameContext* ui_FrameContext_val_clone_o(ui_FrameContext* self);

ui_FrameContext* ui_FrameContext_box_clone_o(ui_FrameContext* self);

/* Allocate a Array_U32_val without initialising it. */
Array_U32_val* Array_U32_val_Alloc(void);

/*
Returns true if the array contains `value`, false otherwise.

The default predicate checks for matches by identity. To search for matches
by structural equality, pass an object literal such as `{(l, r) => l == r}`.
*/
bool Array_U32_val_box_contains_Iob(Array_U32_val* self, uint32_t value, $0$9_U32_val* predicate);

/*
Returns true if the array contains `value`, false otherwise.

The default predicate checks for matches by identity. To search for matches
by structural equality, pass an object literal such as `{(l, r) => l == r}`.
*/
bool Array_U32_val_val_contains_Iob(Array_U32_val* self, uint32_t value, $0$9_U32_val* predicate);

/*
Returns true if the array contains `value`, false otherwise.

The default predicate checks for matches by identity. To search for matches
by structural equality, pass an object literal such as `{(l, r) => l == r}`.
*/
bool Array_U32_val_ref_contains_Iob(Array_U32_val* self, uint32_t value, $0$9_U32_val* predicate);

/*
Reserve space for len elements, including whatever elements are already in
the array. Array space grows geometrically.
*/
None* Array_U32_val_ref_reserve_Zo(Array_U32_val* self, size_t len);

size_t Array_U32_val_ref_next_growth_size_ZZ(Array_U32_val* self, size_t s);

size_t Array_U32_val_val_next_growth_size_ZZ(Array_U32_val* self, size_t s);

size_t Array_U32_val_box_next_growth_size_ZZ(Array_U32_val* self, size_t s);

size_t Array_U32_val_tag_next_growth_size_ZZ(Array_U32_val* self, size_t s);

/*
Add an element to the end of the array.
*/
None* Array_U32_val_ref_push_Io(Array_U32_val* self, uint32_t value);

/*
Create an array with zero elements, but space for len elements.
*/
Array_U32_val* Array_U32_val_ref_create_Zo(Array_U32_val* self, size_t len);

/* Allocate a ui_ScrollEvent without initialising it. */
ui_ScrollEvent* ui_ScrollEvent_Alloc(void);

ui_ScrollEvent* ui_ScrollEvent_val_create_Zffffo(ui_ScrollEvent* self, size_t id_, float dx, float dy, float px, float py);

/* Allocate a ui_YogaNode without initialising it. */
ui_YogaNode* ui_YogaNode_Alloc(void);

None* ui_YogaNode_ref_fill_o(ui_YogaNode* self);

uint64_t ui_YogaNode_ref_render_oW(ui_YogaNode* self, ui_FrameContext* frameContext);

None* ui_YogaNode_ref_width_fo(ui_YogaNode* self, float v);

void* ui_YogaNode_ref_getNodeByName_oo(ui_YogaNode* self, String* nodeName);

void* ui_YogaNode_ref_getNodeByID_Zo(ui_YogaNode* self, size_t nodeID);

float ui_YogaNode_box_getHeight_f(ui_YogaNode* self);

float ui_YogaNode_val_getHeight_f(ui_YogaNode* self);

float ui_YogaNode_ref_getHeight_f(ui_YogaNode* self);

size_t ui_YogaNode_val_id_Z(ui_YogaNode* self);

size_t ui_YogaNode_box_id_Z(ui_YogaNode* self);

size_t ui_YogaNode_ref_id_Z(ui_YogaNode* self);

uint64_t ui_YogaNode_ref_event_ooW(ui_YogaNode* self, ui_FrameContext* frameContext, void* anyEvent);

uint64_t ui_YogaNode_ref_start_oW(ui_YogaNode* self, ui_FrameContext* frameContext);

None* ui_YogaNode_ref_y_fo(ui_YogaNode* self, float v);

None* ui_YogaNode_ref_z_fo(ui_YogaNode* self, float v);

None* ui_YogaNode_ref_top_fo(ui_YogaNode* self, float p);

float ui_YogaNode_ref_getRotateZ_f(ui_YogaNode* self);

float ui_YogaNode_val_getRotateZ_f(ui_YogaNode* self);

float ui_YogaNode_box_getRotateZ_f(ui_YogaNode* self);

None* ui_YogaNode_ref_left_fo(ui_YogaNode* self, float p);

None* ui_YogaNode_ref_labaAnimate_fo(ui_YogaNode* self, float delta);

None* ui_YogaNode_ref_rotateX_fo(ui_YogaNode* self, float v);

bool ui_YogaNode_ref_postLayout_b(ui_YogaNode* self);

None* ui_YogaNode_ref_rotateY_fo(ui_YogaNode* self, float v);

None* ui_YogaNode_ref_updateSiblingCounts_o(ui_YogaNode* self);

float ui_YogaNode_box__handleNAN_ff(ui_YogaNode* self, float v);

float ui_YogaNode_val__handleNAN_ff(ui_YogaNode* self, float v);

float ui_YogaNode_ref__handleNAN_ff(ui_YogaNode* self, float v);

float ui_YogaNode_box_getAlpha_f(ui_YogaNode* self);

float ui_YogaNode_ref_getAlpha_f(ui_YogaNode* self);

float ui_YogaNode_val_getAlpha_f(ui_YogaNode* self);

float ui_YogaNode_val_getRotateY_f(ui_YogaNode* self);

float ui_YogaNode_ref_getRotateY_f(ui_YogaNode* self);

float ui_YogaNode_box_getRotateY_f(ui_YogaNode* self);

None* ui_YogaNode_ref_padding_Ifo(ui_YogaNode* self, uint32_t v1, float v2);

String* ui_YogaNode_ref_string_o(ui_YogaNode* self);

String* ui_YogaNode_val_string_o(ui_YogaNode* self);

String* ui_YogaNode_box_string_o(ui_YogaNode* self);

None* ui_YogaNode_ref_alpha_fo(ui_YogaNode* self, float a);

void* ui_YogaNode_ref_getNodeByFocusIdx_zo(ui_YogaNode* self, ssize_t idx);

float ui_YogaNode_val_getX_f(ui_YogaNode* self);

float ui_YogaNode_ref_getX_f(ui_YogaNode* self);

float ui_YogaNode_box_getX_f(ui_YogaNode* self);

None* ui_YogaNode_ref_x_fo(ui_YogaNode* self, float v);

ssize_t ui_YogaNode_val_getFocusIdx_z(ui_YogaNode* self);

ssize_t ui_YogaNode_box_getFocusIdx_z(ui_YogaNode* self);

ssize_t ui_YogaNode_ref_getFocusIdx_z(ui_YogaNode* self);

float ui_YogaNode_ref_getZ_f(ui_YogaNode* self);

None* ui_YogaNode_ref_height_fo(ui_YogaNode* self, float v);

None* ui_YogaNode_ref_addChild_oo(ui_YogaNode* self, ui_YogaNode* child);

float ui_YogaNode_box_getWidth_f(ui_YogaNode* self);

float ui_YogaNode_ref_getWidth_f(ui_YogaNode* self);

float ui_YogaNode_val_getWidth_f(ui_YogaNode* self);

None* ui_YogaNode_ref_name_oo(ui_YogaNode* self, String* name_);

None* ui_YogaNode_ref_widthPercent_fo(ui_YogaNode* self, float v);

None* ui_YogaNode_ref_bottom_fo(ui_YogaNode* self, float p);

bool ui_YogaNode_ref_startNeeded_b(ui_YogaNode* self);

float ui_YogaNode_ref_getY_f(ui_YogaNode* self);

float ui_YogaNode_val_getY_f(ui_YogaNode* self);

float ui_YogaNode_box_getY_f(ui_YogaNode* self);

None* ui_YogaNode_ref_rotateZ_fo(ui_YogaNode* self, float v);

ui_YogaNode* ui_YogaNode_ref_create_o(ui_YogaNode* self);

None* ui_YogaNode_ref_scaleAll_fo(ui_YogaNode* self, float v);

None* ui_YogaNode_ref_removeChildren_o(ui_YogaNode* self);

float ui_YogaNode_box_getRotateX_f(ui_YogaNode* self);

float ui_YogaNode_ref_getRotateX_f(ui_YogaNode* self);

float ui_YogaNode_val_getRotateX_f(ui_YogaNode* self);

None* ui_YogaNode_ref_preLayout_o(ui_YogaNode* self);

None* ui_YogaNode_ref_heightPercent_fo(ui_YogaNode* self, float v);

None* ui_YogaNode_ref_invalidate_oo(ui_YogaNode* self, ui_FrameContext* frameContext);

None* ui_YogaNode_ref_layout_o(ui_YogaNode* self);

None* ui_YogaNode_ref_finish_o(ui_YogaNode* self);

None* ui_YogaNode_box__final_o(ui_YogaNode* self);

bool ui_YogaNode_ref_isAnimating_b(ui_YogaNode* self);

None* ui_YogaNode_ref_labaStart_o(ui_YogaNode* self);

/* Allocate a utility_UUID without initialising it. */
utility_UUID* utility_UUID_Alloc(void);

/*
Returns a string representation of the UUID.
*/
String* utility_UUID_box_string_o(utility_UUID* self);

/*
Returns a string representation of the UUID.
*/
String* utility_UUID_val_string_o(utility_UUID* self);

/*
Returns a string representation of the UUID.
*/
String* utility_UUID_ref_string_o(utility_UUID* self);

/*
Creates a random UUID. This is an alias for the `v4` constructor.
*/
utility_UUID* utility_UUID_val_create_o(utility_UUID* self);

Array_U8_val* utility_UUID_tag__create_v4_o(utility_UUID* self);

Array_U8_val* utility_UUID_val__create_v4_o(utility_UUID* self);

Array_U8_val* utility_UUID_ref__create_v4_o(utility_UUID* self);

Array_U8_val* utility_UUID_box__create_v4_o(utility_UUID* self);

String* utility_UUID_val__hex_string_oZo(utility_UUID* self, Array_U8_val* data, size_t width);

String* utility_UUID_ref__hex_string_oZo(utility_UUID* self, Array_U8_val* data, size_t width);

String* utility_UUID_box__hex_string_oZo(utility_UUID* self, Array_U8_val* data, size_t width);

/* Allocate a ui_TouchEvent without initialising it. */
ui_TouchEvent* ui_TouchEvent_Alloc(void);

ui_TouchEvent* ui_TouchEvent_val_create_Zbffo(ui_TouchEvent* self, size_t id_, bool pressed_, float x, float y);

/* Allocate a laba_LabaActionPitch without initialising it. */
laba_LabaActionPitch* laba_LabaActionPitch_Alloc(void);

laba_LabaActionPitch* laba_LabaActionPitch_ref_create_CoobIo(laba_LabaActionPitch* self, char operator_, laba_LabaTarget* target, stringext_StringParser* parser, bool inverted_, uint32_t easing_);

None* laba_LabaActionPitch_ref_simpleRelativeValue_offfo(laba_LabaActionPitch* self, stringext_StringParser* parser, float target, float defaultValue, float mod);

None* laba_LabaActionPitch_box_update_ofo(laba_LabaActionPitch* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionPitch_ref_update_ofo(laba_LabaActionPitch* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionPitch_val_update_ofo(laba_LabaActionPitch* self, laba_LabaTarget* target, float animationValue);

/* Allocate a format_FormatHexBare without initialising it. */
format_FormatHexBare* format_FormatHexBare_Alloc(void);

format_FormatHexBare* format_FormatHexBare_val_create_o(format_FormatHexBare* self);

bool format_FormatHexBare_box_eq_ob(format_FormatHexBare* self, format_FormatHexBare* that);

bool format_FormatHexBare_val_eq_ob(format_FormatHexBare* self, format_FormatHexBare* that);

/* Allocate a ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref without initialising it. */
ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref* ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref_Alloc(void);

ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref* ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref_ref_create_oZo(ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref* self, Array_ui_Viewable_tag* array, size_t offset);

bool ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref_box_has_next_b(ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref* self);

bool ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref_ref_has_next_b(ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref* self);

bool ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref_val_has_next_b(ArrayValues_ui_Viewable_tag_Array_ui_Viewable_tag_ref* self);

/* Allocate a $0$9_U32_val without initialising it. */
$0$9_U32_val* $0$9_U32_val_Alloc(void);

bool $0$9_U32_val_ref_apply_IIb($0$9_U32_val* self, uint32_t p1, uint32_t p2);

bool $0$9_U32_val_box_apply_IIb($0$9_U32_val* self, uint32_t p1, uint32_t p2);

bool $0$9_U32_val_val_apply_IIb($0$9_U32_val* self, uint32_t p1, uint32_t p2);

/* Allocate a ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val without initialising it. */
ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val* ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val_Alloc(void);

ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val* ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val_ref_create_oZo(ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val* self, Array_ui_YogaNode_ref* array, size_t offset);

/* Allocate a laba_Laba without initialising it. */
laba_Laba* laba_Laba_Alloc(void);

None* laba_Laba_ref_parse_o(laba_Laba* self);

bool laba_Laba_ref_animate_fb(laba_Laba* self, float delta);

/* Allocate a collections__MapDeleted without initialising it. */
collections__MapDeleted* collections__MapDeleted_Alloc(void);

collections__MapDeleted* collections__MapDeleted_val_create_o(collections__MapDeleted* self);

bool collections__MapDeleted_box_eq_ob(collections__MapDeleted* self, collections__MapDeleted* that);

bool collections__MapDeleted_val_eq_ob(collections__MapDeleted* self, collections__MapDeleted* that);

/* Allocate a Array_laba_Laba_ref without initialising it. */
Array_laba_Laba_ref* Array_laba_Laba_ref_Alloc(void);

/*
The number of elements in the array.
*/
size_t Array_laba_Laba_ref_ref_size_Z(Array_laba_Laba_ref* self);

/*
The number of elements in the array.
*/
size_t Array_laba_Laba_ref_val_size_Z(Array_laba_Laba_ref* self);

/*
The number of elements in the array.
*/
size_t Array_laba_Laba_ref_box_size_Z(Array_laba_Laba_ref* self);

/*
Return an iterator over the values in the array.
*/
ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_ref* Array_laba_Laba_ref_ref_values_o(Array_laba_Laba_ref* self);

/*
Return an iterator over the values in the array.
*/
ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_box* Array_laba_Laba_ref_box_values_o(Array_laba_Laba_ref* self);

/*
Return an iterator over the values in the array.
*/
ArrayValues_laba_Laba_ref_Array_laba_Laba_ref_val* Array_laba_Laba_ref_val_values_o(Array_laba_Laba_ref* self);

/*
Find and delete the first item matching item
*/
None* Array_laba_Laba_ref_ref_deleteAll_oo(Array_laba_Laba_ref* self, laba_Laba* item);

size_t Array_laba_Laba_ref_ref_next_growth_size_ZZ(Array_laba_Laba_ref* self, size_t s);

size_t Array_laba_Laba_ref_val_next_growth_size_ZZ(Array_laba_Laba_ref* self, size_t s);

size_t Array_laba_Laba_ref_box_next_growth_size_ZZ(Array_laba_Laba_ref* self, size_t s);

size_t Array_laba_Laba_ref_tag_next_growth_size_ZZ(Array_laba_Laba_ref* self, size_t s);

/*
Create an array with zero elements, but space for len elements.
*/
Array_laba_Laba_ref* Array_laba_Laba_ref_ref_create_Zo(Array_laba_Laba_ref* self, size_t len);

__uint128_t U128_box_op_and_QQ(__uint128_t self, __uint128_t y);

__uint128_t U128_val_op_and_QQ(__uint128_t self, __uint128_t y);

__uint128_t U128_val_sub_QQ(__uint128_t self, __uint128_t y);

__uint128_t U128_box_sub_QQ(__uint128_t self, __uint128_t y);

__uint128_t U128_box_shl_QQ(__uint128_t self, __uint128_t y);

__uint128_t U128_val_shl_QQ(__uint128_t self, __uint128_t y);

size_t U128_box_usize_Z(__uint128_t self);

size_t U128_val_usize_Z(__uint128_t self);

bool U128_box_ne_Qb(__uint128_t self, __uint128_t y);

bool U128_val_ne_Qb(__uint128_t self, __uint128_t y);

String* U128_box_string_o(__uint128_t self);

String* U128_val_string_o(__uint128_t self);

String* U128_ref_string_o(__uint128_t self);

__uint128_t U128_box_mul_QQ(__uint128_t self, __uint128_t y);

__uint128_t U128_val_mul_QQ(__uint128_t self, __uint128_t y);

bool U128_box_eq_Qb(__uint128_t self, __uint128_t y);

bool U128_val_eq_Qb(__uint128_t self, __uint128_t y);

__uint128_t U128_box_div_QQ(__uint128_t self, __uint128_t y);

__uint128_t U128_val_div_QQ(__uint128_t self, __uint128_t y);

char U128_box_u8_C(__uint128_t self);

char U128_val_u8_C(__uint128_t self);

__uint128_t U128_box_op_or_QQ(__uint128_t self, __uint128_t y);

__uint128_t U128_val_op_or_QQ(__uint128_t self, __uint128_t y);

__uint128_t U128_val_create_QQ(__uint128_t self, __uint128_t value);

__uint128_t U128_val_shr_QQ(__uint128_t self, __uint128_t y);

__uint128_t U128_box_shr_QQ(__uint128_t self, __uint128_t y);

/* Allocate a ArrayPairs_U8_val_Array_U8_val_box without initialising it. */
ArrayPairs_U8_val_Array_U8_val_box* ArrayPairs_U8_val_Array_U8_val_box_Alloc(void);

ArrayPairs_U8_val_Array_U8_val_box* ArrayPairs_U8_val_Array_U8_val_box_ref_create_oo(ArrayPairs_U8_val_Array_U8_val_box* self, Array_U8_val* array);

/* Allocate a ui_RenderPrimitive without initialising it. */
ui_RenderPrimitive* ui_RenderPrimitive_Alloc(void);

ui_RenderPrimitive* ui_RenderPrimitive_val_create_o(ui_RenderPrimitive* self);

None* ui_RenderPrimitive_box_renderFinished_oo(ui_RenderPrimitive* self, ui_FrameContext* frameContext);

None* ui_RenderPrimitive_val_renderFinished_oo(ui_RenderPrimitive* self, ui_FrameContext* frameContext);

None* ui_RenderPrimitive_tag_renderFinished_oo(ui_RenderPrimitive* self, ui_FrameContext* frameContext);

None* ui_RenderPrimitive_val_startFinished_oo(ui_RenderPrimitive* self, ui_FrameContext* frameContext);

None* ui_RenderPrimitive_tag_startFinished_oo(ui_RenderPrimitive* self, ui_FrameContext* frameContext);

None* ui_RenderPrimitive_box_startFinished_oo(ui_RenderPrimitive* self, ui_FrameContext* frameContext);

/* Allocate a t3_U32_val_String_val_String_val without initialising it. */
t3_U32_val_String_val_String_val* t3_U32_val_String_val_String_val_Alloc(void);

/* Allocate a ui_KeyEvent without initialising it. */
ui_KeyEvent* ui_KeyEvent_Alloc(void);

ui_KeyEvent* ui_KeyEvent_val_create_bSoffo(ui_KeyEvent* self, bool pressed_, uint16_t keyCode_, String* characters_, float x, float y);

/* Allocate a laba_LabaActionYaw without initialising it. */
laba_LabaActionYaw* laba_LabaActionYaw_Alloc(void);

laba_LabaActionYaw* laba_LabaActionYaw_ref_create_CoobIo(laba_LabaActionYaw* self, char operator_, laba_LabaTarget* target, stringext_StringParser* parser, bool inverted_, uint32_t easing_);

None* laba_LabaActionYaw_ref_simpleRelativeValue_offfo(laba_LabaActionYaw* self, stringext_StringParser* parser, float target, float defaultValue, float mod);

None* laba_LabaActionYaw_box_update_ofo(laba_LabaActionYaw* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionYaw_ref_update_ofo(laba_LabaActionYaw* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionYaw_val_update_ofo(laba_LabaActionYaw* self, laba_LabaTarget* target, float animationValue);

/* Allocate a laba_LabaActionScale without initialising it. */
laba_LabaActionScale* laba_LabaActionScale_Alloc(void);

laba_LabaActionScale* laba_LabaActionScale_ref_create_CoobIo(laba_LabaActionScale* self, char operator_, laba_LabaTarget* target, stringext_StringParser* parser, bool inverted_, uint32_t easing_);

None* laba_LabaActionScale_ref_simpleAbsoluteValue_offo(laba_LabaActionScale* self, stringext_StringParser* parser, float target, float defaultValue);

None* laba_LabaActionScale_box_update_ofo(laba_LabaActionScale* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionScale_ref_update_ofo(laba_LabaActionScale* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionScale_val_update_ofo(laba_LabaActionScale* self, laba_LabaTarget* target, float animationValue);

/* Allocate a utility_Size without initialising it. */
utility_Size* utility_Size_Alloc(void);

size_t utility_Size_val_apply_Z(utility_Size* self);

size_t utility_Size_box_apply_Z(utility_Size* self);

utility_Size* utility_Size_val_create_o(utility_Size* self);

/*
Keep the contents, but reserve space for len instances of A.
*/
laba_LabaActionGroup** Pointer_laba_LabaActionGroup_ref_ref__realloc_Zo(laba_LabaActionGroup** self, size_t len);

/*
Set index i and return the previous value.
*/
laba_LabaActionGroup* Pointer_laba_LabaActionGroup_ref_ref__update_Zoo(laba_LabaActionGroup** self, size_t i, laba_LabaActionGroup* value);

/*
Retrieve index i.
*/
laba_LabaActionGroup* Pointer_laba_LabaActionGroup_ref_box__apply_Zo(laba_LabaActionGroup** self, size_t i);

/*
Retrieve index i.
*/
laba_LabaActionGroup* Pointer_laba_LabaActionGroup_ref_val__apply_Zo(laba_LabaActionGroup** self, size_t i);

/*
Retrieve index i.
*/
laba_LabaActionGroup* Pointer_laba_LabaActionGroup_ref_ref__apply_Zo(laba_LabaActionGroup** self, size_t i);

/*
Return a pointer to the n-th element.
*/
laba_LabaActionGroup** Pointer_laba_LabaActionGroup_ref_val__offset_Zo(laba_LabaActionGroup** self, size_t n);

/*
Return a pointer to the n-th element.
*/
laba_LabaActionGroup** Pointer_laba_LabaActionGroup_ref_box__offset_Zo(laba_LabaActionGroup** self, size_t n);

/*
Return a pointer to the n-th element.
*/
laba_LabaActionGroup** Pointer_laba_LabaActionGroup_ref_ref__offset_Zo(laba_LabaActionGroup** self, size_t n);

/*
Delete n elements from the head of pointer, compact remaining elements of
the underlying array. The array length before this should be n + len.
Returns the first deleted element.
*/
laba_LabaActionGroup* Pointer_laba_LabaActionGroup_ref_ref__delete_ZZo(laba_LabaActionGroup** self, size_t n, size_t len);

/* Allocate a $0$12_U8_val without initialising it. */
$0$12_U8_val* $0$12_U8_val_Alloc(void);

bool $0$12_U8_val_ref_apply_CCb($0$12_U8_val* self, char l, char r);

bool $0$12_U8_val_val_apply_CCb($0$12_U8_val* self, char l, char r);

bool $0$12_U8_val_box_apply_CCb($0$12_U8_val* self, char l, char r);

$0$12_U8_val* $0$12_U8_val_val_create_o($0$12_U8_val* self);

/* Allocate a easings_Easing_F32_val without initialising it. */
easings_Easing_F32_val* easings_Easing_F32_val_Alloc(void);

float easings_Easing_F32_val_box_tweenQuinticInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenQuinticInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_quadraticIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_quadraticIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_tweenBounceIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenBounceIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_quinticInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_quinticInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_tweenQuarticOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenQuarticOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_exponentialIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_exponentialIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_sineInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_sineInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_bounceIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_bounceIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_exponentialOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_exponentialOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_tweenQuarticIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenQuarticIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_cubicOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_cubicOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_tweenLinear_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenLinear_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenCircularOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenCircularOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_quinticIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_quinticIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_sineIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_sineIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_tweenBounceOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenBounceOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenExponentialIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenExponentialIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenExponentialInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenExponentialInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenBackInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenBackInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenElasticOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenElasticOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenCubicInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenCubicInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_quinticOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_quinticOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_tweenSineInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenSineInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_circularInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_circularInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_tween_Iffff(easings_Easing_F32_val* self, uint32_t id, float a, float b, float t);

float easings_Easing_F32_val_val_tween_Iffff(easings_Easing_F32_val* self, uint32_t id, float a, float b, float t);

float easings_Easing_F32_val_box_quarticIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_quarticIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_elasticInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_elasticInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_tweenBounceInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenBounceInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_backInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_backInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_tweenExponentialOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenExponentialOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_backIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_backIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_tweenBackOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenBackOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_quarticInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_quarticInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_tweenCircularInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenCircularInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_circularOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_circularOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_tweenQuadraticInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenQuadraticInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_cubicIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_cubicIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_tweenCircularIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenCircularIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenQuinticIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenQuinticIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_backOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_backOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_bounceOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_bounceOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_sineOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_sineOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_tweenQuarticInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenQuarticInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenSineIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenSineIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_elasticIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_elasticIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_tweenElasticInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenElasticInOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenCubicIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenCubicIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenQuadraticOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenQuadraticOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenElasticIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenElasticIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_circularIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_circularIn_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_cubicInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_cubicInOut_ff(easings_Easing_F32_val* self, float p);

easings_Easing_F32_val* easings_Easing_F32_val_val_create_o(easings_Easing_F32_val* self);

float easings_Easing_F32_val_val_exponentialInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_exponentialInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_tweenCubicOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenCubicOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenBackIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenBackIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenQuinticOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenQuinticOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_elasticOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_elasticOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_bounceInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_bounceInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_quadraticInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_quadraticInOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_tweenSineOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenSineOut_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_tweenQuadraticIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_val_tweenQuadraticIn_ffff(easings_Easing_F32_val* self, float a, float b, float t);

float easings_Easing_F32_val_box_quadraticOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_quadraticOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_box_quarticOut_ff(easings_Easing_F32_val* self, float p);

float easings_Easing_F32_val_val_quarticOut_ff(easings_Easing_F32_val* self, float p);

/* Allocate a u4_ui_NullEvent_val_ui_TouchEvent_val_ui_ScrollEvent_val_ui_KeyEvent_val without initialising it. */
u4_ui_NullEvent_val_ui_TouchEvent_val_ui_ScrollEvent_val_ui_KeyEvent_val* u4_ui_NullEvent_val_ui_TouchEvent_val_ui_ScrollEvent_val_ui_KeyEvent_val_Alloc(void);

/*
Space for len instances of A.
*/
ui_Viewable** Pointer_ui_Viewable_tag_ref__alloc_Zo(ui_Viewable** self, size_t len);

/*
A null pointer.
*/
ui_Viewable** Pointer_ui_Viewable_tag_ref_create_o(ui_Viewable** self);

/*
Retrieve index i.
*/
ui_Viewable* Pointer_ui_Viewable_tag_box__apply_Zo(ui_Viewable** self, size_t i);

/*
Retrieve index i.
*/
ui_Viewable* Pointer_ui_Viewable_tag_val__apply_Zo(ui_Viewable** self, size_t i);

/*
Retrieve index i.
*/
ui_Viewable* Pointer_ui_Viewable_tag_ref__apply_Zo(ui_Viewable** self, size_t i);

bool Bool_box_op_and_bb(bool self, bool y);

bool Bool_val_op_and_bb(bool self, bool y);

String* Bool_ref_string_o(bool self);

String* Bool_val_string_o(bool self);

String* Bool_box_string_o(bool self);

bool Bool_box_eq_bb(bool self, bool y);

bool Bool_val_eq_bb(bool self, bool y);

bool Bool_box_op_not_b(bool self);

bool Bool_val_op_not_b(bool self);

bool Bool_val_create_bb(bool self, bool from);

bool Bool_val_op_or_bb(bool self, bool y);

bool Bool_box_op_or_bb(bool self, bool y);

/* Allocate a u2_String_box_Array_U8_val_box without initialising it. */
u2_String_box_Array_U8_val_box* u2_String_box_Array_U8_val_box_Alloc(void);

/*
Copy copy_len characters from this to that at specified offsets.
*/
None* u2_String_box_Array_U8_val_box_ref__copy_to_oZZZo(void* self, char* ptr, size_t copy_len, size_t from_offset, size_t to_offset);

/*
Copy copy_len characters from this to that at specified offsets.
*/
None* u2_String_box_Array_U8_val_box_val__copy_to_oZZZo(void* self, char* ptr, size_t copy_len, size_t from_offset, size_t to_offset);

/*
Copy copy_len characters from this to that at specified offsets.
*/
None* u2_String_box_Array_U8_val_box_box__copy_to_oZZZo(void* self, char* ptr, size_t copy_len, size_t from_offset, size_t to_offset);

/* Allocate a laba_LabaActionFade without initialising it. */
laba_LabaActionFade* laba_LabaActionFade_Alloc(void);

laba_LabaActionFade* laba_LabaActionFade_ref_create_CoobIo(laba_LabaActionFade* self, char operator_, laba_LabaTarget* target, stringext_StringParser* parser, bool inverted_, uint32_t easing_);

None* laba_LabaActionFade_box_update_ofo(laba_LabaActionFade* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionFade_ref_update_ofo(laba_LabaActionFade* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaActionFade_val_update_ofo(laba_LabaActionFade* self, laba_LabaTarget* target, float animationValue);

/* Allocate a t2_ISize_val_Bool_val without initialising it. */
t2_ISize_val_Bool_val* t2_ISize_val_Bool_val_Alloc(void);

/* Allocate a collections_Range_USize_val without initialising it. */
collections_Range_USize_val* collections_Range_USize_val_Alloc(void);

size_t collections_Range_USize_val_ref_next_Z(collections_Range_USize_val* self);

collections_Range_USize_val* collections_Range_USize_val_ref_create_ZZZo(collections_Range_USize_val* self, size_t min, size_t max, size_t inc);

bool collections_Range_USize_val_box_has_next_b(collections_Range_USize_val* self);

bool collections_Range_USize_val_ref_has_next_b(collections_Range_USize_val* self);

bool collections_Range_USize_val_val_has_next_b(collections_Range_USize_val* self);

/* Allocate a t2_USize_val_U8_val without initialising it. */
t2_USize_val_U8_val* t2_USize_val_U8_val_Alloc(void);

/* Allocate a stringext_StringExt without initialising it. */
stringext_StringExt* stringext_StringExt_Alloc(void);

stringext_StringExt* stringext_StringExt_val_create_o(stringext_StringExt* self);

String* stringext_StringExt_box_format_oooooooooooooooooooooo(stringext_StringExt* self, String* fmt, Stringable* arg0, Stringable* arg1, Stringable* arg2, Stringable* arg3, Stringable* arg4, Stringable* arg5, Stringable* arg6, Stringable* arg7, Stringable* arg8, Stringable* arg9, Stringable* arg10, Stringable* arg11, Stringable* arg12, Stringable* arg13, Stringable* arg14, Stringable* arg15, Stringable* arg16, Stringable* arg17, Stringable* arg18, Stringable* arg19);

String* stringext_StringExt_val_format_oooooooooooooooooooooo(stringext_StringExt* self, String* fmt, Stringable* arg0, Stringable* arg1, Stringable* arg2, Stringable* arg3, Stringable* arg4, Stringable* arg5, Stringable* arg6, Stringable* arg7, Stringable* arg8, Stringable* arg9, Stringable* arg10, Stringable* arg11, Stringable* arg12, Stringable* arg13, Stringable* arg14, Stringable* arg15, Stringable* arg16, Stringable* arg17, Stringable* arg18, Stringable* arg19);

/* Allocate a u2_AmbientAuth_val_None_val without initialising it. */
u2_AmbientAuth_val_None_val* u2_AmbientAuth_val_None_val_Alloc(void);

/* Allocate a laba_LabaAction without initialising it. */
laba_LabaAction* laba_LabaAction_Alloc(void);

None* laba_LabaAction_box_update_ofo(laba_LabaAction* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaAction_ref_update_ofo(laba_LabaAction* self, laba_LabaTarget* target, float animationValue);

None* laba_LabaAction_val_update_ofo(laba_LabaAction* self, laba_LabaTarget* target, float animationValue);

/* Allocate a apple_Memory without initialising it. */
apple_Memory* apple_Memory_Alloc(void);

Array_U8_val* apple_Memory_val_arrayFromCPointer_oZo(apple_Memory* self, char* data, size_t size);

Array_U8_val* apple_Memory_tag_arrayFromCPointer_oZo(apple_Memory* self, char* data, size_t size);

Array_U8_val* apple_Memory_ref_arrayFromCPointer_oZo(apple_Memory* self, char* data, size_t size);

Array_U8_val* apple_Memory_box_arrayFromCPointer_oZo(apple_Memory* self, char* data, size_t size);

apple_Memory* apple_Memory_tag_create_o__send(apple_Memory* self);

String* apple_Memory_ref_stringFromCPointer_oZo(apple_Memory* self, char* data, size_t size);

String* apple_Memory_tag_stringFromCPointer_oZo(apple_Memory* self, char* data, size_t size);

String* apple_Memory_box_stringFromCPointer_oZo(apple_Memory* self, char* data, size_t size);

String* apple_Memory_val_stringFromCPointer_oZo(apple_Memory* self, char* data, size_t size);

/* Allocate a Array_ui_Geometry_ref without initialising it. */
Array_ui_Geometry_ref* Array_ui_Geometry_ref_Alloc(void);

/*
Reserve space for len elements, including whatever elements are already in
the array. Array space grows geometrically.
*/
None* Array_ui_Geometry_ref_ref_reserve_Zo(Array_ui_Geometry_ref* self, size_t len);

size_t Array_ui_Geometry_ref_ref_next_growth_size_ZZ(Array_ui_Geometry_ref* self, size_t s);

size_t Array_ui_Geometry_ref_val_next_growth_size_ZZ(Array_ui_Geometry_ref* self, size_t s);

size_t Array_ui_Geometry_ref_box_next_growth_size_ZZ(Array_ui_Geometry_ref* self, size_t s);

size_t Array_ui_Geometry_ref_tag_next_growth_size_ZZ(Array_ui_Geometry_ref* self, size_t s);

/*
Add an element to the end of the array.
*/
None* Array_ui_Geometry_ref_ref_push_oo(Array_ui_Geometry_ref* self, ui_Geometry* value);

/*
Create an array with zero elements, but space for len elements.
*/
Array_ui_Geometry_ref* Array_ui_Geometry_ref_ref_create_Zo(Array_ui_Geometry_ref* self, size_t len);

/* Allocate a format_FormatBinaryBare without initialising it. */
format_FormatBinaryBare* format_FormatBinaryBare_Alloc(void);

format_FormatBinaryBare* format_FormatBinaryBare_val_create_o(format_FormatBinaryBare* self);

bool format_FormatBinaryBare_box_eq_ob(format_FormatBinaryBare* self, format_FormatBinaryBare* that);

bool format_FormatBinaryBare_val_eq_ob(format_FormatBinaryBare* self, format_FormatBinaryBare* that);

/* Allocate a format_FormatOctalBare without initialising it. */
format_FormatOctalBare* format_FormatOctalBare_Alloc(void);

format_FormatOctalBare* format_FormatOctalBare_val_create_o(format_FormatOctalBare* self);

bool format_FormatOctalBare_box_eq_ob(format_FormatOctalBare* self, format_FormatOctalBare* that);

bool format_FormatOctalBare_val_eq_ob(format_FormatOctalBare* self, format_FormatOctalBare* that);

/* Allocate a linal_R4fun without initialising it. */
linal_R4fun* linal_R4fun_Alloc(void);

linal_R4fun* linal_R4fun_val_create_o(linal_R4fun* self);

/* Allocate a _SignedCheckedArithmetic without initialising it. */
_SignedCheckedArithmetic* _SignedCheckedArithmetic_Alloc(void);

_SignedCheckedArithmetic* _SignedCheckedArithmetic_val_create_o(_SignedCheckedArithmetic* self);


#ifdef __cplusplus
}
#endif

#endif
