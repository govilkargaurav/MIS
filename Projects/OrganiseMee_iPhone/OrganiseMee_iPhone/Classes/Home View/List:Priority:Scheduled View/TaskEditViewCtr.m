//
//  TaskEditViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by apple on 2/15/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "TaskEditViewCtr.h"
#import "DatabaseAccess.h"
#import "EditTaskViewCtr.h"
#import "GlobalMethods.h"
#import "CustomIOS7AlertView.h"

@interface demoView : UIView{
    
}
@end

@implementation demoView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UITextView *txtMesage = [[UITextView alloc] initWithFrame:CGRectMake(12, 40, 260,100)];
        [txtMesage setTextAlignment:NSTextAlignmentLeft];
        [txtMesage setFont:[UIFont fontWithName:@"ArialMT" size:16.0]];
        [txtMesage setEditable:YES];
        [txtMesage setTextColor:[UIColor darkGrayColor]];
        txtMesage.layer.borderWidth = 2.0f;
        txtMesage.layer.borderColor = [[UIColor clearColor] CGColor];
        txtMesage.layer.cornerRadius = 5.0;
        txtMesage.keyboardType=UIKeyboardTypeDefault;
        [txtMesage becomeFirstResponder];
        [self addSubview:txtMesage];
        
        UILabel *lblMessageTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 260, 20)];
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"] isEqualToString:@"de"]) {
            lblMessageTitle.text = @"Nachricht";
        }else{
            lblMessageTitle.text = @"Message";
        }
        [lblMessageTitle setFont:[UIFont fontWithName:@"ArialMT" size:16.0]];
        lblMessageTitle.textColor = [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f];
        lblMessageTitle.backgroundColor = [UIColor clearColor];
        lblMessageTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblMessageTitle];
    
    }
    return self;
}

-(void)loadview{
    
    
}

-(void)drawRect:(CGRect)rect{
   
    [[UIColor blueColor] set];
    /* Get the current graphics context */
    CGContextRef currentContext =UIGraphicsGetCurrentContext();
    /* Set the width for the line */
    CGContextSetLineWidth(currentContext,2.0f);
    /* Start the line at this point */
    CGContextMoveToPoint(currentContext,100.0f, 150.0f);
    /* And end it at this point */
    CGContextAddLineToPoint(currentContext,100.0f, 175.0f);
    /* Use the context's current color to draw the line */
    CGContextStrokePath(currentContext);
}

@end

@interface TaskEditViewCtr ()

@end

@implementation TaskEditViewCtr
@synthesize strTaskId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
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
        localizationDict = [AppDel.langDict objectForKey:@"TaskEditView"];
        lblList_Projectttl.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbllist_project"]];
        lblPriorityttl.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblpriority"]];
        lblResponsiblettl.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblresponsible"]];
        lblDueDatettl.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblduedate"]];
        lblReminderBeforettl.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblremonderbefore"]];
        lblReminderOnttl.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblremonderon"]];
    }
    
    
    
   // [self ViewName:ViewReminderBeforebg];
   // [self ViewName:ViewReminderOnbg];
   // [self lblName:lblListProjectbg];
   // [self lblName:lblPrioritybg];
   // [self lblName:lblDueDatebg];
   // [self lblName:lblResponsiblebg];
    
   // Swipe Right for display list view
    UISwipeGestureRecognizer* swipRightObj = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeToDisplayList:)];
    swipRightObj.delegate = self;
    swipRightObj.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipRightObj];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - Right Gesture Method
-(void)SwipeToDisplayList:(UISwipeGestureRecognizer *)swipe
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    // Get Tasks of the Current List
    NSString *strQueryTask = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where taskId=%d",[strTaskId intValue]];
    NSMutableArray *ArryTask = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQueryTask]];
    DicTask = [ArryTask objectAtIndex:0];

    // Set Frame of all Subviews
    Yaxis = lblDesc.frame.origin.y;
    
    CGSize strDescSize = [self text:[DicTask valueForKey:@"description"] :lblDesc.frame.size.width :20];
    lblDesc.frame = CGRectMake(lblDesc.frame.origin.x, Yaxis, lblDesc.frame.size.width,MAX(strDescSize.height, lblDesc.frame.size.height));
    
    imgbgTran1.frame = CGRectMake(0, 0, imgbgTran1.frame.size.width,lblDesc.frame.size.height + 24);
    
    Yaxis = Yaxis + lblDesc.frame.size.height + 10;
    
    ViewTop.frame = CGRectMake(ViewTop.frame.origin.x, Yaxis, ViewTop.frame.size.width, ViewTop.frame.size.height);
    Yaxis = Yaxis + ViewTop.frame.size.height + 8;
    
    
    //Set Value
    lblDesc.text = [NSString stringWithFormat:@"%@",[DicTask valueForKey:@"description"]];
    
    // Get List Name From Local DB From List View
    NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_lists where listId=%d",[[DicTask valueForKey:@"listId"] intValue]];
    NSMutableArray *ArryLists = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_lists:strQuerySelect]];
    if ([ArryLists count] == 0)
    {
        lblListProjectName.text = @"";
    }
    else
    {
        lblListProjectName.text = [NSString stringWithFormat:@"%@",[[ArryLists objectAtIndex:0] valueForKey:@"listName"]];
    }
    
    // Set Assigned Values
    NSDictionary *dicAssign = [GlobalMethods GetContactName:[DicTask valueForKey:@"assignedId"] TaskCategoryType:[DicTask valueForKey:@"taskCategoryType"]];
    lblResponsibleName.text = [NSString stringWithFormat:@"%@",[dicAssign valueForKey:@"Responsible"]];
    [self HideShowButton:[dicAssign valueForKey:@"Color"] Delete:[[dicAssign valueForKey:@"Delete"] boolValue] Archieve:[[dicAssign valueForKey:@"Archieve"] boolValue] Message:[[dicAssign valueForKey:@"Message"] boolValue] CallBack:[[dicAssign valueForKey:@"CallBack"] boolValue] GiveBack:[[dicAssign valueForKey:@"GiveBack"] boolValue]];
    
    
    // Set Due Date Values
    if ([[DicTask valueForKey:@"dueDate"] isEqualToString:@"0000-00-00"])
    {
        if ([UserLanguage isEqualToString:@"de"]) {
            lblDueDate.text= @"Keine";
        }else{
            lblDueDate.text = @"None";
        }
        
    }
    else
    {
        lblDueDate.text = [NSString stringWithFormat:@"%@",[GlobalMethods GetStringDateWithFormate:[DicTask valueForKey:@"dueDate"]]];
    }
    
    // Set Priority Values
    imgPriority.image = [GlobalMethods GetImagePriority:[DicTask valueForKey:@"priority"]];
    
    NSString *strQuerySelectReminder = [NSString stringWithFormat:@"SELECT * FROM tbl_reminders where reminderId=%d",[[DicTask valueForKey:@"reminderId"] intValue]];
    NSMutableArray *ArryReminder = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_standerd_reminder:strQuerySelectReminder]];
    
    if ([ArryReminder count] > 0)
    {
        if ([[[ArryReminder objectAtIndex:0]valueForKey:@"startDay"] intValue] == 0 && [[[ArryReminder objectAtIndex:0]valueForKey:@"isEveryDay"] intValue] == 0)
        {
            lblReminderBeforeDate.text = @"None";
        }
        else
        {
            NSString *strBeforeDueDateFinal;
            if ([[[ArryReminder objectAtIndex:0]valueForKey:@"startDay"] intValue] != 0 && [[[ArryReminder objectAtIndex:0]valueForKey:@"isEveryDay"] intValue] != 0)
            {
                if([UserLanguage isEqualToString:@"de"])
                {
                    strBeforeDueDateFinal = [NSString stringWithFormat:@"%@ Tage vor , und jeden Tag dazwischen, um",[[ArryReminder objectAtIndex:0]valueForKey:@"startDay"]];
                    
                }else{
                    strBeforeDueDateFinal = [NSString stringWithFormat:@"%@ days before and every day in between at",[[ArryReminder objectAtIndex:0]valueForKey:@"startDay"]];
                }
            }
            else if ([[[ArryReminder objectAtIndex:0]valueForKey:@"startDay"] intValue] != 0)
            {
                if([UserLanguage isEqualToString:@"de"])
                {
                    strBeforeDueDateFinal = [NSString stringWithFormat:@"%@ Tage vor, um",[[ArryReminder objectAtIndex:0]valueForKey:@"startDay"]];
                    
                }else{
                    strBeforeDueDateFinal = [NSString stringWithFormat:@"%@ days before at",[[ArryReminder objectAtIndex:0]valueForKey:@"startDay"]];
                }
                
            }
            else if ([[[ArryReminder objectAtIndex:0]valueForKey:@"isEveryDay"] intValue] != 0)
            {
                if([UserLanguage isEqualToString:@"de"])
                {
                    strBeforeDueDateFinal = @"jeden Tag dazwischen, um";
                    
                }else{
                  strBeforeDueDateFinal = @"Every day in between at";
                }
            }
            
            NSString *strBeforeDueDate1 = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryReminder objectAtIndex:0]valueForKey:@"beforeDuedateTime1"]]];
            strBeforeDueDate1 = [self Time:strBeforeDueDate1];
            
            NSString *strBeforeDueDate2 = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryReminder objectAtIndex:0]valueForKey:@"beforeDuedateTime2"]]];
            strBeforeDueDate2 = [self Time:strBeforeDueDate2];
            
            NSString *strBeforeDueDate3 = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryReminder objectAtIndex:0]valueForKey:@"beforeDuedateTime3"]]];
            strBeforeDueDate3 = [self Time:strBeforeDueDate3];
            
            if ([strBeforeDueDate1 length] != 0)
            {
                strBeforeDueDateFinal = [NSString stringWithFormat:@"%@ %@ and",strBeforeDueDateFinal,strBeforeDueDate1];
            }
            if ([strBeforeDueDate2 length] != 0)
            {
                strBeforeDueDateFinal = [NSString stringWithFormat:@"%@ %@ and",strBeforeDueDateFinal,strBeforeDueDate2];
            }
            if ([strBeforeDueDate3 length] != 0)
            {
                strBeforeDueDateFinal = [NSString stringWithFormat:@"%@ %@",strBeforeDueDateFinal,strBeforeDueDate3];
            }
            NSMutableArray *ArryBeforeDueDate = [[strBeforeDueDateFinal componentsSeparatedByString:@" "] mutableCopy];
            NSString *lastWord = [ArryBeforeDueDate lastObject];
            if ([lastWord isEqualToString:@"and"])
            {
                [ArryBeforeDueDate removeLastObject];
            }
            strBeforeDueDateFinal = [ArryBeforeDueDate componentsJoinedByString:@" "];
            lblReminderBeforeDate.text = [NSString stringWithFormat:@"%@",strBeforeDueDateFinal];
        }
        NSString *strOnDueDate1 = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryReminder objectAtIndex:0]valueForKey:@"onDuedateTime1"]]];
        strOnDueDate1 = [self Time:strOnDueDate1];
        
        NSString *strOnDueDate2 = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryReminder objectAtIndex:0]valueForKey:@"onDuedateTime2"]]];
        strOnDueDate2 = [self Time:strOnDueDate2];
        
        NSString *strOnDueDate3 = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryReminder objectAtIndex:0]valueForKey:@"onDuedateTime3"]]];
        strOnDueDate3 = [self Time:strOnDueDate3];
        
        if ([strOnDueDate1 length] == 0 && [strOnDueDate2 length] == 0 && [strOnDueDate3 length] == 0)
        {
            if ([UserLanguage isEqualToString:@"de"]) {
                lblReminderOnDate.text = @"Keine";
            }else{
                lblReminderOnDate.text = @"None";
            }
        }
        else
        {
            NSString *strOnDueDateFinal;
            NSString *strANDDueDateFinal;
            if ([UserLanguage isEqualToString:@"de"]) {
                strOnDueDateFinal = @"Um";
                strANDDueDateFinal = @"und";
            }else{
                strOnDueDateFinal = @"At";
                strANDDueDateFinal = @"and";
            }
            if ([strOnDueDate1 length] != 0)
            {
                strOnDueDateFinal = [NSString stringWithFormat:@"%@ %@ %@",strOnDueDateFinal,strOnDueDate1,strANDDueDateFinal];
            }
            if ([strOnDueDate2 length] != 0)
            {
                strOnDueDateFinal = [NSString stringWithFormat:@"%@ %@ %@",strOnDueDateFinal,strOnDueDate2,strANDDueDateFinal];
            }
            if ([strOnDueDate3 length] != 0)
            {
                strOnDueDateFinal = [NSString stringWithFormat:@"%@ %@",strOnDueDateFinal,strOnDueDate3];
            }
            NSMutableArray *ArryOnDueDate = [[strOnDueDateFinal componentsSeparatedByString:@" "] mutableCopy];
            NSString *lastWord1 = [ArryOnDueDate lastObject];
            if ([lastWord1 isEqualToString:@"and"])
            {
                [ArryOnDueDate removeLastObject];
            }
            
            strOnDueDateFinal = [ArryOnDueDate componentsJoinedByString:@" "];
            lblReminderOnDate.text = [NSString stringWithFormat:@"%@",strOnDueDateFinal];
        }
    }
    else
    {
         if ([UserLanguage isEqualToString:@"de"]) {
             lblReminderBeforeDate.text = @"Keine";
             lblReminderOnDate.text = @"Keine";
         }else{
             lblReminderBeforeDate.text = @"None";
             lblReminderOnDate.text = @"None";
         }
    }
    CGSize strBeforeDueDateSize = [self text:lblReminderBeforeDate.text :lblReminderBeforeDate.frame.size.width :18];
    lblReminderBeforeDate.frame = CGRectMake(lblReminderBeforeDate.frame.origin.x, lblReminderBeforeDate.frame.origin.y, lblReminderBeforeDate.frame.size.width, MAX(lblReminderBeforeDate.frame.size.height, strBeforeDueDateSize.height));

    ViewReminderBeforebg.frame = CGRectMake(ViewReminderBeforebg.frame.origin.x, Yaxis, ViewReminderBeforebg.frame.size.width, lblReminderBeforeDate.frame.size.height + 49);
    Yaxis = Yaxis + ViewReminderBeforebg.frame.size.height + 8;
    
    CGSize strOnDueDateSize = [self text:lblReminderOnDate.text :lblReminderOnDate.frame.size.width :18];
    lblReminderOnDate.frame = CGRectMake(lblReminderOnDate.frame.origin.x, lblReminderOnDate.frame.origin.y, lblReminderOnDate.frame.size.width, MAX(lblReminderOnDate.frame.size.height, strOnDueDateSize.height));
    ViewReminderOnbg.frame = CGRectMake(ViewReminderOnbg.frame.origin.x, Yaxis, ViewReminderOnbg.frame.size.width, lblReminderOnDate.frame.size.height + 500);
    Yaxis = Yaxis + ViewReminderOnbg.frame.size.height + 15 - 450;
    
    scl_bg.contentSize = CGSizeMake(320, Yaxis);
    [super viewWillAppear:animated];
}

#pragma mark - Set label Border
-(void)ViewName:(UIView*)View
{
    [View.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [View.layer setBorderWidth: 1.0];
    [View.layer setMasksToBounds:YES];
}
#pragma mark - Set label Border
-(void)lblName:(UILabel*)lbl
{
    [lbl.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lbl.layer setBorderWidth: 1.0];
    [lbl.layer setMasksToBounds:YES];
}

// Set Button According to Task Assign
-(void)HideShowButton:(UIColor*)color Delete:(BOOL)deleteValue Archieve:(BOOL)archieveValue Message:(BOOL)messageValue CallBack:(BOOL)callbackValue GiveBack:(BOOL)givebackValue
{
    lblResponsibleName.textColor = color;
    btnDelete.hidden = deleteValue;
    btnArchieve.hidden = archieveValue;
    btnMessage.hidden = messageValue;
    btnCallBack.hidden = callbackValue;
    btnGiveBack.hidden = givebackValue;
}
#pragma mark - IBAction Methods
-(IBAction)btnDeleteTaskViewCtr:(id)sender
{
    
    if ([UserLanguage isEqualToString:@"de"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"Wollen Sie die Aufgabe löschen?" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Löschen",nil];
        alert.tag = 1;
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"Do you want to Delete this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete",nil];
        alert.tag = 1;
        [alert show];
    }

    
}
-(IBAction)btnArchievPressed:(id)sender
{
    if ([UserLanguage isEqualToString:@"de"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"Wollen Sie die Aufgabe archivieren?" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Archivieren",nil];
        alert.tag = 2;
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"Do you want to Archive this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Archive",nil];
        alert.tag = 2;
        [alert show];
    }
    
}
-(IBAction)btnMessagePressed:(id)sender
{
   /* UIAlertView *avWithTxtView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send",nil];
   // avWithTxtView.alertViewStyle = UIAlertViewStylePlainTextInput;
    txtMesage = [[UITextView alloc] initWithFrame:CGRectMake(12, 50, 260,100)];
    [txtMesage setTextAlignment:UITextAlignmentLeft];
    [txtMesage setFont:[UIFont fontWithName:@"ArialMT" size:16.0]];
    [txtMesage setEditable:YES];
    [txtMesage setTextColor:[UIColor darkGrayColor]];
    txtMesage.layer.borderWidth = 2.0f;
    txtMesage.layer.borderColor = [[UIColor clearColor] CGColor];
    txtMesage.layer.cornerRadius = 5.0;
    txtMesage.keyboardType=UIKeyboardTypeDefault;
    [txtMesage becomeFirstResponder];
    [avWithTxtView addSubview:txtMesage];
    [avWithTxtView setTag:3];
    [avWithTxtView show];*/

    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initWithParentView:self.view];
    demoView *view = [[demoView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
    [view setNeedsDisplay];
    [alertView setContainerView:view];
    if ([UserLanguage isEqualToString:@"de"]) {
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Abbrechen", @"Senden", nil]];
    }else{
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Send", nil]];
    }
    
    [alertView setDelegate:self];
    [alertView setUseMotionEffects:true];
    [alertView show];
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
    }
    else
    {
        if ([[txtMesage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0)
        {
            //Send Data Of user setting from local databse
            NSString *strQuerySelect = @"SELECT * FROM tbl_user_setting";
            NSMutableArray *ArryretriveUserSettings = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_user_setting:strQuerySelect]];
            
            //Add Message in Local Database
            int SenderUserID = [[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"] intValue];
            int RecieverUserID;
            
            if (SenderUserID == [[DicTask valueForKey:@"receiverId"] intValue])
            {
                RecieverUserID = [[DicTask valueForKey:@"senderId"] intValue];
            }
            else
            {
                RecieverUserID = [[DicTask valueForKey:@"receiverId"] intValue];
            }
            
            NSString *strMaxMessageID = @"SELECT max(messageId) FROM tbl_messages";
            int messageID = [DatabaseAccess getMaxid:strMaxMessageID];
            messageID = messageID + 1;
            
            NSString *strQueryInsertMessage = [NSString stringWithFormat:@"insert into tbl_add_messages(messageId,messageDescription,messageType,recieverId,senderId,taskId) values(%d,'%@','%@',%d,%d,%d)",messageID,txtMesage.text,@"OUTBOX",RecieverUserID,SenderUserID,[[DicTask valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryInsertMessage];
        }
        
    }
    [alertView close];
}
- (UIView *)createDemoView
{

}

-(IBAction)btnCallBackPressed:(id)sender
{
    if ([UserLanguage isEqualToString:@"de"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"Wollen Sie diese Aufgaben zurückholen?" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Zurückholen",nil];
        alert.tag = 4;
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"Do you want to Callback this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Callback",nil];
        alert.tag = 4;
        [alert show];
    }
}
-(IBAction)btnGiveBackPressed:(id)sender
{
    
    if ([UserLanguage isEqualToString:@"de"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"Wollen Sie die Aufgabe zurückgeben?" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Zurückgeben",nil];
        alert.tag = 5;
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"Do you want to Giveback this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Giveback",nil];
        alert.tag = 5;
        [alert show];
        
    }
    
    
}

-(IBAction)btnEditTaskPressed:(id)sender
{
    EditTaskViewCtr *obj_EditTaskViewCtr = [[EditTaskViewCtr alloc]initWithNibName:@"EditTaskViewCtr" bundle:nil];
    obj_EditTaskViewCtr.DicTask = DicTask;
    [self.navigationController pushViewController:obj_EditTaskViewCtr animated:YES];
}

#pragma mark - AlertView Delegate Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            if ([[DicTask valueForKey:@"istasknew"] intValue] == 1)
            {
                NSString *strQueryDelete = [NSString stringWithFormat:@"DELETE FROM tbl_tasks Where taskId=%d",[[DicTask valueForKey:@"taskId"] intValue]];
                [DatabaseAccess updatetbl:strQueryDelete];
                NSString *strQueryDeleteReminder = [NSString stringWithFormat:@"DELETE FROM tbl_reminders Where reminderId=%d",[[DicTask valueForKey:@"reminderId"] intValue]];
                [DatabaseAccess updatetbl:strQueryDeleteReminder];
            }
            else
            {
                NSString *strQueryDelete = [NSString stringWithFormat:@"update tbl_tasks Set taskstatus=3 Where taskId=%d",[[DicTask valueForKey:@"taskId"] intValue]];
                [DatabaseAccess updatetbl:strQueryDelete];
                
                NSString *strQueryDeleteReminder = [NSString stringWithFormat:@"update tbl_reminders Set reminderstatus=3 Where reminderId=%d",[[DicTask valueForKey:@"reminderId"] intValue]];
                [DatabaseAccess updatetbl:strQueryDeleteReminder];
            }
            
            NSString *strQueryMessageDelete = [NSString stringWithFormat:@"DELETE FROM tbl_add_messages where taskId=%d",[[DicTask valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryMessageDelete];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            NSString *strQueryDelete = [NSString stringWithFormat:@"update tbl_tasks Set taskCategoryType='ARCHIEVE' Where taskId=%d",[[DicTask valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryDelete];
            
            NSString *strQueryInsertArchieveTask = [NSString stringWithFormat:@"insert into tbl_archive_tasks(taskId) values(%d)",[[DicTask valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryInsertArchieveTask];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 3)
    {
        
    }
    else if (alertView.tag == 4)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            NSString *strQueryDelete = [NSString stringWithFormat:@"update tbl_tasks Set senderId=%d,receiverId=%d,taskCategoryType='%@',assignedId=%d,taskstatus=5 Where taskId=%d",0,0,@"GENEREL",0,[[DicTask valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryDelete];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 5)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            NSString *strQueryDelete = [NSString stringWithFormat:@"DELETE FROM tbl_tasks Where taskId=%d",[[DicTask valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryDelete];
            
            NSString *strQueryInsertGiveBack = [NSString stringWithFormat:@"insert into tbl_giveback_tasks(taskId) values(%d)",[[DicTask valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryInsertGiveBack];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Text Size Return Methods

-(CGSize)text:(NSString*)strTextContent :(CGFloat)lblwidth :(CGFloat)FontSize
{
    CGSize constraintSize;
    constraintSize.width = lblwidth;
    constraintSize.height = MAXFLOAT;
    CGSize stringSize1 =[strTextContent sizeWithFont: [UIFont fontWithName:@"ArialMT" size:FontSize] constrainedToSize: constraintSize lineBreakMode: UILineBreakModeWordWrap];
    return stringSize1;
}

#pragma mark - Time Return With AM - PM formate
-(NSString *)Time:(NSString*)strTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSDate *dateGet = [dateFormatter dateFromString:strTime];
    dateFormatter.dateFormat = @"hh:mm a";
    strTime = [dateFormatter stringFromDate:dateGet];
    return strTime;
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
