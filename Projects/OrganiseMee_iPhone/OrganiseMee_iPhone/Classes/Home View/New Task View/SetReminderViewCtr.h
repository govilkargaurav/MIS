//
//  SetReminderViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by apple on 2/11/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SBTableAlert.h"

@interface SetReminderViewCtr : UIViewController <UITextFieldDelegate,SBTableAlertDelegate, SBTableAlertDataSource>
{
    IBOutlet UIScrollView *scl_bg;
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblReminderBeforeDuedate,*lblReminderOnDuedate,*lblalldaysbetween,*lblStandardReminder,*lblInduReminder,*lblSendReminder,*lbldaybeforeduedate;
    IBOutlet UIButton *btnAssignCheckUncheck,*btnAllDayCheckUnCheck;
    
    IBOutlet UITextField *tfReminderCountBeforeDay;
    IBOutlet UITextField *tfBeforeHH1,*tfBeforeHH2,*tfBeforeHH3,*tfOnHH1,*tfOnHH2,*tfOnHH3;
    IBOutlet UITextField *tfBeforeMM1,*tfBeforeMM2,*tfBeforeMM3,*tfOnMM1,*tfOnMM2,*tfOnMM3;
    
    NSMutableArray *ArryStan_Reminder,*ArryChannel;

    IBOutlet UILabel *lblContactBeforeDueDate,*lblContactOnDueDate;
    NSString *strBeforChannelID,*strOnChannelID;
    
    NSString *strBeforeAMPM1,*strBeforeAMPM2,*strBeforeAMPM3,*strOnAMPM1,*strOnAMPM2,*strOnAMPM3;
    
    NSString *strAllDaysCheckUncheck;
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
    //Channel PopUp
    int ChannelSelectedTag;
    SBTableAlert *alert;
}
@end
