/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Customized view for macOS
*/

#import "PonyExpressNSView.h"
#import "PonyExpressConfig.h"
#import "HALRenderEngine.h"

@implementation PonyExpressNSView
{
    CVDisplayLinkRef _displayLink;

#if RENDER_ON_MAIN_THREAD
    dispatch_source_t _displaySource;
#endif
}

///////////////////////////////////////
#pragma mark - Initialization and Setup
///////////////////////////////////////

- (instancetype)initCommon
{
    self.wantsLayer = YES;
    self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawDuringViewResize;
    self.layerContentsPlacement = NSViewLayerContentsPlacementTopLeft;
    
    self = [super initCommon];

    return self;
}

- (CALayer*)makeBackingLayer
{
    CAMetalLayer* metalLayer = [CAMetalLayer layer];
    metalLayer.device = MTLCreateSystemDefaultDevice();

    return metalLayer;
}

- (void)viewDidMoveToWindow
{
    [super viewDidMoveToWindow];
        
    self.metalLayer.maximumDrawableCount = 3;
    self.metalLayer.framebufferOnly = true;
    self.metalLayer.opaque = true;

#if ANIMATION_RENDERING
    [self setupCVDisplayLinkForScreen:self.window.screen];
#endif

#if AUTOMATICALLY_RESIZE
    [self resizeDrawable:self.window.screen.backingScaleFactor];
#else
    // Notify delegate of default drawable size when it can be calculated
    CGSize defaultDrawableSize = self.bounds.size;
    defaultDrawableSize.width *= self.layer.contentsScale;
    defaultDrawableSize.height *= self.layer.contentsScale;
    [self.delegate drawableResize:defaultDrawableSize withScale:self.layer.contentsScale];
#endif
}

//////////////////////////////////
#pragma mark - Render Loop Control
//////////////////////////////////

#if ANIMATION_RENDERING

- (BOOL)setupCVDisplayLinkForScreen:(NSScreen*)screen
{
#if RENDER_ON_MAIN_THREAD

    // The CVDisplayLink callback, DispatchRenderLoop, never executes
    // on the main thread. To execute rendering on the main thread, create
    // a dispatch source using the main queue (the main thread).
    // DispatchRenderLoop merges this dispatch source in each call
    // to execute rendering on the main thread.
    _displaySource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
    __weak PonyExpressView* weakSelf = self;
    dispatch_source_set_event_handler(_displaySource, ^(){
        if (self.paused == false) {
            [weakSelf render];
        }else{
            [weakSelf setNeedsDisplay:true];
        }
    });
    dispatch_resume(_displaySource);

#endif // END RENDER_ON_MAIN_THREAD

    CVReturn cvReturn;

    // Create a display link capable of being used with all active displays
    cvReturn = CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);

    if(cvReturn != kCVReturnSuccess)
    {
        return NO;
    }

#if RENDER_ON_MAIN_THREAD

    // Set DispatchRenderLoop as the callback function and
    // supply _displaySource as the argument to the callback.
    cvReturn = CVDisplayLinkSetOutputCallback(_displayLink, &DispatchRenderLoop, (__bridge void*)_displaySource);

#else // IF !RENDER_ON_MAIN_THREAD

    // Set DispatchRenderLoop as the callback function and
    // supply this view as the argument to the callback.
    cvReturn = CVDisplayLinkSetOutputCallback(_displayLink, &DispatchRenderLoop, (__bridge void*)self);

#endif // END !RENDER_ON_MAIN_THREAD

    if(cvReturn != kCVReturnSuccess)
    {
        return NO;
    }

    // Associate the display link with the display on which the
    // view resides
    CGDirectDisplayID viewDisplayID =
        (CGDirectDisplayID) [self.window.screen.deviceDescription[@"NSScreenNumber"] unsignedIntegerValue];;

    cvReturn = CVDisplayLinkSetCurrentCGDisplay(_displayLink, viewDisplayID);

    if(cvReturn != kCVReturnSuccess)
    {
        return NO;
    }

    CVDisplayLinkStart(_displayLink);

    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];

    // Register to be notified when the window closes so that you
    // can stop the display link
    [notificationCenter addObserver:self
                           selector:@selector(windowWillClose:)
                               name:NSWindowWillCloseNotification
                             object:self.window];

    return YES;
}

- (void)windowWillClose:(NSNotification*)notification
{
    // Stop the display link when the window is closing since there
    // is no point in drawing something that can't be seen
    if(notification.object == self.window)
    {
        CVDisplayLinkStop(_displayLink);

#if RENDER_ON_MAIN_THREAD
        dispatch_source_cancel(_displaySource);
#endif
    }
}

// This is the renderer output callback function
static CVReturn DispatchRenderLoop(CVDisplayLinkRef displayLink,
                                   const CVTimeStamp* now,
                                   const CVTimeStamp* outputTime,
                                   CVOptionFlags flagsIn,
                                   CVOptionFlags* flagsOut,
                                   void* displayLinkContext)
{

#if RENDER_ON_MAIN_THREAD

    // 'DispatchRenderLoop' is always called on a secondary thread.  Merge the dispatch source
    // setup for the main queue so that rendering occurs on the main thread
    __weak dispatch_source_t source = (__bridge dispatch_source_t)displayLinkContext;
    dispatch_source_merge_data(source, 1);

#else

    @autoreleasepool
    {
        PonyExpressNSView *customView = (__bridge PonyExpressNSView*)displayLinkContext;
        if (customView.paused == false) {
            [customView render];
        }
    }
#endif

    return kCVReturnSuccess;
}

- (void)stopRenderLoop
{
    if(_displayLink)
    {
        // Stop the display link BEFORE releasing anything in the view otherwise the display link
        // thread may call into the view and crash when it encounters something that no longer
        // exists
        CVDisplayLinkStop(_displayLink);
        CVDisplayLinkRelease(_displayLink);

#if RENDER_ON_MAIN_THREAD
        dispatch_source_cancel(_displaySource);
#endif
    }
}

#endif // END ANIMATION_RENDERING

///////////////////////
#pragma mark - Resizing
///////////////////////

#if AUTOMATICALLY_RESIZE

// Override all methods which indicate the view's size has changed.

- (void)viewDidChangeBackingProperties
{
    [super viewDidChangeBackingProperties];
    [self resizeDrawable:self.window.screen.backingScaleFactor];
}

- (void)setFrameSize:(NSSize)size
{
    [super setFrameSize:size];
    [self resizeDrawable:self.window.screen.backingScaleFactor];
}

- (void)setBoundsSize:(NSSize)size
{
    [super setBoundsSize:size];
    [self resizeDrawable:self.window.screen.backingScaleFactor];
}
#endif // END AUTOMATICALLY_RESIZE

- (void) displayLayer:(CALayer *)layer {
    [self render];
}


#pragma mark - Events

- (BOOL) acceptsFirstResponder
{
    return YES;
}

- (BOOL) becomesFirstResponder
{
    return YES;
}

- (BOOL)canBecomeKeyView
{
    return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
    return YES;
}

- (void)mouseDown:(NSEvent *)event
{
    NSPoint p = [self convertPoint:[event locationInWindow] fromView:NULL];
    RenderEngineInternal_touchEvent(nil, (size_t)event.eventNumber, true, p.x, -(self.bounds.size.height - p.y));
}

- (void)mouseUp:(NSEvent *)event
{
    NSPoint p = [self convertPoint:[event locationInWindow] fromView:NULL];
    RenderEngineInternal_touchEvent(nil, (size_t)event.eventNumber, false, p.x, -(self.bounds.size.height - p.y));
}

- (void)mouseMoved:(NSEvent *)event
{
    NSPoint p = [self convertPoint:[event locationInWindow] fromView:NULL];
    RenderEngineInternal_touchEvent(nil, (size_t)event.eventNumber, true, p.x, -(self.bounds.size.height - p.y));
}

- (void)mouseDragged:(NSEvent *)event
{
    NSPoint p = [self convertPoint:[event locationInWindow] fromView:NULL];
    RenderEngineInternal_touchEvent(nil, (size_t)event.eventNumber, true, p.x, -(self.bounds.size.height - p.y));
}

- (void)keyUp:(NSEvent *)event
{
    //[delegate Event:event];
}

- (void)keyDown:(NSEvent *)event
{
    //[delegate Event:event];
}

- (void)rightMouseDown:(NSEvent *)event
{
    //[delegate Event:event];
}

- (void)rightMouseUp:(NSEvent *)event
{
    //[delegate Event:event];
}

- (void)otherMouseDown:(NSEvent *)event
{
    //[delegate Event:event];
}

- (void)otherMouseUp:(NSEvent *)event
{
    //[delegate Event:event];
}

- (void)rightMouseDragged:(NSEvent *)event
{
    //[delegate Event:event];
}

- (void)otherMouseDragged:(NSEvent *)event
{
    //[delegate Event:event];
}

- (void)scrollWheel:(NSEvent *)event
{
    NSPoint p = [self convertPoint:[event locationInWindow] fromView:NULL];
    CGFloat mul = [event hasPreciseScrollingDeltas] ? 0.1f : 1.0f;
    if([event momentumPhase] == NSEventPhaseBegan || [event momentumPhase] == NSEventPhaseNone){
        RenderEngineInternal_scrollEvent(nil, 0, [event scrollingDeltaX] * mul, [event scrollingDeltaY] * mul, p.x, -(self.bounds.size.height - p.y));
    }
}

- (void)mouseEntered:(NSEvent *)event
{
    //[delegate Event:event];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    //[delegate Event:theEvent];
}

- (void)flagsChanged:(NSEvent *)theEvent
{
    //[delegate Event:theEvent];
}

- (void)cursorUpdate:(NSEvent *)theEvent
{
    //[delegate Event:theEvent];
}



@end
