//
//  AppDelegate.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/15/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "webService.h"
#import "WSPContinuous.h"
#import "Header.h"
#import "SyncClass.h"

@implementation AppDelegate

@synthesize dataBasePath;
@synthesize langDict;
@synthesize ColorFlag;
//@synthesize masterIsVisible;
@synthesize deckController;
@synthesize strTaskId;
@synthesize _delegate;

NSString *kDataBaseName=@"organisemee";
NSString *kDataBaseExt=@"sqlite";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    NSString *databaseFile=[[NSBundle mainBundle] pathForResource:kDataBaseName ofType:kDataBaseExt];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *dbPath=[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",kDataBaseName,kDataBaseExt]];
	NSFileManager *fm=[NSFileManager defaultManager];
	
	if(![fm fileExistsAtPath:dbPath]){
		[fm copyItemAtPath:databaseFile toPath:dbPath error:nil];
	}
	
    self.dataBasePath=dbPath;
    
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"];
	if (![loginStatus isEqualToString:@"LoggedIn"])
	{
        [self GetToken];
    }
    
    UILocalNotification *notification = [launchOptions objectForKey:
                                         UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (notification)
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }

    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)GetToken
{
    WSPContinuous *wsparser;
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_accessToken] action:[webService getSA_accessToken] message:[webService getSM_accessToken]]
                                                       rootTag:@"ns1:soapOut"
                                                   startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil]
                                                     endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:random",@"ns1:random",nil]
                                                     otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil]
                                                           sel:@selector(finishAccessToken:)
                                                    andHandler:self];
}
-(void)finishAccessToken:(NSDictionary*)dictionary
{
	strAccesstoken = [[(NSMutableArray *)[dictionary valueForKey:@"array"] objectAtIndex:0] valueForKey:@"ns1:random"];
    [[NSUserDefaults standardUserDefaults] setObject:strAccesstoken forKey:@"Accesstoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    // Set Current Time For SyncNeeded WS
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strNextSyncTime = [dateFormatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:strNextSyncTime forKey:@"lastSyncDateTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self checkConnection])
    {
        SyncClass *obj_SyncClass = [[SyncClass alloc]init];
        [obj_SyncClass CallSync:@"NO"];
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier bgTask = 0;
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"];
	if ([loginStatus isEqualToString:@"LoggedIn"])
	{
        [_delegate CallWsFromFGTask];
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
}

#pragma mark Global Indicator Methods

- (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title
{
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.labelText = title;
    return hud;
}
- (void)dismissGlobalHUD
{
    //NSLog(@"Dismiss indicator Called");
    [MBProgressHUD hideHUDForView:self.window animated:YES];
}

#pragma mark - CheckConnection
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

@end
