//
//  AppDelegate.m
//  Suvi
//
//  Created by apple on 9/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MyAppManager.h"
#import "common.h"
#import <NewRelicAgent/NewRelicAgent.h>

@implementation UINavigationController (IOS6_Rotation)
-(BOOL)shouldAutorotate
{
    return NO;
}
@end

@implementation UITabBarController (IOS6_Rotation)
-(BOOL)shouldAutorotate
{
    return YES;
}
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;
@synthesize navigationController =_navigationController;
@synthesize loginViewController=_loginViewController;
@synthesize locationManager;

@synthesize currentLocationLastUpdated;
@synthesize InternetConnectionFlag;
@synthesize fileManager,arrlocations,arrlocationsname;
@synthesize arrMyFeedsGlobal,arrAllFeedsGlobal,strAllFeedsGlobalTotalCount,intAllFeedsGlobal_PageCount,intMyFeedsGlobal_PageCount,strMyFeedsGlobalTotalCount,strPrepopulatedAddress;
@synthesize facebook;

+(AppDelegate *)sharedInstance;
{
    
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[NewRelicAgent startWithApplicationToken:@"AA7eb24fe6ef5b5fb9e5f5b559da271d17c34ea6c8"];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                     UITextAttributeFont: [UIFont fontWithName:@"Helvetica-Light" size:24.0f],
                                UITextAttributeTextColor:[UIColor darkGrayColor]
     }];

    
    strPostSuccessful =@"RefreshView";
    isAddressAdded=NO;
    strPrepopulatedAddress=[[NSMutableString alloc]init];
    
    // Push Notification For count
    [[NSUserDefaults standardUserDefaults]setObject:launchOptions forKey:@"LaunchOption"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    arrlocations=[[NSMutableArray alloc]init];
    arrlocationsname=[[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability  *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability * reachability)
    {
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        InternetConnectionFlag = 1;
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
    };
    [reach startNotifier];
    
    sleep(2);
    
    self.navigationController.navigationBarHidden = YES;
    fileManager=[[NSFileManager alloc]init];
    [self setupLocationManager];
    [self createEditableCopyOfDatabaseIfNeeded];
    [self openDB];
    
    [[MyAppManager sharedManager] createDirectoryInDocumentsFolderWithName:kTempUploaderDirectory];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,480+iPhone5ExHeight)];
    [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bgapp"]]];
    [self.window addSubview:imgView];
    [self.window bringSubviewToFront:imgView];
    [[SDWebImageDownloader sharedDownloader]setExecutionOrder:SDWebImageDownloaderLIFOExecutionOrder];
    self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark - Push Noti
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *strDeviceToken = [[[[[deviceToken description]stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString:@" " withString: @""]copy];
    [[NSUserDefaults standardUserDefaults]setValue:strDeviceToken forKey:@"Device_Token"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self performSelectorInBackground:@selector(updateDeviceToken) withObject:nil];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([userInfo objectForKey:@"total_badges"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNotificationCOUNT" object:userInfo];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNotificationCOUNTMyFeed" object:userInfo];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{

}
-(void)updateDeviceToken
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag!=0)
    {
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]!=nil)
        {
            
            NSString *strURL = [NSString stringWithFormat:@"%@&userID=%@&device=%@",strUpdateToken,[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[[NSUserDefaults standardUserDefaults]valueForKey:@"Device_Token"]];
            NSURL *url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            if (data) {
                /*
                 NSMutableDictionary *dictRes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *strMSG = [NSString stringWithFormat:@"%@",[dictRes valueForKey:@"MESSAGE"]];
                 if ([strMSG isEqualToString:@"SUCCESS"]||[strMSG isEqualToString:@"Already Exists"])
                 {
                 
                 }
                 */
            }
        }
    }
}

#pragma mark - DATABASE METHODS

-(void)createEditableCopyOfDatabaseIfNeeded
{
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success)
    {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SuviV1.1.2.sqlite3"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}
-(NSString *)getDBPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"SuviV1.1.2.sqlite3"];
}
-(void)openDB
{
	if (sqlite3_open([[self getDBPath] UTF8String], &db) != SQLITE_OK )
	{
		sqlite3_close(db);
		NSAssert(0, @"Database Failedto open.");
	}
	else
    {
    }
}
-(void)closeDB
{
	sqlite3_close(db);
}

-(BOOL)getalllocations
{
    [arrlocations removeAllObjects];
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM tbllocation"];
	const char *sqlStatement = [sqlStr UTF8String];
    
    sqlite3_stmt *compiledStatement;
	
    if(sqlite3_prepare_v2(db, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            NSMutableDictionary *tempdict=[NSMutableDictionary dictionary];

            if (sqlite3_column_text(compiledStatement, 0) != nil)
            {
                [tempdict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] forKey:@"locid"];
            }
            
            if (sqlite3_column_text(compiledStatement, 1) != nil)
            {
                [tempdict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] forKey:@"locationid"];
            }
            
            if (sqlite3_column_text(compiledStatement, 2) != nil)
            {
                [tempdict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] forKey:@"locationname"];
            }
            
            if (sqlite3_column_text(compiledStatement, 3) != nil)
            {
                [tempdict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] forKey:@"locationtimestamp"];
            }
            
            [arrlocations addObject:tempdict];
        }
    }
    else
    {
        sqlite3_finalize(compiledStatement);
        return NO;
    }
    
    return YES;
}
-(NSString *)getmaxtimestampoflocations
{
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT MAX(locationtimestamp) FROM tbllocation"];
	const char *sqlStatement = [sqlStr UTF8String];
    
    sqlite3_stmt *compiledStatement;
	
    if(sqlite3_prepare_v2(db, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            if (sqlite3_column_text(compiledStatement, 0) != nil)
            {
                return [NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]];
            }
        }
    }
    else
    {
        sqlite3_finalize(compiledStatement);
    }
    
    return @"0";
}
-(BOOL)addlocationwithlocationid:(NSInteger)locationid locationname:(NSString *)locationname locationtimestamp:(NSString *)locationtimestamp
{
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO tbllocation (locationid,locationname,locationtimestamp) VALUES (%d,?,'%@')",locationid,locationtimestamp];
	const char *sqlStatement = [sqlStr UTF8String];
    
    sqlite3_stmt *compiledStatement;
	
    if(sqlite3_prepare_v2(db, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStatement, 1, [locationname UTF8String], -1, SQLITE_TRANSIENT);
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            
        }
    }
    else
    {
        sqlite3_finalize(compiledStatement);
        return NO;
    }
    
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
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    }
}
#pragma mark - IMAGES
-(void)createImageDirectoryIfNeeded
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSError *error;
	NSString *documentsDir = [paths objectAtIndex:0];
	
	NSString *dataPath = [documentsDir stringByAppendingPathComponent:@"Photos"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
		[[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
{
    return [facebook handleOpenURL:url];
//    return NO;
}
-(void)setupLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}
#pragma mark Location Manager Interactions 
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocationLastUpdated=newLocation;
   
    if (newLocation!=nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",currentLocationLastUpdated.coordinate.latitude] forKey:@"lat"];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",currentLocationLastUpdated.coordinate.longitude] forKey:@"long"];
        
        CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
        if (reverseGeocoder)
        {
            [reverseGeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                if (placemark)
                {
                    NSString *strCityName = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressCityKey];
                    NSString *strStateName = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressStateKey];
                    NSString *strCountryName = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressCountryKey];
                    
                    [strPrepopulatedAddress setString:@""];
                    if ([[strCityName removeNull]length]!=0) {
                        [strPrepopulatedAddress setString:strCityName];
                    }
                    
                    if ([[strStateName removeNull]length]!=0)
                    {
                        if ([[strPrepopulatedAddress removeNull]length]!=0)
                        {
                            [strPrepopulatedAddress appendFormat:@" ,%@",strStateName];
                        }
                    }
                    
                    if ([[strCountryName removeNull]length]!=0)
                    {
                        if ([[strPrepopulatedAddress removeNull]length]!=0)
                        {
                            [strPrepopulatedAddress appendFormat:@" ,%@",strCountryName];
                        }
                    }
                }
            }];
        }
    }

    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    if (newLocation.horizontalAccuracy < 0) return;
    [locationManager stopUpdatingLocation];
}

#pragma mark - AlertView Methods

- (void)showLoadingView {
    [self performSelectorOnMainThread:@selector(doshowLoadingView) withObject:nil waitUntilDone:NO];
}
- (void)hideLoadingView {
    [self performSelectorOnMainThread:@selector(dohideLoadingView) withObject:nil waitUntilDone:NO];
}
- (void)doshowLoadingView{
    hud=[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
}
- (void)dohideLoadingView
{
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
}

-(void)showLoader
{
    hud=[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
}

-(void)showLoaderWithtext:(NSString *)strText
{
    hud =[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = strText;
}
-(void)showLoaderWithtext:(NSString *)strText andDetailText:(NSString *)strDetailText
{
    hud =[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = strText;
    hud.detailsLabelText = strDetailText;
}

-(void)hideLoader
{
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
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
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    strPostSuccessful =@"RefreshView";
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

@end
