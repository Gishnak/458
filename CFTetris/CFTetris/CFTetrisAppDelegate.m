//
//  CFTetrisAppDelegate.m
//  CFTetris
//
//  Created by Laub, Brian on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CFTetrisAppDelegate.h"
#import "UglyTetrisViewController.h"

@implementation CFTetrisAppDelegate


@synthesize viewController=_viewController;

@synthesize engine = _engine;

@synthesize window=_window;

@synthesize tabBarController=_tabBarController;

- (void) saveState 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *state = [self.engine currentState];
    [defaults setObject:state forKey: @"gameState"];
    [defaults synchronize];
}

- (void) restoreState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *state = (NSDictionary*)[defaults objectForKey: @"gameState"];
    if (state) {
        self.engine = [[TetrisEngine alloc] initWithState: state];
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    [self restoreState];
    if (!self.engine)
        self.engine = [[TetrisEngine alloc] initWithHeight:10];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.engine.antiGrav = [defaults boolForKey: @"antigravity"];
    [[self.tabBarController.viewControllers objectAtIndex:1] setEngine:self.engine]; 
    [[self.tabBarController.viewControllers objectAtIndex:0] setEngine:self.engine];
    //self.window.rootViewController = self.viewController;
   // [self.window makeKeyAndVisible];
   // return YES;
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eraseView) name:@"shake" object:nil];
    return YES;
}

-(void) eraseView
{

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.engine stop];
    timeStep = [self.engine timeStep];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.engine stop];
    [self saveState];
    timeStep = NO;
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    self.engine.antiGrav = [defaults boolForKey: @"antigravity"];
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (timeStep) {
        [self.engine start];
    }
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.engine stop];
    [self saveState];
    timeStep = NO;
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
