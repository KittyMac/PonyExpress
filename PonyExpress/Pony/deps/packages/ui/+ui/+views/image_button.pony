use "linal"
use "stringext"
use "utility"

actor ImageButton is (Imageable & Buttonable)
  """
  A button which toggles between two supplied images.

  Example:

  YogaNode.view(ImageButton( "unpressed_button", "pressed_button" ).>sizeToFit()
                                                                   .>onClick({ 
    () =>
      @printf("clicked 3!\n".cstring())
    }))
  """

  var _unpressedImage:(String|None) = None
  var _pressedImage:(String|None) = None
  
  var _pressedColor:RGBA = RGBA.white()
  var _unpressedColor:RGBA = RGBA.white()
    
  be pressedPath(_pressedImage':(String|None)) =>
    _pressedImage = _pressedImage'
    updateButton(buttonPressed)
  
  be unpressedPath(_unpressedImage':(String|None)) =>
    _unpressedImage = _unpressedImage'
    updateButton(buttonPressed)
  
  be pressedColor(rgba:RGBA) =>
    _pressedColor = rgba
    updateButton(buttonPressed)
  
  be color(rgba:RGBA) =>
    _unpressedColor = rgba
    _color = rgba
    updateButton(buttonPressed)
  
  fun ref start(frameContext:FrameContext val) =>
    if _unpressedImage as String then
      _textureName = _unpressedImage
    end
    imageable_start(frameContext)
  
  fun ref updateButton(pressed:Bool) =>
    if pressed then
      if _pressedImage as String then
        _textureName = _pressedImage
      else
        _textureName = _pathImage
      end
      _color = _pressedColor
    else
      if _unpressedImage as String then
        _textureName = _unpressedImage
      else
        _textureName = _pathImage
      end
      _color = _unpressedColor
    end
    bufferedGeometry.invalidate()
    setNeedsRendered()

  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    buttonable_event(frameContext, anyEvent, bounds)
  
  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    imageable_render(frameContext, bounds)
  
