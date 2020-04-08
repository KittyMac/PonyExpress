#include <stdio.h>
#include "PonyPlatform.h"

#import "PonyExpress-Swift.h"

// The Pony code registers all of its actors before NSApplicationMain/UIApplicationMain is called
// so the rest of the application can rest assured that these will never be null.

PlatformOSX * platformActor = NULL;

void registerPlatformActor(PlatformOSX * actor) {
    platformActor = actor;
}

