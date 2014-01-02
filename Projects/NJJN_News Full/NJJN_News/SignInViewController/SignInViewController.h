//
//  SignInViewController.h
//  NewsStand
//
//  Created by openxcell technolabs on 5/2/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"
#import "AppDelegate.h"
#import "SignUpViewController.h"
#import "NSString+Valid.h"

@interface SignInViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{

    IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtUserPassword;
    
    IBOutlet UITextField *txtAccountNo;
    IBOutlet UITextField *tfZipCode;
    
    IBOutlet UIScrollView* scrlObj;
    
}


@end
