//
//  UglyTetrisViewController.m
//  UglyTetris
//
//  Created by Laub, Brian on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UglyTetrisViewController.h"

@implementation UglyTetrisViewController

@synthesize engine = _engine;

- (void)dealloc
{
    
    if ([self.engine running]) {
        [self.engine stop];
    }
    [gridLabels release];
    [_engine release];
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
    [self setupLabels];
   // [self refreshView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [gridLabels release];
    [timeLabel release];
    [scoreLabel release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction) buttonPressed:(UIButton*)sender
{
    NSLog(@"Button pressed with tag: %d\n", sender.tag);
    if (sender.tag == 1) {
        [self.engine start];
    }
    else if (sender.tag == 2) {
        [self.engine slideLeft];
    }
    else if (sender.tag == 3) {
        [self.engine slideRight];
    }
    else if (sender.tag == 4) {
        [self.engine rotateCW];
    }
    else if (sender.tag == 5) {
        [self.engine rotateCCW];
    }
    else if (sender.tag == 6) {
        if ([self.engine running]) {
            [self.engine stop];
        }
    }
    else if (sender.tag == 7) {
        [self.engine reset];
    }
    else if (sender.tag == 8) {
        [self.engine pieceUp];
    }
    else if (sender.tag == 9) {
        [self.engine pieceDown];
    }
    else if (sender.tag == 10) {
        [self.engine saveState];
    }
    else if (sender.tag == 11) {
        [self.engine restoreState];
        [self refreshView];
    }
    
    //[self refreshView];
    
}
- (void)setEngine:(TetrisEngine *)eng
{ 
    [self loadView];
    [_engine removeObserver:self forKeyPath:@"score"];
    [_engine removeObserver:self forKeyPath:@"timeStep"];
    [_engine removeObserver:self forKeyPath:@"gridVersion"];
    [_engine release];
    _engine = [eng retain];

    [self setupLabels];
  
    //[self refreshView]; 
}
- (void) setupLabels
{
    if (!self.engine || gridLabels || ![self isViewLoaded])
        return;

    gridLabels = [[NSMutableArray alloc]initWithCapacity: [self.engine width] * [self.engine height]];
    for (int row = 0; row < [self.engine height]; row++) {
        for (int column = 0; column < [self.engine width]; column++) {
            CGRect frame; 
            frame.size.width = 16;
            frame.size.height = 26; 
            frame.origin.x = 130 + frame.size.width * column;
            frame.origin.y = 280 - frame.size.height * row;
            [gridLabels addObject: [[UILabel alloc] initWithFrame:frame]];
            [self.view addSubview: [gridLabels objectAtIndex: TetrisArrIdx(row, column)]];
        } 
    }
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
}
- (void) refreshView
{ 
    if (!self.engine || !gridLabels)
        return;
    for (int column = 0; column < [self.engine width]; column++) {
        for (int row = 0; row < [self.engine height]; row++) {
            int piece = [self.engine pieceAtRow:row column:column];
            if (0 == piece)
                ((UILabel*)[gridLabels objectAtIndex: TetrisArrIdx(row, column)]).text = @".";
            else
                ((UILabel*)[gridLabels objectAtIndex: TetrisArrIdx(row, column)]).text = @"X";
            
        }
    }
}


@end
