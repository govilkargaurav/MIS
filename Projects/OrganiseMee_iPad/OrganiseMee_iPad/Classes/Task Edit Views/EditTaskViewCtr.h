//
//  EditTaskViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Imac 2 on 2/28/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IIViewDeckController.h"
#import "DatePickerViewCtr.h"

@interface EditTaskViewCtr : UIViewController <UIScrollViewDelegate,UITextViewDelegate,IIViewDeckControllerDelegate,UIPopoverControllerDelegate,DatePickerDelegate>
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
    NSMutableDictionary *DicTask;
    
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
    BOOL RemoveNewTaskReminder,RemoveOldTaskReminder;
        
}

@end
