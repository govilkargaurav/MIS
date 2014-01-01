//
//  TaskViewCtr.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/16/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "TaskViewCtr.h"
#import "GlobalMethods.h"
#import "TTTAttributedLabel.h"
#import "AppDelegate.h"
#import "DatabaseAccess.h"
#import "TempRightViewCtr.h"
#import "SyncClass.h"
#import "Header.h"
#import "SettingsViewCtr.h"
#import "KSCustomPopoverBackgroundView.h"

#define tbl_width_pot 768
#define tbl_width_land 1024

@interface TaskViewCtr ()
@end

@implementation TaskViewCtr
@synthesize obj_popOver,obj_popOver_Setting;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)SetTaskAccordingToList:(NSNotification*)noti
{
    strQuery = [NSString stringWithFormat:@"%@",[noti.userInfo valueForKey:@"Query"]];
    
    lblNav_Title.text = [NSString stringWithFormat:@"%@",[noti.userInfo valueForKey:@"Title"]];
    ArryTasks = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_tasks:strQuery]];
    [tbl_Tasks reloadData];
    [self SetBg];

    /*if (self.masterIsVisible)
    {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
            [self hideMasterView];
        }
    }*/
}
-(void)SetBg
{
    if (ArryTasks.count > 0)
        imgLogo.hidden = YES;
    else
        imgLogo.hidden = NO;
    
    imgbgTrans.frame = CGRectMake(imgbgTrans.frame.origin.x, tbl_Tasks.contentSize.height + 44, imgbgTrans.frame.size.width, tbl_Tasks.frame.size.height - tbl_Tasks.contentSize.height);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedRow = -1;
    chatindex = [NSIndexPath indexPathForRow:-1 inSection:0];
    
    imgLogo.hidden = YES;

    SetSyncFlag = YES;
    self.navigationController.navigationBarHidden = YES;

    [btnViewMenu addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SetTaskAccordingToList:) name:@"SetTaskAccordingList" object:nil];

    //DismissSettingPopOver
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DismissSettingPopOver:) name:@"DismissSettingPopOver" object:nil];
    
    //Logout
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LogOut) name:@"LogOut" object:nil];
    
    //ReloadTable
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadTable) name:@"ReloadTable" object:nil];

    // Do any additional setup after loading the view from its nib.
}
-(void)ReloadTable
{
    ArryTasks = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_tasks:strQuery]];
    [tbl_Tasks reloadData];
    [self SetBg];
}
-(void)LogOut
{
    if ([obj_popOver_Setting isPopoverVisible])
    {
        [obj_popOver_Setting dismissPopoverAnimated:YES];
    }
   
    AutoSyncViewCtr *obj_AutoSync = [[AutoSyncViewCtr alloc]init];
    [obj_AutoSync.timer invalidate];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"Off" forKey:@"SyncSwitch"];
    [[NSUserDefaults standardUserDefaults] setObject:@"LoggedOut" forKey:@"Login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [AppDel.deckController.navigationController popToRootViewControllerAnimated:YES];
}
-(void)DismissSettingPopOver:(NSNotification*)noti
{
    if ([obj_popOver_Setting isPopoverVisible])
    {
        [obj_popOver_Setting dismissPopoverAnimated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self updateui];
}
#pragma mark Table view data source

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 }*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ArryTasks count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil)
    // {
    if(cell!=nil)
        cell=nil;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    UIImageView *imgbg = [[UIImageView alloc]init];
    imgbg.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height-1);
    imgbg.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imgbg.image = [UIImage imageNamed:@"bgTrans.png"];
    [cell.contentView addSubview:imgbg];
    
    
    CGFloat width;
    int tblWidth;
    if (OrientationFlag == 0)
    {
        tblWidth = tbl_width_pot;
        width = 440;
    }
    else
    {
        tblWidth = tbl_width_land;
        width = 696;
    }
    
    TTTAttributedLabel *lblDescr = [[TTTAttributedLabel alloc] init];
    lblDescr.tag = indexPath.row;
    [lblDescr setFont:[UIFont fontWithName:@"ArialMT" size:16.0f]];
    [lblDescr setBackgroundColor:[UIColor clearColor]];
    [lblDescr setNumberOfLines:0];
    [lblDescr setTextColor:[UIColor blackColor]];
    [lblDescr setTextAlignment:NSTextAlignmentLeft];
    [lblDescr setLineBreakMode:NSLineBreakByWordWrapping];
    NSString *someText = [[NSString stringWithFormat:@"%@",[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"description"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
    CGFloat strheight = [self CalculateStringSize:someText];
    [cell.contentView addSubview:lblDescr];
    
    NSString *strFadeDate = [[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"fadeDate"];
    NSString *strDueDate = [[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"dueDate"];
    UIButton *btnCompleteTask = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCompleteTask.frame = CGRectMake(10, 7, 25, 25);
    if ([strFadeDate isEqualToString:@"0000-00-00"])
    {
        [btnCompleteTask setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        [btnCompleteTask setSelected:NO];
        
        [lblDescr setText:someText];
    }
    else
    {
        [btnCompleteTask setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        [btnCompleteTask setSelected:YES];
        
        AppDel.ColorFlag = YES;
        [lblDescr setText:someText];
        lblDescr.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]forKey:@"TTTCustomStrikeOut"];
        [lblDescr addLinkToURL:nil withRange:NSMakeRange(0, [lblDescr.text length])];
    }
    btnCompleteTask.tag = indexPath.row;
    [btnCompleteTask addTarget:self action:@selector(btnCompleteTaskPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnCompleteTask.userInteractionEnabled = YES;
    [cell.contentView addSubview:btnCompleteTask];
    
    UILabel *lblDate;
    if (![strDueDate isEqualToString:@"0000-00-00"])
    {
        lblDate = [[UILabel alloc] init];
        lblDate.tag = indexPath.row + 1000;
        lblDate.textColor = [UIColor darkGrayColor];
        lblDate.backgroundColor = [UIColor clearColor];
        lblDate.font = [UIFont fontWithName:@"ArialMT" size:16.0f];
        lblDate.textAlignment = NSTextAlignmentLeft;
        lblDate.text = [NSString stringWithFormat:@"%@",[GlobalMethods GetStringDateWithFormate:strDueDate]];
        [lblDate setFrame:CGRectMake(tblWidth-47, 7, 45,36)];
        [cell.contentView addSubview:lblDate];
        lblDate.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;

    }
    UIButton *btnPriority = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imgPriority = [GlobalMethods GetImagePriority:[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"priority"]];
        [btnPriority setImage:imgPriority forState:UIControlStateNormal];
        btnPriority.frame = CGRectMake(50, 7, 25, 25);
        btnPriority.tag = indexPath.row;
        [btnPriority addTarget:self action:@selector(btnPriorityChanged:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnPriority];
    
    UIImageView *imgReminder_icon;
    if ([[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"reminderId"] intValue] != 0)
    {
        BOOL CheckReminder = [GlobalMethods CheckReminderSetOrNot:[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"reminderId"]];
        if (CheckReminder)
        {
            imgReminder_icon = [[UIImageView alloc]init];
            imgReminder_icon.tag = indexPath.row;
            imgReminder_icon.image = [UIImage imageNamed:@"r_clock.png"];
            imgReminder_icon.contentMode = UIViewContentModeScaleToFill;
            if (![strDueDate isEqualToString:@"0000-00-00"])
            {
                // Code Change By Chirag 235 X axis
                [imgReminder_icon setFrame:CGRectMake(tblWidth - 47 - 30, 12, 20,20)];
            }
            else
            {
                [imgReminder_icon setFrame:CGRectMake(tblWidth - 47 - 30, 12, 20,20)];
            }
            [cell.contentView addSubview:imgReminder_icon];
        }
    }
    
    // Set Assigned Values
    NSString *strAssignID = [[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"assignedId"];
    NSString *strTaskCategoryType = [[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"taskCategoryType"];
    NSDictionary *dicAssign = [GlobalMethods GetContactName:strAssignID TaskCategoryType:strTaskCategoryType];
    UILabel *lblResponsible;
    if (![[dicAssign valueForKey:@"Responsible"] isEqualToString:@"You"])
    {
        lblResponsible = [[UILabel alloc] init];
        lblResponsible.textColor = [dicAssign valueForKey:@"Color"];
        lblResponsible.backgroundColor = [UIColor clearColor];
        lblResponsible.font = [UIFont fontWithName:@"ArialMT" size:16.0f];
        lblResponsible.textAlignment = NSTextAlignmentCenter;
        lblResponsible.numberOfLines = 2;
        lblResponsible.lineBreakMode = NSLineBreakByWordWrapping;
        lblResponsible.text = [NSString stringWithFormat:@"%@",[dicAssign valueForKey:@"Responsible"]];
        [lblResponsible setFrame:CGRectMake(tblWidth - 47 - 30 - 155, 4, 150,36)];
        [cell.contentView addSubview:lblResponsible];
    }
    
    if ([GlobalMethods CheckMessageExistOrNot:[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"taskId"] CatType:[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"taskCategoryType"]])
    {
        UIButton *btnChat = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imgPriority = [UIImage imageNamed:@"Chat.png"];
        [btnChat setImage:imgPriority forState:UIControlStateNormal];
        btnChat.frame = CGRectMake(tblWidth - 47 - 30 - 155 - 35 , 5, 25, 25);
        btnChat.tag = indexPath.row;
        [btnChat addTarget:self action:@selector(btnChatPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnChat];
        
        [lblDescr setFrame:CGRectMake(90, 7, width - 40,strheight)];
    }
    else
    {
        [lblDescr setFrame:CGRectMake(90, 7, width,strheight)];
    }
    [lblDescr sizeToFit];
    // }
    
    if (chatindex.section == indexPath.section && chatindex.row == indexPath.row && Selected)
    {
        NSString *strMessageChat = [GlobalMethods GetMessagesFromTaskId:[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"taskId"]];
        
        UILabel *lblChat = [[UILabel alloc]init];
        lblChat.tag = indexPath.row + 2000;
        [lblChat setFont:[UIFont fontWithName:@"ArialMT" size:16.0f]];
        [lblChat setBackgroundColor:[UIColor clearColor]];
        [lblChat setNumberOfLines:0];
        [lblChat setText:strMessageChat];
        [lblChat setTextColor:[UIColor blackColor]];
        [lblChat setTextAlignment:NSTextAlignmentLeft];
        [lblChat setLineBreakMode:NSLineBreakByWordWrapping];
        [cell.contentView addSubview:lblChat];
        
        CGFloat strheightMsgChat = [self CalculateStringSize:strMessageChat];
        [lblChat setFrame:CGRectMake(90, 7 + strheight + 3, width,strheightMsgChat)];
    }
    else
    {
        UILabel *lblChat = (UILabel*)[cell viewWithTag:indexPath.row + 2000];
        if (lblChat)
        {
            [lblChat removeFromSuperview];
        }
    }
    
    UIImage *image = [UIImage imageNamed:@"arrow.png"];
    UIButton *buttonEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, 25, 25);
    buttonEdit.frame = frame;
    [buttonEdit setImage:image forState:UIControlStateNormal];
    [buttonEdit addTarget:self action:@selector(checkBtnTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    buttonEdit.tag = indexPath.row;
    cell.editingAccessoryView = buttonEdit;
    
    cell.editing = YES;

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([AppDel.deckController rightControllerIsOpen])
    {
        [AppDel.deckController closeRightView];
        return;
    }

    if ([[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"fadeDate"] isEqualToString:@"0000-00-00"])
    {
        AppDel.strTaskId = [NSString stringWithFormat:@"%@",[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"taskId"]];
        [AppDel.deckController toggleRightView];
        /*EditTaskViewCtr *obj_EditTaskViewCtr = [[EditTaskViewCtr alloc]initWithNibName:@"EditTaskViewCtr" bundle:nil];
        [self.navigationController pushViewController:obj_EditTaskViewCtr animated:YES];*/
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *someText = [[NSString stringWithFormat:@"%@",[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"description"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    CGFloat height = [self CalculateStringSize:someText];
    
    NSString *strMessageChat = [GlobalMethods GetMessagesFromTaskId:[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"taskId"]];
    
    CGFloat heightChat = [self CalculateStringSize:strMessageChat];
    

    /*NSString *strAssignID = [[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"assignedId"];
    NSString *strTaskCategoryType = [[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"taskCategoryType"];
    NSDictionary *dicAssign = [GlobalMethods GetContactName:strAssignID TaskCategoryType:strTaskCategoryType];
    if (![[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"dueDate"] isEqualToString:@"0000-00-00"])
    {
        if (chatindex.section == indexPath.section && chatindex.row == indexPath.row && Selected)
        {
            height = height + 30 + heightChat + 6;
        }
        else
        {
            height = height + 30;
        }
    }
    else if ([[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"reminderId"] intValue] != 0)
    {
        if (chatindex.section == indexPath.section && chatindex.row == indexPath.row && Selected)
        {
            height = height + 30 + heightChat + 6;
        }
        else
        {
            height = height + 30;
        }
    }
    else if (![[dicAssign valueForKey:@"Responsible"] isEqualToString:@"You"])
    {
        if (chatindex.section == indexPath.section && chatindex.row == indexPath.row && Selected)
        {
            height = height + 30 + heightChat + 6;
        }
        else
        {
            height = height + 30;
        }
    }
    else
    {*/
        if (chatindex.section == indexPath.section && chatindex.row == indexPath.row && Selected)
        {
            height = height + 7 + heightChat + 6;
        }
        else
        {
            height = height + 10;
        }
    //}
    
    if (height < 45)
    {
        return 44;
    }
    else
    {
        return height;
    }
    
}

-(CGFloat)CalculateStringSize:(NSString*)strText
{
    NSString *someText = [NSString stringWithFormat:@"%@",strText];
    
    CGSize constraintSize;
    constraintSize.width = 440;
    if (OrientationFlag == 0)
        constraintSize.width = 440;
    else
        constraintSize.width = 696;
    
    constraintSize.height = MAXFLOAT;
    CGSize stringSize = [someText sizeWithFont: [UIFont fontWithName:@"ArialMT" size:16.0f] constrainedToSize: constraintSize lineBreakMode: NSLineBreakByWordWrapping];
    
    return stringSize.height;
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}
- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
   /* [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    
    UITableViewCell *cell = (UITableViewCell*)[tbl_Tasks cellForRowAtIndexPath:indexPath];
    UILabel *lbl = (UILabel*)[cell viewWithTag:indexPath.row + 1000];
    lbl.alpha = 0.4f;
    [UIView commitAnimations];*/
    
    return NO;
}

/*- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}*/
-(IBAction)btnCompleteTaskPressed:(id)sender
{
    UIButton *btnComplete = (UIButton*)sender;
    if (btnComplete.isSelected)
    {
        [btnComplete setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        [btnComplete setSelected:NO];
        
        NSString *strQueryDelete = [NSString stringWithFormat:@"update tbl_tasks Set fadeDate='0000-00-00' Where taskId=%d",[[[ArryTasks objectAtIndex:btnComplete.tag] valueForKey:@"taskId"] intValue]];
        [DatabaseAccess updatetbl:strQueryDelete];
        
        NSString *strQueryGetFadeDate = [NSString stringWithFormat:@"SELECT * FROM tbl_add_fadedate Where taskId=%d",[[[ArryTasks objectAtIndex:btnComplete.tag] valueForKey:@"taskId"] intValue]];
        NSMutableArray *ArryFadeDate = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_add_fadedate:strQueryGetFadeDate]];
        
        if ([ArryFadeDate count] != 0)
        {
            NSString *strQueryUpdateFadeDate = [NSString stringWithFormat:@"update tbl_add_fadedate Set fadedate='0000-00-00' Where taskId=%d",[[[ArryTasks objectAtIndex:btnComplete.tag] valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryUpdateFadeDate];
        }
        else
        {
            NSString *strQueryInsertMessage = [NSString stringWithFormat:@"insert into tbl_add_fadedate(taskId,fadedate) values(%d,'%@')",[[[ArryTasks objectAtIndex:btnComplete.tag] valueForKey:@"taskId"] intValue],@"0000-00-00"];
            [DatabaseAccess updatetbl:strQueryInsertMessage];
        }
    }
    else
    {
        [btnComplete setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        [btnComplete setSelected:YES];
        
        //Send Data Of user setting from local databse
        NSString *strQuerySelect = @"SELECT * FROM tbl_user_setting";
        NSMutableArray *ArryretriveUserSettings = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_user_setting:strQuerySelect]];
        
        int interval = [[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"fadeOnDays"] intValue];
        NSDate *now = [NSDate date];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSDate *earlierDate = [now dateByAddingTimeInterval:(interval*24*60*60)];
        NSString *d = [format stringFromDate:earlierDate];
        
        NSString *strQueryDelete = [NSString stringWithFormat:@"update tbl_tasks Set fadeDate='%@' Where taskId=%d",d,[[[ArryTasks objectAtIndex:btnComplete.tag] valueForKey:@"taskId"] intValue]];
        [DatabaseAccess updatetbl:strQueryDelete];
        
        NSString *strQueryGetFadeDate = [NSString stringWithFormat:@"SELECT * FROM tbl_add_fadedate Where taskId=%d",[[[ArryTasks objectAtIndex:btnComplete.tag] valueForKey:@"taskId"] intValue]];
        NSMutableArray *ArryFadeDate = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_add_fadedate:strQueryGetFadeDate]];
        
        if ([ArryFadeDate count] != 0)
        {
            NSString *strQueryUpdateFadeDate = [NSString stringWithFormat:@"update tbl_add_fadedate Set fadedate='%@' Where taskId=%d",d,[[[ArryTasks objectAtIndex:btnComplete.tag] valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryUpdateFadeDate];
        }
        else
        {
            NSString *strQueryInsertMessage = [NSString stringWithFormat:@"insert into tbl_add_fadedate(taskId,fadedate) values(%d,'%@')",[[[ArryTasks objectAtIndex:btnComplete.tag] valueForKey:@"taskId"] intValue],d];
            [DatabaseAccess updatetbl:strQueryInsertMessage];
        }
    }
    ArryTasks = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_tasks:strQuery]];
    [tbl_Tasks reloadData];
    [self SetBg];
}
#pragma mark - Change Priority

-(IBAction)btnChatPressed:(id)sender
{
    if ([[[ArryTasks objectAtIndex:[sender tag]] valueForKey:@"fadeDate"] isEqualToString:@"0000-00-00"])
    {
        if (selectedRow == [sender tag] && Selected)
        {
            Selected = NO;
        }
        else
        {
            Selected = YES;
        }
        selectedRow = [sender tag];
        
        chatindex = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
        [tbl_Tasks reloadData];
        [self SetBg];
    }
}

-(IBAction)btnAddTaskPressed:(id)sender
{
    AppDel.strTaskId = @"";
    [AppDel.deckController toggleRightView];
}

-(IBAction)btnPriorityChanged:(id)sender
{
    UIButton *btnpriority = (UIButton*)sender;
    // Set Assigned Values
    /*NSDictionary *dicAssign = [GlobalMethods GetContactName:[[ArryTasks objectAtIndex:btnpriority.tag] valueForKey:@"assignedId"] TaskCategoryType:[[ArryTasks objectAtIndex:btnpriority.tag] valueForKey:@"taskCategoryType"]];
     BOOL CallOrNot = [[dicAssign valueForKey:@"BtnUserInt"] boolValue];
     
     if (CallOrNot)
     {*/
    int  Priorityid = [[[ArryTasks objectAtIndex:btnpriority.tag] valueForKey:@"priority"] intValue];
    if (Priorityid == 2)
        Priorityid = 0;
    else
        Priorityid ++;
    
    if (Priorityid == 0)
    {
        [btnpriority setImage:[UIImage imageNamed:@"star_low.png"] forState:UIControlStateNormal];
    }
    else if (Priorityid == 1)
    {
        [btnpriority setImage:[UIImage imageNamed:@"star_med.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnpriority setImage:[UIImage imageNamed:@"star_high.png"] forState:UIControlStateNormal];
    }
    
    NSString *strPriorityId = [NSString stringWithFormat:@"%d",Priorityid];
    NSString *strTaskId = [NSString stringWithFormat:@"%@",[[ArryTasks objectAtIndex:btnpriority.tag] valueForKey:@"taskId"]];
    NSDictionary *dicWithObj = [NSDictionary dictionaryWithObjectsAndKeys:strPriorityId,@"Priorityid",strTaskId,@"taskId", nil];
    [self performSelector:@selector(btnChangePriorityStarDB:) withObject:dicWithObj afterDelay:1.0];
    //  }
}
-(void)btnChangePriorityStarDB:(NSDictionary*)dic
{
    NSString *strQueryUpdateTaskReminder = [NSString stringWithFormat:@"update tbl_tasks Set priority=%d,taskstatus=2 Where taskId=%d",[[dic valueForKey:@"Priorityid"] intValue],[[dic valueForKey:@"taskId"] intValue]];
    [DatabaseAccess updatetbl:strQueryUpdateTaskReminder];
    ArryTasks = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_tasks:strQuery]];
    [tbl_Tasks reloadData];
    [self SetBg];

}

// Set Button According to Task Assign
-(void)HideShowButton:(UIColor*)color Delete:(BOOL)deleteValue Archieve:(BOOL)archieveValue Message:(BOOL)messageValue CallBack:(BOOL)callbackValue GiveBack:(BOOL)givebackValue
{
    btnDelete.hidden = deleteValue;
    btnArchieve.hidden = archieveValue;
    btnMessage.hidden = messageValue;
    btnCallBack.hidden = callbackValue;
    btnGiveBack.hidden = givebackValue;
}
#pragma mark - IBAction Methods

- (void)checkBtnTapped:(id)sender event:(id)event
{
    NSString *strTaskId = [NSString stringWithFormat:@"%@",[[ArryTasks objectAtIndex:[sender tag]] valueForKey:@"taskId"]];
    NSString *strQueryTask = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where taskId=%d",[strTaskId intValue]];
    NSMutableArray *ArryTask = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQueryTask]];
    DicTask = [ArryTask objectAtIndex:0];
    
    // Set Assigned Values
    NSDictionary *dicAssign = [GlobalMethods GetContactName:[DicTask valueForKey:@"assignedId"] TaskCategoryType:[DicTask valueForKey:@"taskCategoryType"]];
    [self HideShowButton:[dicAssign valueForKey:@"Color"] Delete:[[dicAssign valueForKey:@"Delete"] boolValue] Archieve:[[dicAssign valueForKey:@"Archieve"] boolValue] Message:[[dicAssign valueForKey:@"Message"] boolValue] CallBack:[[dicAssign valueForKey:@"CallBack"] boolValue] GiveBack:[[dicAssign valueForKey:@"GiveBack"] boolValue]];
    
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	currentTouchPosition = [touch locationInView:tbl_Tasks];
    
    if (![obj_popOver isPopoverVisible])
    {
        obj_popOver = [[UIPopoverController alloc] initWithContentViewController:View_EditTask];
       // obj_popOver.popoverBackgroundViewClass = [KSCustomPopoverBackgroundView class];
        [obj_popOver setPopoverContentSize:CGSizeMake(280, 150) animated:YES];
        [obj_popOver presentPopoverFromRect:CGRectMake(currentTouchPosition.x-15, currentTouchPosition.y-11, 22, 22) inView:tbl_Tasks permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
}
-(IBAction)btnDeleteTaskViewCtr:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"Do you want to Delete this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete",nil];
    alert.tag = 1;
    [alert show];
    
}
-(IBAction)btnArchievPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"Do you want to Archive this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Archive",nil];
    alert.tag = 2;
    [alert show];
}
-(IBAction)btnMessagePressed:(id)sender
{
    UIAlertView *avWithTxtView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send",nil];
    
    txtMesage = [[UITextView alloc] initWithFrame:CGRectMake(12, 50, 260,100)];
    [txtMesage setTextAlignment:NSTextAlignmentLeft];
    [txtMesage setFont:[UIFont fontWithName:@"ArialMT" size:16.0]];
    [txtMesage setEditable:YES];
    txtMesage.layer.borderWidth = 2.0f;
    txtMesage.layer.borderColor = [[UIColor clearColor] CGColor];
    txtMesage.layer.cornerRadius = 5.0;
    txtMesage.keyboardType=UIKeyboardTypeDefault;
    [txtMesage becomeFirstResponder];
    [avWithTxtView addSubview:txtMesage];
    [avWithTxtView setTag:3];
    [avWithTxtView show];
}
-(IBAction)btnCallBackPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"Do you want to Callback this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Callback",nil];
    alert.tag = 4;
    [alert show];
}
-(IBAction)btnGiveBackPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"Do you want to Giveback this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Giveback",nil];
    alert.tag = 5;
    [alert show];
}
-(IBAction)btnCancelPressed:(id)sender
{
    [self DismissPopOver];
}
-(IBAction)btnEditList:(id) sender
{
	if ([tbl_Tasks isEditing])
	{
		[tbl_Tasks setEditing:NO animated:YES];
	}
	else
	{
		[tbl_Tasks setEditing:YES animated:YES];
	}
}
-(void)DismissPopOver
{
    if ([obj_popOver isPopoverVisible])
    {
        [obj_popOver dismissPopoverAnimated:YES];
    }
}

-(IBAction)btnSettingsPressed:(id)sender
{
    if (![obj_popOver_Setting isPopoverVisible])
    {
        SettingsViewCtr *obj_SettingsViewCtr = [[SettingsViewCtr alloc]initWithNibName:@"SettingsViewCtr" bundle:nil];
        UINavigationController *obj_nav = [[UINavigationController alloc]initWithRootViewController:obj_SettingsViewCtr];
        obj_popOver_Setting = [[UIPopoverController alloc] initWithContentViewController:obj_nav];
       // obj_popOver_Setting.popoverBackgroundViewClass = [KSCustomPopoverBackgroundView class];
        [obj_popOver_Setting setPopoverContentSize:CGSizeMake(320, 444) animated:YES];
        [obj_popOver_Setting presentPopoverFromRect:CGRectMake(self.view.center.x,self.view.center.y, 10, 10) inView:self.view permittedArrowDirections:0 animated:YES];
    }
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
            
            NSString *strQueryMsgDelete = [NSString stringWithFormat:@"DELETE FROM tbl_messages where taskId=%d",[[DicTask valueForKey:@"taskId"] intValue]];
            [DatabaseAccess updatetbl:strQueryMsgDelete];
            
            ArryTasks = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_tasks:strQuery]];
            [tbl_Tasks reloadData];
            [self SetBg];
            [self DismissPopOver];
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
            
            ArryTasks = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_tasks:strQuery]];
            [tbl_Tasks reloadData];
            [self SetBg];
            [self DismissPopOver];
        }
    }
    else if (alertView.tag == 3)
    {
        if (buttonIndex == 0)
        {
            return;
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
                
                NSString *strQueryInsertMsg = [NSString stringWithFormat:@"insert into tbl_messages(messageId,messageDescription,messageType,recieverId,senderId,taskId) values(%d,'%@','%@',%d,%d,%d)",messageID,txtMesage.text,@"OUTBOX",RecieverUserID,SenderUserID,[[DicTask valueForKey:@"taskId"] intValue]];
                [DatabaseAccess updatetbl:strQueryInsertMsg];
            }
            
        }
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
            
            ArryTasks = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_tasks:strQuery]];
            [tbl_Tasks reloadData];
            [self SetBg];
            [self DismissPopOver];
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
            
            ArryTasks = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_tasks:strQuery]];
            [tbl_Tasks reloadData];
            [self SetBg];
            [self DismissPopOver];
        }
    }
}

/*-(IBAction)btnShowHideMaster:(id)sender
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
    {
        [self ShowHideViews];
    }
}
-(IBAction)btnAddNewtaskPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RightViewShow" object:nil userInfo:nil];
}
-(void)ShowHideViews
{
    if (AppDel.masterIsVisible)
    {
        AppDel.masterIsVisible = NO;
        [self showMasterView:@"no"];
    }
    else
    {
        AppDel.masterIsVisible = YES;
        [self showMasterView:@"yes"];
    }
}
- (void)showMasterView:(NSString*)Value
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftViewShow" object:Value userInfo:nil];
}*/

#pragma mark - UIInterfaceOrientation For iOS < 6

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        AppDel.deckController.leftLedge = 448;
        AppDel.deckController.rightLedge = 448;
        OrientationFlag = 0;
        
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        AppDel.deckController.leftLedge = 704;
        AppDel.deckController.rightLedge = 704;
        OrientationFlag = 1;
    }
    [tbl_Tasks reloadData];
    [self SetBg];

    if ([obj_popOver isPopoverVisible])
    {
        if (OrientationFlag == 0)
        {
            currentTouchPosition.x = currentTouchPosition.x - 256;
            [obj_popOver presentPopoverFromRect:CGRectMake(currentTouchPosition.x-15, currentTouchPosition.y-11, 22, 22) inView:tbl_Tasks permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        }
        else
        {
            currentTouchPosition.x = currentTouchPosition.x + 256;
            [obj_popOver presentPopoverFromRect:CGRectMake(currentTouchPosition.x-15, currentTouchPosition.y-11, 22, 22) inView:tbl_Tasks permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        }
    }
    
    if ([obj_popOver_Setting isPopoverVisible])
    {
        [obj_popOver_Setting presentPopoverFromRect:CGRectMake(self.view.center.x,self.view.center.y, 10, 10) inView:self.view permittedArrowDirections:0 animated:YES];
    }
}
#pragma mark - CallSync Methods

-(IBAction)btnSyncPressed:(id)sender
{
    if ([AppDel checkConnection])
    {
        SyncClass *obj_SyncClass = [[SyncClass alloc]init];
        [obj_SyncClass CallSync:@"YES"];
    }
    else
    {
        DisplayAlertWithTitle(App_Name, @"You are not connected to internet connection.");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
