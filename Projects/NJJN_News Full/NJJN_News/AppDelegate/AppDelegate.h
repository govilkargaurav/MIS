//
//  AppDelegate.h
//  NJJN_News
//
//  Created by Mac-i7 on 6/18/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UserInfoViewController.h"
#import "SignInViewController.h"
#import "SubscribeViewController.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>
#import "PDKeychainBindings.h"
#import "SubclassInAppHelper.h"
#import "AppConstat.h"
#import <SystemConfiguration/SystemConfiguration.h>

#define AppDel ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,UIPopoverControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) int popOverFlag;

@property (nonatomic, strong) UIPopoverController* popOverUserObj;
@property (nonatomic, strong) UIPopoverController* popOverSignInObj;
@property (nonatomic, strong) UIPopoverController* popOverSubscriptionObj;

@property (nonatomic, strong) NSMutableArray *arrPdf,*downloadingArray;

@property (nonatomic, strong) NSDictionary* firstDictReceipt;

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UIImageView *imageView4;
@property (nonatomic, strong) UIImageView *imageView5;
@property (nonatomic, strong) UIImageView *imageView6;
@property (strong ,nonatomic) NSString *dataBasePath;
@property (nonatomic, strong) MBProgressHUD* hud;
@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, assign) int isIndvidualPurchase;
@property (nonatomic, strong) NSArray *arPackageList,*_products;
@property (nonatomic)BOOL YesNo,usedPromoCode;
@property (nonatomic, strong) NSString* strPurchaseOperation;
@property (nonatomic, strong) NSNumberFormatter*  _priceFormatter;
@property (nonatomic, strong) NSString* strPackegIdToSubscribe,*strPromoCodeTrueFalse;
@property (nonatomic, assign) int isAlertFromIAP;

//MBProgressHUD Indicator
- (void)doshowHUD;
- (void)dohideHUD;
-(void)UpdateNewsStandCover;

-(void)TabBarCustomizationImages;


// Popover Class
-(IBAction)OpenUserPopOverController:(id)sender;
-(IBAction)OpenSignInPopOverController:(id)sender;
-(IBAction)OpenSubscriptionPopOverController:(id)sender;

-(IBAction)ChangeSignInFrameInOrientation:(id)sender;
-(IBAction)ChangeSubscriptionFrameInOrientation:(id)sender;
- (BOOL) checkConnection;
@end
