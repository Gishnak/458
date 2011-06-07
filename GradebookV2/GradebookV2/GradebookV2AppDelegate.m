//
//  GradebookV2AppDelegate.m
//  GradebookV2
//
//  Created by lokistudios on 6/6/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import "GradebookV2AppDelegate.h"

#import "RootViewController.h"
#import "DetailViewController.h"
#import "SectionPicker.h"
#import "Section.h"
#import "Enrollment.h"
#import "Assignment.h"
#import "Score.h"
#import "NSString+Base64Encoding.h"
#import "JSONKit.h"
#import "InfoGrabber.h"
#import "MemoryHound.h"

@implementation GradebookV2AppDelegate


@synthesize window=_window;

@synthesize splitViewController=_splitViewController;

@synthesize rootViewController=_rootViewController;

@synthesize detailViewController=_detailViewController;

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
    // Override point for customization after application launch.
    // Add the split view controller's view to the window and display.
    [MemoryHound startLowMemoryHound];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    myUserName = [defaults stringForKey:@"username"];
    //myUserName = @"blaub";
    myPassword = [defaults stringForKey:@"password"];
   // myPassword = @"f7Tq39u)";
    myBaseUrl = [defaults stringForKey:@"baseURL"];
   // myBaseUrl = @"https://users.csc.calpoly.edu/~bellardo/cgi-bin/grades.json";
    
    
    [self populateSections];
    
    

    
    SectionPicker *sp = [[SectionPicker alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:sp];
    DetailContainer *dc = [[DetailContainer alloc]init];
    

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.splitViewController = [[UISplitViewController alloc] init];
            self.splitViewController.delegate = dc;
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:nc, dc, nil];
        [self.window addSubview:self.splitViewController.view];
    }
    else
    {
        [self.window addSubview:nc.view];
    }
    
    [self.window makeKeyAndVisible];
    
    
    //self.window.rootViewController = self.splitViewController;
    //[self.window makeKeyAndVisible];
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
    [_window release];
   // [_splitViewController release];
    [_rootViewController release];
    [_detailViewController release];
    [super dealloc];
}

@end
