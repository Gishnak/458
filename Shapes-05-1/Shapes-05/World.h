//
//  World.h
//  Shapes-05
//
//  Created by John Bellardo on 4/26/11.
//  Licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
//  http://creativecommons.org/licenses/by-nc-sa/3.0/us/
//

#import <Foundation/Foundation.h>
#import "WorldObject.h"

@interface World : NSObject {
    @private
    CGRect world;
}
@property (nonatomic, readonly) NSArray *worldObjects;

- (WorldObject*) objectWithID: (int) objId;
- (id) initWithRect: (CGRect) rect;
- (void) step: (CFTimeInterval)intv;
- (void) addObject: (WorldObject*) obj;

@end
