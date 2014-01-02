//
//  EditTaskViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Imac 2 on 2/28/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface EditTaskViewCtr : UIViewController <UIScrollViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIScrollView *scl_bg,*scl_list;
    IBOutlet UITextField *tfTaskDescr;
    IBOutlet UILabel *lblPriority,*lblDueDate,*lblResponsible,*lblReminder;
    IBOutlet UIImageView *imgPriority,*imgDueDate,*imgResponsible,*imgReminder;
    IBOutlet UILabel *lblDueDateValue,*lblResponsibleValue;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnPriority,*btnReminder,*btndueDate,*btnResponsible,*btnReminderArrow;
    NSMutableArray *ArryManageList;
    
    //DatePicker
    
    IBOutlet UIDatePicker *DatepickerView;
    IBOutlet UIToolbar *DatetoolBar;
    IBOutlet UIBarButtonItem *Btncancel;
    IBOutlet UIBarButtonItem *BtnDone;
    IBOutlet UIBarButtonItem *BtnDeleteDueDate;
    //Values For New task
    int Priorityid,Listid;
    int reminderId;
    NSMutableDictionary *dicResponsible,*dicReminder;
    
    NSString *strResponsibleID,*strSenderId,*strRecieveId,*strtaskCategoryType,*strAssignedTo;
    NSString *StrDueDate;
    NSMutableDictionary *DicTask;
    
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
    BOOL RemoveNewTaskReminder,RemoveOldTaskReminder;
    IBOutlet UIView *ViewDPBg;
}
@property (nonatomic,strong)NSMutableDictionary *DicTask;
@end