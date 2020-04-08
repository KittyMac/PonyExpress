
#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import <PonyExpressiOS/PonyExpressiOS-Swift.h>
#else
#import <PonyExpressMacOS/PonyExpressMacOS-Swift.h>
#endif
