//
//  SignUpController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TredingViewController.h"
#import "FirstViewController.h"

@interface SignUpController : UIViewController<RequestWrapperDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UIImage *avatar;
    WebServices *webServices;
    NSMutableDictionary *userInfo;
    DejalActivityView *loadingActivityIndicator;
    BOOL isSigningUp;
    IBOutlet UIImageView *avatarView;
    UIView *titleView;
    NSNumber *loggedWithAccountType;
}

@property (retain, nonatomic) IBOutlet UIButton *imagePicker;

@property (retain, nonatomic) IBOutlet UITextField *txtEmail;
@property (retain, nonatomic) IBOutlet UITextField *txtUsername;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtPhone;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,assign) FirstViewController *controller;

- (IBAction)resignResponders:(id)sender;
- (IBAction)selectAvatar:(id)sender;
- (IBAction)signUpWithFB:(id)sender;
- (IBAction)signUpWithTwitter:(id)sender;
- (IBAction)signUp:(id)sender;

@end
