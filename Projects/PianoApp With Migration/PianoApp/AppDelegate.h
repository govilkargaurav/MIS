//
//  AppDelegate.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#define isiPhone5 ([UIScreen mainScreen].bounds.size.height == 568 && [[UIDevice currentDevice] userInterfaceIdiom]== UIUserInterfaceIdiomPhone)

#define AppDel ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *strSelectedType;
    NSString *dataBasePath;
    NSString *strCallYesOrNo;
    NSMutableDictionary *DicCache;
    BOOL isiAdVisible;
    MBProgressHUD* _hud;
    
    NSDictionary *dicEncrtptedFile;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSString *strSelectedType;
@property (strong ,nonatomic) NSString *dataBasePath;
@property (strong ,nonatomic) NSString *strCallYesOrNo;
@property (strong ,nonatomic) NSMutableDictionary *DicCache;
@property (nonatomic,assign) BOOL isiAdVisible;
@property (nonatomic,strong) NSDictionary *dicEncrtptedFile;

- (void)doshowHUD;
- (void)dohideHUD;
@end
