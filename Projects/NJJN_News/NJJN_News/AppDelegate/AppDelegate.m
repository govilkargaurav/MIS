//
//  AppDelegate.m
//  NJJN_News
//
//  Created by Mac-i7 on 6/18/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+Valid.h"

#define UDIDKey @"CreatedUDID"

NSString *kDataBaseName = @"NJJN_DB";
NSString *kDataBaseExt = @"sqlite";

@implementation AppDelegate

@synthesize tabBarController = _tabBarController;
@synthesize window = _window;
//@synthesize InternetConnectionFlag;
@synthesize hud = _hud;
@synthesize imageView1 = _imageView1,imageView2 = _imageView2,imageView3 = _imageView3,imageView4 = _imageView4,imageView5 = _imageView5,imageView6 = _imageView6;
@synthesize dataBasePath;
@synthesize arrPdf,downloadingArray;

#pragma mark - Application Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setIdleTimerDisabled:YES];
    
     [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
        
    self.tabBarController.delegate = self;
    
    [self finalUDIDSting];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    NSString *databaseFile=[[NSBundle mainBundle] pathForResource:kDataBaseName ofType:kDataBaseExt];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *dbPath=[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",kDataBaseName,kDataBaseExt]];
	NSFileManager *fm=[NSFileManager defaultManager];
	
	if(![fm fileExistsAtPath:dbPath])
    {
		[fm copyItemAtPath:databaseFile toPath:dbPath error:nil];
	}
	
    self.dataBasePath=dbPath;
        
    _tabBarController.selectedIndex = 0;
    
    [self.window makeKeyAndVisible];
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"])
    {
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    }
    
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceTokenSend"] isEqualToString:@"Yes"])
    {
        [self performSelector:@selector(finalUDIDSting) withObject:nil afterDelay:0.1];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}


#pragma mark - Tabbar Customization

-(void)TabBarCustomizationImages
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0)
    {
        _tabBarController.tabBar.backgroundImage=[UIImage imageNamed:@"tabBG.png"];
    }
    else
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBG.png"]];
        [_tabBarController.tabBar insertSubview:imageView atIndex:0];
    }
    
    _imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home.png"]];
    [_imageView1 setFrame:CGRectMake(50, 0, 60 , 49)];
    [_tabBarController.tabBar insertSubview:_imageView1 atIndex:1];

    
    _imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"issues.png"]];
    [_imageView2 setFrame:CGRectMake(150, 0, 60 , 49)];
    [_tabBarController.tabBar insertSubview:_imageView2 atIndex:2];
    
    _imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"download.png"]];
    [_imageView3 setFrame:CGRectMake(250, 0, 60 , 49)];
    [_tabBarController.tabBar insertSubview:_imageView3 atIndex:3];
    
    
    _imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact.png"]];
    [_imageView4 setFrame:CGRectMake(350, 0, 60 , 49)];
    [_tabBarController.tabBar insertSubview:_imageView4 atIndex:4];
    
    
    _imageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings.png"]];
    [_imageView5 setFrame:CGRectMake(450, 0, 60 , 49)];
    [_tabBarController.tabBar insertSubview:_imageView5 atIndex:5];
    
    _imageView6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"infoTab.png"]];
    [_imageView6 setFrame:CGRectMake(550, 0, 60 , 49)];
    [_tabBarController.tabBar insertSubview:_imageView6 atIndex:6];
}



#pragma mark - MBProgressHUD AlertHandler
- (void)doshowHUD
{
	[self performSelectorOnMainThread:@selector(doshowLoadingView) withObject:nil waitUntilDone:NO];
}
- (void)dohideHUD
{
    [self performSelectorOnMainThread:@selector(dohideLoadingView) withObject:nil waitUntilDone:NO];
    
}
- (void)showLoadingView
{
    [self performSelectorOnMainThread:@selector(doshowLoadingView) withObject:nil waitUntilDone:NO];
    
}
- (void)hideLoadingView
{
    [self performSelectorOnMainThread:@selector(dohideLoadingView) withObject:nil waitUntilDone:NO];
}

- (void)doshowLoadingView
{
    _hud=[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    _hud.mode=MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Loading...";
}

- (void)dohideLoadingView
{
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
}



#pragma mark - Push Notification

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *strDeviceToken = [[[[[deviceToken description]stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString:@" " withString: @""]copy];
    [[NSUserDefaults standardUserDefaults] setObject:strDeviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{    
    if([userInfo valueForKey:@"aps"])
    {
        if([[userInfo valueForKey:@"aps"] valueForKey:@"alert"])
        {
            self.tabBarController.selectedIndex = 1;
        }
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}
#pragma mark - UDID Keychain

- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

- (void)finalUDIDSting
{
    NSString *previousUDID;
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    previousUDID = [NSString stringWithFormat:@"%@",[bindings objectForKey:UDIDKey]];
    if ([[previousUDID StringNotNullValidation] isEqualToString:@""])
    {
        NSString* deviceUDID = [[self GetUUID] copy];
        [bindings setObject:deviceUDID forKey:UDIDKey];
        [[NSUserDefaults standardUserDefaults] setValue:deviceUDID forKey:@"DeviceUDID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:previousUDID forKey:@"DeviceUDID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self WSDeviceTokenCall];
}


#pragma mark - Device Token WS Call

-(void)WSDeviceTokenCall
{
    [AppDel doshowHUD];
    
    NSString *str_DeviceToken = [NSString stringWithFormat:@"%@c=user&func=addUdidTokenLite&vUdid=%@&vDeviceToken=%@",WebURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceUDID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str_DeviceToken stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
     {
         if (error)
         {
             UIAlertView *obj_Alert = [[UIAlertView alloc]initWithTitle:App_Name message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Working offline", nil];
             [obj_Alert show];
             [AppDel dohideHUD];
         }
         else
         {
             if(!response)
             {
                 UIAlertView *obj_Alert = [[UIAlertView alloc]initWithTitle:App_Name message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Working offline", nil];
                 [obj_Alert show];
                  [AppDel dohideHUD];
                  return;
             }
             NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
             NSString *strMsg = [dicResult valueForKey:@"SUCCESS"];
             if ([strMsg isEqualToString:@"1"])
             {
                 [self dohideHUD];
                 
                 NSString *strNotiOnOff = [NSString stringWithFormat:@"%@",[dicResult valueForKey:@"NOTIFICATION"]];
                 
                 [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"DeviceTokenSend"];
                 [[NSUserDefaults standardUserDefaults] setObject:strNotiOnOff forKey:@"NotificationOnOff"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
         }
     }];
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
//com.dnpslite.com
@end
