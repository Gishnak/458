//
//  GradebookV2AppDelegate.h
//  GradebookV2
//
//  Created by lokistudios on 6/6/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionPicker.h"
#import "DetailContainer.h"

@class RootViewController;

@class DetailViewController;

@interface GradebookV2AppDelegate : NSObject <UIApplicationDelegate> {
    NSMutableArray *sections;
    
    NSString* myUserName;
    NSString* myPassword;
    NSString* myBaseUrl;
}

@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, assign) UISplitViewController *splitViewController;

@property (nonatomic, assign) DetailContainer *dc;

@property (nonatomic, assign) SectionPicker *sp;

@property (nonatomic, retain) UINavigationController *nc;

//@property (nonatomic, retain) RootViewController *rootViewController;

@property (nonatomic, assign) NSMutableArray *sections;

@end
