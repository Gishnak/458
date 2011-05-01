//
//  World.m
//  Shapes-05
//
//  Created by John Bellardo on 4/26/11.
//  Licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
//  http://creativecommons.org/licenses/by-nc-sa/3.0/us/
//

#import "World.h"

@interface World ()
@property (nonatomic, retain) NSMutableArray *objects;
@end

@implementation World
@synthesize objects = objects_;
@synthesize worldObjects = worldObjects_;

- (NSArray*) worldObjects
{
    return self.objects;
}

- (void) dealloc
{
    [objects_ release];
    [super dealloc];
}

// Find the WorldObject with the given objId
- (WorldObject*) objectWithID: (int) objId
{
    for (WorldObject *obj in self.objects)
        if (obj.objId == objId)
            return obj;
    return nil;
}

- (id) initWithRect:(CGRect)rect
{
    self = [super init];
    if (self) {
        self.objects = [NSMutableArray arrayWithCapacity:10];
        self->world = rect;
    }
    
    return self;
}

- (void) step: (CFTimeInterval)intv
{
    for (WorldObject *obj in self.objects)
        [obj stepInRect:world withInterval:intv];
}

- (void) addObject:(WorldObject *)obj
{
    [self.objects addObject:obj];
}

@end
