//
//  TaskEditViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by apple on 2/15/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TaskEditViewCtr : UIViewController <UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UIView *ViewTop,*ViewReminderBeforebg,*ViewReminderOnbg;
    IBOutlet UILabel *lblDesc,*lblListProjectName,*lblResponsibleName,*lblDueDate,*lblReminderBeforeDate,*lblReminderOnDate;
    IBOutlet UIImageView *imgPriority;
    IBOutlet UIScrollView *scl_bg;
    int Yaxis;
    
    IBOutlet UIButton *btnDelete,*btnArchieve,*btnMessage,*btnCallBack,*btnGiveBack;
    IBOutlet UILabel *lblList_Projectttl,*lblPriorityttl,*lblResponsiblettl,*lblDueDatettl,*lblReminderBeforettl,*lblReminderOnttl;
    
    NSMutableDictionary *DicTask;
    UITextView *txtMesage;
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
    NSString *strTaskId;
    
    IBOutlet UIImageView *imgbgTran1;
}
@property (nonatomic,strong) NSString *strTaskId;
@end
