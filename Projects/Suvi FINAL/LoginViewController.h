//
//  LoginViewController.h
//  Suvi
//
//  Created by apple on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "IIViewDeckController.h"
#import "ViewControl1.h"
#import "HomeViewController.h"
#import "LeftViewController.h"
#import "Global.h"
#import "FBConnect.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,NSURLConnectionDelegate,UIAlertViewDelegate,UIScrollViewDelegate,FBSessionDelegate,FBDialogDelegate,FBRequestDelegate>
{
    IBOutlet UIView *viewloginbox;
    IBOutlet UITextField *logintextField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIView *viewAllBtn;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UILabel *lblSignIN;
    IBOutlet UIButton *btnLogin;
    Facebook *_facebook;
    UITextField *tfForgotPass;
    
    BOOL isSignUpClicked;
    NSURLConnection *connection;
    NSMutableData *webData;
    NSString *action;
}

-(IBAction)LoginCliked:(id)sender;
-(IBAction)btnForgetPasswordClicked:(id)sender;

@property (retain, nonatomic) UIViewController *centerController;
@property (retain, nonatomic) UIViewController *leftController;
@property (retain, nonatomic) UIViewController *HomeController;

-(BOOL)validEmail:(NSString*) emailString;
-(void)_stopReceiveWithStatus:(NSString *)statusString;
-(void)_receiveDidStopWithStatus:(NSString *)statusString;
-(void)setData:(NSDictionary*)dictionary;
-(void)login;
@property (nonatomic, strong) Facebook *facebook;
@end
