use "collections"
use "utility"

use @Apple_URLDownload[None](sender:URLDownload tag, uuid:String, method:String, body:String, url:String)

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

  be get(url:String, body:(String|None), callback:URLDownloadCallback val) =>
    let uuid:String val = UUID.string()
    mapResponses(uuid) = callback
    match body
    | let bodyAsString:String => @Apple_URLDownload(this, uuid, "GET", bodyAsString, url)
    | None => @Apple_URLDownload(this, uuid, "GET", "", url)
    end
  
  be put(url:String, body:(String|None), callback:URLDownloadCallback val) =>
    let uuid:String val = UUID.string()
    mapResponses(uuid) = callback
    match body
    | let bodyAsString:String => @Apple_URLDownload(this, uuid, "PUT", bodyAsString, url)
    | None => @Apple_URLDownload(this, uuid, "PUT", "", url)
    end
  
  be post(url:String, body:(String|None), callback:URLDownloadCallback val) =>
    let uuid:String val = UUID.string()
    mapResponses(uuid) = callback
    match body
    | let bodyAsString:String => @Apple_URLDownload(this, uuid, "POST", bodyAsString, url)
    | None => @Apple_URLDownload(this, uuid, "POST", "", url)
    end
    
