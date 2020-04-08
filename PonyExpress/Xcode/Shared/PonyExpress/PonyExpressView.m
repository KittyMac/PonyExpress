/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Custom view base class
*/

#import "PonyExpressView.h"

@implementation PonyExpressView

///////////////////////////////////////
#pragma mark - Initialization and Setup
///////////////////////////////////////

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        return [self initCommon];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        return [self initCommon];
    }
    return self;
}

- (instancetype)initCommon
{
    _metalLayer = (CAMetalLayer*) self.layer;

    self.layer.delegate = self;
    
#if TARGET_OS_OSX
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseAnimation) name:NSWindowWillStartLiveResizeNotification object:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeAnimation) name:NSWindowDidEndLiveResizeNotification object:NULL];
#endif

    return self;
}

//////////////////////////////////
#pragma mark - Render Loop Control
//////////////////////////////////

- (void) pauseAnimation {
    _paused = true;
}

- (void) resumeAnimation {
    _paused = false;
}

#if ANIMATION_RENDERING

- (void)stopRenderLoop
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self stopRenderLoop];
}

#else // IF !ANIMATION_RENDERING

// Override methods needed to handle event-based rendering

- (void)displayLayer:(CALayer *)layer
{
    [self renderOnEvent];
}

- (void)drawLayer:(CALayer *)layer
        inContext:(CGContextRef)ctx
{
    [self renderOnEvent];
}

- (void)drawRect:(CGRect)rect
{
    [self renderOnEvent];
}

- (void)renderOnEvent
{
#if RENDER_ON_MAIN_THREAD
    [self render];
#else
    // Dispatch rendering on a concurrent queue
    dispatch_queue_t globalQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_async(globalQueue, ^(){
        [self render];
    });
#endif
}

#endif // END !ANIMAITON_RENDERING
///////////////////////
#pragma mark - Resizing
///////////////////////

#if AUTOMATICALLY_RESIZE

- (void)resizeDrawable:(CGFloat)scaleFactor
{
    CGSize newSize = self.bounds.size;
    newSize.width *= scaleFactor;
    newSize.height *= scaleFactor;

#if RENDER_ON_MAIN_THREAD
    _metalLayer.contentsScale = scaleFactor;
    _metalLayer.drawableSize = newSize;

    if(_delegate)
    {
        [_delegate drawableResize:newSize withScale:scaleFactor];
    }
#else
    // All AppKit and UIKit calls which notify of a resize are called on the main thread.  Use
    // a synchronized block to ensure that resize notifications on the delegate are atomic
    @synchronized(_metalLayer)
    {
        _metalLayer.contentsScale = scaleFactor;
        _metalLayer.drawableSize = newSize;

        [_delegate drawableResize:newSize withScale:scaleFactor];
    }
#endif
}

#endif

//////////////////////
#pragma mark - Drawing
//////////////////////

- (void)render
{
#if RENDER_ON_MAIN_THREAD
    [_delegate renderToMetalLayer:_metalLayer];
#else
    // Must synchronize if rendering on background thread to ensure resize operations from the
    // main thread are complete before rendering which depends on the size occurs.
    @synchronized(_metalLayer)
    {
        [_delegate renderToMetalLayer:_metalLayer];
    }
#endif
}

@end
