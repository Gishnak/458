//
//  MovableShape.h
//  Shapes-05
//
//  Created by John Bellardo on 4/28/11.
//  Licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
//  http://creativecommons.org/licenses/by-nc-sa/3.0/us/
//

#import <UIKit/UIKit.h>

@interface MovableShapePanData : NSObject {
}
@property (nonatomic) CGPoint distance, velocity;
@property (nonatomic) UIGestureRecognizerState state;
@end

@interface MovableShape : UIView {
    
}
// "target" is assign to prevent circular reference loop.
//  Normally you will use retain or copy instead of assign.
@property (nonatomic, assign) id target;

@property (nonatomic) SEL panAction;

@end
