//
//  FirstViewController.m
//  CFTetris
//
//  Created by Laub, Brian on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController

@synthesize engine = _engine;


- (void)setEngine:(TetrisEngine *)eng
{ 
    [self loadView];
    [_engine removeObserver:self forKeyPath:@"score"];
    [_engine removeObserver:self forKeyPath:@"timeStep"];
    [_engine removeObserver:self forKeyPath:@"gridVersion"];
    [_engine release];
    _engine = [eng retain];
    [self setupLabels];
    
}
//
- (void) setupLabels
{
    if (!self.engine || ![self isViewLoaded] || !board)
        return;
    [self.engine addObserver:self
                  forKeyPath:@"score"
                     options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                     context:nil];
    [self.engine addObserver:self
                  forKeyPath:@"timeStep"
                     options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                     context:nil];
    [self.engine addObserver:self
                  forKeyPath:@"gridVersion"
                     options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                     context:nil];
    [board addObserver:self
            forKeyPath:@"width"
               options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
               context:nil];
    [board addObserver:self
            forKeyPath:@"height"
               options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
               context:nil];
    //Ask Bellardo: Where should I put this stuff?
    board.width = [self.engine width];
    board.height = [self.engine height];
    board.target = self;
    board.panAction = @selector(panAmount:);
    board.touchAction = @selector(touchAmount:);
    board.shakeAction = @selector(shake);
    
    [self refreshView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [board becomeFirstResponder];
    [super viewWillAppear:animated];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [board resignFirstResponder];
    [super viewWillDisappear:animated];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual: @"score"]) {
        scoreLabel.text =[NSString stringWithFormat:@"%d", [self.engine score]];
        
    }
    if ([keyPath isEqual: @"timeStep"]) {
        timeLabel.text = [NSString stringWithFormat:@"%d", [self.engine timeStep]]; 
        
    }
    if ([keyPath isEqual: @"gridVersion"]) {
        [self refreshView]; 
        
    }
    if ([keyPath isEqual: @"width"]) {
        [board setUpGrid];
        
    }
    if ([keyPath isEqual: @"height"]) {
        [board setUpGrid];
        
    }
}

- (void) refreshView
{ 
    if (!self.engine)
        return;
    for (int column = 0; column < [self.engine width]; column++) {
        for (int row = 0; row < [self.engine height]; row++) {
            int piece = [self.engine pieceAtRow:row column:column];
            if (0 == piece)
                [board setColor: [UIColor whiteColor] forRow:row column: column];
            else if ( 1 == piece) 
                [board setColor: [UIColor cyanColor] forRow:row column: column];
            else if ( 2 == piece) 
                [board setColor: [UIColor blueColor] forRow:row column: column];
            else if ( 3 == piece) 
                [board setColor: [UIColor orangeColor] forRow:row column: column];
            else if ( 4 == piece) 
                [board setColor: [UIColor yellowColor] forRow:row column: column];
            else if ( 5 == piece) 
                [board setColor: [UIColor greenColor] forRow:row column: column];
            else if ( 6 == piece) 
                [board setColor: [UIColor purpleColor] forRow:row column: column];
            else if ( 7 == piece) 
                [board setColor: [UIColor redColor] forRow:row column: column];
            
        }
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//Ask Bellardo: Why isn't this called ever?
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLabels];

}
- (void) panAmount: (NSNumber*)amount
{
    if ([amount intValue] > 0 ) 
    {
        [self.engine slideRight];
    }
    else 
    {
        [self.engine slideLeft];
    }
}
- (void) touchAmount: (NSNumber*)amount
{
    if ([amount intValue] == 1)
    {
        if ([self.engine running]) 
        {
            [self.engine rotateCW];
        }
        else
        {
            [self.engine start];
        }
    }
    else if ([amount intValue] == 2)
    {
        if ([self.engine running])
        {
            [self.engine stop];
        }
        else
        {
            [self.engine start];
        }
    }
        
    
    
}

- (void) shake
{
    [self.engine reset];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [super dealloc];
}

@end
