//
//  Ellipse.m
//  Shapes-05
//
//  Created by John Bellardo on 4/21/11.
//  Licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
//  http://creativecommons.org/licenses/by-nc-sa/3.0/us/
//

#import "Ellipse.h"


@implementation Ellipse

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect box = self.bounds;
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, box);
    CGContextClosePath(context);
    [[UIColor blackColor] setStroke];
    [[UIColor redColor] setFill];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)dealloc
{
    [super dealloc];
}

@end
