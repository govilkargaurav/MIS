//
//  RegistrationViewController.h
//  MyU
//
//  Created by Vijay on 7/5/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALPickerView.h"
#import "OAuthLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"


@class OAuthTwitter,TwitterController,FoursquareController,CustomLoginPopup;
@interface RegistrationViewController : UIViewController<UITextFieldDelegate,ALPickerViewDelegate,oAuthLoginPopupDelegate, TwitterLoginUiFeedback>
{
    IBOutlet UIButton *btnCheckMark;
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtUniversity;
    IBOutlet UITextField *txtEmail;
    IBOutlet UIView *viewsignup;
    BOOL isUserProffesor;
    BOOL isManuallyUniEntry;
    NSMutableDictionary *dictSocial;
    
    ALPickerView *pickerView;
    NSMutableArray *arrUniversityNames;
    NSInteger selecteduni;
    
    OAuthTwitter *oAuthTwitter;
    TwitterController *twitterController;
    CustomLoginPopup *loginPopup;
    
    
}

@property (retain, nonatomic) OAuthTwitter *oAuthTwitter;
-(void)handleOAuthVerifier:(NSString *)oauth_verifier;

@end
