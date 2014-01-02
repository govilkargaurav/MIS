//
//  RegisterViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/10/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RegisterViewCtr : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scl_bg;
    
    IBOutlet UILabel *lblRegister,*lblErrorMsg;
    
    IBOutlet UILabel *lblUsername,*lblFirstname,*lblLastname,*lblEmail,*lblPassword,*lblConfirmPass;
    IBOutlet UILabel *lblTerm1,*lblTerm2;
    IBOutlet UILabel *lblLine;
    IBOutlet UITextField *tfUsername,*tfFirstname,*tfLastname,*tfEmail,*tfPassword,*tfConfirmPass;
    
    IBOutlet UIButton *btnAcceptTerm,*btnToseeTermsAndCond;
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
}
@end
