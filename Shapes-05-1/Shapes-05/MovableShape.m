//
//  MovableShape.m
//  Shapes-05
//
//  Created by John Bellardo on 4/28/11.
//  Licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
//  http://creativecommons.org/licenses/by-nc-sa/3.0/us/
//

#import "MovableShape.h"

@implementation MovableShapePanData
@synthesize distance = distance_, velocity = velocity_;
@synthesize state = state_;
@end

@interface MovableShape ()
@property (nonatomic) CGPoint lastPan;

- (void) setupGestures;
- (void) handlePanGesture: (UIPanGestureRecognizer*)sender;
@end

@implementation MovableShape
@synthesize target = target_;
@synthesize panAction = panAction_;
@synthesize lastPan = lastPan_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGestures];
    }
    return self;
}

// Method to configure all gesture recognizers for a MovableShape
- (void) setupGestures
{
    UIPanGestureRecognizer * pgn =
        [[UIPanGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(handlePanGesture:)];
    
    pgn.minimumNumberOfTouches = 1;
    pgn.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:pgn];
    [pgn release];
}

// Method to receive gesture events.  Translates from absolute
//  coordinates into delta values.
- (void) handlePanGesture: (UIPanGestureRecognizer*)sender
{
    if (!self.target)
        return;
    
    CGPoint translate = [sender translationInView:self];    
    if (sender.state == UIGestureRecognizerStateBegan)
        self.lastPan = translate;
    
    if (sender.state != UIGestureRecognizerStateBegan &&
        sender.state != UIGestureRecognizerStateChanged &&
        sender.state != UIGestureRecognizerStateEnded)
        return;
    
    // Do the conversion into an <x,y> delta
    CGPoint delta = translate;
    delta.x -= self.lastPan.x;
    delta.y -= self.lastPan.y;
    
    // Populate an object to pass all the data into our target-action
    MovableShapePanData * data = [[MovableShapePanData alloc] init];
    data.distance = delta;
    data.state = sender.state;
    data.velocity = [sender velocityInView:self];
    
    // Call the target-action
    [self.target performSelector:self.panAction
            withObject:self
                      withObject:data];
    
    [data release];
    self.lastPan = translate;
}

- (void)dealloc
{
    [super dealloc];
}

@end
