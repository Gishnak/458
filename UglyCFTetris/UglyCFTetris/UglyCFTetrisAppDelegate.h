//
//  UglyCFTetrisAppDelegate.h
//  UglyCFTetris
//
//  Created by lokistudios on 4/18/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TetrisEngine.h"

@class UglyTetrisViewController;

@interface UglyCFTetrisAppDelegate : NSObject <UIApplicationDelegate> {
    int timeStep;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UglyTetrisViewController *viewController;

@property (nonatomic, retain) TetrisEngine *engine;

- (void) saveState;
- (void) restoreState;

@end
