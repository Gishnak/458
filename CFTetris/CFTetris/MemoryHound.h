//
//  MemoryHound.h
//  UglyCFTetris
//
//  Created by John Bellardo on 4/13/11.
//  Licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
//  http://creativecommons.org/licenses/by-nc-sa/3.0/us/
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MemoryHound : NSObject <UIApplicationDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

// Call startHound once in your App Delegate's application:didFinishLaunchingwithOptions: method.
+ (void) startHound;

- (void) didRotate:(NSNotification *)notification;

@end
