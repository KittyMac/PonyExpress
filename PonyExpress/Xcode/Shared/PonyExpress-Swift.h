
#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import <PonyExpressiOS/PonyExpressiOS-Swift.h>
#else
#import <PonyExpressOSX/PonyExpressOSX-Swift.h>
#endif
