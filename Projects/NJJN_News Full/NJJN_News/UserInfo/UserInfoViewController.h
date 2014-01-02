//
//  UserInfoViewController.h
//  NewsStand
//
//  Created by openxcell technolabs on 4/23/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"


@interface UserInfoViewController : UIViewController<UIAlertViewDelegate,UIPopoverControllerDelegate,UITextFieldDelegate>
{
    IBOutlet UIButton *btnCancel;
    IBOutlet UIButton *btnConnect;
    IBOutlet UIButton *btnSubscribe;
    IBOutlet UIButton *btnPrintedSubscriber;
    IBOutlet UIButton *btnChangePassword;
    
    UIAlertView *alertLogin;
    UITextField *txtUserName; 
    UITextField *txtPassword;
    
    UIAlertView *alertSubscription;
    UIPopoverController *popoverController;
    UINavigationController *obj_nav;
    
    IBOutlet UILabel *lblUntilValid;
    
}

@property (strong, nonatomic) UIPopoverController* popSignIn;
@property (strong, nonatomic) IBOutlet UIButton *btnConnect;
@property (strong, nonatomic) IBOutlet UIButton *btnSubscribe;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;



@end
