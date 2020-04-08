/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Header for the cross-platform view controller
*/

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
@import UIKit;
#define PlatformViewController UIViewController
#else
@import AppKit;
#define PlatformViewController NSViewController
#endif

#import "PonyExpressView.h"

@interface PonyExpressViewController : PlatformViewController <PonyExpressViewDelegate>

@end
