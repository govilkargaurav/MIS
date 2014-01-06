//
//  NewAssessorViewController.h
//  T&L
//
//  Created by openxcell tech.. on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
@interface NewAssessorViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UILabel *lblUnitName,*lblUnitInfo,*lblIconName;
        
    IBOutlet UITextField *tflogin_name,*tflogin_pinnumber,*tfass_name,*tfass_jobtitle,*tfass_org,*tfass_empid,*tfass_officeadd,*tfass_city,*tfass_state,*tfass_phonenumber,*tfass_postcode,*tfass_email,*tfass_supervisor,*tfass_pinnumber,*tfass_conpinnumber,*tfass_secque,*tfass_answer;
    
    IBOutlet UISegmentedControl *segSignInUp;
    IBOutlet UIView *viewSignIn;
    IBOutlet UIScrollView *viewSignUp;
    IBOutlet UIImageView *ivSignInUpStrip,*ivIcon,*ivTopBarSelected;
    
    NSString *strPushViewController,*LoginType,*strSelectedView;
    UIPopoverController *popoverController; 
}
@property(nonatomic,strong)NSString *LoginType,*strPushViewController,*strSelectedView;
-(IBAction)continueView:(id)sender;
-(void)viewDissmiss;
-(IBAction)SegmentChanged:(id)sender;
-(IBAction)callPushView;
@end
