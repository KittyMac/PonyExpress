# Pony Express

Pony Express is a UI toolkit for building fully concurrent applications written in [Pony](https://www.ponylang.io) (an open-source, object-oriented, actor-model, capabilities-secure, high-performance programming language).

# Architecture




# TODOS

## ponyc

* [x] ~~ponyc should skip building if nothing has changed since last build~~
* [ ] ensure that stub functions or behaviors are optimized out by ponyc
* [x] ~~FFI calls on iOS under release builds are... wonky (see garbled printf output)~~

## ponyrt

* [ ] be able to set a maximum memory usaged for the ponyrt
* [ ] change ponyrt to free memory back to the OS that it doesn't need anymore

## pony.ui

* [ ] scroll view
* [x] ~~stencil cropping by view bounds~~
* [ ] input fields

## renderengine

* [ ] ensure that the pony express render can work in multiple views OR at least can switch views cleanly
* [ ] load textures from image memory in pony
* [ ] expose bundle path conversion to pony

## misc

* [ ] in StringExt.format, if the %s is at the end of the string the print is garbled on iOS

## demos

* [ ] massively scrolling google image search

## platforms

* [x] iOS
* [x] macOS
* [ ] tvOS
* [ ] Android
* [ ] Windows
* [ ] Linux