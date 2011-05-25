//
//  GradebookV1AppDelegate.m
//  GradebookV1
//
//  Created by lokistudios on 5/24/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import "GradebookV1AppDelegate.h"
#import "Section.h"
#import "Enrollment.h"
#import "Assignment.h"
#import "Score.h"
#import "NSString+Base64Encoding.h"
#import "JSONKit.h"
#import "InfoGrabber.h"
#import "MemoryHound.h"

@implementation GradebookV1AppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;

@synthesize sections = _sections;


- (NSString*) authenticationHeader: (NSString*)username
                          password:(NSString*)password
{
    NSString *loginString = [NSString
                             stringWithFormat:@"%@:%@", username, password];
    return [NSString stringWithFormat:@"Basic %@",
            [loginString base64Encode]];
}

- (void)populateSections
{
    NSString* aHeader = [self authenticationHeader:myUserName password: myPassword];
    InfoGrabber *grabber = [[InfoGrabber alloc] initWithAuthenticationHeader:aHeader];
    NSString* baseURL = myBaseUrl;
    NSString* sectionQuery = @"?record=sections";
    NSDictionary *sectionResult = [grabber getDictFromURL:[NSString localizedStringWithFormat:@"%@%@",baseURL,sectionQuery]];
    
    
    if (sectionResult) {
        if (self.sections == nil) {
        self.sections = [[NSMutableArray alloc] init];
        }
    NSArray* mySections = [sectionResult objectForKey:@"sections"];
    
    for (NSDictionary* secDic in mySections) {
        
        NSString *course = [secDic objectForKey:@"course"];
        NSString *term = [secDic objectForKey: @"term"];
        Section *curSec = [[Section alloc] initWithNameAndTerm:course term:term];
        curSec.enrollments = [[NSMutableArray alloc] init];
        
        NSString* enrollmentQuery = [NSString localizedStringWithFormat:      @"?record=enrollments&term=%@&course=%@", term, course];
        NSDictionary *enrollmentResult = [grabber getDictFromURL:[NSString localizedStringWithFormat:@"%@%@",baseURL,enrollmentQuery]];
        NSArray* myEnrollments = [enrollmentResult objectForKey:@"enrollments"];
        for (NSDictionary* enrollDic in myEnrollments) {
            NSString *userName = [enrollDic objectForKey:@"username"];
            Enrollment *curEnroll = [[Enrollment alloc] initWithName:userName];
            curEnroll.assignments = [[NSMutableArray alloc] init];
            
            NSString *userScoresQuery = [NSString localizedStringWithFormat:@"?record=userscores&term=%@&course=%@&user=%@",term,course,userName];
            NSDictionary *userScoresResult = [grabber getDictFromURL: [NSString localizedStringWithFormat:@"%@%@", baseURL,userScoresQuery]];
            NSLog(@"userscoresresult count %d", [userScoresResult count]);
            NSArray *myUserScores = [userScoresResult objectForKey:@"userscores"];
            
            for (NSDictionary* userScoreDic in myUserScores) {
                NSString *assnName = [userScoreDic objectForKey:@"name"];
                Assignment *curAssign = [[Assignment alloc]initWithName:assnName];
                curAssign.scores = [[NSMutableArray alloc]init];
                NSArray *myScore = [userScoreDic objectForKey:@"scores"];
                for (NSDictionary *scoreDict in myScore) {
                    Score *curScore = [[Score alloc] initWithName:[scoreDict objectForKey:@"display_score"]];
                    [curAssign.scores addObject:curScore];
                    [curScore release];
                }
                
                [curEnroll.assignments addObject:curAssign];
                [curAssign.scores release];
                [curAssign release];
            }
            [curSec.enrollments addObject:curEnroll];
            [curEnroll.assignments release];
            [curEnroll release];
            
        }
        [self.sections addObject: curSec];
        [curSec.enrollments release];
        [curSec release];
    }
    }
    [grabber release];
    

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MemoryHound startRotateHound];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    myUserName = [defaults stringForKey:@"username"];
    myPassword = [defaults stringForKey:@"password"];
    myBaseUrl = [defaults stringForKey:@"baseURL"];
    NSLog(@"user: %@", myUserName);
    NSLog(@"pass: %@", myPassword);
    NSLog(@"base: %@", myBaseUrl);
    
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    if (myUserName && myPassword && myBaseUrl) {

        [self populateSections];
    }
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    myUserName = [defaults stringForKey:@"username"];
    myPassword = [defaults stringForKey:@"password"];
    myBaseUrl = [defaults stringForKey:@"baseURL"];
    self.sections = nil;
    if (myUserName && myPassword && myBaseUrl) {
        [self populateSections];
        self.window.rootViewController = self.navigationController;
        [self.window makeKeyAndVisible];
    }
    //self.engine.antiGrav = [defaults boolForKey: @"antigravity"];
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_sections release];
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
