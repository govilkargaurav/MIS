//
//  AppDelegate.m
//  SkyyApp
//
//  Created by Vishal Jani on 9/3/13.
//  Copyright (c) 2013 openxcell. All rights reserved.

#import "AppDelegate.h"
#import "InfoViewController.h"
#import "InboxViewController.h"
#import "HomeViewController.h"

@implementation AppDelegate
@synthesize navController,arrTrash,_toDoItems,arrInbox,currentLeftClass,currentRightClass,currentDeviceToken;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [Parse setApplicationId:@"ftFfLnarcXfL6k1LMiTRdJAbNT8BoYyAnkkUJwbP" clientKey:@"ILpQWWlh2g0oaABcfUrEZcvYLaWrRWRJw3gah3Kg"];
    // Override point for customization after application launch.
    if ([PFUser currentUser]) {
        HomeViewController *objHomeViewController=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        self.navController=[[UINavigationController alloc]initWithRootViewController:objHomeViewController];
    }else{
        self.viewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
        self.navController=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    }

    self.arrTrash=[[NSMutableArray alloc]init];
   self.arrInbox=[[NSMutableArray alloc]init];
    
    [PFFacebookUtils initializeFacebook];
    self.window.rootViewController = self.navController;
    
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:CustomfontLight(21) forKey:UITextAttributeFont];
    [titleBarAttributes setValue:[UIColor clearColor] forKey:UITextAttributeTextShadowColor];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];

    [[self window] setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    return YES;

}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
  self.currentDeviceToken = deviceToken;

}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    if([[userInfo objectForKey:@"action"] isEqualToString:@"note"]){
        InboxViewController *objInboxViewController=[[InboxViewController alloc]initWithNibName:@"InboxViewController" bundle:nil];
        objInboxViewController.title=@"Inbox";
        [self.navController pushViewController:objInboxViewController animated:FALSE];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];

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

@end
