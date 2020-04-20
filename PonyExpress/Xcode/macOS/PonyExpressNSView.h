/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Customized view for macOS
*/

#import <Metal/Metal.h>
#import <AppKit/AppKit.h>
#import "PonyExpressView.h"

@interface PonyExpressNSView : PonyExpressView

- (void)showKeyboard;
- (void)hideKeyboard;

@end
