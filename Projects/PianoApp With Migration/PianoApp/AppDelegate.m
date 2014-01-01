//
//  AppDelegate.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "MasterViewControlleriPhone5.h"
#import "SubclassInAppHelper.h"
#import "DataExporter.h"
#import <sqlite3.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize strSelectedType;
@synthesize dataBasePath;
@synthesize strCallYesOrNo;
@synthesize DicCache;
@synthesize isiAdVisible;
@synthesize dicEncrtptedFile;

NSString *kDataBaseName=@"PianoDB";
NSString *kDataBaseExt=@"sqlite";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Local DB Path //----------------------------------------------------------------------------
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    NSString *databaseFile=[[NSBundle mainBundle] pathForResource:kDataBaseName ofType:kDataBaseExt];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *dbPath=[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",kDataBaseName,kDataBaseExt]];
	NSFileManager *fm=[NSFileManager defaultManager];
	
	if(![fm fileExistsAtPath:dbPath])
    {
        self.dataBasePath=dbPath;
		[fm copyItemAtPath:databaseFile toPath:dbPath error:nil];
	}
    else
    {
        self.dataBasePath=dbPath;
        if (![self dbFieldCount:@"PRAGMA table_info(tbl_notes)" CheckFiled:@"editable"])
        {
            [self AleteTblNotes:@"ALTER TABLE tbl_notes ADD COLUMN editable VARCHAR DEFAULT 0"];
        }
        
        if (![self dbFieldCount:@"PRAGMA table_info(tbl_cameraroll)" CheckFiled:@"tag"])
        {
            [self AleteTblNotes:@"ALTER TABLE tbl_cameraroll ADD COLUMN tag TEXT"];
        }
        
        if (![self dbFieldCount:@"PRAGMA table_info(tbl_cameraroll)" CheckFiled:@"desc"])
        {
            [self AleteTblNotes:@"ALTER TABLE tbl_cameraroll ADD COLUMN desc TEXT"];
        }
    }
    
    //----------------------------------------------------------------------------
    
    DicCache = [[NSMutableDictionary alloc]init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    if (isiPhone5)
    {
        MasterViewControlleriPhone5 *obj_MasterViewControlleriPhone5 = [[MasterViewControlleriPhone5 alloc] initWithNibName:@"MasterViewControlleriPhone5" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:obj_MasterViewControlleriPhone5];
    }
    else
    {
        MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    }
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)AleteTblNotes:(NSString*)strQuery
{
    sqlite3 *database;
    
    if(sqlite3_open([self.dataBasePath UTF8String],&database) == SQLITE_OK) {
        
        const char *sqlStmt=[strQuery UTF8String];
        sqlite3_stmt *cmp_sqlStmt;
        if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK) {
            int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL);
            ((returnValue==SQLITE_OK) ?  NSLog(@"Success") :  NSLog(@"UnSuccess"));
            sqlite3_step(cmp_sqlStmt);
        }
        sqlite3_finalize(cmp_sqlStmt);
    }
    sqlite3_close(database);
    
}
-(BOOL)dbFieldCount:(NSString*)strQuery CheckFiled:(NSString*)strFieldName
{
    BOOL checkfield = NO;
    sqlite3 *database;
    
    if(sqlite3_open([self.dataBasePath UTF8String],&database) == SQLITE_OK) {
        
        const char *sqlStmt=[strQuery UTF8String];
        sqlite3_stmt *cmp_sqlStmt;
        if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(cmp_sqlStmt)==SQLITE_ROW)
            {
                NSString *str = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(cmp_sqlStmt, 1)];
                if ([str isEqualToString:strFieldName])
                {
                    checkfield = YES;
                    break;
                }
            }
        }
        sqlite3_finalize(cmp_sqlStmt);
    }
    sqlite3_close(database);
    return checkfield;
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
    exit(0);
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

#pragma mark - MBProgressHUD AlertHandler
- (void)doshowHUD
{
	[self performSelectorOnMainThread:@selector(doshowLoadingView) withObject:nil waitUntilDone:NO];
}
- (void)dohideHUD
{
    [self performSelectorOnMainThread:@selector(dohideLoadingView) withObject:nil waitUntilDone:NO];
    
}
- (void)doshowLoadingView
{
    _hud=[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    _hud.mode=MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Loading.....";
}

- (void)dohideLoadingView
{
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
}


#pragma mark Handle URL 
-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if (url != nil && [url isFileURL]) {
        [self handleOpenURL:url];
    }
    return YES;
}
-(void)handleOpenURL:(NSURL *)url
{
    self.dicEncrtptedFile = [[NSDictionary alloc]initWithDictionary:[DataExporter getDictionaryFromURL:url]];
}

//com.paino.distr
//com.pianoInapptest.dev

@end
