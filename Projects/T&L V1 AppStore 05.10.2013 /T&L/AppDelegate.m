//
//  AppDelegate.m
//  T&L
//
//  Created by openxcell tech.. on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobleClass.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize strWhichTabBar,dataBasePath;
NSString *kDataBaseName=@"TLISC";
NSString *kDataBaseExt=@"sqlite";

static AppDelegate *appDel;
+(AppDelegate *)classInstance{
    if(appDel == nil){
        appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    }
    return appDel;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //sleep(3);
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    
    strWhichTabBar = @"FirstTabBar";
    //----------- Copy Database -----------
    NSString *databaseFile=[[NSBundle mainBundle] pathForResource:kDataBaseName ofType:kDataBaseExt];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *dbPath=[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",kDataBaseName,kDataBaseExt]];
	NSFileManager *fm=[NSFileManager defaultManager];
	
	if(![fm fileExistsAtPath:dbPath]){
		[fm copyItemAtPath:databaseFile toPath:dbPath error:nil];
	}
	
    self.dataBasePath=dbPath;
    
    //---------------     File Write    ---------------------------
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSLog(@"%@",documentsDir);
    NSString *filesPath = [documentsDir stringByAppendingPathComponent:@"FILES"];
    NSLog(@"%@",filesPath);
    [[NSUserDefaults standardUserDefaults] setValue:filesPath forKey:@"FILESPATH"];
    fm=[NSFileManager defaultManager];
    if(![fm fileExistsAtPath:filesPath])
    {
        if(![fm createDirectoryAtPath:filesPath withIntermediateDirectories:YES attributes:nil error:NULL])
        {
        }
    }
    
    globle_assessment_task_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"globle_assessment_task_id"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self.navigationController setNavigationBarHidden:TRUE];
    
    ViewController *objViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:objViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)removeNotificationCenter{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"popToViewController" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SetTabBar_12" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SetTabBar_13" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SetTabBar_14" object:nil];
}

-(void)showWithGradient:(NSString *)str views:(UIView*)myView
{
    NSLog(@"%@",str);
    HUD = [[MBProgressHUD alloc] initWithView:myView];
    [myView addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD setLabelText:str];
    [HUD show:TRUE];
}
-(void)hideWithGradient
{
    [HUD hide:TRUE];
    [HUD removeFromSuperview];
}

-(UIImage *)topbarselectedImage:(NSString *)strID
{
    UIImage *returnImage;
    
    if([strID isEqualToString:@"1"])
        returnImage = [UIImage imageNamed:@"resourceSelected.png"];
    else if([strID isEqualToString:@"2"])
        returnImage = [UIImage imageNamed:@"assessmentSelected.png"];
    else if([strID isEqualToString:@"3"])
        returnImage = [UIImage imageNamed:@"learningSelected.png"];
    
    return returnImage;
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
    UIApplication *app = [UIApplication sharedApplication];   
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{ 
        [app endBackgroundTask:bgTask]; 
    }];
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

@end
