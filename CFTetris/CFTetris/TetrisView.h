//
//  TetrisView.h
//  CFTetris
//
//  Created by Laub, Brian on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovableShapePanData : NSObject {
}
@property (nonatomic) CGPoint distance, velocity;
@property (nonatomic) UIGestureRecognizerState state;
@end

@interface TetrisView : UIView {
    
}

@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic, retain) NSMutableArray* grid;

@property (nonatomic, assign) id target;
@property (nonatomic) SEL panAction;
@property (nonatomic) SEL touchAction;
@property (nonatomic) SEL shakeAction;

- (void) setColor: (UIColor*) color forRow: (int) row column: (int) col;
- (void) setUpGrid;

@end
