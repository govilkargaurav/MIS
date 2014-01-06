//
//  TabbarController.h
//  T&L
//
//  Created by openxcell tech.. on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "QuestionAssessorViewController.h"
#import "ParticipantsQueViewController.h"
#import "KeypadVC.h"
#import "QuestionAssessorViewController.h"



@interface TabbarController : UIViewController<UINavigationControllerDelegate>
@property(nonatomic,strong)QuestionAssessorViewController *questionAsseessorView;
@property(nonatomic,strong)IBOutlet UINavigationController*questionAsseessorNavCnTlr;
@property(nonatomic,strong)KeypadVC *loginVeiw;
@property(nonatomic,strong)IBOutlet UINavigationController *loginViewNavController;
@property(nonatomic,strong)ParticipantsQueViewController *participantsViewController;
@property(nonatomic,strong)QuestionAssessorViewController *QAviewController;
@property(nonatomic,strong)IBOutlet UINavigationController *QAViewNavController;
@property(nonatomic,strong)IBOutlet UINavigationController *participantsNavViewController;
@property (nonatomic,strong)UINavigationController *currentViewController;
+ (TabbarController *) sharedInstance;
- (void) releaseResources;
- (IBAction) hideTabViewController;
-(IBAction) showQAview;
-(IBAction) showParticipatsview;
-(IBAction) showparticipantQueView;
@end
