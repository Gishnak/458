//
//  GradebookV2AppDelegate.h
//  GradebookV2
//
//  Created by lokistudios on 6/6/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@class DetailViewController;

@interface GradebookV2AppDelegate : NSObject <UIApplicationDelegate> {
    NSMutableArray *sections;
    
    NSString* myUserName;
    NSString* myPassword;
    NSString* myBaseUrl;
}

@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) UISplitViewController *splitViewController;

@property (nonatomic, retain) RootViewController *rootViewController;

@property (nonatomic, retain) DetailViewController *detailViewController;

@property (nonatomic, assign) NSMutableArray *sections;

@end
