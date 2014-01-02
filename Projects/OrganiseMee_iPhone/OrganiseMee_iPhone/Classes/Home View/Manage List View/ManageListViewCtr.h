//
//  ManageListViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/18/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ManageListViewCtr : UIViewController <UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UIScrollView *scl_bg;
    IBOutlet UIView *ViewCreate,*ViewList;
    IBOutlet UITextField *tfCreate;
    IBOutlet UIButton *btnCreate;
    IBOutlet UILabel *lblTitle,*lblCreate;
    
    NSMutableArray *ArryManageList;
    
    int YAxis,OrientationFlag;
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    IBOutlet UIImageView *imgtopTrans;
    
}
-(void)updateui;

@end
