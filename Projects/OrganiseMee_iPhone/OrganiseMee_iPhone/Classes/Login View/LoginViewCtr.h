//
//  LoginViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/10/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoginViewCtr : UIViewController <UIScrollViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIScrollView *scl_bg;
    
    IBOutlet UITextField *tfUsername;
	IBOutlet UITextField *tfPass;
    
    IBOutlet UILabel *lblErrorDesc,*lblLoginHeader;
    IBOutlet UILabel *lblUsername,*lblPassword;
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
    IBOutlet UIView *viewBottom;
}
@end
