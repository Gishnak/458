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

    return self;
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

- (void)dealloc
{
    [super dealloc];
}

@end
