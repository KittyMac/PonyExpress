/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Customized view for iOS & tvOS
*/

#import "PonyExpressUIView.h"
#import "PonyExpressConfig.h"
#import "HALRenderEngine.h"
#import "RSTimingFunction.h"

extern uint64_t ponyint_cpu_tick(void);

@implementation PonyExpressUIView
{
    
    CADisplayLink *_displayLink;

#if !RENDER_ON_MAIN_THREAD
    // Secondary thread containing the render loop
    NSThread *_renderThread;

    // Flag to indcate rendering should cease on the main thread
    BOOL _continueRunLoop;
#endif
}

///////////////////////////////////////
#pragma mark - Initialization and Setup
///////////////////////////////////////

+ (Class) layerClass
{
    return [CAMetalLayer class];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    _trackingTouches = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSafeBottom:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSafeBottom:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setMultipleTouchEnabled:true];
    
    self.metalLayer.maximumDrawableCount = 3;
    self.metalLayer.framebufferOnly = true;

#if ANIMATION_RENDERING
    if(self.window == nil)
    {
        // If moving off of a window destroy the display link.
        [_displayLink invalidate];
        _displayLink = nil;
        return;
    }

    [self setupCADisplayLinkForScreen:self.window.screen];

#if RENDER_ON_MAIN_THREAD

    // CADisplayLink callbacks are associated with an 'NSRunLoop'. The currentRunLoop is the
    // the main run loop (since 'didMoveToWindow' is always executed from the main thread.
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

#else // IF !RENDER_ON_MAIN_THREAD

    // Protect _continueRunLoop with a `@synchronized` block since it is accessed by the seperate
    // animation thread
    @synchronized(self)
    {
        // Stop animation loop allowing the loop to complete if it's in progress.
        _continueRunLoop = NO;
    }

    // Create and start a secondary NSThread which will have another run runloop.  The NSThread
    // class will call the 'runThread' method at the start of the secondary thread's execution.
    _renderThread =  [[NSThread alloc] initWithTarget:self selector:@selector(runThread) object:nil];
    _continueRunLoop = YES;
    [_renderThread start];

#endif // END !RENDER_ON_MAIN_THREAD
#endif // ANIMATION_RENDERING

    // Perform any actions which need to know the size and scale of the drawable.  When UIKit calls
    // didMoveToWindow after the view initialization, this is the first opportunity to notify
    // components of the drawable's size
#if AUTOMATICALLY_RESIZE
    [self resizeDrawable:self.window.screen.nativeScale];
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

- (void)setPaused:(BOOL)paused
{
    super.paused = paused;

    _displayLink.paused = paused;
}

- (void)setupCADisplayLinkForScreen:(UIScreen*)screen
{
    [self stopRenderLoop];

    _displayLink = [screen displayLinkWithTarget:self selector:@selector(render)];

    _displayLink.paused = self.paused;

    _displayLink.preferredFramesPerSecond = 0;
}

- (void)didEnterBackground:(NSNotification*)notification
{
    self.paused = YES;
}

- (void)willEnterForeground:(NSNotification*)notification
{
    self.paused = NO;
}

- (void)stopRenderLoop
{
    [_displayLink invalidate];
}

#if !RENDER_ON_MAIN_THREAD
- (void)runThread
{
    // Set the display link to the run loop of this thread so its call back occurs on this thread
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [_displayLink addToRunLoop:runLoop forMode:@"PonyExpressDisplayLinkMode"];

    // The '_continueRunLoop' ivar is set outside this thread, so it must be synchronized.  Create a 'continueRunLoop' local var that can be set from the _continueRunLoop ivar in a @synchronized block
    BOOL continueRunLoop = YES;

    // Begin the run loop
    while (continueRunLoop)
    {
        // Create autorelease pool for the current iteration of loop.
        @autoreleasepool
        {
            // Run the loop once accepting input only from the display link.
            [runLoop runMode:@"PonyExpressDisplayLinkMode" beforeDate:[NSDate distantFuture]];
        }

        // Synchronize this with the _continueRunLoop ivar which is set on another thread
        @synchronized(self)
        {
            // Anything accessed outside the thread such as the '_continueRunLoop' ivar
            // is read inside the synchronized block to ensure it is fully/atomically written
            continueRunLoop = _continueRunLoop;
        }
    }
}
#endif // END !RENDER_ON_MAIN_THREAD

#endif // END ANIMATION_RENDERING

///////////////////////
#pragma mark - Resizing
///////////////////////

#if AUTOMATICALLY_RESIZE

// Override all methods which indicate the view's size has changed

- (void)setContentScaleFactor:(CGFloat)contentScaleFactor
{
    [super setContentScaleFactor:contentScaleFactor];
    [self resizeDrawable:self.window.screen.nativeScale];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resizeDrawable:self.window.screen.nativeScale];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //[self resizeDrawable:self.window.screen.nativeScale];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    //[self resizeDrawable:self.window.screen.nativeScale];
}

#endif // END AUTOMATICALLY_RESIZE



#pragma mark - Events

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch * touch in touches) {
        CGPoint p = [touch locationInView:self];
        RenderEngineInternal_touchEvent(nil, (size_t)touch, true, p.x, -p.y);
        if([_trackingTouches containsObject:touch] == false) {
            [_trackingTouches addObject:touch];
        }
    }
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch * touch in touches) {
        CGPoint p = [touch locationInView:self];
        RenderEngineInternal_touchEvent(nil, (size_t)touch, false, p.x, -p.y);
        [_trackingTouches removeObject:touch];
    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch * touch in touches) {
        if([_trackingTouches containsObject:touch]) {
            CGPoint p = [touch locationInView:self];
            RenderEngineInternal_touchEvent(nil, (size_t)touch, true, p.x, -p.y);
        }
    }
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch * touch in touches) {
        CGPoint p = [touch locationInView:self];
        RenderEngineInternal_touchEvent(nil, (size_t)touch, false, p.x, -p.y);
        [_trackingTouches removeObject:touch];
    }
}



@synthesize hasText;

- (BOOL) canBecomeFirstResponder {
    return true;
}

- (void)showKeyboard {
    
    // Stop tracking all touches; this is because the screen might move while we're opening the keyboard
    [_trackingTouches removeAllObjects];
    
    _returnKeyType = UIReturnKeyDone;
    _smartQuotesType = UITextSmartQuotesTypeNo;
    _smartDashesType = UITextSmartDashesTypeNo;
    _smartInsertDeleteType = UITextSmartInsertDeleteTypeNo;
    _keyboardType = UIKeyboardTypeASCIICapable;
    
    // Since we don't put any text in this view directly, this will not work
    _enablesReturnKeyAutomatically = NO;
    
    // TODO: set this from Pony?  Doesn't seem necessary, as the view doesn't display anything
    // we just snarf the key events from it!
    _secureTextEntry = YES;
        
    dispatch_async(dispatch_get_main_queue(), ^{
        [self becomeFirstResponder];
    });
}

- (void)hideKeyboard {
    // Stop tracking all touches; this is because the screen might move while we're opening the keyboard
    [_trackingTouches removeAllObjects];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resignFirstResponder];
    });
}

- (void)deleteBackward {
    RenderEngineInternal_keyEvent(nil, true, 127, "", 0, 0);
    RenderEngineInternal_keyEvent(nil, false, 127, "", 0, 0);
}

- (void)insertText:(nonnull NSString *)text {
    const char * utf8 = [text UTF8String];
    unsigned char keyCode = utf8[0];
    
    RenderEngineInternal_keyEvent(nil, false, keyCode, utf8, 0, 0);
    RenderEngineInternal_keyEvent(nil, true, keyCode, utf8, 0, 0);
}

- (void)updateSafeBottom:(NSNotification *)notification
{
    NSValue * beginFrameValue = [notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue * endFrameValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //NSNumber *curve = [notification.userInfo objectForKey: UIKeyboardAnimationCurveUserInfoKey];
    
    CGFloat fromHeight = self.frame.size.height - [beginFrameValue CGRectValue].origin.y;
    CGFloat toHeight = self.frame.size.height - [endFrameValue CGRectValue].origin.y;
    
    super.keyboardHeight = fromHeight;
    [self resizeDrawable:self.window.screen.nativeScale];
    
    [_keyboardAnimationTimer invalidate];
    
    RSTimingFunction * heavyEaseInTimingFunction = [RSTimingFunction timingFunctionWithName:kRSTimingFunctionEaseOut];
    
    __block uint64_t animationStartNano = ponyint_cpu_tick();
    __block CGFloat animationDuration = [duration floatValue];
    _keyboardAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 60.0 repeats:true block:^(NSTimer * _Nonnull timer) {
        float animationValue = ((CGFloat)(ponyint_cpu_tick() - animationStartNano) / 1000000000.0) * (1.0 / animationDuration);

        if (animationValue < 1.0) {
            super.keyboardHeight = fromHeight + (toHeight - fromHeight) * [heavyEaseInTimingFunction valueForX:animationValue];
        } else {
            super.keyboardHeight = toHeight;
            [timer invalidate];
        }
        
        [self resizeDrawable:self.window.screen.nativeScale];
    }];

}



@end
