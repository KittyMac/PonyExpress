use "collections"
use "utility"

use @Apple_URLDownload[None](uuid:String val, url:String val, sender:URLDownload tag)

type URLDownloadError is String
type URLDownloadResult is (Array[U8] | URLDownloadError)
type URLDownloadCallback is {(URLDownloadResult val)}

actor@ URLDownload
  
  let mapResponses:Map[String,URLDownloadCallback val]
  
  // Note: this appears to be necessary to force cstring() to be included in the
  // generated C header.
  fun ref neverCalled() =>
    "hello".cstring()
  
  new create() =>
    mapResponses = Map[String,URLDownloadCallback val](64)

  be responseFail(uuid:String, errorString:String val) =>
    try
      let callback = mapResponses(uuid)?
      callback(errorString)
    end
  
  be responseSuccess(uuid:String, data:Array[U8] val) =>
    try
      let callback = mapResponses(uuid)?
      callback(data)
    end

  be get(url:String, callback:URLDownloadCallback val) =>
    let uuid:String val = UUID.string()
    mapResponses(uuid) = callback
    @Apple_URLDownload[None](uuid, url, this)
    
