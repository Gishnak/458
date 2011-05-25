//
//  Ellipse.m
//  Shapes-05
//
//  Created by John Bellardo on 4/21/11.
//  Licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
//  http://creativecommons.org/licenses/by-nc-sa/3.0/us/
//

#import "Ship.h"


@implementation Ship

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
   // CGContextAddEllipseInRect(context, box);
    CGContextClosePath(context);
   // [[UIColor blackColor] setStroke];
   // [[UIColor whiteColor] setFill];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
   // CGRect myImageRect = CGRectMake(0.0f, 0.0f, 320.0f, 109.0f);
    UIImageView *myImage = [[UIImageView alloc] initWithFrame:box];
    [myImage setImage:[UIImage imageNamed:@"drashmupz.gif"]]; 
    myImage.opaque = YES; // explicitly opaque for performance 
    [self addSubview:myImage]; 
    [myImage release]; 
}

- (void)dealloc
{
    [super dealloc];
}

@end
