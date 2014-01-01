//
//  FsenetAppDelegate.m
//  MyMites
//
//  Created by openxcell technolabs on 7/10/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "FsenetAppDelegate.h"
#import "FsenetMasterViewController.h"

@implementation FsenetAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    sleep(3);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    FsenetMasterViewController *masterViewController = [[FsenetMasterViewController alloc] initWithNibName:@"FsenetMasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}
- (BOOL) checkConnection {
	const char *host_name = "www.google.com";
    BOOL _isDataSourceAvailable = NO;
    Boolean success;    
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL,host_name);
	SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    _isDataSourceAvailable = success && 
	(flags & kSCNetworkFlagsReachable) &&
	!(flags & kSCNetworkFlagsConnectionRequired);
	
    CFRelease(reachability);
	
    return _isDataSourceAvailable;
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
-(IBAction)btnGlobalSearchPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushIt0" object:self];
}


@end
