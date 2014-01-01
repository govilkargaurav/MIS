//
//  AppDelegate.m
//  LawyerApp
//
//  Created by Openxcell Game on 6/6/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "AppDelegate.h"
#import "ReverseGeoCoder.h"
#import "ViewController.h"
#import "RageIAPHelper.h"
#import "Reachability.h"
#import "FindALawyerViewController.h"
#import "MSMasterViewController.h"
@implementation AppDelegate
@synthesize InternetConnectionFlag;
@synthesize navigationController;
@synthesize locationManager;
@synthesize loadingActivityIndicator;
@synthesize strCityName;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    sleep(2.0);
    
    
    InternetConnectionFlag = 1;
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability  *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability  *reachability)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        InternetConnectionFlag = 1;
    };
    reach.unreachableBlock = ^(Reachability * reachability)
    {
    };
    [reach startNotifier];
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate=self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];    
    [[NSUserDefaults standardUserDefaults] setValue:@"FIRSTTIME" forKey:@"FIRSTTIME"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.navigationPaneViewController = [[MSNavigationPaneViewController alloc] init];
    MSMasterViewController *masterViewController = [[MSMasterViewController alloc] init];
    masterViewController.navigationPaneViewController = self.navigationPaneViewController;
    self.navigationPaneViewController.masterViewController = masterViewController;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationPaneViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Internet Notification
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    if([reach isReachable])
    {
        InternetConnectionFlag = 1;
    }
    else
    {
        InternetConnectionFlag = 0;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Connection Error!!" message:@"Internet connection not available in your device!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
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

#pragma mark - Location Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSString *currentLat=[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString *currentLong=[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    strCityName = [[ReverseGeoCoder sharedManager] getAddressFromLatLon:[currentLat doubleValue] withLongitude:[currentLong doubleValue]];
    if (strCityName!=NULL) {
        [locationManager stopUpdatingLocation];
        [loadingActivityIndicator removeFromSuperview];
    }
}

@end
