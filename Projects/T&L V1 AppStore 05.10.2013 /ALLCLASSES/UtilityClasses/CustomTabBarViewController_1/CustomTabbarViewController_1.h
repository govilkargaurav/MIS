//
//  CustomTabbarViewController_1.h
//  T&L
//
//  Created by OpenXcell-Macmini3 on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReourceListViewController.h"
#import "LearningViewController.h"
#import "NewParticipentController.h"
#import "NParticipantViewController.h"
#import "ParticipantsQueViewController.h"
#import "QuestionAssessorViewController.h"
#import "TLISCViewController.h"
#import "AppDelegate.h"
#import "NAssessmentViewController.h"
#import "GlobleClass.h"

@interface CustomTabbarViewController_1 : UIViewController <UITabBarControllerDelegate>
{
    UITabBarController *MainTabBar;
    UINavigationController *nav_1;
	UINavigationController *nav_2;
	UINavigationController *nav_3;
	UINavigationController *nav_4;
    UINavigationController *nav_5;
    
    ReourceListViewController *nextResourceListViewController;
    LearningViewController *nextLearningViewController;
    NParticipantViewController *nextNParticipantViewController;
    TLISCViewController *nextViewController;
    ParticipantsQueViewController *nextParticipantsQueViewController;
    QuestionAssessorViewController *nextQuestionAssessorViewController;
    NAssessmentViewController *nextAssessmentViewController;
    
    AppDelegate *appDel;
    
    UIImageView *imageView1,*imageView2,*imageView3,*imageView4;
    UIImageView *iv_1,*iv_2,*iv_3,*iv_4;
}
-(void)btnSetTabBar_11;
-(void)btnSetTabBar_12;
-(void)btnSetTabBar_13;
-(void)btnSetTabBar_14;

-(void)btnSetTabBar_21;
-(void)btnSetTabBar_22;
-(void)btnSetTabBar_23;

-(void)popToBackButton;
// popToViewController When Click on HOME in TABBAR
-(void)popToViewController;
-(void)popToViewController_SecondTabbar;
-(void)popToViewController_ShowAssessment;
@end
