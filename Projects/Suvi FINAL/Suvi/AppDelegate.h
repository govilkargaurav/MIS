//
//  AppDelegate.h
//  Suvi
//
//  Created by apple on 9/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "LoginViewController.h"
#import "sqlite3.h"
#import "FBConnect.h"

@class LoginViewController;
@class WelcomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,FBSessionDelegate>
{
    MBProgressHUD *hud;
    CLLocationManager *locationManager;
    CLLocation *currentLocationLastUpdated;
    int InternetConnectionFlag;
    NSFileManager *fileManager;
    
    sqlite3 *db;
    NSMutableArray *arrlocations;
    NSMutableArray *arrlocationsname;
    NSMutableString *strPrepopulatedAddress;
    BOOL isAddressAdded;
    Facebook *facebook;

}

@property(nonatomic,assign)int InternetConnectionFlag;
-(void)reachabilityChanged:(NSNotification*)note;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *arrlocations;
@property (strong, nonatomic) NSMutableArray *arrlocationsname;
@property (strong, nonatomic) NSMutableString *strPrepopulatedAddress;

@property (strong, nonatomic) WelcomeViewController  *mainViewController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) CLLocation *currentLocationLastUpdated;
@property (nonatomic, strong) Facebook *facebook;

@property(nonatomic,strong)NSMutableArray *arrAllFeedsGlobal;
@property(nonatomic,strong)NSString *strAllFeedsGlobalTotalCount;
@property(nonatomic,readwrite)int intAllFeedsGlobal_PageCount;

@property(nonatomic,strong)NSString *strMyFeedsGlobalTotalCount;
@property(nonatomic,readwrite)int intMyFeedsGlobal_PageCount;
@property(nonatomic,strong)NSMutableArray *arrMyFeedsGlobal;

+(AppDelegate *)sharedInstance;

-(void)showLoadingView;
-(void)hideLoadingView;
-(void)doshowLoadingView;
-(void)dohideLoadingView;
-(void)showLoader;
-(void)showLoaderWithtext:(NSString *)strText;
-(void)showLoaderWithtext:(NSString *)strText andDetailText:(NSString *)strDetailText;
-(void)hideLoader;

-(void)createImageDirectoryIfNeeded;
-(void)setupLocationManager;
@property (strong, nonatomic) CLLocationManager *locationManager;

-(void)createEditableCopyOfDatabaseIfNeeded;
-(BOOL)getalllocations;
-(NSString *)getmaxtimestampoflocations;
-(BOOL)addlocationwithlocationid:(NSInteger)locationid locationname:(NSString *)locationname locationtimestamp:(NSString *)locationtimestamp;
-(NSString *)getDBPath;
-(void)openDB;
-(void)closeDB;

@end

