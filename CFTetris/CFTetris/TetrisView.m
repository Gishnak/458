//
//  TetrisView.m
//  CFTetris
//
//  Created by Laub, Brian on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TetrisView.h"
#import "TetrisEngine.h"

@implementation MovableShapePanData
@synthesize distance = distance_, velocity = velocity_;
@synthesize state = state_;
@end

@interface TetrisView ()
@property (nonatomic) CGPoint lastPan;
@property (nonatomic) int moveAmt;

- (void) setupGestures;
- (void) handlePanGesture: (UIPanGestureRecognizer*)sender;
@end

@implementation TetrisView

@synthesize height = _height;
@synthesize width = _width;
@synthesize grid = _grid;
@synthesize target = target_;
@synthesize panAction = panAction_;
@synthesize touchAction = touchAction_;
@synthesize shakeAction = shakeAction_;
@synthesize lastPan = lastPan_;
@synthesize moveAmt = moveAmt_;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setupGestures];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setupGestures];
    return self;
}

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
    
    UITapGestureRecognizer * dtgn =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleDoubleTap:)];
    dtgn.numberOfTapsRequired = 2;
    
    
    [self addGestureRecognizer:dtgn];
    [dtgn release];

    
    UITapGestureRecognizer * tgn =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleTap:)];
    [tgn requireGestureRecognizerToFail:dtgn];
    
    
    [self addGestureRecognizer:tgn];
    [tgn release];
    
}


- (void) setUpGrid
{
    [self.grid release];
    self.grid = [[NSMutableArray alloc] initWithCapacity: TetrisArrSize(self.height)];
    for (int i = 0; i < TetrisArrSize(self.height); i++) 
    {
        [self.grid addObject: [UIColor whiteColor]];
    }
}

- (void) handlePanGesture: (UIPanGestureRecognizer*)sender
{
    if (!self.target)
        return;
    
    CGPoint translate = [sender translationInView:self];
    if (sender.state == UIGestureRecognizerStateBegan)
        self.moveAmt = 0;
        //self.lastPan = translate;
    
    if (sender.state != UIGestureRecognizerStateBegan &&
        sender.state != UIGestureRecognizerStateChanged &&
        sender.state != UIGestureRecognizerStateEnded)
        return;
    
    
    // Call the target-action
    if (translate.x >= [self frame].size.width / self.width + [self frame].size.width / self.width * self.moveAmt) {
        self.moveAmt++;
        [self.target performSelector:self.panAction
                          withObject:[NSNumber numberWithInt: 1]];
    }
    if (translate.x <= -1 * [self frame].size.width / self.width + [self frame].size.width / self.width * self.moveAmt) {
        self.moveAmt--;
        [self.target performSelector:self.panAction
                          withObject:[NSNumber numberWithInt: -1]];
    }
    
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{    
    NSLog(@"ht: %d\n", [sender numberOfTouches]);
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.target performSelector:self.touchAction
                          withObject:[NSNumber numberWithInt: [sender numberOfTouches]]];
    } 
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender
{    
     NSLog(@"hdt: %d\n", [sender numberOfTouches]);
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.target performSelector:self.touchAction
                          withObject:[NSNumber numberWithInt: 2]];
    } 
}


- (void) setColor: (UIColor*)color forRow: (int) row column: (int) col
{
    [self.grid replaceObjectAtIndex: TetrisArrIdx(row, col) withObject: color];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    for (int column = 0; column < self.width; column++) {
        for (int row = 0; row < self.height; row++) {
            
            CGContextRef context = UIGraphicsGetCurrentContext();

            CGRect box = CGRectMake(rect.origin.x + (double)column/self.width * rect.size.width, rect.size.height - (double)(	row+1)/self.height * rect.size.height, rect.size.width/self.width, (double)rect.size.height/self.height);

            CGContextBeginPath(context);
            CGContextAddRect(context, box);
            CGContextClosePath(context);
            [[UIColor blackColor] setStroke];
            [(UIColor*)[self.grid objectAtIndex: TetrisArrIdx(row, column)] setFill];	
            
            CGContextDrawPath(context, kCGPathFillStroke); 

            
        }
    }
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake )
    {
        [self.target performSelector: self.shakeAction];
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{ 
    return YES;
}


- (void)dealloc
{
    [super dealloc];
}

@end
