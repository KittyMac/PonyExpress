
#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import <PonyExpress_iOS/PonyExpress_iOS-Swift.h>
#else
#import <PonyExpress_macOS/PonyExpress_macOS-Swift.h>
#endif
