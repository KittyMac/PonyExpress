use "linal"

actor Image is Imageable
  new empty() =>
    _mode = ImageMode.aspectFit
    _textureName = ""
  
  new create(textureName:String) =>
    _mode = ImageMode.aspectFit
    _textureName = textureName