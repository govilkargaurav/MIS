//
//  RegisterViewCtr.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/16/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RegisterViewCtr : UIViewController <UIScrollViewDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UIScrollView *scl_bg;
    
    IBOutlet UILabel *lblRegister,*lblErrorMsg;
    
    IBOutlet UILabel *lblUsername,*lblFirstname,*lblLastname,*lblEmail,*lblPassword,*lblConfirmPass;
    IBOutlet UILabel *lblTerm1,*lblTerm2,*lblLine;
    
    IBOutlet UITextField *tfUsername,*tfFirstname,*tfLastname,*tfEmail,*tfPassword,*tfConfirmPass;
    
    IBOutlet UIButton *btnAcceptTerm,*btnTerm,*btnRegister;
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
}
@property (strong, nonatomic)UIPopoverController *popoverController;


@end
