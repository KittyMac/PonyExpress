# Pony Express

Pony Express is a UI toolkit for building fully concurrent applications written in [Pony](https://www.ponylang.io) (an open-source, object-oriented, actor-model, capabilities-secure, high-performance programming language).

# Architecture




# TODOS

## ponyc

* [x] ~~ponyc should skip building if nothing has changed since last build~~
* [x] ~~FFI calls on iOS under release builds are... wonky (see garbled printf output)~~
* [ ] ensure that stub functions or behaviors are optimized out by ponyc

## ponyrt

* [ ] be able to set a maximum memory usage for the ponyrt
* [ ] change ponyrt to free memory back to the OS that it doesn't need anymore

## pony.ui

* [x] ~~scroll view~~
* [x] ~~stencil cropping by view bounds~~
* [ ] input fields

## renderengine

* [ ] ensure that the pony express render can work in multiple views OR can switch views cleanly
* [ ] load textures from image memory in pony
* [ ] expose bundle path conversion to pony
* [ ] fix quick window resize on mac where metal drawable doesn't match the window size
* [ ] fix "out of screen" geometry culling to handle views which are wider than screen

## misc

* [ ] add support for Laba animations

## demos

* [ ] massively scrolling google image search

## platforms

* [x] iOS
* [x] macOS
* [ ] tvOS
* [ ] Android
* [ ] Windows
* [ ] Linux