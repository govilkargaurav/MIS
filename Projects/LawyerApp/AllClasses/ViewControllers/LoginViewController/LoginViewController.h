//
//  LoginViewController.h
//  LawyerApp
//
//  Created by Openxcell Game on 6/6/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController{
    BOOL ISREMEBER;
}
@property (nonatomic,strong)DejalActivityView *loadingActivityIndicator;
@property (nonatomic,strong)AppDelegate *appdelegate;
@property (nonatomic,strong)IBOutlet UITextField *txtFldUserName;
@property (nonatomic,strong)IBOutlet UITextField *txtFldPassword;
@property (nonatomic,strong)IBOutlet UIButton *btnLogin;
@property (nonatomic,strong)IBOutlet UIButton *btnSignUp;
@property (nonatomic,strong)UITextField *globalTextField;
@property (nonatomic,strong)NSOperationQueue *queue;
@property (nonatomic,strong)NSMutableArray *ArrLawyerInfo;
@property (nonatomic,strong)IBOutlet UIButton *btnRememberMe;
-(IBAction)rememberMe:(id)sender;
@end
