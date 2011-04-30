//
//  UglyTetrisViewController.m
//  UglyTetris
//
//  Created by Laub, Brian on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UglyTetrisViewController.h"

@implementation UglyTetrisViewController

- (void)dealloc
{
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
    [self refreshView];
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
- (IBAction) buttonPressed:(UIButton*)sender
{
    NSLog(@"Button pressed with tag: %d\n", sender.tag);
    if (sender.tag == 1) {
        if (!stepTimer) {
            NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0.0];
            stepTimer = [[NSTimer alloc] initWithFireDate:fireDate
                                                 interval:1.0
                                                   target:self
                                                 selector:@selector(gameStep)
                                                 userInfo:nil
                                                  repeats:YES];
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            [runLoop addTimer:stepTimer forMode:NSDefaultRunLoopMode];
            
        }
    }
    else if (sender.tag == 2) {
        if (stepTimer) {
            [engine slideLeft];
        }
    }
    else if (sender.tag == 3) {
        if (stepTimer) {
            [engine slideRight];
        }
    }
    else if (sender.tag == 4) {
        if (stepTimer) {
            [engine rotateCW];
        }
    }
    else if (sender.tag == 5) {
        if (stepTimer) {
            [engine rotateCCW];
        }
    }
    else if (sender.tag == 6) {
        if (stepTimer) {
            [stepTimer invalidate];
            stepTimer = nil;
        }
    }
    else if (sender.tag == 7) {
        [engine reset];
    }
    [self refreshView];
    
}
- (void)setEngine:(TetrisEngine *)eng
{ 
    [self loadView];
    engine = eng;
    gridLabels = malloc(sizeof(UILabel*) * TetrisArrSize([engine height]));
    for (int column = 0; column < [engine width]; column++) 
    { 	
        for (int row = 0; row < [engine height]; row++) {
            CGRect frame; 
            frame.size.width = 16;
            frame.size.height = 26; 
            frame.origin.x = 130 + frame.size.width * column;
            frame.origin.y = 280 - frame.size.height * row;
            gridLabels[TetrisArrIdx(row, column)] =	[[UILabel alloc] initWithFrame:frame];
            [self.view addSubview:	
             gridLabels[TetrisArrIdx(row, column)]];
            } 
    }    
    [self refreshView]; 
}
- (void) refreshView
{ 
    timeLabel.text = [NSString stringWithFormat:@"%d", [engine timeStep]]; 
    scoreLabel.text =[NSString stringWithFormat:@"%d", [engine score]];
    if (!engine || !gridLabels)
        return;
    for (int column = 0; column < [engine width]; column++) {
        for (int row = 0; row < [engine height]; row++) {
            int piece = [engine pieceAtRow:row column:column];
            if (0 == piece)
                gridLabels[TetrisArrIdx(row, column)].text = @".";
            else
                gridLabels[TetrisArrIdx(row, column)].text = @"X";
            
        }
    }
}
- (void) gameStep
{
    [engine advance];
    [self refreshView];
}
@end
