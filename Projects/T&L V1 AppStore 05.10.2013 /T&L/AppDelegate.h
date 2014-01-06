//
//  AppDelegate.h
//  T&L
//
//  Created by openxcell tech.. on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
#import "MBProgressHUD.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSString *strWhichTabBar;
    NSString *dataBasePath;
    UIBackgroundTaskIdentifier bgTask;
}
@property (strong,nonatomic)NSString *strWhichTabBar,*dataBasePath;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

-(void)removeNotificationCenter;
-(void)showWithGradient:(NSString *)str views:(UIView*)views;
-(void)hideWithGradient;
-(UIImage *)topbarselectedImage:(NSString *)strID;
+(AppDelegate *)classInstance;
@end
