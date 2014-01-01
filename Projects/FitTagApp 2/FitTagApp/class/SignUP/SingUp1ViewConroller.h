//
//  SingUp1ViewConroller.h
//  FitTagApp
//
//  Created by apple on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
@interface SingUp1ViewConroller : UIViewController{

    IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmPassword;
    IBOutlet UITextField *txtEmail;
    AppDelegate *_appdelegate;
}

-(IBAction)btnSignupDonePressed:(id)sender;
- (IBAction)btnFBSignUpPressed:(id)sender;
- (IBAction)btnTwitterSignUpPressed:(id)sender;
-(BOOL) validateEmail: (NSString *) Email;
-(BOOL)validation;
@end
