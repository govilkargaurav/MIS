//
//  ListViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by apple on 2/8/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "ListViewCtr.h"
#import "DatabaseAccess.h"
#import "NewTaskViewCtr.h"
#import "TaskEditViewCtr.h"
#import "TTTAttributedLabel.h"
#import "GlobalMethods.h"
#import "AppDelegate.h"

@interface ListViewCtr ()

@end

@implementation ListViewCtr
@synthesize strFromView;

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
    
    if ([strFromView isEqualToString:@"List"])
    {
        // Get List From Local DB From List View
        NSString *strQuerySelect = @"SELECT * FROM tbl_lists where listCategory=1 and liststatus!=3";
        ArryLists = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_lists:strQuerySelect]];
    }
    else if ([strFromView isEqualToString:@"Priority"])
    {
        PriorityIndex = 2;
        // Set List From Priority View
        UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
        if ([UserLanguage isEqualToString:@"de"]) {
            ArryLists = [[NSMutableArray alloc]initWithObjects:@"Hohe Priorität",@"Mittlere Priorität",@"Niedrige Priorität", nil];
        }else{
            ArryLists = [[NSMutableArray alloc]initWithObjects:@"High",@"Medium",@"Low", nil];
        }
        
    }
    else if ([strFromView isEqualToString:@"Scheduled"])
    {
        //Send Data Of user setting from local databse
        NSString *strQuerySelect = @"SELECT * FROM tbl_user_setting";
        NSMutableArray *ArryretriveUserSettings = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_user_setting:strQuerySelect]];
        NSString *strDueDates = [NSString stringWithFormat:@"%@",[[ArryretriveUserSettings objectAtIndex:0]valueForKey:@"dueDates"]];
        // Set List From Priority View
        ArryLists = [[NSMutableArray alloc]init];
        ArryLists = [[strDueDates componentsSeparatedByString:@","] mutableCopy];
    }
    ListIndex = 0;

    // Lang Data Get n Display
    
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"EmptyTaksListMessage"];
        Btncancel.title = [NSString stringWithFormat:@"%@",@"Cancel"];
        BtnDone.title = [NSString stringWithFormat:@"%@",@"Ok"];
        BtnDeleteDueDate.title = [NSString stringWithFormat:@"%@",@"Termin löschen"];
    }
    else
    {
        AppDel.langDict = [mainDict objectForKey:@"en"];
        localizationDict = [AppDel.langDict objectForKey:@"EmptyTaksListMessage"];
    }
    
    [lblMessage setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14.0f]];
    
    
    // Set Right Gesture
    UISwipeGestureRecognizer* swipRightObj = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeToPreviousPage:)];
    swipRightObj.delegate = self;
    swipRightObj.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipRightObj];
    
    // Set Left Gesture
    UISwipeGestureRecognizer* swipLeftObj = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeToNextPage:)];
    swipLeftObj.delegate = self;
    swipLeftObj.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipLeftObj];
    
    //Date Picker
    
    DatepickerView.minimumDate = [NSDate date];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateui];
    DatetoolBar.alpha = 0.0;
    DatepickerView.alpha = 0.0;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)GetTaskOfCurrentList
{
    lblMessage.hidden = YES;
    imgLogo.hidden = YES;
    tbl_List.hidden = NO;
    
    // Set Current Page & No of pages of the Page Control
    PageList.numberOfPages = [ArryLists count];
    PageList.currentPage = ListIndex;
    
    // Set PageControl Color to Current Page and Number of pages
    PageList.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:1.0f];
	PageList.currentPageIndicatorTintColor = [UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    if ([strFromView isEqualToString:@"List"])
    {
        // Set Label Heading list From List View
        lblListHeading.text = [NSString stringWithFormat:@"%@",[[ArryLists objectAtIndex:ListIndex]valueForKey:@"listName"]];
        
        // Get Tasks of the Current List
        NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where listId=%d and taskCategoryType!='ARCHIEVE' and taskstatus!=3",[[[ArryLists objectAtIndex:ListIndex]valueForKey:@"listId"] intValue]];
        ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
        
        if ([ArryTasks count] == 0)
        {
            lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Eachtasklist"]];
        }
    }
    else if ([strFromView isEqualToString:@"Priority"])
    {
        // Set Label Heading list From Priority View
        //lblListHeading.text = [NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]];
        
        if ([UserLanguage isEqualToString:@"de"]) {
            if ([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"today"]) {
                lblListHeading.text = @"Heute";
            }else if([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"next2days"]){
                lblListHeading.text = @"In 2 Tagen";
            }else if ([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"next3days"]){
                lblListHeading.text = @"In 3 Tagen";
            }else if ([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"overdue"]){
                lblListHeading.text = @"Überfällig";
            }else{
                lblListHeading.text = [NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]];
            }
        }else{
            
            lblListHeading.text = [NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]];
        }
        
        NSString *strPriority;
        if (PriorityIndex == 0)
        {
            strPriority = @"(priority=0 or priority=3 or priority=-1)";
        }
        else
        {
            strPriority = [NSString stringWithFormat:@"priority=%d",PriorityIndex];
        }
        // Get Tasks of the Current List
        NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where %@ and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",strPriority];
        ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
        
        if ([ArryTasks count] == 0 && PriorityIndex == 0)
        {
            lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Prioritylow"]];
        }
        else if ([ArryTasks count] == 0 && PriorityIndex == 1)
        {
            lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Prioritymedium"]];
        }
        else if ([ArryTasks count] == 0 && PriorityIndex == 2)
        {
            lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Priorityhigh"]];
        }
    }
    else if ([strFromView isEqualToString:@"Scheduled"])
    {        
        // Set Label Heading list From Priority View
         //= [];
        if ([UserLanguage isEqualToString:@"de"]) {
            if ([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"today"]) {
                lblListHeading.text = @"Heute";
            }else if([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"next2days"]){
                lblListHeading.text = @"Nächste 2 Tagen";
            }else if ([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"next3days"]){
                lblListHeading.text = @"Nächste 3 Tagen";
            }else if ([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"next7days"]){
                lblListHeading.text = @"Nächste 7 Tagen";
            }else if ([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"next10days"]){
                lblListHeading.text = @"Nächste 10 Tagen";
            }else if ([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"next14days"]){
                lblListHeading.text = @"Nächste 14 Tagen";
            }else if ([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"thisweek"]){
                lblListHeading.text = @"Diese Woche";
            }else if ([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"nextweek"]){
                lblListHeading.text = @"Nächste Woche";
            }else if ([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"thismonth"]){
                lblListHeading.text = @"Diesen Monat";
            }else if ([[NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]] isEqualToString:@"overdue"]){
                lblListHeading.text = @"Überfällig";
            }else{
                lblListHeading.text = [NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]];
            }
        }else{
            
            lblListHeading.text = [NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]];
        }
        NSDate *now = [NSDate date];
        NSDate *today = [[NSDate alloc] init];
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        // Get the weekday component of the current date
        NSDateComponents *weekdayComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
        /*
         Create a date components to represent the number of days to subtract from the current date.
         The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today is Sunday, subtract 0 days.)
         */
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
        NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract
                                                             toDate:today options:0];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        
        NSString *strSchedule = [NSString stringWithFormat:@"%@",[ArryLists objectAtIndex:ListIndex]];
        if ([strSchedule isEqualToString:@"today"])
        {
             NSString *d = [format stringFromDate:now];
            // Get Tasks of the Current Schedule
            NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where dueDate='%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",d];
            ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
            
            if ([ArryTasks count] == 0)
            {
                lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Duedatetoday"]];
            }
        }
        else if ([strSchedule isEqualToString:@"next2days"])
        {
            NSDate *earlierDate = [now dateByAddingTimeInterval:(2*24*60*60)];
             NSString *d = [format stringFromDate:earlierDate];
             NSString *nowDate = [format stringFromDate:now];
            
            // Get Tasks of the Current Schedule
            NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",nowDate,d];
            ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
            
            if ([ArryTasks count] == 0)
            {
                lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Duedatenext2days"]];
            }
        }
        else if ([strSchedule isEqualToString:@"next3days"])
        {
            NSDate *earlierDate = [now dateByAddingTimeInterval:(3*24*60*60)];
            NSString *d = [format stringFromDate:earlierDate];
            NSString *nowDate = [format stringFromDate:now];
        
            // Get Tasks of the Current Schedule
            NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",nowDate,d];
            ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
            
            if ([ArryTasks count] == 0)
            {
                lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Duedatenext3days"]];
            }
        }
        else if ([strSchedule isEqualToString:@"next7days"])
        {
            NSDate *earlierDate = [now dateByAddingTimeInterval:(7*24*60*60)];
            NSString *d = [format stringFromDate:earlierDate];
            NSString *nowDate = [format stringFromDate:now];
            
            // Get Tasks of the Current Schedule
            NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",nowDate,d];
            ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
            
            if ([ArryTasks count] == 0)
            {
                lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Duedatenext7days"]];
            }
        }
        else if ([strSchedule isEqualToString:@"next10days"])
        {
            NSDate *earlierDate = [now dateByAddingTimeInterval:(10*24*60*60)];
            NSString *d = [format stringFromDate:earlierDate];
            NSString *nowDate = [format stringFromDate:now];
            
            // Get Tasks of the Current Schedule
            NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",nowDate,d];
            ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
            
            if ([ArryTasks count] == 0)
            {
                lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Duedatenext10days"]];
            }
        }
        else if ([strSchedule isEqualToString:@"next14days"])
        {
            NSDate *earlierDate = [now dateByAddingTimeInterval:(14*24*60*60)];
            NSString *d = [format stringFromDate:earlierDate];
            NSString *nowDate = [format stringFromDate:now];
            
            // Get Tasks of the Current Schedule
            NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",nowDate,d];
            ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
            
            if ([ArryTasks count] == 0)
            {
                lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Duedatenext14days"]];
            }
        }
        else if ([strSchedule isEqualToString:@"thisweek"])
        {
            NSDate *EndDate = [beginningOfWeek dateByAddingTimeInterval:(6*24*60*60)];
            
            NSString *StrBeginDate = [format stringFromDate:beginningOfWeek];
            NSString *StrEndDate = [format stringFromDate:EndDate];
            
            // Get Tasks of the Current Schedule
            NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",StrBeginDate,StrEndDate];
            ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
            
            if ([ArryTasks count] == 0)
            {
                lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Duedatethisweek"]];
            }
        }
        else if ([strSchedule isEqualToString:@"nextweek"])
        {
            NSDate *StartDate = [beginningOfWeek dateByAddingTimeInterval:(7*24*60*60)];
            NSDate *EndDate = [beginningOfWeek dateByAddingTimeInterval:(13*24*60*60)];
            NSString *StrStartDate = [format stringFromDate:StartDate];
            NSString *StrEndDate = [format stringFromDate:EndDate];
            
            // Get Tasks of the Current Schedule
            NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",StrStartDate,StrEndDate];
            ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
            
            if ([ArryTasks count] == 0)
            {
                lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Duedatenextweek"]];
            }
        }
        else if ([strSchedule isEqualToString:@"thismonth"])
        {
            [weekdayComponents setDay:1];
            NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:weekdayComponents];
            NSString *StrStartDate = [format stringFromDate:firstDayOfMonthDate];
            NSRange daysRange = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:today];
            NSInteger month = [weekdayComponents month];
            NSInteger year = [weekdayComponents year];
            NSString *StrEndDate = [NSString stringWithFormat:@"%d-%d-%d",year,month,daysRange.length];
            
            // Get Tasks of the Current Schedule
            NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",StrStartDate,StrEndDate];
            ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
            
            if ([ArryTasks count] == 0)
            {
                lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Duedatethismonth"]];
            }
        }
        else if ([strSchedule isEqualToString:@"overdue"])
        {
            NSString *nowDate = [format stringFromDate:now];
            // Get Tasks of the Current Schedule
            NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate < '%@' and fadeDate = '0000-00-00' and duedate != '0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",nowDate];
            ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
            
            if ([ArryTasks count] == 0)
            {
                lblMessage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"Duedateoverdue"]];
            }
        }
        else if([strSchedule isEqualToString:@"all"])
        {
            NSString *strQuerySelect = @"SELECT * FROM tbl_tasks where taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3";
            ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
        }
    }
    
    if ([ArryTasks count] == 0)
    {
        lblMessage.hidden = NO;
        imgbgTrans.hidden = NO;
        imgLogo.hidden = NO;
        tbl_List.hidden = YES;
    }
    
    [tbl_List reloadData];
    if ([ArryTasks count] != 0)
    {
        if (tbl_List.frame.size.height - tbl_List.contentSize.height - 44 <= 0)
            imgbgTrans.hidden = YES;
        else
            imgbgTrans.hidden = NO;

        imgbgTrans.frame = CGRectMake(imgbgTrans.frame.origin.x, tbl_List.contentSize.height + 72, imgbgTrans.frame.size.width, tbl_List.frame.size.height - tbl_List.contentSize.height - 44);
    }
    else if ([ArryTasks count] == 0)
    {
        imgbgTrans.hidden = NO;
        imgbgTrans.frame = CGRectMake(imgbgTrans.frame.origin.x, tbl_List.contentSize.height + 71, imgbgTrans.frame.size.width, tbl_List.frame.size.height - tbl_List.contentSize.height - 42);
    }
    
    [tbl_List setContentSize:CGSizeMake(tbl_List.frame.size.width, tbl_List.contentSize.height + 44)];
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
    [self GetTaskOfCurrentList];
}

#pragma mark - Left Gesture Method
-(void)SwipeToNextPage:(UISwipeGestureRecognizer *)swipe
{
    
    if (ListIndex < [ArryLists count]-1)
    {
        ListIndex++;
        PriorityIndex --;
        PageList.currentPage = ListIndex;
        [self GetTaskOfCurrentList];
    }
}

#pragma mark - Right Gesture Method
-(void)SwipeToPreviousPage:(UISwipeGestureRecognizer *)swipe
{
    if (ListIndex > 0)
    {
        ListIndex--;
        PriorityIndex ++;
        PageList.currentPage = ListIndex;
        [self GetTaskOfCurrentList];
    }
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
   /* UIButton *btnDate;
    if (![strDueDate isEqualToString:@"0000-00-00"] && [ArryTaskSetting containsObject:@"2"])
    {
        btnDate = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDate setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btnDate.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:14.0f];
        btnDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnDate setTitle:[NSString stringWithFormat:@"%@",[GlobalMethods GetStringDateWithFormate:strDueDate]] forState:UIControlStateNormal];
        [btnDate setFrame:CGRectMake(30, 5 + strheight + 5, 102,20)];
        [btnDate addTarget:self action:@selector(btnDateChange:) forControlEvents:UIControlEventTouchUpInside];
        btnDate.tag = indexPath.row;
        [cell addSubview:btnDate];
    }*/
    
   /* UIImageView *imgPriority;
    if ([ArryTaskSetting containsObject:@"1"])
    {
        imgPriority = [[UIImageView alloc]init];
        imgPriority.image = [GlobalMethods GetImagePriority:[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"priority"]];
        imgPriority.contentMode = UIViewContentModeScaleToFill;
        imgPriority.frame = CGRectMake(width + 35, 3, 25, 25);
        [cell addSubview:imgPriority];
    }*/
    UIButton *btnPriority;
    if ([ArryTaskSetting containsObject:@"1"])
    {
        btnPriority = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imgPriority = [GlobalMethods GetImagePriority:[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"priority"]];
        [btnPriority setImage:imgPriority forState:UIControlStateNormal];
        btnPriority.frame = CGRectMake(width + 35, 3, 25, 25);
        btnPriority.tag = indexPath.row;
        [btnPriority addTarget:self action:@selector(btnPriorityChanged:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnPriority];
    }
    
    UIImageView *imgReminder_icon;
    if ([[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"reminderId"] intValue] != 0 && [ArryTaskSetting containsObject:@"3"])
    {
        BOOL CheckReminder = [GlobalMethods CheckReminderSetOrNot:[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"reminderId"]];
        if (CheckReminder)
        {
            imgReminder_icon = [[UIImageView alloc]init];
            imgReminder_icon.image = [UIImage imageNamed:@"r_clock.png"];
            imgReminder_icon.contentMode = UIViewContentModeScaleToFill;
            if (![strDueDate isEqualToString:@"0000-00-00"] && [ArryTaskSetting containsObject:@"2"])
            {
                // Code Change By Chirag 235 X axis
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
        lblResponsible.font = [UIFont fontWithName:@"ArialMT" size:14.0f];
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
    
    /*if (![[[ArryTasks objectAtIndex:indexPath.row] valueForKey:@"dueDate"] isEqualToString:@"0000-00-00"])
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
    }*/
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

#pragma mark - Change Priority
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
    [self GetTaskOfCurrentList];

}
/*-(IBAction)btnDateChange:(id)sender
{
    UIButton *btnDate = (UIButton*)sender;
    IndexpathRow = btnDate.tag;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.50f];
    DatetoolBar.alpha = 1.0;
    DatepickerView.alpha = 1.0;
    [UIView commitAnimations];
}
#pragma mark - DatePicker Method

-(IBAction)CanclePressedDate:(id)sender
{
	[self HidePickerView];
}
-(IBAction)DonePressedDate:(id)sender
{
    if ([DatepickerView.date compare:[NSDate date]] == NSOrderedAscending)
    {
        DisplayAlertWithTitle(App_Name, @"Please select future date to set the reminder");
        return;
    }
    else
    {
        [self HidePickerView];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *StrDueDate = [NSString stringWithFormat:@"%@",[df stringFromDate:DatepickerView.date]];
        [self UpdateDate:StrDueDate];
    }
}
-(IBAction)DeleteExistingDate:(id)sender
{
    NSString *StrDueDate = @"0000-00-00";
    [self UpdateDate:StrDueDate];
    [self HidePickerView];
}
-(void)HidePickerView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.50f];
    DatetoolBar.alpha = 0.0;
    DatepickerView.alpha = 0.0;
    [UIView commitAnimations];
}
-(void)UpdateDate:(NSString*)strDate
{
    NSString *strQueryUpdateTaskReminder = [NSString stringWithFormat:@"update tbl_tasks Set dueDate='%@' Where taskId=%d",strDate,[[[ArryTasks objectAtIndex:IndexpathRow] valueForKey:@"taskId"] intValue]];
    [DatabaseAccess updatetbl:strQueryUpdateTaskReminder];
    [self GetTaskOfCurrentList];
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
        OrientationFlag = 0;
        imgLogo.frame = CGRectMake(imgLogo.frame.origin.x, 213, imgLogo.frame.size.width, imgLogo.frame.size.height);
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        OrientationFlag = 1;
        imgLogo.frame = CGRectMake(imgLogo.frame.origin.x, 213 - 30, imgLogo.frame.size.width, imgLogo.frame.size.height);
    }
    
    [self GetTaskOfCurrentList];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
