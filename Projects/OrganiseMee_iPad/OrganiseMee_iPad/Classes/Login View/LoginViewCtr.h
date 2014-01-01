//
//  LoginViewCtr.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/16/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
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
}


@end
