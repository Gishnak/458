//
//  WorldObject.m
//  Shapes-05
//
//  Created by John Bellardo on 4/26/11.
//  Licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
//  http://creativecommons.org/licenses/by-nc-sa/3.0/us/
//

#import "WorldObject.h"

@interface WorldObject ()
@property (nonatomic) int objId;
@property (nonatomic) int type;

@end

@implementation WorldObject

@synthesize type = type_;
@synthesize objId = objId_;
@synthesize location = location_;
@synthesize velocity = velocity_, acceleration = acceleration_;

- (id) initWithType: (int) ty andLocation:(CGRect) rect
{
    static int nextId = 0;
    
    self = [super init];
    self.objId = nextId++;
    self.type = ty;
    self.location = rect;
    self.velocity = CGPointMake(0, -500);
    self.acceleration = CGPointMake(0, 0);
    
    return self;
}

- (void) stepInRect: (CGRect) world withInterval: (CFTimeInterval) intv
{
    CGRect location = self.location;
    
    location.origin.x += self.velocity.x * intv;
    location.origin.y += self.velocity.y * intv;
    
    // Check for collision with right/left side of view
    if ( (location.origin.x + location.size.width ) >= 
        world.size.width) {
        location.origin.x = world.size.width - location.size.width;
        self.velocity = CGPointMake(-self.velocity.x * 4.0 / 5.0 , self.velocity.y);
    }
    else if (location.origin.x < world.origin.x) {
        location.origin.x = world.origin.x;
        self.velocity = CGPointMake(-self.velocity.x * 4.0 / 5.0, self.velocity.y);
    }
    else
        self.velocity = CGPointMake(intv * self.acceleration.x + self.velocity.x, self.velocity.y);
    
    // Check for collision with bottom of view
    if ( (location.origin.y + location.size.height) >= 
        world.size.height) {
        location.origin.y = world.size.height - location.size.height;
        self.velocity = CGPointMake(self.velocity.x, -self.velocity.y * 4.0 / 5.0);
    }
    else
        self.velocity = CGPointMake(self.velocity.x, intv * self.acceleration.y + self.velocity.y);
    
    self.location = location;
}

@end
