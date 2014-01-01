//
//  EditResponsibleViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Imac 2 on 2/28/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IIViewDeckController.h"

@interface EditResponsibleViewCtr : UIViewController <UITextViewDelegate,IIViewDeckControllerDelegate>
{
    IBOutlet UILabel *lblOption1,*lblOption2,*lblMessage,*lblTitle;
    IBOutlet UIScrollView *scl_OwnContact,*scl_OrgContact,*scl_bg;
    IBOutlet UITextView *txtMessage;
    IBOutlet UIButton *btnCancel,*btnSave;

    int setTag,YAxis;
    NSMutableArray *ArryOwnContact,*ArryOrgContact,*ArryAssign;
        
    NSString *strResponsible,*strResponsibleID,*strContactFrom,*strSenderId,*strRecieveId,*strtaskCategoryType,*strAssignedTo;
    
    NSString *strAssignID;
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    int YAxis1;
    int YAxis11;
    IBOutlet UIImageView *imgtrans1,*imgtrans2,*imgtrans3;
}
@property(nonatomic,strong)NSString *strAssignID;
@end
