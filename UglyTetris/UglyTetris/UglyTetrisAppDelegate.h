//
//  UglyTetrisAppDelegate.h
//  UglyTetris
//
//  Created by Laub, Brian on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TetrisEngine.h"


@class UglyTetrisViewController;

@interface UglyTetrisAppDelegate : NSObject <UIApplicationDelegate> {
    TetrisEngine *engine;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UglyTetrisViewController *viewController;

@end
