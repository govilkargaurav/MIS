//
//  CustomTabbarViewController_2.h
//  T&L
//
//  Created by OpenXcell-Macmini3 on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ParticipantsQueViewController.h"
#import "QuestionAssessorViewController.h"
@interface CustomTabbarViewController_2 : UIViewController <UITabBarControllerDelegate>
{
    UITabBarController *MainTabBar;
    UINavigationController *nav_1;
	UINavigationController *nav_2;
    UINavigationController *nav_3;
    
    ParticipantsQueViewController *nextParticipantsQueViewController;
    QuestionAssessorViewController *nextQuestionAssessorViewController;

    
    AppDelegate *appDel;
    
    UIImageView *imageView1,*imageView2,*imageView3;
}
@end
