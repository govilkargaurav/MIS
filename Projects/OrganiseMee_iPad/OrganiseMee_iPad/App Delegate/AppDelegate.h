//
//  AppDelegate.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/15/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "IIViewDeckController.h"

#define AppDel ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@protocol CallWSFromFGDelegate <NSObject>

-(void)CallWsFromFGTask;

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
//@property (assign, nonatomic) BOOL masterIsVisible;
@property (strong,nonatomic)IIViewDeckController *deckController;
@property(nonatomic,strong)NSString *strTaskId;

@property (nonatomic,strong) id <CallWSFromFGDelegate> _delegate;



- (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;
- (void)dismissGlobalHUD;
- (BOOL) checkConnection;

@end
