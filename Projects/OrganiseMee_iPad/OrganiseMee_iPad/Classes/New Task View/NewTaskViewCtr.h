//
//  NewTaskViewCtr.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/26/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IIViewDeckController.h"
#import "DatePickerViewCtr.h"

@interface NewTaskViewCtr : UIViewController <UIScrollViewDelegate,UITextViewDelegate,IIViewDeckControllerDelegate,UIPopoverControllerDelegate,DatePickerDelegate,UITextFieldDelegate>
{
    IBOutlet UIScrollView *scl_bg,*scl_list;
    IBOutlet UITextView *txtTaskDescr;
    IBOutlet UILabel *lblPriority,*lblDueDate,*lblResponsible,*lblReminder;
    IBOutlet UIImageView *imgPriority,*imgDueDate,*imgResponsible,*imgReminder;
    IBOutlet UILabel *lblDueDateValue,*lblResponsibleValue;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnPriority,*btnReminder,*btndueDate,*btnResponsible,*btnReminderArrow;
    IBOutlet UIButton *btnSave,*btnCancel;
    NSMutableArray *ArryManageList;
    
    //Values For New task
    int Priorityid,Listid;
    int reminderId;
    NSMutableDictionary *dicResponsible,*dicReminder;
    
    NSString *strResponsibleID,*strSenderId,*strRecieveId,*strtaskCategoryType,*strAssignedTo;
    NSString *StrDueDate;
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
        
}
-(void)updateui;
@end
