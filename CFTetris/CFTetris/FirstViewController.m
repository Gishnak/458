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

- (void) setupLabels
{
    if (!self.engine || ![self isViewLoaded])
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
    if (!self.engine)
        return;
    for (int column = 0; column < [self.engine width]; column++) {
        for (int row = 0; row < [self.engine height]; row++) {
            int piece = [self.engine pieceAtRow:row column:column];
            if (0 == piece)
                //((UILabel*)[gridLabels objectAtIndex: TetrisArrIdx(row, column)]).text = @".";
                [board setColor: [UIColor whiteColor] forRow:row column: column];
            else
                [board setColor: [UIColor redColor] forRow:row column: column];
                //((UILabel*)[gridLabels objectAtIndex: TetrisArrIdx(row, column)]).text = @"X";
            
        }
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLabels];
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
