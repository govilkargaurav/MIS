//
//  SetResponsibilityViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by apple on 2/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SetResponsibilityViewCtr : UIViewController <UITextViewDelegate>
{
    IBOutlet UILabel *lblOption1,*lblOption2,*lblMessage,*lblTitle;
    IBOutlet UIScrollView *scl_OwnContact,*scl_OrgContact,*scl_bg;
    IBOutlet UITextView *txtMessage;
    int setTag,YAxis;
    NSMutableArray *ArryOwnContact,*ArryOrgContact,*ArryAssign;
    IBOutlet UIToolbar *toolBar;
    
    NSString *strResponsible,*strResponsibleID,*strContactFrom,*strSenderId,*strRecieveId,*strtaskCategoryType,*strAssignedTo;
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
    IBOutlet UIImageView *imgtrans1,*imgtrans2,*imgtrans3;
    
    int YAxis1;
    int YAxis11;
}
@end
