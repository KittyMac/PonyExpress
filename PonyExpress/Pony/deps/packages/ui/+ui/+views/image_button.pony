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

  var unpressedImage:String
  var pressedImage:String
  
  var _pressedColor:RGBA
  var _unpressedColor:RGBA
    
	new create(unpressedImage':String, pressedImage':String, pressedColor':RGBA = RGBA.white()) =>
    unpressedImage = unpressedImage'
    pressedImage = pressedImage'
    _pressedColor = pressedColor'
    _unpressedColor = pressedColor'
  
  be pressedColor(rgba:RGBA) =>
    _pressedColor = rgba
    bufferedGeometry.invalidate()
  
  be color(rgba:RGBA) =>
    _unpressedColor = rgba
    _color = rgba
    bufferedGeometry.invalidate()
  
  fun ref start(frameContext:FrameContext val) =>
    _textureName = unpressedImage
    imageable_start(frameContext)
  
  fun ref updateButton(pressed:Bool) =>
    if pressed then
      _textureName = pressedImage
      _color = _pressedColor
    else
      _textureName = unpressedImage
      _color = _unpressedColor
    end
    bufferedGeometry.invalidate()
    if engine as RenderEngine then
        engine.setNeedsRendered()
    end

  fun ref event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    buttonable_event(frameContext, anyEvent, bounds)
  
  fun ref render(frameContext:FrameContext val, bounds:R4) =>
    imageable_render(frameContext, bounds)
  
