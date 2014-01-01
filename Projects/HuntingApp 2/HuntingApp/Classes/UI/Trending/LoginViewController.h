//
//  LoginViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,RequestWrapperDelegate,UIAlertViewDelegate>
{
    WebServices *webServices;
    WebServices *forgotRequest;
    NSMutableDictionary *userInfo;
    DejalActivityView *loadingActivityIndicator;
    UIView *titleView;
    NSNumber *loggedWithAccountType;
}

@property (retain, nonatomic) IBOutlet UITextField *txtEmail;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property(nonatomic,assign) FirstViewController *controller;

- (IBAction)logIn:(id)sender;
- (IBAction)resignResponders:(id)sender;
- (IBAction)signInWithFB:(id)sender;
- (IBAction)signInWithTwitter:(id)sender;
- (IBAction)forgotMyPassword:(id)sender;
@end
