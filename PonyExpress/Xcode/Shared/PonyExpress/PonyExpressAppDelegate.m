/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Application delegate for Metal Sample Code
*/

#import "PonyExpressAppDelegate.h"

@implementation PonyExpressAppDelegate

#if TARGET_OS_OSX
// Close app when window is closed
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app {
    return YES;
}
#endif

@end
