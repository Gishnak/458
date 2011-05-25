//
//  GradebookV1AppDelegate.h
//  GradebookV1
//
//  Created by lokistudios on 5/24/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradebookV1AppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
    IBOutlet UINavigationController *navigationController;

    NSMutableArray *sections;
    
    NSString* myUserName;
    NSString* myPassword;
    NSString* myBaseUrl;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, assign) NSMutableArray *sections;
@end
