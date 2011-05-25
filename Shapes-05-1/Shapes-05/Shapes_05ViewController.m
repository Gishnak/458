//
//  Shapes_05ViewController.m
//  Shapes-05
//
//  Created by John Bellardo on 4/21/11.
//  Licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
//  http://creativecommons.org/licenses/by-nc-sa/3.0/us/
//

#import "Shapes_05ViewController.h"
#import "Ellipse.h"
#import "Square.h"
#import "Ship.h"
#import "World.h"
#import <QuartzCore/QuartzCore.h>

@interface Shapes_05ViewController ()
@property (nonatomic, retain) World *world;
@property (nonatomic, retain) CADisplayLink *dispLink;

- (void) panShape: (MovableShape*) shape amount: (MovableShapePanData*)data;

@end
@implementation Shapes_05ViewController
@synthesize world = world_;
@synthesize dispLink = dispLink_;

- (void)dealloc
{
    // Release our ownership of the World
    [world_ release];
    
    // Let our superclass clean up it's memory
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.world)
        self.world = [[[World alloc] initWithRect:self.view.bounds] autorelease];
    
    MovableShape *subView;
    WorldObject *wobj;


    UITapGestureRecognizer * tgn =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleTap:)];
    
    
    [self.view addGestureRecognizer:tgn];
    
    [tgn release];
    
    CGRect frame4 = { 100, self.view.frame.size.height - 100, 43, 100 };
    wobj = [[WorldObject alloc] initWithType:1 andLocation:frame4];
    wobj.velocity =  CGPointMake(0, 0);
    [self.world addObject:wobj];
    subView = [[Ship alloc] initWithFrame:frame4];
    subView.opaque = NO;
    subView.backgroundColor = [UIColor clearColor];
    subView.tag = wobj.objId;
    subView.target = self;
    subView.panAction = @selector(panShape:amount:);
    [self.view addSubview:subView];
    [subView release];
    [wobj addObserver:self forKeyPath:@"location"
              options:NSKeyValueObservingOptionInitial
              context:subView];
    // I want to keep an ownership interest in the WorldObject since I'm monitoring
    //  it with KVO.  The ownership will be released in - (void) dealloc.
    // [wobj release];
    
    self.dispLink = [CADisplayLink
                         displayLinkWithTarget:self
                         selector:@selector(nextFrame:)];
    self.dispLink.frameInterval = 1;
    [self.dispLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void) stop
{
    if (self.dispLink) {
        // Stop the animation timer
        [self.dispLink invalidate];
        self.dispLink = nil;
        
        // Release our ownership of the WorldObjects
        for (WorldObject *wobj in world_.worldObjects) {
            [wobj removeObserver:self forKeyPath:@"location"];
            [wobj release];
        }
    }
}

- (void) panShape: (MovableShape*) shape amount: (MovableShapePanData*)data
{
    WorldObject *wobj = [self.world objectWithID: shape.tag];
    
    if (data.state == UIGestureRecognizerStateBegan) {
        wobj.velocity = CGPointMake(0, 0);
        wobj.acceleration = CGPointMake(0, 0);
    }
    if (data.state == UIGestureRecognizerStateEnded) {
    //wobj.acceleration = CGPointMake(0, 480);
       // wobj.velocity = data.velocity;
    }
    
    CGRect newFrame = wobj.location;
    newFrame.origin.x += data.distance.x;
    newFrame.origin.y += data.distance.y;
    
    wobj.location = newFrame;
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{    
   // NSLog(@"ht: %d\n", [sender numberOfTouches]);
    WorldObject *ship = [self.world objectWithID: 0];
    NSLog(@"loc: %f\n", ship.location.origin.x);
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        //WorldObject *ship = [self.world objectWithID: 0];
        
        WorldObject *wobj;
        MovableShape *subView;
        CGRect bullet = {ship.location.origin.x + 17, ship.location.origin.y, 10, 10 };
        wobj = [[WorldObject alloc] initWithType:1 andLocation:bullet];
        [self.world addObject:wobj];
        subView = [[Ellipse alloc] initWithFrame:bullet];
        subView.opaque = NO;
        subView.backgroundColor = [UIColor clearColor];
        subView.tag = wobj.objId;
        subView.target = self;
        subView.panAction = @selector(panShape:amount:);
        [self.view addSubview:subView];
        [subView release];
        [wobj addObserver:self forKeyPath:@"location"
                  options:NSKeyValueObservingOptionInitial
                  context:subView];
     //  [self.target performSelector:self.touchAction
                        //  withObject:[NSNumber numberWithInt: [sender numberOfTouches]]];
    } 
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"location"]) {
        ((UIView*)context).frame = ((WorldObject*)object).location;
    }
}

- (void) nextFrame: (CADisplayLink*) link
{
    [self.world step:link.duration];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
