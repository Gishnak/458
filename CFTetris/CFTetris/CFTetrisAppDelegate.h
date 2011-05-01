//
//  CFTetrisAppDelegate.h
//  CFTetris
//
//  Created by Laub, Brian on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TetrisEngine.h"

@class UglyTetrisViewController;

@interface CFTetrisAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    int timeStep;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet UglyTetrisViewController *viewController;

@property (nonatomic, retain) TetrisEngine *engine;

- (void) saveState;
- (void) restoreState;


@end
