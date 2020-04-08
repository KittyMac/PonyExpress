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

typedef struct ui_NullEvent ui_NullEvent;

typedef struct StringEncoding StringEncoding;

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
/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct ui_Viewable ui_Viewable;

typedef struct u2_ui_YogaNode_ref_None_val u2_ui_YogaNode_ref_None_val;

typedef struct PlatformOSX PlatformOSX;

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

typedef struct ui_ShaderType ui_ShaderType;

typedef struct t4_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val t4_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val;

/*
tuple based Vector 2 functions - see VectorFun for details*/
typedef struct linal_V2fun linal_V2fun;

typedef struct _SignedPartialArithmetic _SignedPartialArithmetic;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
/*
Worker type providing simple to string conversions for numbers.
*/
typedef struct _ToString _ToString;

typedef struct ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box;

typedef struct t4_F32_val_F32_val_F32_val_F32_val t4_F32_val_F32_val_F32_val_F32_val;

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

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
/*
Asnychronous access to some output stream.
*/
typedef struct OutStream OutStream;

/*
functions for a 4x4 matrix*/
typedef struct linal_M4fun linal_M4fun;

typedef struct $0$12_U32_val $0$12_U32_val;

typedef struct $0$6 $0$6;

typedef struct _UnsignedPartialArithmetic _UnsignedPartialArithmetic;

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

typedef struct u2_ui_RenderEngine_tag_None_val u2_ui_RenderEngine_tag_None_val;

/*
An environment holds the command line and other values injected into the
program by default by the runtime.
*/
typedef struct Env Env;

/*
tuple based Vector 3 functions - see VectorFun for details*/
typedef struct linal_V3fun linal_V3fun;

/*
A UnsafePointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. UnsafePointer[A]
is exactly like Pointer[A] except none of the method are private, allowing the Pony developer
the freedom to use unsafe pointer capabilities if they so choose.
*/
typedef struct t2_USize_val_USize_val t2_USize_val_USize_val;

typedef struct StringRunes StringRunes;

typedef struct u2_ui_Viewable_tag_None_val u2_ui_Viewable_tag_None_val;

typedef struct yoga_YGNode yoga_YGNode;

typedef struct ui_RenderContext ui_RenderContext;

typedef struct t3_F32_val_F32_val_F32_val t3_F32_val_F32_val_F32_val;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct utility_Log utility_Log;

typedef struct None None;

typedef struct u2_ui_NullEvent_val_ui_TouchEvent_val u2_ui_NullEvent_val_ui_TouchEvent_val;

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

typedef struct PonyPlatform PonyPlatform;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct PlatformIOS PlatformIOS;

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

typedef struct t2_U32_val_U8_val t2_U32_val_U8_val;

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

typedef struct ui_YogaNode ui_YogaNode;

typedef struct ui_TouchEvent ui_TouchEvent;

typedef struct $0$9_U32_val $0$9_U32_val;

typedef struct ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val;

/*
Rendering actors can call this concurrently safely to submit geometry to the platform rendering engine
*/
typedef struct ui_RenderPrimitive ui_RenderPrimitive;

typedef struct ui_$2$17 ui_$2$17;

/*
A Pointer[A] is a raw memory pointer. It has no descriptor and thus can't be
included in a union or intersection, or be a subtype of any interface. Most
functions on a Pointer[A] are private to maintain memory safety.
*/
typedef struct u2_String_box_Array_U8_val_box u2_String_box_Array_U8_val_box;

typedef struct t2_ISize_val_Bool_val t2_ISize_val_Bool_val;

typedef struct stringext_StringExt stringext_StringExt;

typedef struct u2_AmbientAuth_val_None_val u2_AmbientAuth_val_None_val;

/*
rectangle operations for R4*/
typedef struct linal_R4fun linal_R4fun;

typedef struct _SignedCheckedArithmetic _SignedCheckedArithmetic;

/* Allocate a t3_t2_F32_val_F32_val_F32_val_F32_val without initialising it. */
t3_t2_F32_val_F32_val_F32_val_F32_val* t3_t2_F32_val_F32_val_F32_val_F32_val_Alloc(void);

/* Allocate a ui_NullEvent without initialising it. */
ui_NullEvent* ui_NullEvent_Alloc(void);

/* Allocate a StringEncoding without initialising it. */
StringEncoding* StringEncoding_Alloc(void);

StringEncoding* StringEncoding_val_create_o(StringEncoding* self);

uint32_t StringEncoding_val_utf8_I(StringEncoding* self);

uint32_t StringEncoding_box_utf8_I(StringEncoding* self);

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

String* F64_box_string_o(double self);

String* F64_val_string_o(double self);

String* F64_ref_string_o(double self);

double F64_val_f64_d(double self);

double F64_box_f64_d(double self);

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

/* Allocate a ui_Viewable without initialising it. */
ui_Viewable* ui_Viewable_Alloc(void);

None* ui_Viewable_tag_viewable_start_oo(ui_Viewable* self, ui_FrameContext* frameContext);

None* ui_Viewable_ref_start_oo(ui_Viewable* self, ui_FrameContext* frameContext);

/* Allocate a u2_ui_YogaNode_ref_None_val without initialising it. */
u2_ui_YogaNode_ref_None_val* u2_ui_YogaNode_ref_None_val_Alloc(void);

uint64_t U32_val_u64_W(uint32_t self);

uint64_t U32_box_u64_W(uint32_t self);

uint32_t U32_box_sub_II(uint32_t self, uint32_t y);

uint32_t U32_val_sub_II(uint32_t self, uint32_t y);

uint32_t U32_val_shl_II(uint32_t self, uint32_t y);

uint32_t U32_box_shl_II(uint32_t self, uint32_t y);

String* U32_ref_string_o(uint32_t self);

String* U32_val_string_o(uint32_t self);

String* U32_box_string_o(uint32_t self);

uint32_t U32_val_add_II(uint32_t self, uint32_t y);

uint32_t U32_box_add_II(uint32_t self, uint32_t y);

uint32_t U32_val_create_II(uint32_t self, uint32_t value);

/* Allocate a PlatformOSX without initialising it. */
PlatformOSX* PlatformOSX_Alloc(void);

PlatformOSX* PlatformOSX_tag_create_oo__send(PlatformOSX* self, Env* env);

None* PlatformOSX_val_poll_o(PlatformOSX* self);

None* PlatformOSX_ref_register_oo(PlatformOSX* self, PonyPlatform* platform);

bool PlatformOSX_box__use_main_thread_b(PlatformOSX* self);

/* Allocate a AmbientAuth without initialising it. */
AmbientAuth* AmbientAuth_Alloc(void);

/* Allocate a ui_ShaderType without initialising it. */
ui_ShaderType* ui_ShaderType_Alloc(void);

ui_ShaderType* ui_ShaderType_val_create_o(ui_ShaderType* self);

uint32_t ui_ShaderType_val_finished_I(ui_ShaderType* self);

uint32_t ui_ShaderType_box_finished_I(ui_ShaderType* self);

bool USize_val_le_Zb(size_t self, size_t y);

bool USize_box_le_Zb(size_t self, size_t y);

bool USize_box_ge_Zb(size_t self, size_t y);

bool USize_val_ge_Zb(size_t self, size_t y);

uint64_t USize_val_u64_W(size_t self);

uint64_t USize_box_u64_W(size_t self);

size_t USize_val_bitwidth_Z(size_t self);

size_t USize_box_bitwidth_Z(size_t self);

size_t USize_box_sub_ZZ(size_t self, size_t y);

size_t USize_val_sub_ZZ(size_t self, size_t y);

size_t USize_val_shl_ZZ(size_t self, size_t y);

size_t USize_box_shl_ZZ(size_t self, size_t y);

size_t USize_box_usize_Z(size_t self);

size_t USize_val_usize_Z(size_t self);

bool USize_val_ne_Zb(size_t self, size_t y);

bool USize_box_ne_Zb(size_t self, size_t y);

size_t USize_val_max_value_Z(size_t self);

String* USize_ref_string_o(size_t self);

String* USize_val_string_o(size_t self);

String* USize_box_string_o(size_t self);

size_t USize_val_add_ZZ(size_t self, size_t y);

size_t USize_box_add_ZZ(size_t self, size_t y);

size_t USize_val_next_pow2_Z(size_t self);

size_t USize_box_next_pow2_Z(size_t self);

bool USize_box_eq_Zb(size_t self, size_t y);

bool USize_val_eq_Zb(size_t self, size_t y);

size_t USize_box_div_ZZ(size_t self, size_t y);

size_t USize_val_div_ZZ(size_t self, size_t y);

size_t USize_box_clz_Z(size_t self);

size_t USize_val_clz_Z(size_t self);

size_t USize_val_max_ZZ(size_t self, size_t y);

size_t USize_box_max_ZZ(size_t self, size_t y);

ssize_t USize_box_isize_z(size_t self);

ssize_t USize_val_isize_z(size_t self);

size_t USize_val_from_U8_val_CZ(size_t self, char a);

size_t USize_val_neg_Z(size_t self);

size_t USize_box_neg_Z(size_t self);

size_t USize_val_min_ZZ(size_t self, size_t y);

size_t USize_box_min_ZZ(size_t self, size_t y);

size_t USize_val_create_ZZ(size_t self, size_t value);

bool USize_val_lt_Zb(size_t self, size_t y);

bool USize_box_lt_Zb(size_t self, size_t y);

bool USize_val_gt_Zb(size_t self, size_t y);

bool USize_box_gt_Zb(size_t self, size_t y);

/* Allocate a t4_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val without initialising it. */
t4_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val* t4_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_t4_F32_val_F32_val_F32_val_F32_val_Alloc(void);

/* Allocate a linal_V2fun without initialising it. */
linal_V2fun* linal_V2fun_Alloc(void);

linal_V2fun* linal_V2fun_val_create_o(linal_V2fun* self);

/* Allocate a _SignedPartialArithmetic without initialising it. */
_SignedPartialArithmetic* _SignedPartialArithmetic_Alloc(void);

_SignedPartialArithmetic* _SignedPartialArithmetic_val_create_o(_SignedPartialArithmetic* self);

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

/* Allocate a _ToString without initialising it. */
_ToString* _ToString_Alloc(void);

_ToString* _ToString_val_create_o(_ToString* self);

String* _ToString_val__f64_do(_ToString* self, double x);

String* _ToString_box__f64_do(_ToString* self, double x);

String* _ToString_box__u64_Wbo(_ToString* self, uint64_t x, bool neg);

String* _ToString_val__u64_Wbo(_ToString* self, uint64_t x, bool neg);

/* Allocate a ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box without initialising it. */
ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box* ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box_Alloc(void);

ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box* ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box_ref_create_oZo(ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_box* self, Array_ui_YogaNode_ref* array, size_t offset);

/* Allocate a t4_F32_val_F32_val_F32_val_F32_val without initialising it. */
t4_F32_val_F32_val_F32_val_F32_val* t4_F32_val_F32_val_F32_val_F32_val_Alloc(void);

/* Allocate a Array_U8_val without initialising it. */
Array_U8_val* Array_U8_val_Alloc(void);

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

/*
The number of elements in the array.
*/
size_t Array_U8_val_box_size_Z(Array_U8_val* self);

/*
The number of elements in the array.
*/
size_t Array_U8_val_val_size_Z(Array_U8_val* self);

/*
The number of elements in the array.
*/
size_t Array_U8_val_ref_size_Z(Array_U8_val* self);

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

/* Allocate a _UnsignedPartialArithmetic without initialising it. */
_UnsignedPartialArithmetic* _UnsignedPartialArithmetic_Alloc(void);

_UnsignedPartialArithmetic* _UnsignedPartialArithmetic_val_create_o(_UnsignedPartialArithmetic* self);

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

uint64_t U64_val_u64_W(uint64_t self);

uint64_t U64_box_u64_W(uint64_t self);

uint64_t U64_box_sub_WW(uint64_t self, uint64_t y);

uint64_t U64_val_sub_WW(uint64_t self, uint64_t y);

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

uint64_t U64_val_mul_WW(uint64_t self, uint64_t y);

uint64_t U64_box_mul_WW(uint64_t self, uint64_t y);

bool U64_val_eq_Wb(uint64_t self, uint64_t y);

bool U64_box_eq_Wb(uint64_t self, uint64_t y);

uint64_t U64_box_div_WW(uint64_t self, uint64_t y);

uint64_t U64_val_div_WW(uint64_t self, uint64_t y);

uint64_t U64_val_create_WW(uint64_t self, uint64_t value);

/* Allocate a u2_ui_RenderEngine_tag_None_val without initialising it. */
u2_ui_RenderEngine_tag_None_val* u2_ui_RenderEngine_tag_None_val_Alloc(void);

/* Allocate a Env without initialising it. */
Env* Env_Alloc(void);

/* Allocate a linal_V3fun without initialising it. */
linal_V3fun* linal_V3fun_Alloc(void);

linal_V3fun* linal_V3fun_val_create_o(linal_V3fun* self);

/*
A null pointer.
*/
float* UnsafePointer_F32_val_ref_create_o(float* self);

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

bool U8_val_gt_Cb(char self, char y);

bool U8_box_gt_Cb(char self, char y);

/* Allocate a t2_USize_val_USize_val without initialising it. */
t2_USize_val_USize_val* t2_USize_val_USize_val_Alloc(void);

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

/* Allocate a u2_ui_Viewable_tag_None_val without initialising it. */
u2_ui_Viewable_tag_None_val* u2_ui_Viewable_tag_None_val_Alloc(void);

/* Allocate a yoga_YGNode without initialising it. */
yoga_YGNode* yoga_YGNode_Alloc(void);

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

String* ISize_box_string_o(ssize_t self);

String* ISize_val_string_o(ssize_t self);

String* ISize_ref_string_o(ssize_t self);

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

/*
A null pointer.
*/
None** Pointer_None_val_ref_create_o(None** self);

/* Allocate a utility_Log without initialising it. */
utility_Log* utility_Log_Alloc(void);

utility_Log* utility_Log_val_create_o(utility_Log* self);

None* utility_Log_val_println_oooooooooooooooooooooo(utility_Log* self, String* fmt, Stringable* arg0, Stringable* arg1, Stringable* arg2, Stringable* arg3, Stringable* arg4, Stringable* arg5, Stringable* arg6, Stringable* arg7, Stringable* arg8, Stringable* arg9, Stringable* arg10, Stringable* arg11, Stringable* arg12, Stringable* arg13, Stringable* arg14, Stringable* arg15, Stringable* arg16, Stringable* arg17, Stringable* arg18, Stringable* arg19);

None* utility_Log_box_println_oooooooooooooooooooooo(utility_Log* self, String* fmt, Stringable* arg0, Stringable* arg1, Stringable* arg2, Stringable* arg3, Stringable* arg4, Stringable* arg5, Stringable* arg6, Stringable* arg7, Stringable* arg8, Stringable* arg9, Stringable* arg10, Stringable* arg11, Stringable* arg12, Stringable* arg13, Stringable* arg14, Stringable* arg15, Stringable* arg16, Stringable* arg17, Stringable* arg18, Stringable* arg19);

/* Allocate a None without initialising it. */
None* None_Alloc(void);

String* None_ref_string_o(None* self);

String* None_val_string_o(None* self);

String* None_box_string_o(None* self);

None* None_val_create_o(None* self);

bool None_box_eq_ob(None* self, None* that);

bool None_val_eq_ob(None* self, None* that);

/* Allocate a u2_ui_NullEvent_val_ui_TouchEvent_val without initialising it. */
u2_ui_NullEvent_val_ui_TouchEvent_val* u2_ui_NullEvent_val_ui_TouchEvent_val_Alloc(void);

/* Allocate a ui_RenderEngine without initialising it. */
ui_RenderEngine* ui_RenderEngine_Alloc(void);

None* ui_RenderEngine_tag_getNodeByName_ooo__send(ui_RenderEngine* self, String* nodeName, ui_$2$17* callback);

None* ui_RenderEngine_tag_getNodeByID_Zoo__send(ui_RenderEngine* self, size_t id, ui_$2$17* callback);

None* ui_RenderEngine_tag_addNode_oo__send(ui_RenderEngine* self, ui_YogaNode* yoga);

None* ui_RenderEngine_ref_handleNewNodeAdded_o(ui_RenderEngine* self);

None* ui_RenderEngine_tag_addToNodeByName_ooo__send(ui_RenderEngine* self, String* nodeName, ui_YogaNode* yoga);

None* ui_RenderEngine_tag_touchEvent_Zbffo__send(ui_RenderEngine* self, size_t id, bool pressed, float x, float y);

String* ui_RenderEngine_ref_root_o(ui_RenderEngine* self);

String* ui_RenderEngine_val_root_o(ui_RenderEngine* self);

String* ui_RenderEngine_tag_root_o(ui_RenderEngine* self);

String* ui_RenderEngine_box_root_o(ui_RenderEngine* self);

None* ui_RenderEngine_tag_renderAll_o__send(ui_RenderEngine* self);

uint32_t ui_RenderEngine_box__prioritiy_I(ui_RenderEngine* self);

uint32_t ui_RenderEngine_val__prioritiy_I(ui_RenderEngine* self);

uint32_t ui_RenderEngine_ref__prioritiy_I(ui_RenderEngine* self);

ui_RenderEngine* ui_RenderEngine_tag_empty_o__send(ui_RenderEngine* self);

uint32_t ui_RenderEngine_box__batch_I(ui_RenderEngine* self);

None* ui_RenderEngine_tag_setNeedsRendered_o__send(ui_RenderEngine* self);

None* ui_RenderEngine_ref_layout_o(ui_RenderEngine* self);

None* ui_RenderEngine_box__final_o(ui_RenderEngine* self);

None* ui_RenderEngine_tag_renderFinished_o__send(ui_RenderEngine* self);

None* ui_RenderEngine_tag_startFinished_o__send(ui_RenderEngine* self);

uint32_t ui_RenderEngine_box__tag_I(ui_RenderEngine* self);

None* ui_RenderEngine_tag_setNeedsLayout_o__send(ui_RenderEngine* self);

None* ui_RenderEngine_tag_updateBounds_ffo__send(ui_RenderEngine* self, float w, float h);

ui_RenderEngine* ui_RenderEngine_tag_create_o__send(ui_RenderEngine* self);

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

/* Allocate a PlatformIOS without initialising it. */
PlatformIOS* PlatformIOS_Alloc(void);

PlatformIOS* PlatformIOS_tag_create_oo__send(PlatformIOS* self, Env* env);

None* PlatformIOS_val_poll_o(PlatformIOS* self);

None* PlatformIOS_ref_register_oo(PlatformIOS* self, PonyPlatform* platform);

bool PlatformIOS_box__use_main_thread_b(PlatformIOS* self);

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

/* Allocate a t2_F32_val_F32_val without initialising it. */
t2_F32_val_F32_val* t2_F32_val_F32_val_Alloc(void);

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

float F32_val_sub_ff(float self, float y);

float F32_box_sub_ff(float self, float y);

String* F32_ref_string_o(float self);

String* F32_val_string_o(float self);

String* F32_box_string_o(float self);

float F32_box_add_ff(float self, float y);

float F32_val_add_ff(float self, float y);

float F32_box_mul_ff(float self, float y);

float F32_val_mul_ff(float self, float y);

float F32_box_div_ff(float self, float y);

float F32_val_div_ff(float self, float y);

double F32_val_f64_d(float self);

double F32_box_f64_d(float self);

float F32_box_neg_f(float self);

float F32_val_neg_f(float self);

float F32_val_create_ff(float self, float value);

bool F32_box_lt_fb(float self, float y);

bool F32_val_lt_fb(float self, float y);

/* Allocate a t2_U32_val_U8_val without initialising it. */
t2_U32_val_U8_val* t2_U32_val_U8_val_Alloc(void);

/* Allocate a ui_FrameContext without initialising it. */
ui_FrameContext* ui_FrameContext_Alloc(void);

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

/* Allocate a ui_YogaNode without initialising it. */
ui_YogaNode* ui_YogaNode_Alloc(void);

void* ui_YogaNode_ref_getNodeByName_oo(ui_YogaNode* self, String* nodeName);

None* ui_YogaNode_ref_widthPercent_fo(ui_YogaNode* self, float v);

void* ui_YogaNode_ref_getNodeByID_Zo(ui_YogaNode* self, size_t nodeID);

size_t ui_YogaNode_val_id_Z(ui_YogaNode* self);

size_t ui_YogaNode_box_id_Z(ui_YogaNode* self);

size_t ui_YogaNode_ref_id_Z(ui_YogaNode* self);

None* ui_YogaNode_ref_removeChildren_o(ui_YogaNode* self);

uint64_t ui_YogaNode_ref_event_ooW(ui_YogaNode* self, ui_FrameContext* frameContext, void* anyEvent);

None* ui_YogaNode_ref_height_fo(ui_YogaNode* self, float v);

None* ui_YogaNode_ref_fill_o(ui_YogaNode* self);

None* ui_YogaNode_ref_addChild_oo(ui_YogaNode* self, ui_YogaNode* child);

uint64_t ui_YogaNode_ref_start_oW(ui_YogaNode* self, ui_FrameContext* frameContext);

None* ui_YogaNode_ref_heightPercent_fo(ui_YogaNode* self, float v);

None* ui_YogaNode_ref_layout_o(ui_YogaNode* self);

uint64_t ui_YogaNode_ref_render_oW(ui_YogaNode* self, ui_FrameContext* frameContext);

None* ui_YogaNode_box__final_o(ui_YogaNode* self);

None* ui_YogaNode_ref_width_fo(ui_YogaNode* self, float v);

ui_YogaNode* ui_YogaNode_ref_create_o(ui_YogaNode* self);

None* ui_YogaNode_ref_name_oo(ui_YogaNode* self, String* name_);

/* Allocate a ui_TouchEvent without initialising it. */
ui_TouchEvent* ui_TouchEvent_Alloc(void);

ui_TouchEvent* ui_TouchEvent_val_create_Zbffo(ui_TouchEvent* self, size_t id_, bool pressed_, float x, float y);

/* Allocate a $0$9_U32_val without initialising it. */
$0$9_U32_val* $0$9_U32_val_Alloc(void);

bool $0$9_U32_val_ref_apply_IIb($0$9_U32_val* self, uint32_t p1, uint32_t p2);

bool $0$9_U32_val_box_apply_IIb($0$9_U32_val* self, uint32_t p1, uint32_t p2);

bool $0$9_U32_val_val_apply_IIb($0$9_U32_val* self, uint32_t p1, uint32_t p2);

/* Allocate a ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val without initialising it. */
ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val* ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val_Alloc(void);

ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val* ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val_ref_create_oZo(ArrayValues_ui_YogaNode_ref_Array_ui_YogaNode_ref_val* self, Array_ui_YogaNode_ref* array, size_t offset);

/* Allocate a ui_RenderPrimitive without initialising it. */
ui_RenderPrimitive* ui_RenderPrimitive_Alloc(void);

ui_RenderPrimitive* ui_RenderPrimitive_val_create_o(ui_RenderPrimitive* self);

None* ui_RenderPrimitive_box_renderFinished_oo(ui_RenderPrimitive* self, ui_FrameContext* frameContext);

None* ui_RenderPrimitive_val_renderFinished_oo(ui_RenderPrimitive* self, ui_FrameContext* frameContext);

None* ui_RenderPrimitive_tag_renderFinished_oo(ui_RenderPrimitive* self, ui_FrameContext* frameContext);

None* ui_RenderPrimitive_val_startFinished_oo(ui_RenderPrimitive* self, ui_FrameContext* frameContext);

None* ui_RenderPrimitive_tag_startFinished_oo(ui_RenderPrimitive* self, ui_FrameContext* frameContext);

None* ui_RenderPrimitive_box_startFinished_oo(ui_RenderPrimitive* self, ui_FrameContext* frameContext);

/* Allocate a ui_$2$17 without initialising it. */
ui_$2$17* ui_$2$17_Alloc(void);

bool ui_$2$17_box_apply_ob(ui_$2$17* self, ui_YogaNode* p1);

bool ui_$2$17_val_apply_ob(ui_$2$17* self, ui_YogaNode* p1);

bool ui_$2$17_ref_apply_ob(ui_$2$17* self, ui_YogaNode* p1);

bool Bool_box_op_and_bb(bool self, bool y);

bool Bool_val_op_and_bb(bool self, bool y);

String* Bool_ref_string_o(bool self);

String* Bool_val_string_o(bool self);

String* Bool_box_string_o(bool self);

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

/* Allocate a t2_ISize_val_Bool_val without initialising it. */
t2_ISize_val_Bool_val* t2_ISize_val_Bool_val_Alloc(void);

/* Allocate a stringext_StringExt without initialising it. */
stringext_StringExt* stringext_StringExt_Alloc(void);

stringext_StringExt* stringext_StringExt_val_create_o(stringext_StringExt* self);

String* stringext_StringExt_box_format_oooooooooooooooooooooo(stringext_StringExt* self, String* fmt, Stringable* arg0, Stringable* arg1, Stringable* arg2, Stringable* arg3, Stringable* arg4, Stringable* arg5, Stringable* arg6, Stringable* arg7, Stringable* arg8, Stringable* arg9, Stringable* arg10, Stringable* arg11, Stringable* arg12, Stringable* arg13, Stringable* arg14, Stringable* arg15, Stringable* arg16, Stringable* arg17, Stringable* arg18, Stringable* arg19);

String* stringext_StringExt_val_format_oooooooooooooooooooooo(stringext_StringExt* self, String* fmt, Stringable* arg0, Stringable* arg1, Stringable* arg2, Stringable* arg3, Stringable* arg4, Stringable* arg5, Stringable* arg6, Stringable* arg7, Stringable* arg8, Stringable* arg9, Stringable* arg10, Stringable* arg11, Stringable* arg12, Stringable* arg13, Stringable* arg14, Stringable* arg15, Stringable* arg16, Stringable* arg17, Stringable* arg18, Stringable* arg19);

/* Allocate a u2_AmbientAuth_val_None_val without initialising it. */
u2_AmbientAuth_val_None_val* u2_AmbientAuth_val_None_val_Alloc(void);

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
