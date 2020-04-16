
use @registerPlatformActor[None](platform:PonyPlatform tag)

trait PonyPlatform
  fun val poll() =>
    @ponyint_poll_self[None]()
  
  fun ref register(platform:PonyPlatform tag) =>
    @registerPlatformActor(platform)
  