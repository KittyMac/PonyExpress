/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Custom view base class
*/

#import <QuartzCore/CAMetalLayer.h>
#import <Metal/Metal.h>
#import "PonyExpressConfig.h"

#if TARGET_OS_IPHONE
@import UIKit;
#else
@import AppKit;
#endif

// Protocol to provide resize and redraw callbacks to a delegate
@protocol PonyExpressViewDelegate <NSObject>

- (void)drawableResize:(CGSize)size
             withScale:(CGFloat)scale;

- (void)renderToMetalLayer:(nonnull CAMetalLayer *)metalLayer;

@end

// Metal view base class
#if TARGET_OS_IPHONE
@interface PonyExpressView : UIView <CALayerDelegate>
#else
@interface PonyExpressView : NSView <CALayerDelegate>
#endif

@property (nonatomic, nonnull, readonly) CAMetalLayer *metalLayer;

@property (nonatomic, getter=isPaused) BOOL paused;

@property (nonatomic, nullable) id<PonyExpressViewDelegate> delegate;

- (nonnull instancetype)initCommon;

#if AUTOMATICALLY_RESIZE
- (void)resizeDrawable:(CGFloat)scaleFactor;
#endif

#if ANIMATION_RENDERING
- (void)stopRenderLoop;
#endif

- (void)render;

@end
