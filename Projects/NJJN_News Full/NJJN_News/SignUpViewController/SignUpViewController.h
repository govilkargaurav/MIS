//
//  SignUpViewController.h
//  NewsStand
//
//  Created by openxcell technolabs on 5/3/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"

@class LoginAppDelegate;
@interface SignUpViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIImageView *imgBg;
    IBOutlet UIImageView *imgHeader;
    IBOutlet UIButton *btnSignUp;
    IBOutlet UIButton *btnCancel;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtLastName;
    
    int flagOrientation;

    IBOutlet UIScrollView* scrlObj;
}

-(IBAction)ClickBtnSignUp:(id)sender;
-(IBAction)ClickBtnCancel:(id)sender;

@end
