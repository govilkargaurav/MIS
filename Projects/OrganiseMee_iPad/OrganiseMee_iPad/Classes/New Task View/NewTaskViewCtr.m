//
//  NewTaskViewCtr.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/26/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "NewTaskViewCtr.h"
#import "AppDelegate.h"
#import "DatabaseAccess.h"
#import "SetResponsibilityViewCtr.h"
#import "SetReminderViewCtr.h"

//KeyBoard Animation
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
CGFloat animatedDistance;

@interface NewTaskViewCtr ()

@end

@implementation NewTaskViewCtr

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
    
    // Lang Data Get n Display
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    [self txtName:txtTaskDescr];

    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"addVC"];
        lblPriority.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblpriority"]];
        lblDueDate.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"dueDate"]];
        lblResponsible.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"responsible"]];
        lblReminder.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"reminder"]];
        lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbladdtasktitle"]];
    }
    
    for (UIButton *btn in scl_list.subviews)
    {
        if ([btn isKindOfClass:[UIButton class]])
        {
            [btn removeFromSuperview];
        }
    }
    
    
    Priorityid = 0;
    
    
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
        [btnListName setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btnListName.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:18.0f];
        btnListName.titleLabel.textAlignment = NSTextAlignmentLeft;
        btnListName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btnListName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [btnListName addTarget:self action:@selector(btnListNameSelectPressed:) forControlEvents:UIControlEventTouchUpInside];
        [scl_list addSubview:btnListName];
        YAxis = YAxis + 25;
    }
    YAxis = YAxis + 2;
    scl_list.contentSize = CGSizeMake(280, YAxis);
    scl_list.frame = CGRectMake(20, 164, 280, scl_list.contentSize.height);
    YAxis = 168 + scl_list.contentSize.height;
    [self SetFrameAccordingToList:lblPriority Yaxis:YAxis];
    [self SetFrameAccordingToListImage:imgPriority Yaxis:YAxis];
    btnPriority.frame = CGRectMake(253, YAxis + 5, 30, 30);
    YAxis = YAxis + 44;
    [self SetFrameAccordingToList:lblDueDate Yaxis:YAxis];
    [self SetFrameAccordingToListImage:imgDueDate Yaxis:YAxis];
    lblDueDateValue.frame = CGRectMake(150, YAxis, 140, 40);
    btndueDate.frame = CGRectMake(20, YAxis, 280, 40);
    YAxis = YAxis + 44;
    [self SetFrameAccordingToList:lblResponsible Yaxis:YAxis];
    [self SetFrameAccordingToListImage:imgResponsible Yaxis:YAxis];
    lblResponsibleValue.frame = CGRectMake(150, YAxis, 140, 40);
    btnResponsible.frame = CGRectMake(20, YAxis, 280, 40);
    YAxis = YAxis + 44;
    [self SetFrameAccordingToList:lblReminder Yaxis:YAxis];
    [self SetFrameAccordingToListImage:imgReminder Yaxis:YAxis];
    btnReminder.frame = CGRectMake(31, YAxis + 10, 20, 20);
    btnReminderArrow.frame = CGRectMake(260, YAxis + 5, 29, 31);
    
    YAxis = YAxis + 60;
    btnSave.frame = CGRectMake(btnSave.frame.origin.x, YAxis, btnSave.frame.size.width, btnSave.frame.size.height);
    btnCancel.frame = CGRectMake(btnCancel.frame.origin.x, YAxis, btnCancel.frame.size.width, btnCancel.frame.size.height);
    
    YAxis = YAxis + 44;
    scl_bg.contentSize = CGSizeMake(320, YAxis + 30);
    
    
    strResponsibleID = @"0";
    strSenderId = @"0";
    strRecieveId = @"0";
    strtaskCategoryType = @"GENEREL";
    strAssignedTo = @"0";
    
    btnReminder.userInteractionEnabled = NO;
    
    reminderId = 0;
    Listid = -1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetResponsible:) name:@"GetResponsibilityData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetReminder:) name:@"GetReminderData" object:nil];

        // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
   // AppDel.deckController.panningMode = IIViewDeckNoPanning;
}
-(void)viewDeckControllerDidCloseRightView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated
{
    NSLog(@"Pop New Task View");
    NSArray *vList = [self.navigationController viewControllers];
    UIViewController *view;
    for (int i=[vList count]-1; i>=0; --i)
    {
        view = [vList objectAtIndex:i];
        if ([view.nibName isEqualToString: @"TempRightViewCtr"])
        {
            [self.navigationController popToViewController:view animated:YES];
            break;
        }
    }
}

// Get NotificationCenter Dictionary
-(void)GetResponsible:(NSNotification*)notiinfo
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
-(void)GetReminder:(NSNotification*)notiinfo
{
    btnReminder.userInteractionEnabled = YES;
    //Get Dic
    dicReminder = [[NSMutableDictionary alloc] initWithDictionary:notiinfo.object];
    [btnReminder setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [btnReminder setSelected:YES];
}

-(void)SetFrameAccordingToList:(UILabel*)lblName Yaxis:(int)yValue
{
    lblName.frame = CGRectMake(20, yValue, 280, 40);
}
-(void)SetFrameAccordingToListImage:(UIImageView*)imgName Yaxis:(int)yValue
{
    imgName.frame = CGRectMake(20, yValue, 280, imgName.frame.size.height);
}

#pragma mark - DatePicker Method

-(void)Done:(NSString *)strDate str:(NSString *)StrDueDateSave
{
    
    lblDueDateValue.text=[NSString stringWithFormat:@"%@",strDate];
    
    StrDueDate = [NSString stringWithFormat:@"%@",StrDueDateSave];
}
-(void)DeleteExisteingDate
{
    lblDueDateValue.text = @"None";
}

#pragma mark - IBAction Methods
-(IBAction)btnListNameSelectPressed:(id)sender
{
    for (int i = 0; i < [ArryManageList count]; i++)
    {
        UIButton *btnAll = (UIButton*)[scl_list viewWithTag:i + 101];
        [btnAll setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
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
        
        NSString *strQueryDelete = [NSString stringWithFormat:@"DELETE FROM tbl_reminders where reminderId=%d",reminderId];
        [DatabaseAccess updatetbl:strQueryDelete];
        
        [dicReminder removeAllObjects];
        reminderId = 0;
        
        btnReminder.userInteractionEnabled = NO;
    }
    else
    {
        [btnReminder setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        [btnReminder setSelected:YES];
    }
}
-(IBAction)btnDueDatePressed:(id)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    
    
    DatePickerViewCtr *obj_DatePickerViewCtr = [[DatePickerViewCtr alloc] initWithNibName:@"DatePickerViewCtr" bundle:nil];
    obj_DatePickerViewCtr._delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:obj_DatePickerViewCtr animated:NO];
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
        CATransition* transition = [CATransition animation];
        transition.duration = 0.8;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        
        SetResponsibilityViewCtr *obj_SetResponsibilityViewCtr = [[SetResponsibilityViewCtr alloc]initWithNibName:@"SetResponsibilityViewCtr" bundle:nil];

        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:obj_SetResponsibilityViewCtr animated:NO];
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
    
    // Get Standard Reminder From Local Db
    NSString *strQuerySelect = @"SELECT * FROM tbl_standerd_reminder";
    NSMutableArray *ArryStan_Reminder = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_standerd_reminder:strQuerySelect]];
    if ([lblDueDateValue.text isEqualToString:@"None"])
    {
        DisplayAlertWithTitle(App_Name, @"Please select due date");
    }
    else if ([ArryStan_Reminder count] == 0)
    {
        DisplayAlertWithTitle(App_Name, @"Please Wait... Standard reminder is loading...");
    }
    else if ([Duedate compare:[NSDate date]] == NSOrderedAscending)
    {
        DisplayAlertWithTitle(App_Name, @"Please select future date to set the reminder");
        return;
    }
    else
    {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.8;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        
        
        SetReminderViewCtr *obj_SetReminderViewCtr = [[SetReminderViewCtr alloc] initWithNibName:@"SetReminderViewCtr" bundle:nil];
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:obj_SetReminderViewCtr animated:NO];
    }
}
-(IBAction)btnAddNewTaskCreatedPressed:(id)sender
{
    if ([[txtTaskDescr.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        DisplayAlertWithTitle(App_Name, @"Please enter task description");
        return;
    }
    else if (Listid == -1)
    {
        DisplayAlertWithTitle(App_Name, @"You need to select task list to save task");
        return;
    }
    else if ([dicReminder count] > 0 && [lblDueDateValue.text isEqualToString:@"None"])
    {
        DisplayAlertWithTitle(App_Name, @"You can not set reminder without duedate.");
        return;
    }
    else
    {
        NSString *strMaxtaskId = @"SELECT max(taskId) FROM tbl_tasks";
        int taskId = [DatabaseAccess getMaxid:strMaxtaskId];
        taskId = taskId + 1;
        
        if ([lblDueDateValue.text isEqualToString:@"None"])
        {
            StrDueDate = @"0000-00-00";
        }
        //Save Reminder
        if ([dicReminder count] > 0)
        {
            NSString *strMaxReminderId = @"SELECT max(reminderId) FROM tbl_reminders";
            reminderId = [DatabaseAccess getMaxid:strMaxReminderId];
            reminderId = reminderId + 1;
            
            [self setLocalNoti:dicReminder];
            
            NSString *strQueryInsertReminder = [NSString stringWithFormat:@"insert into tbl_reminders(reminderId,startDay,isEveryDay,beforeDuedateTime1,beforeDuedateTime2,beforeDuedateTime3,onDuedateTime1,onDuedateTime2,onDuedateTime3,beforeDueDateChannelId,onDueDateChannelId,reminderstatus,isremindernew) values(%d,%d,%d,'%@','%@','%@','%@','%@','%@',%d,%d,%d,%d)",reminderId,[[dicReminder valueForKey:@"startDay"] intValue],[[dicReminder valueForKey:@"isEveryDay"] intValue],[dicReminder valueForKey:@"beforeDueDateTime1"],[dicReminder valueForKey:@"beforeDueDateTime2"],[dicReminder valueForKey:@"beforeDueDateTime3"],[dicReminder valueForKey:@"onDueDateTime1"],[dicReminder valueForKey:@"onDueDateTime2"],[dicReminder valueForKey:@"onDueDateTime3"],[[dicReminder valueForKey:@"beforeDueDateChannelId"] intValue],[[dicReminder valueForKey:@"onDueDateChannelId"] intValue],1,1];
            [DatabaseAccess updatetbl:strQueryInsertReminder];
        }
        
        NSString *strQueryInsert = [NSString stringWithFormat:@"insert into tbl_tasks(taskId,listId,description,priority,dueDate,reminderId,senderId,receiverId,taskCategoryType,fadeDate,assignedId,taskstatus,istasknew,taskassignedto) values(%d,%d,'%@',%d,'%@',%d,%d,%d,'%@','%@',%d,%d,%d,%d)",taskId,Listid,txtTaskDescr.text,Priorityid,StrDueDate,reminderId,[strSenderId intValue],[strRecieveId intValue],strtaskCategoryType,@"0000-00-00",[strResponsibleID intValue],1,1,[strAssignedTo intValue]];
        [DatabaseAccess updatetbl:strQueryInsert];
        
        
        if ([[dicResponsible valueForKey:@"From"] isEqualToString:@"Org"] && ![[dicResponsible valueForKey:@"Message"] isEqualToString:@"Message..."] && [[[dicResponsible valueForKey:@"Message"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0)
        {
            //Send Data Of user setting from local databse
            NSString *strQuerySelect = @"SELECT * FROM tbl_user_setting";
            NSMutableArray *ArryretriveUserSettings = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_user_setting:strQuerySelect]];
            
            //Add Message in Local Database
            int SenderUserID = [[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"] intValue];
            int RecieverUserID;
            
            if (SenderUserID == [strRecieveId intValue])
            {
                RecieverUserID = [strSenderId intValue];
            }
            else
            {
                RecieverUserID = [strRecieveId intValue];
            }
            
            
            NSString *strMaxMessageID = @"SELECT max(messageId) FROM tbl_messages";
            int messageID = [DatabaseAccess getMaxid:strMaxMessageID];
            messageID = messageID + 1;
            
            NSString *strQueryInsertMessage = [NSString stringWithFormat:@"insert into tbl_add_messages(messageId,messageDescription,messageType,recieverId,senderId,taskId) values(%d,'%@','%@',%d,%d,%d)",messageID,[dicResponsible valueForKey:@"Message"],@"OUTBOX",RecieverUserID,SenderUserID,taskId];
            [DatabaseAccess updatetbl:strQueryInsertMessage];
            
            NSString *strQueryInsertMsg = [NSString stringWithFormat:@"insert into tbl_messages(messageId,messageDescription,messageType,recieverId,senderId,taskId) values(%d,'%@','%@',%d,%d,%d)",messageID,[dicResponsible valueForKey:@"Message"],@"OUTBOX",RecieverUserID,SenderUserID,taskId];
            [DatabaseAccess updatetbl:strQueryInsertMsg];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTable" object:nil];
        AppDel.strTaskId = @"";
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(IBAction)btnCancelPressed:(id)sender
{
    AppDel.strTaskId = @"";
    [self.navigationController popViewControllerAnimated:YES];
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
        /*}
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
        /*}
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
        /*if (isEvryDay == 0)
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
    notif.alertBody = txtTaskDescr.text;
    notif.alertAction = @"View Details";
    notif.applicationIconBadgeNumber = 1;
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.repeatInterval = 0;
    NSString *strReminderID = [NSString stringWithFormat:@"%d-%@-%d",reminderId,strTime,TimeInterval];
    NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:strReminderID,@"ReminderUniquetag",txtTaskDescr.text,@"AlertBody", nil];
    notif.userInfo = userDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
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
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateui];
}
#pragma mark - Set Landscape Frame

-(void)updateui
{}

#pragma mark - TextView Delegate Methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView.layer setBorderColor: [[UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0] CGColor]];
    [textView.layer setBorderWidth: 1.0];
    [textView.layer setMasksToBounds:YES];
    
    CGRect textVWRect = [self.view.window convertRect:textView.bounds fromView:textView];
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



-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self txtName:textView];
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}
#pragma mark - Set label Border
-(void)txtName:(UITextView*)tf
{
    [tf.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [tf.layer setBorderWidth: 1.0];
    [tf.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
