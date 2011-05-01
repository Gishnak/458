//
//  WorldObject.h
//  Shapes-05
//
//  Created by John Bellardo on 4/26/11.
//  Licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
//  http://creativecommons.org/licenses/by-nc-sa/3.0/us/
//

#import <Foundation/Foundation.h>


@interface WorldObject : NSObject {
    
}

@property (nonatomic, readonly) int type;
@property (nonatomic, readonly) int objId;
@property (nonatomic) CGRect location;
@property (nonatomic) CGPoint velocity, acceleration;

- (id) initWithType: (int) ty andLocation:(CGRect) rect;
- (void) stepInRect: (CGRect) world withInterval: (CFTimeInterval) intv;

@end
