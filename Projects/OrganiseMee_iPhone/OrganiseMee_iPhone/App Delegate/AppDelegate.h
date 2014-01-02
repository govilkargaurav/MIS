//
//  AppDelegate.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/10/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <SystemConfiguration/SystemConfiguration.h>

#define AppDel ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@protocol CallWSFromFGDelegate <NSObject>

-(void)CallWsFromFGTask;
-(void)CallSyncFromBGTask;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *dataBasePath;
    NSDictionary *langDict;
    BOOL ColorFlag;
    MBProgressHUD *HUD;
    
    id <CallWSFromFGDelegate> _delegate;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong ,nonatomic) NSString *dataBasePath;
@property (nonatomic,strong) NSDictionary *langDict;
@property (nonatomic,assign) BOOL ColorFlag;
@property (nonatomic,strong) id <CallWSFromFGDelegate> _delegate;

- (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;
- (void)dismissGlobalHUD;
- (BOOL) checkConnection;

@end
