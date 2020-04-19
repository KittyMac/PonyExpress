use "linal"

actor Image is Imageable
  
  new create() =>
    _mode = ImageMode.aspectFit
    _textureName = ""