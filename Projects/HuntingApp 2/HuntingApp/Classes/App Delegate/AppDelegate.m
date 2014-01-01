//
//  AppDelegate.m
//  HuntingApp
//
//  Created by Habib Ali on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SHKConfiguration.h"
#import "CameraViewController.h"
#import "SHKFacebook.h"
#import "LocationTracker.h"
#import "ProfileViewController.h"
#import "iRate.h"
#import "TredingViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [iRate sharedInstance].appStoreCountry = @"US";
    [iRate sharedInstance].appStoreID = 558144747;
	[iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    
    //enable preview mode
    [iRate sharedInstance].previewMode = NO;
    
    [[iRate sharedInstance] setMessage:@"If you enjoy using OutdoorLoop, would you mind taking a moment to rate it? It won’t take more than a minute. Thanks for your support!"];
    
    previousViewControllerIndex = 0;
    
    
    if (IS_IPHONE_5) {
        
        UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"mainStoryBoard_iPhone5" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        TredingViewController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
        
        
    }else{
    
        UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        TredingViewController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
        
    }
    
    
    self.tabBarController = (UITabBarController *)self.window.rootViewController;
    
    UIImage *img = [UIImage imageNamed:@"NavigationBar"];
    [self.tabBarController.tabBar setBackgroundImage:img];
    [[UINavigationBar appearance] setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    @try {
        DefaultSHKConfigurator *configurator = [[DefaultSHKConfigurator alloc] init];
        [SHKConfiguration sharedInstanceWithConfigurator:configurator];
        [configurator release];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
    }
    @finally {
        
    }

    [self setImagesOnTabbar];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //   [defaults setObject:@"1" forKey:LOGIN_STATE];
    //    [defaults setObject:@"JVP8xGk4hsX2cZd0L3NQ" forKey:LOGIN_TOKEN];
    //    [defaults setObject:@"1" forKey:PROFILE_USER_ID_KEY];
    //    [defaults synchronize];
    if (![defaults objectForKey:LOGIN_TOKEN])
    {
        [defaults setObject:[NSMutableArray array] forKey:NOTIFICATION_READ];
        [defaults setObject:@"0" forKey:LOGIN_STATE];
        [defaults setObject:@"0" forKey:FIRST_VIEW];
        [defaults setObject:@"0" forKey:HAVE_SHOWN_LOC_ALERT];
        [defaults setObject:@"0" forKey:LOAD_PROFILE_IMAGE_FROM_SERVER];
        [defaults synchronize];
        [self.tabBarController setSelectedIndex:0];
    }
    else {
        [self createAlbums:[Utility userID]];
        DLog(@"%@",[Utility token]);
    }
    if (![[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_TOKEN]) {
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    return YES;
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[[NSString alloc] initWithString:[deviceToken description]]autorelease];
    DLog(@"%@",[deviceToken description]);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:DEVICE_TOKEN];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
    //[[DAL sharedInstance] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[Utility sharedInstance] setShouldRate:YES];
    [[LocationTracker sharedInstance] trackLocation];
    if ([Utility userID])
    {
        [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:[Utility userID]];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) setImagesOnTabbar
{
    UITabBar *tabBar = self.tabBarController.tabBar;
    UIImage *selectedImage0 = [UIImage imageNamed:@"home"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"home"];
    
    UIImage *selectedImage1 = [UIImage imageNamed:@"trending"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"trending"];
    
    UIImage *selectedImage2 = [UIImage imageNamed:@""];
    UIImage *unselectedImage2 = [UIImage imageNamed:@""];
    
    UIImage *selectedImage3 = [UIImage imageNamed:@"profile"];
    UIImage *unselectedImage3 = [UIImage imageNamed:@"profile"];
    
    UIImage *selectedImage4 = [UIImage imageNamed:@"settings"];
    UIImage *unselectedImage4 = [UIImage imageNamed:@"settings"];

    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    UITabBarItem *item4 = [tabBar.items objectAtIndex:4];
    
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    [item3 setFinishedSelectedImage:selectedImage3 withFinishedUnselectedImage:unselectedImage3];
    [item4 setFinishedSelectedImage:selectedImage4 withFinishedUnselectedImage:unselectedImage4];
    
    [item0 setTitle:@""];
    [item1 setTitle:@""];
    [item2 setTitle:@""];
    [item3 setTitle:@""];
    [item4 setTitle:@""];
    
    UIImage *buttonImage = [UIImage imageNamed:@"camera"];
    UIImage *highlightImage = [UIImage imageNamed:@"camera-selected"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(tabBar.frame.origin.x,tabBar.frame.origin.y, 56, 55);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBarController.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBarController.tabBar.center;
    else
    {
        CGPoint center = self.tabBarController.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    CGRect frame = button.frame;
    
    if (IS_IPHONE_5) {
        
        frame.origin.y=510;
    }else{
       
        frame.origin.y = 422;
    }
    
    button.frame = frame;
    [button addTarget:self action:@selector(showCameraViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:button];
}

- (void)showCameraViewController
{
    if (self.tabBarController.selectedIndex !=2)
        previousViewControllerIndex = self.tabBarController.selectedIndex;
    [self.tabBarController setSelectedIndex:2];
}

- (void)gotoPreviousViewController
{
    [self.tabBarController setSelectedIndex:previousViewControllerIndex];
}


- (void)createAlbums:(NSString *)userID
{
    if (userID && ![userID isEmptyString] && [[[DAL sharedInstance] getAllAlbumNamesAndID:userID] count]==0)
    {
        NSArray *arr = [[NSArray alloc] initWithObjects:@"BigGame",@"SmallGame",@"FreshWater",@"SaltWater",@"Exotic",@"Others", nil];
        int ind = 0;
        for (NSString *albumName in arr) {
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",ind],ALBUM_ID_KEY,albumName,ALBUM_NAME_KEY,userID,PROFILE_USER_ID_KEY, nil];
            [[DAL sharedInstance] createAlbumWithParams:params];
            ind++;
        }
        RELEASE_SAFELY(arr);
    }
}

// for facebook
- (BOOL)handleOpenURL:(NSURL*)url
{
    NSString* scheme = [url scheme];
    NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
    if ([scheme hasPrefix:prefix])
        return [SHKFacebook handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    return [self handleOpenURL:url];  
}


- (void)logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:LOGIN_STATE];
    [defaults removeObjectForKey:LOGIN_TOKEN];
    [defaults removeObjectForKey:PROFILE_USER_ID_KEY];
        [[DAL sharedInstance] resetDataStore];
    [SHK logoutOfAll];
    [defaults synchronize];
    [((UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:0]) popToRootViewControllerAnimated:YES];
    [((UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:1]) popToRootViewControllerAnimated:YES];
    [((UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:3]) popToRootViewControllerAnimated:YES];
    [((UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:4]) popToRootViewControllerAnimated:YES];
    if (self.tabBarController.selectedIndex==0)
        [((UIViewController *)[((UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:0]).viewControllers objectAtIndex:0]) viewWillAppear:YES];

    [self.tabBarController setSelectedIndex:0];
    
}

- (void)gotoProfileView:(id)sender
{
    ProfileViewController *controller = (ProfileViewController *)[((UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:3]).viewControllers objectAtIndex:0];
    [controller.navigationController popToRootViewControllerAnimated:YES];
    [controller profileSelected:(UIButton *)sender];
    [self.tabBarController setSelectedIndex:3];
}


@end
