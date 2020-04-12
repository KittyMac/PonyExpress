/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation of the cross-platform view controller
*/

#import "PonyExpressViewController.h"
#if TARGET_OS_IPHONE
#import "PonyExpressUIView.h"
#else
#import "PonyExpressNSView.h"
#endif

#import "PonyExpress-Swift.h"

#import <QuartzCore/CAMetalLayer.h>

@implementation PonyExpressViewController
{
    Renderer * _renderer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    id<MTLDevice> device = MTLCreateSystemDefaultDevice();

    PonyExpressView *view = (PonyExpressView *)self.view;

    // Set the device for the layer so the layer can create drawable textures that can be rendered to
    // on this device.
    view.metalLayer.device = device;
    view.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    CGFloat backgroundColorValues[] = {0, 0, 0, 1};
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB); //kCGColorSpaceSRGB
    view.metalLayer.backgroundColor = CGColorCreate(colorSpaceRef, backgroundColorValues);
    view.metalLayer.colorspace = colorSpaceRef;

    // Set this class as the delegate to receive resize and render callbacks.
    view.delegate = self;

    _renderer = [[Renderer alloc] initWithAaplView:view];
}

- (void)drawableResize:(CGSize)size withScale:(CGFloat)scale
{
    [_renderer drawableResize:size withScale:scale];
}

- (void)renderToMetalLayer:(nonnull CAMetalLayer *)layer
{
    [_renderer renderToMetalLayer:layer];
}

@end
