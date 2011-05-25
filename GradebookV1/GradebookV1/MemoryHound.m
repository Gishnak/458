//
//  MemoryHound.m
//  UglyCFTetris
//
//  Created by John Bellardo on 4/13/11.
//  Licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
//  http://creativecommons.org/licenses/by-nc-sa/3.0/us/
//

#import "MemoryHound.h"

static MemoryHound *hound = nil;

@interface MemoryHound ()
- (void) executeHound;
@end

@implementation MemoryHound
@synthesize window = _window;
@synthesize onShake, onRotate, onLowMemory;

+ (void) startRotateHound
{
    if (!hound)
        hound = [[MemoryHound alloc] init];
    
    hound.onRotate = YES;
}

+ (void) startLowMemoryHound
{
    if (!hound)
        hound = [[MemoryHound alloc] init];
    
    hound.onLowMemory = YES;
}

+ (void) startShakeHound
{
    if (!hound)
        hound = [[MemoryHound alloc] init];
    
    hound.onShake = YES;
    [hound becomeFirstResponder];
    // [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (BOOL)canBecomeFirstResponder {
    NSLog(@"I'm first!\n");
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"Shake 111!\n");
    if (self.onShake && event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"Shake!\n");
        [self executeHound];
    }
}

- (id) init
{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter]
                addObserver:self
                   selector:@selector(didRotate:)
                       name:UIDeviceOrientationDidChangeNotification object:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];     

        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(lowMemory:)
         name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}
    return self;
}

- (void) didRotate:(NSNotification *)notification
{
    if (self.onRotate && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        [self executeHound];
}

- (void) lowMemory:(NSNotification *)notification
{
    if (self.onLowMemory)
        [self executeHound];
}

- (void) executeHound
{
    if (self == [UIApplication sharedApplication].delegate)
        return;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *wind = app.keyWindow;
    
    // Hold on to the window so it doesn't get deallocated
    self.window = wind;
    
    // Remove all objects from window
    if ([wind respondsToSelector:@selector(setRootViewController:)])
        [wind setRootViewController: nil];
    
    while ([wind.subviews count] > 0) {
        UIView *subv = [wind.subviews objectAtIndex:0];
        [subv removeFromSuperview];
    }
    
    // Locate the NSMutableArray* in UIApplication that holds the main nib objects.
    //  Since this variable is private (@package, actually) we don't have direct access.
    //  Iterate through all points in UIApplication looking for one of type NSArray.
    //  This is a hack, but works fairly well due to Obj-C's full dynamic typing.
    id *curr = (id*)app, *nibArr = NULL;
    curr += 4;
    for (int i = 0; i < 8; i++, curr++) {
        if (!(*curr))
            continue;
        if ([*curr isKindOfClass:[NSArray class]]) {
            nibArr = curr;
            break;
        }
    }
    
    // Set up the message that gets displayed while hound is active
    UIView *whiteView = [[UIView alloc] initWithFrame:wind.frame];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 50, 300, 30)];
    lbl.text = @"MemoryHound!";
    [whiteView addSubview:lbl];
    [lbl release];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 80, 300, 30)];
    lbl.text = @"App must not crash.";
    [whiteView addSubview:lbl];
    [lbl release];

    lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 110, 300, 30)];
    lbl.text = @"App must be restarted to continue.";
    [whiteView addSubview:lbl];
    [lbl release];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(25, 150, 200, 50);
    [btn setTitle:@"Quit App" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:btn];
    
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.opaque = YES;
    [wind addSubview:whiteView];
    [whiteView release];
    
    // Take control of the app
    app.delegate = self;
    
    // Release any objects loaded from the main nib file
    if (nibArr) {
        [*nibArr release];
        *nibArr = [[NSMutableArray alloc] initWithCapacity:0];
    }

    [pool drain];
}

- (void) buttonClicked: (id) sender
{
    exit(0);
}

- (void) dealloc
{
    [_window release];
    [super dealloc];
}

@end