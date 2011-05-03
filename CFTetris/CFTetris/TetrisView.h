//
//  TetrisView.h
//  CFTetris
//
//  Created by Laub, Brian on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TetrisView : UIView {
    
}

@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic, retain) NSMutableArray* grid;

- (void) setColor: (UIColor*) color forRow: (int) row column: (int) col;
- (void) setUpGrid;

@end
