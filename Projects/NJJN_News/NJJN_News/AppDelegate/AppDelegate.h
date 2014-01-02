//
//  AppDelegate.h
//  NJJN_News
//
//  Created by Mac-i7 on 6/18/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>
#import "PDKeychainBindings.h"
#import "AppConstat.h"
#import <SystemConfiguration/SystemConfiguration.h>

#define AppDel ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,UIPopoverControllerDelegate,UIAlertViewDelegate>


@property (nonatomic, strong) NSMutableArray *arrPdf,*downloadingArray;

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

//MBProgressHUD Indicator
- (void)doshowHUD;
- (void)dohideHUD;

-(void)TabBarCustomizationImages;



- (BOOL) checkConnection;
@end
