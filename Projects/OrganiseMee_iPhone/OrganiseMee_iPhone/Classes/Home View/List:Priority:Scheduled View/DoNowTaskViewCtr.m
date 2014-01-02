//
//  DoNowViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by apple on 2/20/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "DoNowTaskViewCtr.h"
#import "TaskEditViewCtr.h"
#import "DatabaseAccess.h"
#import "NewTaskViewCtr.h"
#import "Header.h"
#import "TTTAttributedLabel.h"
#import "GlobalMethods.h"

@interface DoNowTaskViewCtr ()

@end

@implementation DoNowTaskViewCtr

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
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    localizationDict = [[NSMutableDictionary alloc] init];
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"settingVC"];
        lblDoNow.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbldonow"]];
    }
    

    // Get Task list Acoording to Do Now Settings
    // Do any additional setup after loading the view from its nib.
}
-(void)GetTaskList
{
    
    NSString *strDoNow = [[NSUserDefaults standardUserDefaults] stringForKey:@"DoNowSetting"];
    NSArray *Arry = [strDoNow componentsSeparatedByString:@","];
    
    NSString *strPriority = @"";
    NSString *strDueDate =@"";
    
    //For Priority
    if ([Arry containsObject:@"1"] && [Arry containsObject:@"2"])
    {
        strPriority = @"(priority=2 or priority=1)";
    }
    else if ([Arry containsObject:@"1"])
    {
        strPriority = @"priority=2";
    }
    else if ([Arry containsObject:@"2"])
    {
        strPriority = @"priority=1";
    }
    else
    {
        strPriority = @"priority>=-1";
    }
    
    //For Due Date
    NSDate *now = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *d = [format stringFromDate:now];
    if ([Arry containsObject:@"3"] && [Arry containsObject:@"4"] && [Arry containsObject:@"5"])
    {
        NSDate *earlierDate = [now dateByAddingTimeInterval:(3*24*60*60)];
        NSString *d1 = [format stringFromDate:earlierDate];
        strDueDate = [NSString stringWithFormat:@"or (dueDate >='%@' and dueDate <='%@')",d,d1];
    }
    else if ([Arry containsObject:@"3"] && [Arry containsObject:@"4"])
    {
        NSDate *earlierDate = [now dateByAddingTimeInterval:(2*24*60*60)];
        NSString *d1 = [format stringFromDate:earlierDate];
        strDueDate = [NSString stringWithFormat:@"or (dueDate >='%@' and dueDate <='%@')",d,d1];
    }
    else if ([Arry containsObject:@"3"] && [Arry containsObject:@"5"])
    {
        NSDate *earlierDate = [now dateByAddingTimeInterval:(3*24*60*60)];
        NSString *d1 = [format stringFromDate:earlierDate];
        strDueDate = [NSString stringWithFormat:@"or (dueDate >='%@' and dueDate <='%@')",d,d1];
    }
    else if ([Arry containsObject:@"4"] && [Arry containsObject:@"5"])
    {
        NSDate *earlierDate = [now dateByAddingTimeInterval:(2*24*60*60)];
        NSString *d1 = [format stringFromDate:earlierDate];
        NSDate *earlierDate1 = [now dateByAddingTimeInterval:(3*24*60*60)];
        NSString *d2 = [format stringFromDate:earlierDate1];
        strDueDate = [NSString stringWithFormat:@"or (dueDate >='%@' and dueDate <='%@')",d1,d2];
    }
    else if ([Arry containsObject:@"4"])
    {
        NSDate *earlierDate = [now dateByAddingTimeInterval:(2*24*60*60)];
        NSString *d1 = [format stringFromDate:earlierDate];
        strDueDate = [NSString stringWithFormat:@"or dueDate ='%@'",d1];
    }
    else if ([Arry containsObject:@"5"])
    {
        NSDate *earlierDate = [now dateByAddingTimeInterval:(3*24*60*60)];
        NSString *d1 = [format stringFromDate:earlierDate];
        strDueDate = [NSString stringWithFormat:@"or dueDate ='%@'",d1];
    }
    else if ([Arry containsObject:@"3"])
    {
        strDueDate = [NSString stringWithFormat:@"or dueDate ='%@'",d];
    }
    else
    {
        NSDate *earlierDate = [now dateByAddingTimeInterval:(3*24*60*60)];
        NSString *d1 = [format stringFromDate:earlierDate];
        strDueDate = [NSString stringWithFormat:@"or (dueDate >='%@' and dueDate <='%@')",d,d1];
    }
    
    // Get Tasks of the Current Schedule
    NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where (%@ %@) and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",strPriority,strDueDate];
    ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateui];
}

#pragma mark - IBAction Methods
-(IBAction)btnNewTaskCreatePressed:(id)sender
{
    NewTaskViewCtr *obj_NewTaskViewCtr = [[NewTaskViewCtr alloc] initWithNibName:@"NewTaskViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_NewTaskViewCtr animated:YES];
}
-(IBAction)btnCompleteTaskPressed:(id)sender
{
    UIButton *btnComplete = (UIButton*)sender;
    if (btnComplete.isSelected)
    {
        [btnComplete setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        [btnComplete setSelected:NO];
        
        NSString *strQueryDelete = [NSString stringWithFormat:@"update tbl_tasks Set fadeDate='0000-00-00' Where taskId=%d",[[[ArryTasks objectAtIndex:btnComplete.tag] valueForKey:@"taskId"] intValue]];
        [DatabaseAccess updatetbl:strQueryDelete];
        
        NSString *strQueryInsertMessage = [NSString stringWithFormat:@"insert into tbl_add_fadedate(taskId,fadedate) values(%d,'%@')",[[[ArryTasks objectAtIndex:btnComplete.tag] valueForKey:@"taskId"] intValue],@"0000-00-00"];
        [DatabaseAccess updatetbl:strQueryInsertMessage];
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
        
        NSString *strQueryInsertMessage = [NSString stringWithFormat:@"insert into tbl_add_fadedate(taskId,fadedate) values(%d,'%@')",[[[ArryTasks objectAtIndex:btnComplete.tag] valueForKey:@"taskId"] intValue],d];
        [DatabaseAccess updatetbl:strQueryInsertMessage];
    }
    [self GetTaskList];
    [tbl_Task reloadData];
    if ([ArryTasks count] != 0)
    {
        if (tbl_Task.frame.size.height - tbl_Task.contentSize.height - 44 <= 0)
            imgbgTrans.hidden = YES;
        else
            imgbgTrans.hidden = NO;
        
        imgbgTrans.frame = CGRectMake(imgbgTrans.frame.origin.x, tbl_Task.contentSize.height + 60, imgbgTrans.frame.size.width, tbl_Task.frame.size.height - tbl_Task.contentSize.height - 44);
    }
    else if ([ArryTasks count] == 0)
    {
        imgbgTrans.hidden = NO;
        imgbgTrans.frame = CGRectMake(imgbgTrans.frame.origin.x, tbl_Task.contentSize.height + 59, imgbgTrans.frame.size.width, tbl_Task.frame.size.height - tbl_Task.contentSize.height - 42);
    }
    [tbl_Task setContentSize:CGSizeMake(tbl_Task.frame.size.width, tbl_Task.contentSize.height + 44)];

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
    [cell addSubview:imgbg];
    
    NSString *strTaskSetting = [[NSUserDefaults standardUserDefaults] stringForKey:@"TaskSetting"];
    NSMutableArray *ArryTaskSetting = [[strTaskSetting componentsSeparatedByString:@","] mutableCopy];
    
    CGFloat width = [GlobalMethods CheckIphoneAndReturnWidth:220.f Landscap5:468.0f Landscap:380.f Orientation:OrientationFlag];
    
    TTTAttributedLabel *lblDescr = [[TTTAttributedLabel alloc] init];
    lblDescr.tag = indexPath.row;
    [lblDescr setFont:[UIFont fontWithName:@"ArialMT" size:14.0f]];
    [lblDescr setBackgroundColor:[UIColor clearColor]];
    [lblDescr setNumberOfLines:0];
    [lblDescr setTextColor:[UIColor blackColor]];
    [lblDescr setTextAlignment:NSTextAlignmentLeft];
    [lblDescr setLineBreakMode:NSLineBreakByWordWrapping];
    NSString *someText = [[NSString stringWithFormat:@"%@",[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"description"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
    CGFloat strheight = [self CalculateStringSize:someText];
    [cell addSubview:lblDescr];
    
    NSString *strFadeDate = [[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"fadeDate"];
    NSString *strDueDate = [[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"dueDate"];
    UIButton *btnCompleteTask = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCompleteTask.frame = CGRectMake(0, 3, 25, 25);
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
    [cell addSubview:btnCompleteTask];
    
    UILabel *lblDate;
    if (![strDueDate isEqualToString:@"0000-00-00"] && [ArryTaskSetting containsObject:@"2"])
    {
        lblDate = [[UILabel alloc] init];
        lblDate.textColor = [UIColor darkGrayColor];
        lblDate.backgroundColor = [UIColor clearColor];
        lblDate.font = [UIFont fontWithName:@"ArialMT" size:12.0f];
        lblDate.textAlignment = NSTextAlignmentLeft;
        lblDate.lineBreakMode = NSLineBreakByWordWrapping;
        lblDate.text = [NSString stringWithFormat:@"%@",[GlobalMethods GetStringDateWithFormate:strDueDate]];
        [lblDate setFrame:CGRectMake(30, 5 + strheight + 5, 33,20)];
        [cell addSubview:lblDate];
    }
    
    UIImageView *imgPriority;
    if ([ArryTaskSetting containsObject:@"1"])
    {
        imgPriority = [[UIImageView alloc]init];
        imgPriority.image = [GlobalMethods GetImagePriority:[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"priority"]];
        imgPriority.contentMode = UIViewContentModeScaleToFill;
        imgPriority.frame = CGRectMake(width + 35, 3, 25, 25);
        [cell addSubview:imgPriority];
    }
    
    UIImageView *imgReminder_icon;
    if ([[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"reminderId"] intValue] != 0 && [ArryTaskSetting containsObject:@"3"])
    {
        
        BOOL CheckReminder = [GlobalMethods CheckReminderSetOrNot:[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"reminderId"]];
        if (CheckReminder) {
            imgReminder_icon = [[UIImageView alloc]init];
            imgReminder_icon.image = [UIImage imageNamed:@"r_clock.png"];
            imgReminder_icon.contentMode = UIViewContentModeScaleToFill;
            if (![strDueDate isEqualToString:@"0000-00-00"] && [ArryTaskSetting containsObject:@"2"])
            {
                [imgReminder_icon setFrame:CGRectMake(width + 12, 5 + strheight + 7, 15,15)];
            }
            else
            {
                [imgReminder_icon setFrame:CGRectMake(width + 12, 5 + strheight + 7, 15,15)];
            }
            [cell addSubview:imgReminder_icon];
        }
    }
    
    // Set Assigned Values
    NSString *strAssignID = [[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"assignedId"];
    NSString *strTaskCategoryType = [[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"taskCategoryType"];
    NSDictionary *dicAssign = [GlobalMethods GetContactName:strAssignID TaskCategoryType:strTaskCategoryType];
    UILabel *lblResponsible;
    if ([ArryTaskSetting containsObject:@"4"] && ![[dicAssign valueForKey:@"Responsible"] isEqualToString:@"You"])
    {
        lblResponsible = [[UILabel alloc] init];
        lblResponsible.textColor = [dicAssign valueForKey:@"Color"];
        lblResponsible.backgroundColor = [UIColor clearColor];
        lblResponsible.font = [UIFont fontWithName:@"ArialMT" size:12.0f];
        lblResponsible.textAlignment = NSTextAlignmentLeft;
        lblResponsible.text = [NSString stringWithFormat:@"%@",[dicAssign valueForKey:@"Responsible"]];
        [lblResponsible setFrame:CGRectMake(93, 5 + strheight + 5, width - 85,20)];
        [cell addSubview:lblResponsible];
    }
    
    [lblDescr setFrame:CGRectMake(30, 5, width,strheight)];
    if (![ArryTaskSetting containsObject:@"1"])
    {
        [lblDescr setFrame:CGRectMake(30, 5, width + 30,strheight)];
    }
    [lblDescr sizeToFit];
    // }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"fadeDate"] isEqualToString:@"0000-00-00"])
    {
        TaskEditViewCtr *obj_TaskEditViewCtr = [[TaskEditViewCtr alloc]initWithNibName:@"TaskEditViewCtr" bundle:nil];
        obj_TaskEditViewCtr.strTaskId = [NSString stringWithFormat:@"%@",[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"taskId"]];
        [self.navigationController pushViewController:obj_TaskEditViewCtr animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *someText = [[NSString stringWithFormat:@"%@",[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"description"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
    
    CGFloat height = [self CalculateStringSize:someText];
    
    NSString *strTaskSetting = [[NSUserDefaults standardUserDefaults] stringForKey:@"TaskSetting"];
    NSMutableArray *ArryTaskSetting = [[strTaskSetting componentsSeparatedByString:@","] mutableCopy];
    
   /* if (![[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"dueDate"] isEqualToString:@"0000-00-00"])
    {
        if ([ArryTaskSetting containsObject:@"2"])
        {
            height = height + 30;
        }
        else
        {
            height = height + 5;
        }
    }
    else
    {
        height = height + 30;
    }
    
    if (height < 45)
    {
        return 44;
    }
    else
    {
        return height;
    }*/

    // Set Assigned Values
    NSString *strAssignID = [[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"assignedId"];
    NSString *strTaskCategoryType = [[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"taskCategoryType"];
    NSDictionary *dicAssign = [GlobalMethods GetContactName:strAssignID TaskCategoryType:strTaskCategoryType];
    if (![[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"dueDate"] isEqualToString:@"0000-00-00"] && [ArryTaskSetting containsObject:@"2"])
    {
        height = height + 30;
    }
    else if ([[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"reminderId"] intValue] != 0 && [ArryTaskSetting containsObject:@"3"])
    {
        height = height + 30;
    }
    else if ([ArryTaskSetting containsObject:@"4"] && ![[dicAssign valueForKey:@"Responsible"] isEqualToString:@"You"])
    {
        height = height + 30;
    }
    else
    {
        if ([GlobalMethods CheckPhoneVersionisiOS7])
            height = height + 10;
        else
            height = height + 5;
    }
    
    if (height < 33)
    {
        return 33;
    }
    else
    {
        return height;
    }
}

-(CGFloat)CalculateStringSize:(NSString*)strText
{
    NSString *someText = [NSString stringWithFormat:@"%@",strText];
	
    CGFloat PWidth,LWidth5,LWidth;
    PWidth =  220.0f;
    LWidth5 = 468.0f;
    LWidth = 380.0f;
    NSString *strTaskSetting = [[NSUserDefaults standardUserDefaults] stringForKey:@"TaskSetting"];
    NSMutableArray *ArryTaskSetting = [[strTaskSetting componentsSeparatedByString:@","] mutableCopy];
    if (![ArryTaskSetting containsObject:@"1"])
    {
        PWidth =  PWidth + 30.0f;
        LWidth5 = LWidth5 + 30.0f;
        LWidth = LWidth + 30.0f;
    }
    
    CGSize constraintSize;
    constraintSize.width = [GlobalMethods CheckIphoneAndReturnWidth:PWidth Landscap5:LWidth5 Landscap:LWidth Orientation:OrientationFlag];
    
    constraintSize.height = MAXFLOAT;
    CGSize stringSize = [someText sizeWithFont: [UIFont fontWithName:@"ArialMT" size:14.0f] constrainedToSize: constraintSize lineBreakMode: UILineBreakModeWordWrap];
    
    return stringSize.height;
}

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
        OrientationFlag = 0;
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        OrientationFlag = 1;
    }
    [self GetTaskList];

    [tbl_Task reloadData];
    if ([ArryTasks count] != 0)
    {
        if (tbl_Task.frame.size.height - tbl_Task.contentSize.height - 44 <= 0)
            imgbgTrans.hidden = YES;
        else
            imgbgTrans.hidden = NO;
        
        imgbgTrans.frame = CGRectMake(imgbgTrans.frame.origin.x, tbl_Task.contentSize.height + 60, imgbgTrans.frame.size.width, tbl_Task.frame.size.height - tbl_Task.contentSize.height - 44);
    }
    else if ([ArryTasks count] == 0)
    {
        imgbgTrans.hidden = NO;
        imgbgTrans.frame = CGRectMake(imgbgTrans.frame.origin.x, tbl_Task.contentSize.height + 59, imgbgTrans.frame.size.width, tbl_Task.frame.size.height - tbl_Task.contentSize.height - 42);
    }
    [tbl_Task setContentSize:CGSizeMake(tbl_Task.frame.size.width, tbl_Task.contentSize.height + 44)];
    
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
