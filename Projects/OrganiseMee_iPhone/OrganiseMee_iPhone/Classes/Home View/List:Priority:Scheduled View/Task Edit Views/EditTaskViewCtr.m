//
//  EditTaskViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Imac 2 on 2/28/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "EditTaskViewCtr.h"
#import "DatabaseAccess.h"
#import "EditReminderViewCtr.h"
#import "EditResponsibleViewCtr.h"
#import "AppDelegate.h"
#import "GlobalMethods.h"

//KeyBoard Animation
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
CGFloat animatedDistance;

@interface EditTaskViewCtr ()

@end

@implementation EditTaskViewCtr
@synthesize DicTask;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([GlobalMethods CheckPhoneVersionisiOS7])
    {
        scl_bg.frame = CGRectMake(scl_bg.frame.origin.x, scl_bg.frame.origin.y + 20, scl_bg.frame.size.width, scl_bg.frame.size.height  - 20);
    }
    // Lang Data Get n Display
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"addVC"];
        lblPriority.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblpriority"]];
        lblDueDate.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"dueDate"]];
        lblResponsible.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"responsible"]];
        lblReminder.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"reminder"]];
        lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblchangetasktitle"]];
        Btncancel.title = [NSString stringWithFormat:@"%@",@"Cancel"];
        BtnDone.title = [NSString stringWithFormat:@"%@",@"Ok"];
        BtnDeleteDueDate.title = [NSString stringWithFormat:@"%@",@"Termin löschen"];
    }
    //Fill Values
    tfTaskDescr.text = [NSString stringWithFormat:@"%@",[DicTask valueForKey:@"description"]];
    //Date Picker
    DatepickerView.minimumDate = [NSDate date];
    DatetoolBar.alpha = 0.0;
    DatepickerView.alpha = 0.0;
    ViewDPBg.alpha = 0.0;
    //-------
    //Set Priority
    Priorityid = [[DicTask valueForKey:@"priority"] intValue];
    [self SetPriority];
    //--------------------
    
    //Set Due Date
    if ([[DicTask valueForKey:@"dueDate"] isEqualToString:@"0000-00-00"])
    {
        lblDueDateValue.text = @"None";
    }
    else
    {
        lblDueDateValue.text = [NSString stringWithFormat:@"%@",[GlobalMethods GetStringDateWithFormate:[DicTask valueForKey:@"dueDate"]]];
        StrDueDate = [NSString stringWithFormat:@"%@",[DicTask valueForKey:@"dueDate"]];
    }
    //--------------------
    // Set Assigned Values
    NSDictionary *dicAssign = [GlobalMethods GetContactName:[DicTask valueForKey:@"assignedId"] TaskCategoryType:[DicTask valueForKey:@"taskCategoryType"]];
    lblResponsibleValue.text = [NSString stringWithFormat:@"%@",[dicAssign valueForKey:@"Responsible"]];
    lblResponsibleValue.textColor = [dicAssign valueForKey:@"Color"];
    btnResponsible.userInteractionEnabled = [[dicAssign valueForKey:@"BtnUserInt"] boolValue];
    tfTaskDescr.userInteractionEnabled = [[dicAssign valueForKey:@"BtnUserInt"] boolValue];
  //  btnPriority.userInteractionEnabled = [[dicAssign valueForKey:@"BtnUserInt"] boolValue];
   /* [self lblName:lblPriority];
    [self lblName:lblDueDate];
    [self lblName:lblResponsible];
    [self lblName:lblReminder];*/
    
    // Get List from Local DB
    NSString *strQuerySelect = @"SELECT * FROM tbl_lists where listCategory=1 and liststatus!=3";
    ArryManageList = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_lists:strQuerySelect]];
    
    int YAxis = 7;
    for (int i = 0; i < [ArryManageList count]; i++)
    {
        UIButton *btnListName = [UIButton buttonWithType:UIButtonTypeCustom];
        btnListName.frame = CGRectMake(10, YAxis, 260, 21);
        btnListName.tag = i + 101;
        [btnListName setTitle:[NSString stringWithFormat:@"%@",[[ArryManageList objectAtIndex:i]valueForKey:@"listName"]] forState:UIControlStateNormal];
        if ([[[ArryManageList objectAtIndex:i]valueForKey:@"listId"] intValue] == [[DicTask valueForKey:@"listId"] intValue])
        {
            [btnListName setTitleColor:[UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            Listid = [[[ArryManageList objectAtIndex:i]valueForKey:@"listId"] intValue];
        }
        else
        {
            [btnListName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }

        btnListName.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:16.0f];
        btnListName.titleLabel.textAlignment = NSTextAlignmentLeft;
        btnListName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btnListName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [btnListName addTarget:self action:@selector(btnListNameSelectPressed:) forControlEvents:UIControlEventTouchUpInside];
        [scl_list addSubview:btnListName];
        YAxis = YAxis + 25;
    }
    YAxis = YAxis + 2;
    scl_list.contentSize = CGSizeMake(280, YAxis);
    scl_list.frame = CGRectMake(20, 92, 280, scl_list.contentSize.height);
    YAxis = 96 + scl_list.contentSize.height;
    [self SetFrameAccordingToList:lblPriority Yaxis:YAxis];
    [self SetFrameAccordingToListImage:imgPriority Yaxis:YAxis];
    btnPriority.frame = CGRectMake(253, YAxis + 5, 30, 30);
    YAxis = YAxis + 44;
    [self SetFrameAccordingToList:lblDueDate Yaxis:YAxis];
    [self SetFrameAccordingToListImage:imgDueDate Yaxis:YAxis];
    lblDueDateValue.frame = CGRectMake(155, YAxis, 140, 40);
    btndueDate.frame = CGRectMake(20, YAxis, 280, 40);
    YAxis = YAxis + 44;
    [self SetFrameAccordingToList:lblResponsible Yaxis:YAxis];
    [self SetFrameAccordingToListImage:imgResponsible Yaxis:YAxis];
    lblResponsibleValue.frame = CGRectMake(128, YAxis, 167, 40);
    btnResponsible.frame = CGRectMake(20, YAxis, 280, 40);
    YAxis = YAxis + 44;
    [self SetFrameAccordingToList:lblReminder Yaxis:YAxis];
    [self SetFrameAccordingToListImage:imgReminder Yaxis:YAxis];
    btnReminder.frame = CGRectMake(31, YAxis + 10, 20, 20);
    btnReminderArrow.frame = CGRectMake(260, YAxis + 5, 29, 31);
    YAxis = YAxis + 44;
    scl_bg.contentSize = CGSizeMake(320, YAxis);
    
    strResponsibleID = [DicTask valueForKey:@"assignedId"];
    strSenderId = [DicTask valueForKey:@"senderId"];
    strRecieveId = [DicTask valueForKey:@"receiverId"];
    strtaskCategoryType = [DicTask valueForKey:@"taskCategoryType"];
    
    if ([[DicTask valueForKey:@"reminderId"] intValue] == 0)
    {
        [btnReminder setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        [btnReminder setSelected:NO];
        btnReminder.userInteractionEnabled = NO;
    }
    else
    {
        [btnReminder setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        [btnReminder setSelected:YES];
    }
    
    reminderId = [[DicTask valueForKey:@"reminderId"] intValue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetResponsibleForEdit:) name:@"GetResponsibilityDataForEdit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetReminderForEdit:) name:@"GetReminderDataForEdit" object:nil];
    
    [self tfName:tfTaskDescr];
    [self SetInsetToTextField:tfTaskDescr];

}
// Get NotificationCenter Dictionary
-(void)GetResponsibleForEdit:(NSNotification*)notiinfo
{
    //Get Dic
    dicResponsible = [[NSMutableDictionary alloc] initWithDictionary:notiinfo.object];
    
    if ([[dicResponsible valueForKey:@"Name"] isEqualToString:@"Assigned to you"])
        lblResponsibleValue.text = @"You";
    else
        lblResponsibleValue.text = [NSString stringWithFormat:@"%@",[dicResponsible valueForKey:@"Name"]];
    
    if ([[dicResponsible valueForKey:@"From"] isEqualToString:@"Org"])
         lblResponsibleValue.textColor = [UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0];
    else
        lblResponsibleValue.textColor = [UIColor darkGrayColor];

    strResponsibleID = [dicResponsible valueForKey:@"id"];
    strSenderId = [dicResponsible valueForKey:@"SenderId"];
    strRecieveId = [dicResponsible valueForKey:@"RecieveId"];
    strtaskCategoryType = [dicResponsible valueForKey:@"CategoryType"];
    strAssignedTo = [dicResponsible valueForKey:@"assignto"];
}
-(void)GetReminderForEdit:(NSNotification*)notiinfo
{
    btnReminder.userInteractionEnabled = YES;
    //Get Dic
    dicReminder = [[NSMutableDictionary alloc] initWithDictionary:notiinfo.object];
    [btnReminder setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [btnReminder setSelected:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
}
-(void)SetFrameAccordingToList:(UILabel*)lblName Yaxis:(int)yValue
{
    lblName.frame = CGRectMake(20, yValue, 280, 40);
}
-(void)SetFrameAccordingToListImage:(UIImageView*)imgName Yaxis:(int)yValue
{
    imgName.frame = CGRectMake(20, yValue, 280, imgName.frame.size.height);
}

#pragma mark - Set label Border
-(void)tfName:(UITextField*)tf
{
    [tf.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [tf.layer setBorderWidth: 1.0];
    [tf.layer setMasksToBounds:YES];
}
-(void)SetInsetToTextField:(UITextField*)tf
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    tf.leftView = paddingView;
    tf.leftViewMode = UITextFieldViewModeAlways;
}
#pragma mark - DatePicker Method

-(IBAction)CanclePressedDate:(id)sender
{
	[self HidePickerView];
}
-(IBAction)DonePressedDate:(id)sender
{
	[self HidePickerView];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *strDateFormate = [[NSUserDefaults standardUserDefaults] stringForKey:@"DateSetting"];
    if ([strDateFormate intValue] == 0)
    {
        [df setDateFormat:@"dd.MM.yyyy"];
    }
    else
    {
        [df setDateFormat:@"MM/dd/yyyy"];
    }
    NSString *strDate=[NSString stringWithFormat:@"%@",[df stringFromDate:DatepickerView.date]];
    lblDueDateValue.text=[NSString stringWithFormat:@"%@",strDate];
    
    [df setDateFormat:@"yyyy-MM-dd"];
    StrDueDate = [NSString stringWithFormat:@"%@",[df stringFromDate:DatepickerView.date]];
}
-(IBAction)DeleteExistingDate:(id)sender
{
    lblDueDateValue.text = @"None";
    [self HidePickerView];
}
-(void)HidePickerView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.50f];
    DatetoolBar.alpha = 0.0;
    DatepickerView.alpha = 0.0;
    ViewDPBg.alpha = 0.0;
    [UIView commitAnimations];
}

#pragma mark - IBAction Methods
-(IBAction)btnListNameSelectPressed:(id)sender
{
    for (int i = 0; i < [ArryManageList count]; i++)
    {
        UIButton *btnAll = (UIButton*)[scl_list viewWithTag:i + 101];
        [btnAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    UIButton *btnSelected = (UIButton*)[scl_list viewWithTag:[sender tag]];
    [btnSelected setTitleColor:[UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    Listid = [[[ArryManageList objectAtIndex:[sender tag] - 101]valueForKey:@"listId"] intValue];
}
-(IBAction)btnPriorityPressed:(id)sender
{
    Priorityid ++;
    if (Priorityid == 3)
    {
        Priorityid = 0;
    }
    [self SetPriority];
}
-(void)SetPriority
{
    if (Priorityid == 0)
    {
        [btnPriority setImage:[UIImage imageNamed:@"star_low.png"] forState:UIControlStateNormal];
    }
    else if (Priorityid == 1)
    {
        [btnPriority setImage:[UIImage imageNamed:@"star_med.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnPriority setImage:[UIImage imageNamed:@"star_high.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)btnReminderPressed:(id)sender
{
    if ([btnReminder isSelected])
    {
        [btnReminder setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        [btnReminder setSelected:NO];
        
        if ([[DicTask valueForKey:@"istasknew"] intValue] == 1)
        {
          /*  NSString *strQueryDelete = [NSString stringWithFormat:@"DELETE FROM tbl_reminders where reminderId=%d",reminderId];
            [DatabaseAccess updatetbl:strQueryDelete];
            
            NSString *strQueryDeleteTaskReminder = [NSString stringWithFormat:@"update tbl_tasks Set reminderId=0 Where taskId=%d",[[DicTask valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryDeleteTaskReminder];*/
            RemoveNewTaskReminder = YES;
            [dicReminder removeAllObjects];
            reminderId = 0;
        }
        else
        {
            RemoveOldTaskReminder = YES;
        }
        btnReminder.userInteractionEnabled = NO;
    }
    else
    {
        RemoveNewTaskReminder = NO;
        RemoveOldTaskReminder = NO;
        [btnReminder setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        [btnReminder setSelected:YES];
    }
}
-(IBAction)btnDueDatePressed:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.50f];
    DatetoolBar.alpha = 1.0;
    DatepickerView.alpha = 1.0;
    ViewDPBg.alpha = 1.0;
    [UIView commitAnimations];
}
-(IBAction)btnResponsiblePressed:(id)sender
{
    // Get Own Contact From Local DB
    NSString *strQuerySelectOwn = @"SELECT * FROM tbl_own_contact";
    NSMutableArray *ArryOwnContact = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_own_contact:strQuerySelectOwn]];
    
    // Get Org Contact From Local DB
    NSString *strQuerySelectOrg = @"SELECT * FROM tbl_org_contact";
    NSMutableArray *ArryOrgContact = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_org_contact:strQuerySelectOrg]];
    
    if ([ArryOrgContact count] == 0 && [ArryOwnContact count] == 0)
    {
        DisplayAlertWithTitle(App_Name, @"Please Wait... Contacts are loading or No contacts are available...");
    }
    else
    {
        EditResponsibleViewCtr *obj_EditResponsibleViewCtr = [[EditResponsibleViewCtr alloc]initWithNibName:@"EditResponsibleViewCtr" bundle:nil];
        obj_EditResponsibleViewCtr.strAssignID = [NSString stringWithFormat:@"%@",[DicTask valueForKey:@"assignedId"]];
        [self.navigationController pushViewController:obj_EditResponsibleViewCtr animated:YES];
    }
}
-(IBAction)btnReminderSetinDetailPressed:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *strDateFormate = [[NSUserDefaults standardUserDefaults] stringForKey:@"DateSetting"];
    if ([strDateFormate intValue] == 0)
    {
        [df setDateFormat:@"dd.MM.yyyy"];
    }
    else
    {
        [df setDateFormat:@"MM/dd/yyyy"];
    }
    
    NSDate *Duedate = [df dateFromString:lblDueDateValue.text];
    
    
    NSString *strQuerySelect = @"SELECT * FROM tbl_standerd_reminder";
    NSMutableArray *ArryStan_Reminder = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_standerd_reminder:strQuerySelect]];
    if ([lblDueDateValue.text isEqualToString:@"None"])
    {
        if ([UserLanguage isEqualToString:@"de"]) {
            DisplayAlertWithTitle(App_Name, @"Please select due date");
        }else{
             DisplayAlertWithTitle(App_Name, @"Bitte wählen Sie zuerst ein Fertigstellungstermin aus.");
        }
        return;
    }
    else if ([ArryStan_Reminder count] == 0)
    {
        DisplayAlertWithTitle(App_Name, @"Please Wait... Standard reminder is loading...");
        return;
    }
    else if ([Duedate compare:[NSDate date]] == NSOrderedAscending)
    {
        if ([UserLanguage isEqualToString:@"de"]) {
            
            DisplayAlertWithTitle(App_Name, @"Bitte wählen Sie ein Termin in der Zukunft aus.");
        }else{
            DisplayAlertWithTitle(App_Name, @"Please select future date to set the reminder");
        }
        
        return;
    }
    else
    {
        EditReminderViewCtr *obj_EditReminderViewCtr = [[EditReminderViewCtr alloc] initWithNibName:@"EditReminderViewCtr" bundle:nil];
        obj_EditReminderViewCtr.strReminderID = [NSString stringWithFormat:@"%@",[DicTask valueForKey:@"reminderId"]];
        [self.navigationController pushViewController:obj_EditReminderViewCtr animated:YES];
    }
}
-(IBAction)btnUpdateTaskCreatedPressed:(id)sender
{
    if ([[tfTaskDescr.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        DisplayAlertWithTitle(App_Name, @"Please enter task description");
        return;
    }
    else
    {
        if ([lblDueDateValue.text isEqualToString:@"None"])
        {
            StrDueDate = @"0000-00-00";
        }
        if (RemoveNewTaskReminder)
        {
            [self DeleteLocalNotification];
            NSString *strQueryDeleteReminder = [NSString stringWithFormat:@"DELETE FROM tbl_reminders where reminderId=%d",reminderId];
            [DatabaseAccess updatetbl:strQueryDeleteReminder];
            
            NSString *strQueryUpdateTaskReminder = [NSString stringWithFormat:@"update tbl_tasks Set reminderId=0 Where taskId=%d",[[DicTask valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryUpdateTaskReminder];
        }
        if (RemoveOldTaskReminder)
        {
            [self DeleteLocalNotification];
            NSString *strQueryUpdateReminder = [NSString stringWithFormat:@"update tbl_reminders Set reminderstatus=3 where reminderId=%d",reminderId];
            [DatabaseAccess updatetbl:strQueryUpdateReminder];
            NSString *strQueryUpdateTaskReminder = [NSString stringWithFormat:@"update tbl_tasks Set reminderId=0 Where taskId=%d",[[DicTask valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryUpdateTaskReminder];
        }
        
        if ([dicReminder count] > 0)
        {
            if ([[DicTask valueForKey:@"istasknew"] intValue] == 1 || reminderId == 0)
            {
                NSString *strMaxReminderId = @"SELECT max(reminderId) FROM tbl_reminders";
                reminderId = [DatabaseAccess getMaxid:strMaxReminderId];
                reminderId = reminderId + 1;
                [self setLocalNoti:dicReminder];
                NSString *strQueryInsertReminder = [NSString stringWithFormat:@"insert into tbl_reminders(reminderId,startDay,isEveryDay,beforeDuedateTime1,beforeDuedateTime2,beforeDuedateTime3,onDuedateTime1,onDuedateTime2,onDuedateTime3,beforeDueDateChannelId,onDueDateChannelId,reminderstatus,isremindernew) values(%d,%d,%d,'%@','%@','%@','%@','%@','%@',%d,%d,%d,%d)",reminderId,[[dicReminder valueForKey:@"startDay"] intValue],[[dicReminder valueForKey:@"isEveryDay"] intValue],[dicReminder valueForKey:@"beforeDueDateTime1"],[dicReminder valueForKey:@"beforeDueDateTime2"],[dicReminder valueForKey:@"beforeDueDateTime3"],[dicReminder valueForKey:@"onDueDateTime1"],[dicReminder valueForKey:@"onDueDateTime2"],[dicReminder valueForKey:@"onDueDateTime3"],[[dicReminder valueForKey:@"beforeDueDateChannelId"] intValue],[[dicReminder valueForKey:@"onDueDateChannelId"] intValue],1,1];
                [DatabaseAccess updatetbl:strQueryInsertReminder];
                NSString *strQueryUpdateTaskReminder = [NSString stringWithFormat:@"update tbl_tasks Set reminderId=%d Where taskId=%d",reminderId,[[DicTask valueForKey:@"taskId"] intValue]];
                [DatabaseAccess updatetbl:strQueryUpdateTaskReminder];
            }
            else
            {
                [self DeleteLocalNotification];
                [self setLocalNoti:dicReminder];
                
                NSString *strQueryUpdateReminder = [NSString stringWithFormat:@"update tbl_reminders Set startDay=%d,isEveryDay=%d,beforeDuedateTime1='%@',beforeDuedateTime2='%@',beforeDuedateTime3='%@',onDuedateTime1='%@',onDuedateTime2='%@',onDuedateTime3='%@',beforeDueDateChannelId=%d,onDueDateChannelId=%d,reminderstatus=2 Where reminderId=%d",[[dicReminder valueForKey:@"startDay"] intValue],[[dicReminder valueForKey:@"isEveryDay"] intValue],[dicReminder valueForKey:@"beforeDueDateTime1"],[dicReminder valueForKey:@"beforeDueDateTime2"],[dicReminder valueForKey:@"beforeDueDateTime3"],[dicReminder valueForKey:@"onDueDateTime1"],[dicReminder valueForKey:@"onDueDateTime2"],[dicReminder valueForKey:@"onDueDateTime3"],[[dicReminder valueForKey:@"beforeDueDateChannelId"] intValue],[[dicReminder valueForKey:@"onDueDateChannelId"] intValue],reminderId];
                    [DatabaseAccess updatetbl:strQueryUpdateReminder];
            }
        }
        
        NSString *strQueryUpdateTask = [NSString stringWithFormat:@"update tbl_tasks Set listId=%d,description='%@',priority=%d,dueDate='%@',senderId=%d,receiverId=%d,taskCategoryType='%@',assignedId=%d,taskassignedto=%d,taskstatus=2 Where taskId=%d",Listid,tfTaskDescr.text,Priorityid,StrDueDate,[strSenderId intValue],[strRecieveId intValue],strtaskCategoryType,[strResponsibleID intValue],[strAssignedTo intValue],[[DicTask valueForKey:@"taskId"] intValue]];
        [DatabaseAccess updatetbl:strQueryUpdateTask];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Set Local Notification For Reminder
-(void)setLocalNoti:(NSDictionary*)DicNoti
{
    int TimeIntBefore,isEvryDay;
    if ([[DicNoti valueForKey:@"startDay"] length] > 0)
    {
        TimeIntBefore = [[DicNoti valueForKey:@"startDay"] intValue];
    }
    else
    {
        TimeIntBefore = 0;
    }
    
    isEvryDay = [[DicNoti valueForKey:@"isEveryDay"] intValue];
    
    if ([[DicNoti valueForKey:@"beforeDueDateTime1"] length] > 0)
    {
        if (isEvryDay == 0)
        {
            [self SetLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"beforeDueDateTime1"] addtimeInt:TimeIntBefore];
        }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self SetLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"beforeDueDateTime1"] addtimeInt:i];
            }
        }
    }
    if ([[DicNoti valueForKey:@"beforeDueDateTime2"] length] > 0)
    {
        if (isEvryDay == 0)
        {
            [self SetLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"beforeDueDateTime2"] addtimeInt:TimeIntBefore];
        }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self SetLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"beforeDueDateTime2"] addtimeInt:i];
            }
        }
    }
    if ([[DicNoti valueForKey:@"beforeDueDateTime3"] length] > 0)
    {
        if (isEvryDay == 0)
        {
            [self SetLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"beforeDueDateTime3"] addtimeInt:TimeIntBefore];
        }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self SetLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"beforeDueDateTime3"] addtimeInt:i];
            }
        }
    }
    if ([[DicNoti valueForKey:@"onDueDateTime1"] length] > 0)
    {
       /* if (isEvryDay == 0)
        {*/
            [self SetLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"onDueDateTime1"] addtimeInt:0];
      /*  }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self SetLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"onDueDateTime1"] addtimeInt:i];
            }
        }*/
    }
    if ([[DicNoti valueForKey:@"onDueDateTime2"] length] > 0)
    {
        /*if (isEvryDay == 0)
        {*/
            [self SetLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"onDueDateTime2"] addtimeInt:0];
       /* }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self SetLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"onDueDateTime2"] addtimeInt:i];
            }
        }*/
    }
    if ([[DicNoti valueForKey:@"onDueDateTime3"] length] > 0)
    {
       /* if (isEvryDay == 0)
        {*/
            [self SetLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"onDueDateTime3"] addtimeInt:0];
       /* }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self SetLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"onDueDateTime3"] addtimeInt:i];
            }
        }*/
    }
}
-(void)SetLocalNotificationOfTheReminderTime:(NSString*)strTime addtimeInt:(int)TimeInterval
{
    NSString *strDateTime = [NSString stringWithFormat:@"%@ %@",StrDueDate,strTime];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *FireDate = [df dateFromString:strDateTime];
    
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.timeZone = [NSTimeZone systemTimeZone];
    notif.fireDate = [FireDate dateByAddingTimeInterval:-TimeInterval*86400];
    notif.alertBody = tfTaskDescr.text;
    notif.alertAction = @"View Details";
    notif.applicationIconBadgeNumber = 1;
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.repeatInterval = 0;
    NSString *strReminderID = [NSString stringWithFormat:@"%d-%@-%d",reminderId,strTime,TimeInterval];
    NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:strReminderID,@"ReminderUniquetag",tfTaskDescr.text,@"AlertBody", nil];
    notif.userInfo = userDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
}

#pragma Mark - Delete Local Notification
-(void)DeleteLocalNotification
{
    // Get Reminder From Local Db
    NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_reminders where reminderId=%d",reminderId];
    NSMutableArray *Arry_Reminder = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_standerd_reminder:strQuerySelect]];
    [self DeleteLocalNotiDictionary:[Arry_Reminder objectAtIndex:0]];
}
-(void)DeleteLocalNotiDictionary:(NSDictionary*)DicNoti
{
    int TimeIntBefore,isEvryDay;
    if ([[DicNoti valueForKey:@"startDay"] length] > 0)
    {
        TimeIntBefore = [[DicNoti valueForKey:@"startDay"] intValue];
    }
    else
    {
        TimeIntBefore = 0;
    }
    
    isEvryDay = [[DicNoti valueForKey:@"isEveryDay"] intValue];
    
    if ([[DicNoti valueForKey:@"beforeDuedateTime1"] length] > 0)
    {
        if (isEvryDay == 0)
        {
            [self DeleteLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"beforeDuedateTime1"] addtimeInt:TimeIntBefore];
        }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self DeleteLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"beforeDuedateTime1"] addtimeInt:i];
            }
        }
    }
    if ([[DicNoti valueForKey:@"beforeDuedateTime2"] length] > 0)
    {
        if (isEvryDay == 0)
        {
            [self DeleteLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"beforeDuedateTime2"] addtimeInt:TimeIntBefore];
        }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self DeleteLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"beforeDuedateTime2"] addtimeInt:i];
            }
        }
    }
    if ([[DicNoti valueForKey:@"beforeDuedateTime3"] length] > 0)
    {
        if (isEvryDay == 0)
        {
            [self DeleteLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"beforeDuedateTime3"] addtimeInt:TimeIntBefore];
        }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self DeleteLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"beforeDuedateTime3"] addtimeInt:i];
            }
        }
    }
    if ([[DicNoti valueForKey:@"onDuedateTime1"] length] > 0)
    {
       /* if (isEvryDay == 0)
        {*/
            [self DeleteLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"onDuedateTime1"] addtimeInt:0];
       /* }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self DeleteLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"onDuedateTime1"] addtimeInt:i];
            }
        }*/
    }
    if ([[DicNoti valueForKey:@"onDuedateTime2"] length] > 0)
    {
       /* if (isEvryDay == 0)
        {*/
            [self DeleteLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"onDuedateTime2"] addtimeInt:0];
        /*}
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self DeleteLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"onDuedateTime2"] addtimeInt:i];
            }
        }*/
    }
    if ([[DicNoti valueForKey:@"onDuedateTime3"] length] > 0)
    {
      /*  if (isEvryDay == 0)
        {*/
            [self DeleteLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"onDuedateTime3"] addtimeInt:0];
       /* }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self DeleteLocalNotificationOfTheReminderTime:[DicNoti valueForKey:@"onDuedateTime3"] addtimeInt:i];
            }
        }*/
    }
}
-(void)DeleteLocalNotificationOfTheReminderTime:(NSString*)strTime addtimeInt:(int)TimeInterval
{
    UILocalNotification *aNotif;
    NSString *myIDToCancel = [NSString stringWithFormat:@"%d-%@-%d",reminderId,strTime,TimeInterval];
    UILocalNotification *notificationToCancel=nil;
    for(aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if([[aNotif.userInfo objectForKey:@"ReminderUniquetag"] isEqualToString:myIDToCancel])
        {
            notificationToCancel=aNotif;
            break;
        }
    }
    if (notificationToCancel != nil)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
    }
}
#pragma mark - UIInterfaceOrientation For iOS < 6

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}
#pragma mark - UIInterfaceOrientation For iOS 6

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
-(BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - Set Landscape Frame



#pragma mark - Set label Border
-(void)lblName:(UILabel*)lbl
{
    [lbl.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lbl.layer setBorderWidth: 1.0];
    [lbl.layer setMasksToBounds:YES];
}

#pragma mark - UITextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField.layer setBorderColor: [[UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0] CGColor]];
    [textField.layer setBorderWidth: 1.0];
    [textField.layer setMasksToBounds:YES];
    // Below code is used for scroll up View with navigation baar
    CGRect textVWRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textVWRect.origin.y + 0.5 * textVWRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self tfName:textField];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
#pragma mark - Remove Null
-(NSString *)removeNull:(NSString *)str
{
    if (!str || [str isEqualToString:@"<null>"] || [str isEqualToString:@"(null)"])
    {
        return @"";
    }
    else
    {
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
