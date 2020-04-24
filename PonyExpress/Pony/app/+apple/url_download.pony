use "collections"
use "utility"

use @memcpy[Pointer[None]](dst: Pointer[None], src: Pointer[None], n: USize)

use @Apple_URLDownload[None](uuid:String val, url:String val, platform:URLDownload tag)

type URLDownloadResult is (Array[U8] | None)
type URLDownloadCallback is {(URLDownloadResult val)}

actor@ URLDownload
  
  let mapResponses:Map[String,URLDownloadCallback val]
  
  new create() =>
    mapResponses = Map[String,URLDownloadCallback val](64)

  be response(uuid:String, data:Pointer[U8] tag, size:USize val) =>
    try
      let callback = mapResponses(uuid)?
      
      if size == 0 then
        callback(None)
      else
        let ponyData:Array[U8] val = recover
          let p = Array[U8](size)
          p.undefined(size)
          @memcpy(p.cpointer(), data, size)
          p
        end
        callback(ponyData)
      end
    end

  be get(url:String, callback:URLDownloadCallback val) =>
    let uuid:String val = UUID.string()
    mapResponses(uuid) = callback
    @Apple_URLDownload[None](uuid, url, this)
    
