//
//  TetrisView.m
//  CFTetris
//
//  Created by Laub, Brian on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TetrisView.h"
#import "TetrisEngine.h"


@implementation TetrisView

@synthesize height = _height;
@synthesize width = _width;
@synthesize grid = _grid;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.width = 10;
        self.height = 10;
        self.grid = [[NSMutableArray alloc] initWithCapacity: TetrisArrSize(self.height)];
        for (int i = 0; i < TetrisArrSize(self.height); i++) 
        {
            [self.grid addObject: [UIColor whiteColor]];
        }

        
    }
    return self;
}


- (void) setColor: (UIColor*)color forRow: (int) row column: (int) col
{
    [self.grid replaceObjectAtIndex: TetrisArrIdx(row, col) withObject: color];
    [self setNeedsDisplay];
    NSLog(@"%lu", sizeof([self window]));

//    NSLog(@"%d", test);
}


- (void)drawRect:(CGRect)rect
{
    
    for (int column = 0; column < self.width; column++) {
        for (int row = 0; row < self.height; row++) {
            double x = rect.origin.x + (double) row/self.width;
            NSLog(@"x: %f", x);
            CGRect gridSpot = CGRectMake(rect.origin.x + (double)row/self.width * rect.size.width, rect.origin.y + (double)column/self.height * rect.size.height, rect.size.width/self.width, rect.size.height/self.height);
            [(UIColor*)[self.grid objectAtIndex: TetrisArrIdx(row, column)] set]; 
            UIRectFill(gridSpot);
            
        }
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
