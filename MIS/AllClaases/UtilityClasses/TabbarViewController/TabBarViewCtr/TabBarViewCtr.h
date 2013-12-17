//
//  TabBarViewCtr.h
//  MyMites
//
//  Created by openxcell technolabs on 7/10/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "Home.h"
#import "HowItWorks.h"
#import "MoreView.h"
#import "FsenetAppDelegate.h"

@interface TabBarViewCtr : UIViewController <UITabBarControllerDelegate>
{
    UITabBarController *MainTabBar;
	UINavigationController *nav_1;
	UINavigationController *nav_2;
	UINavigationController *nav_3;
	UINavigationController *nav_4;
    
    RootViewController *nextFirst;
    Home *nextSecond;
    HowItWorks *nextThird;
    MoreView *nextFourth;
    
    FsenetAppDelegate *appdel;
    
    UIImageView *imageView1,*imageView2,*imageView3,*imageView4;
}

@property (nonatomic,strong)UITabBarController *MainTabBar;
-(void)btnFirstTab;
-(void)CallPopView;
@end
