//
//  SetResponsibilityViewCtr.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/26/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IIViewDeckController.h"

@interface SetResponsibilityViewCtr : UIViewController <UITextViewDelegate,IIViewDeckControllerDelegate>
{
    IBOutlet UILabel *lblOption1,*lblOption2,*lblMessage,*lblTitle;
    IBOutlet UIScrollView *scl_OwnContact,*scl_OrgContact,*scl_bg;
    IBOutlet UITextView *txtMessage;
    IBOutlet UIButton *btnCancel,*btnSave;
    int setTag,YAxis;
    NSMutableArray *ArryOwnContact,*ArryOrgContact,*ArryAssign;


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
