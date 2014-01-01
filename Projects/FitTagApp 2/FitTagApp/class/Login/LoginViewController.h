//
//  LoginViewController.h
//  FitTagApp
//
//  Created by apple on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "ChangeUserNameViewController.h"
@interface LoginViewController : UIViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,UIAlertViewDelegate,changeUserName>
{
    CGFloat animatedDistance;
    AppDelegate *_appdelagate;
    
    NSString *fbUserName;
    UITextField *txtUserName;
}

@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnFBSigninPressed:(id)sender;
- (IBAction)btnTwitterSignInPressed:(id)sender;
-(BOOL)validation;
-(void)saveFacebookData:(NSMutableDictionary *)userDict;
-(void)configurePushNotificationSetting;

@end
