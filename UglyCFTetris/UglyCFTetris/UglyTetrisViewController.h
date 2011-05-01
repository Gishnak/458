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
    @private
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *scoreLabel;
    NSMutableArray* gridLabels;
}
@property (readwrite, retain, nonatomic) TetrisEngine* engine;

-(IBAction) buttonPressed:(UIButton*)sender;
- (void) setEngine: (TetrisEngine*)eng;
- (void) refreshView;
- (void) setupLabels;
- (void) observeValueForKeyPath:(NSString *)keyPath 
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context;

@end
