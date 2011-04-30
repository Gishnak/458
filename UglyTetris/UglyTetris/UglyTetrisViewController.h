//
//  UglyTetrisViewController.h
//  UglyTetris
//
//  Created by Laub, Brian on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TetrisEngine.h"

@interface UglyTetrisViewController : UIViewController {
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *scoreLabel;
    TetrisEngine *engine;
    NSTimer *stepTimer;
    UILabel **gridLabels;
    
}
-(IBAction) buttonPressed:(UIButton*)sender;
- (void) setEngine: (TetrisEngine*)eng;
- (void) refreshView;
- (void) gameStep;

@end
