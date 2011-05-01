//
//  FirstViewController.h
//  CFTetris
//
//  Created by Laub, Brian on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TetrisEngine.h"
#import "TetrisView.h"


@interface FirstViewController : UIViewController {
    @private
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet TetrisView *board;
}

@property (readwrite, retain, nonatomic) TetrisEngine* engine;

- (void) refreshView;
- (void) setEngine: (TetrisEngine*)eng;
- (void) setupLabels;
- (void) observeValueForKeyPath:(NSString *)keyPath 
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context;

@end
