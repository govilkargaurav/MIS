//
//  TabBarViewCtr.h
//  MyMites
//
//  Created by openxcell technolabs on 7/10/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CreateMeetingViewController.h"
#import "SettingsViewController.h"
@class AppDelegate;

@interface TabBarViewCtr : UIViewController <UITabBarControllerDelegate>
{
    UITabBarController *MainTabBar;
	UINavigationController *nav_1;
	UINavigationController *nav_2;
	UINavigationController *nav_3;
	UINavigationController *nav_4;
    
    ViewController *firstViewCtRl;
    CreateMeetingViewController *createMeetingCtRl;
    SettingsViewController *settingsViewCtRl;
    AppDelegate *appdel;
    
    UIImageView *imageView1,*imageView2,*imageView3,*imageView4;
}

@property (nonatomic,strong)UITabBarController *MainTabBar;
-(void)btnFirstTab;
-(void)CallPopView;
@end
