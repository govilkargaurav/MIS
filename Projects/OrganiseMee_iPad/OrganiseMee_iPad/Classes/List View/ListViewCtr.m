//
//  ListViewCtr.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/16/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "ListViewCtr.h"
#import "Header.h"
#import "WSPContinuous.h"
#import "webService.h"
#import "DatabaseAccess.h"
#import "TaskViewCtr.h"

@interface ListViewCtr ()

@end

@implementation ListViewCtr
@synthesize obj_popOver_AddList;

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
    SetFromFG = NO;
    AppDel._delegate = self;
    
    [self tfName:tfAddList];
    [self tfName:tfEditList];
    self.navigationController.navigationBarHidden = YES;
    
    [self performSelector:@selector(callWS) withObject:nil afterDelay:0.1];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDeckControllerDidOpenLeftView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated
{
    // Lang Data Get n Display
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
    if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"ManageListVC"];
        lblCreate.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblcreatenewlist"]];
    }
}

#pragma mark - TableView Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [ArryList count];
    else if (section == 1)
        return [ArryPriority count];
    else if (section == 2)
        return [ArryScheduled count];
    else
        return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Lists";
    else if (section == 1)
        return @"Priority";
    else if (section == 2)
        return @"Scheduled";
    else
        return @"";
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
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[ArryList objectAtIndex:indexPath.row] objectForKey:@"listName"]];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        UIImage *image = [UIImage imageNamed:@"arrow.png"];
        UIButton *buttonEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, 25, 25);
        buttonEdit.frame = frame;
        [buttonEdit setImage:image forState:UIControlStateNormal];
        [buttonEdit addTarget:self action:@selector(checkBtnTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        buttonEdit.tag = indexPath.row;
        cell.editingAccessoryView = buttonEdit;
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[ArryPriority objectAtIndex:indexPath.row]];
    }
    else if (indexPath.section == 2)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[ArryScheduled objectAtIndex:indexPath.row]];
    }
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self sendTaskInDetail:indexPath.row From:@"List" navTitle:[[ArryList objectAtIndex:indexPath.row]valueForKey:@"listName"]];
    }
    else if (indexPath.section == 1)
    {
        [self sendTaskInDetail:indexPath.row From:@"Priority" navTitle:[ArryPriority objectAtIndex:indexPath.row]];
    }
    else if (indexPath.section == 2)
    {
        [self sendTaskInDetail:indexPath.row From:@"Scheduled" navTitle:[ArryScheduled objectAtIndex:indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

-(void)reloadTbl_List
{
    
        // Get List From Local DB From List View
        NSString *strQuerySelect = @"SELECT * FROM tbl_lists where listCategory=1 and liststatus!=3";
        ArryList = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_lists:strQuerySelect]];
   
        ArryPriority = [[NSMutableArray alloc]initWithObjects:@"High",@"Medium",@"Low",@"All", nil];
   
    //Send Data Of user setting from local databse
        NSString *strQuerySelectSchedule = @"SELECT * FROM tbl_user_setting";
        NSMutableArray *ArryretriveSettings = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_user_setting:strQuerySelectSchedule]];
        NSString *strDueDates = [NSString stringWithFormat:@"%@",[[ArryretriveSettings objectAtIndex:0]valueForKey:@"dueDates"]];
        // Set List From Priority View
        ArryScheduled = [[NSMutableArray alloc]init];
        ArryScheduled = [[strDueDates componentsSeparatedByString:@","] mutableCopy];
    
        [tbl_List reloadData];
    
    
        imgbgTrans.frame = CGRectMake(imgbgTrans.frame.origin.x, tbl_List.contentSize.height + 64, imgbgTrans.frame.size.width, tbl_List.frame.size.height - tbl_List.contentSize.height);

}
-(void)sendTaskInDetail:(int)index From:(NSString*)strFromView navTitle:(NSString*)title
{
    NSString *strQuerySelect;
    if ([strFromView isEqualToString:@"List"])
    {        
        // Get Tasks of the Current List
        strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where listId=%d and taskCategoryType!='ARCHIEVE' and taskstatus!=3",[[[ArryList objectAtIndex:index]valueForKey:@"listId"] intValue]];
        
    }
    else if ([strFromView isEqualToString:@"Priority"])
    {
        NSString *strPriority;
        if ([title isEqualToString:@"Low"])
        {
            strPriority = @"(priority=0 or priority=3 or priority=-1)";
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where %@ and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",strPriority];
        }
        else if ([title isEqualToString:@"Medium"])
        {
            strPriority = @"priority=1";
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where %@ and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",strPriority];
        }
        else if ([title isEqualToString:@"High"])
        {
            strPriority = @"priority=2";
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where %@ and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",strPriority];
        }
        else
        {
            // Get Tasks of the Current List
            strQuerySelect = @"SELECT * FROM tbl_tasks where taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3";
        }
        // Get Tasks of the Current List        
    }
    else if ([strFromView isEqualToString:@"Scheduled"])
    {
        
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
        
        NSString *strSchedule = [NSString stringWithFormat:@"%@",[ArryScheduled objectAtIndex:index]];
        if ([strSchedule isEqualToString:@"today"])
        {
            NSString *d = [format stringFromDate:now];
            // Get Tasks of the Current Schedule
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where dueDate='%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",d];
        }
        else if ([strSchedule isEqualToString:@"next2days"])
        {
            NSDate *earlierDate = [now dateByAddingTimeInterval:(2*24*60*60)];
            NSString *d = [format stringFromDate:earlierDate];
            NSString *nowDate = [format stringFromDate:now];
            
            // Get Tasks of the Current Schedule
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",nowDate,d];
        }
        else if ([strSchedule isEqualToString:@"next3days"])
        {
            NSDate *earlierDate = [now dateByAddingTimeInterval:(3*24*60*60)];
            NSString *d = [format stringFromDate:earlierDate];
            NSString *nowDate = [format stringFromDate:now];
            
            // Get Tasks of the Current Schedule
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",nowDate,d];
        }
        else if ([strSchedule isEqualToString:@"next7days"])
        {
            NSDate *earlierDate = [now dateByAddingTimeInterval:(7*24*60*60)];
            NSString *d = [format stringFromDate:earlierDate];
            NSString *nowDate = [format stringFromDate:now];
            
            // Get Tasks of the Current Schedule
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",nowDate,d];
        }
        else if ([strSchedule isEqualToString:@"next10days"])
        {
            NSDate *earlierDate = [now dateByAddingTimeInterval:(10*24*60*60)];
            NSString *d = [format stringFromDate:earlierDate];
            NSString *nowDate = [format stringFromDate:now];
            
            // Get Tasks of the Current Schedule
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",nowDate,d];
        }
        else if ([strSchedule isEqualToString:@"next14days"])
        {
            NSDate *earlierDate = [now dateByAddingTimeInterval:(14*24*60*60)];
            NSString *d = [format stringFromDate:earlierDate];
            NSString *nowDate = [format stringFromDate:now];
            
            // Get Tasks of the Current Schedule
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",nowDate,d];
        }
        else if ([strSchedule isEqualToString:@"thisweek"])
        {
            NSDate *EndDate = [beginningOfWeek dateByAddingTimeInterval:(6*24*60*60)];
            
            NSString *StrBeginDate = [format stringFromDate:beginningOfWeek];
            NSString *StrEndDate = [format stringFromDate:EndDate];
            
            // Get Tasks of the Current Schedule
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",StrBeginDate,StrEndDate];
        }
        else if ([strSchedule isEqualToString:@"nextweek"])
        {
            NSDate *StartDate = [beginningOfWeek dateByAddingTimeInterval:(7*24*60*60)];
            NSDate *EndDate = [beginningOfWeek dateByAddingTimeInterval:(13*24*60*60)];
            NSString *StrStartDate = [format stringFromDate:StartDate];
            NSString *StrEndDate = [format stringFromDate:EndDate];
            
            // Get Tasks of the Current Schedule
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",StrStartDate,StrEndDate];
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
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate >= '%@' and duedate <= '%@' and duedate !='0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",StrStartDate,StrEndDate];
        }
        else if ([strSchedule isEqualToString:@"overdue"])
        {
            NSString *nowDate = [format stringFromDate:now];
            // Get Tasks of the Current Schedule
            strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_tasks where duedate < '%@' and fadeDate = '0000-00-00' and duedate != '0000-00-00' and taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3",nowDate];
        }
        else if([strSchedule isEqualToString:@"all"])
        {
            strQuerySelect = @"SELECT * FROM tbl_tasks where taskCategoryType != 'INBOX_NOT_ACCEPTED' and taskCategoryType != 'ARCHIEVE' and taskstatus!=3";
        }
    }

    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"Title",strQuerySelect,@"Query", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetTaskAccordingList" object:nil userInfo:dic];
    
    //[AppDel.deckController closeLeftView];
}

#pragma mark - CallWS From Foreground Methods
-(void)CallWsFromFGTask
{
    SetFromFG = YES;
    [AppDel showGlobalProgressHUDWithTitle:@"Please Wait..."];
    
    NSString *strCurrentDate = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastSyncDateTime"];
    
    NSString * strdataCP = [NSString stringWithFormat:@"data={\"credential\": {\"accesToken\": \"%@\",\"ACK\": \"%@\"},\"restIn\": {\"currentTime\":\"%@\"}}",strAccesstoken,strAckNo,strCurrentDate];
    
    NSString *urlStringCPData = [NSString stringWithFormat:@"%@?syncNeeded",App_URL_Rest];
    NSString *postLength = [NSString stringWithFormat:@"%d", [strdataCP length]];
    NSMutableURLRequest *requestData = [[NSMutableURLRequest alloc] init];
    
    [requestData setURL:[NSURL URLWithString:urlStringCPData]];
    [requestData setHTTPMethod:@"POST"];
    [requestData setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestData setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestData setHTTPBody:[strdataCP dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:requestData
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
     {
         if (error)
         {
             [AppDel dismissGlobalHUD];
             DisplayAlertWithTitle(App_Name, [error localizedDescription]);
         }
         else
         {
             NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
             
             [AppDel dismissGlobalHUD];
             
             if ([[dicResult valueForKey:@"restOut"] boolValue])
             {
                 [self performSelector:@selector(callWS) withObject:nil afterDelay:0.1];
             }
             else
             {
                 SetFromFG = NO;
             }
         }
     }];
    
}

// Get Data From Server

-(void) callWS
{
    if ([AppDel checkConnection])
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        [AppDel showGlobalProgressHUDWithTitle:@"Please Wait..."];
        //Send User Setting Request
        wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_UserSetting] action:[webService getSA_UserSetting] message:[webService getSM_UserSetting: strAccesstoken Ack:strAckNo]] rootTag:@"ns1:getUserSettingsSoapOutPart" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:profileId",@"ns1:country",@"ns1:language",@"ns1:timeZone",@"ns1:timeFormat",@"ns1:dateFormat",@"ns1:firstName",@"ns1:lastName",@"ns1:dueDates",@"ns1:fadeOn",@"ns1:webStartPage",@"ns1:mobileStartPage",@"ns1:mobileDisplayPriority",@"ns1:mobileDisplayDueDate",@"ns1:mobileFontSize",@"ns1:gender",@"ns1:userId",@"ns1:fadeOnDays",@"ns1:fadeOnDays",@"ns1:userId",@"ns1:gender",@"ns1:mobileFontSize",@"ns1:mobileDisplayDueDate",@"ns1:mobileDisplayPriority",@"ns1:mobileStartPage",@"ns1:webStartPage",@"ns1:fadeOn",@"ns1:dueDates",@"ns1:lastName",@"ns1:firstName",@"ns1:dateFormat",@"ns1:timeFormat",@"ns1:timeZone",@"ns1:language",@"ns1:country",@"ns1:profileId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishUserSetting:) andHandler:self];
    }
    else
    {
        [AppDel dismissGlobalHUD];
        DisplayAlertWithTitle(App_Name, @"The Internet connection appears to be offline.");
        return;
    }
}
// Get Response User Setting Response
-(void)finishUserSetting:(NSDictionary*)dictionary
{
    // Delete All Data from tbl_user_setting
    if ([[dictionary valueForKey:@"array"] count] > 0)
    {
        NSString *strQueryDelete = @"DELETE FROM tbl_user_setting";
        [DatabaseAccess updatetbl:strQueryDelete];
    }
    
    NSMutableArray *arryQuery = [[NSMutableArray alloc]init];
    // Insert Into tbl_user_setting
    for (int i=0; i<[[dictionary valueForKey:@"array"] count]; i++)
    {
        NSString *StrprofileId = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:profileId"]];
        NSString *Strcountry = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:country"]];
        NSString *Strlanguage = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:language"]];
        NSString *StrtimeZone = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:timeZone"]];
        NSString *StrtimeFormat = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:timeFormat"]];
        NSString *StrdateFormat = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:dateFormat"]];
        NSString *StrfirstName = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:firstName"]];
        NSString *StrlastName = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:lastName"]];
        NSString *StrdueDates = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:dueDates"]];
        NSString *StrfadeOn = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:fadeOn"]];
        NSString *StruserId = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:userId"]];
        NSString *StrfadeOnDays = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:fadeOnDays"]];
        
        NSString *strQueryInsert = [NSString stringWithFormat:@"insert into tbl_user_setting(profileId,country,language,timeZone,timeFormat,dateFormat,firstName,lastName,dueDates,fadeOn,userId,fadeOnDays) values(%d,%d,'%@','%@',%d,%d,'%@','%@','%@',%d,%d,%d)",[StrprofileId intValue],[Strcountry intValue],Strlanguage,StrtimeZone,[StrtimeFormat intValue],[StrdateFormat intValue],StrfirstName,StrlastName,StrdueDates,[StrfadeOn intValue],[StruserId intValue],[StrfadeOnDays intValue]];
        
        [arryQuery addObject:strQueryInsert];
    }
    
    if ([arryQuery count] > 0)
    {
        [DatabaseAccess updatetblWithArrayQuery:arryQuery];
    }
    
    //Send Data Of user setting from local databse
    NSString *strQuerySelect = @"SELECT * FROM tbl_user_setting";
    ArryretriveUserSettings = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_user_setting:strQuerySelect]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"dateFormat"] forKey:@"DateSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"timeFormat"] forKey:@"TimeSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Get List Request
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_GetList] action:[webService getSA_GetList] message:[webService getSM_GetList:strAccesstoken Ack:strAckNo]] rootTag:@"ns1:lists" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:listName",@"ns1:listId",@"ns1:listCategory",@"ns1:listCategory",@"ns1:listId",@"ns1:listName",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil]  sel:@selector(finishGetList:) andHandler:self];
}
// Get List Response
-(void)finishGetList:(NSDictionary*)dictionary
{
    // Delete All Data from tbl_lists
    if ([[dictionary valueForKey:@"array"] count] > 0)
    {
        NSString *strQueryDelete = @"DELETE FROM tbl_lists";
        [DatabaseAccess updatetbl:strQueryDelete];
    }
    
    NSMutableArray *arryQuery = [[NSMutableArray alloc]init];
    // Insert Into tbl_lists
	for (int i=0; i<[[dictionary valueForKey:@"array"] count]; i++)
	{
		NSString *Strlistid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:listId"]];
		NSString *StrlistName = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:listName"]];
		NSString *StrlistCategory = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:listCategory"]];
		
		NSString *strQueryInsert = [NSString stringWithFormat:@"insert into tbl_lists(listId,listName,listActiveColor,listCategory,liststatus,islistnew) values(%d,'%@','%@',%d,%d,%d)",[Strlistid intValue],StrlistName,@"",[StrlistCategory intValue],0,0];
        [arryQuery addObject:strQueryInsert];
	}
    
    if ([arryQuery count] > 0)
    {
        [DatabaseAccess updatetblWithArrayQuery:arryQuery];
    }
    
    [self reloadTbl_List];
    // Send Tasks Request
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_GetTaskDesc] action:[webService getSA_GetTaskDesc] message:[webService getSM_GetTaskDesc:strAccesstoken Ack:strAckNo]] rootTag:@"ns1:tasks" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:taskId",@"ns1:listId",@"ns1:description",@"ns1:priority",@"ns1:dueDate",@"ns1:reminderId",@"ns1:senderId",@"ns1:receiverId",@"ns1:taskCategoryType",@"ns1:fadeDate",@"ns1:assignedId",@"ns1:assignedId",@"ns1:fadeDate",@"ns1:taskCategoryType",@"ns1:receiverId",@"ns1:senderId",@"ns1:reminderId",@"ns1:dueDate",@"ns1:priority",@"ns1:description",@"ns1:listId",@"ns1:taskId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishGetTask:) andHandler:self];
}
// Get Tasks Response
-(void)finishGetTask:(NSDictionary*)dictionary
{
    // Delete All Data from tbl_tasks
    if ([[dictionary valueForKey:@"array"] count] > 0)
    {
        NSString *strQueryDelete = @"DELETE FROM tbl_tasks";
        [DatabaseAccess updatetbl:strQueryDelete];
    }
    
    NSMutableArray *arryQuery = [[NSMutableArray alloc]init];
    // Insert Into tbl_tasks
	for (int i=0; i<[[dictionary valueForKey:@"array"] count]; i++)
	{
		NSString *Strtaskid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:taskId"]];
		NSString *Strlistid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:listId"]];
		NSString *Strdesc = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:description"]];
		NSString *Strpriority = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:priority"]];
		NSString *StrdueDate = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:dueDate"]];
		NSString *StrreminderId = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:reminderId"]];
		NSString *StrsenderId = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:senderId"]];
		NSString *StrreceiverId = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:receiverId"]];
		NSString *StrtaskCategoryType = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:taskCategoryType"]];
		NSString *StrfadeDate = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:fadeDate"]];
		NSString *Strassignedid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:assignedId"]];
        
        NSString *strQueryInsert = [NSString stringWithFormat:@"insert into tbl_tasks(taskId,listId,description,priority,dueDate,reminderId,senderId,receiverId,taskCategoryType,fadeDate,assignedId,taskstatus,istasknew,taskassignedto) values(%d,%d,'%@',%d,'%@',%d,%d,%d,'%@','%@',%d,%d,%d,%d)",[Strtaskid intValue],[Strlistid intValue],Strdesc,[Strpriority intValue],StrdueDate,[StrreminderId intValue],[StrsenderId intValue],[StrreceiverId intValue],StrtaskCategoryType,StrfadeDate,[Strassignedid intValue],0,0,0];
        [arryQuery addObject:strQueryInsert];
	}
    
    if ([arryQuery count] > 0)
    {
        [DatabaseAccess updatetblWithArrayQuery:arryQuery];
    }
    
    // if (!SetFromFG)
    //  {
   // [AppDel dismissGlobalHUD];
    // }
    // BackGorund Process Start
    
    // Send Own Contacts Request
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_GetOwnCont] action:[webService getSA_GetOwnCont] message:[webService getSM_GetOwnCont:strAccesstoken Ack:strAckNo userId:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"]]] rootTag:@"ns1:contacts" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:contactId",@"ns1:firstName",@"ns1:lastName",@"ns1:lastName",@"ns1:firstName",@"ns1:contactId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishGetOwnContact:) andHandler:self];
}

// Get Own Contacts Response
-(void)finishGetOwnContact:(NSDictionary*)dictionary
{
    // Delete All Data from tbl_own_contact
    if ([[dictionary valueForKey:@"array"] count] > 0)
    {
        NSString *strQueryDelete = @"DELETE FROM tbl_own_contact";
        [DatabaseAccess updatetbl:strQueryDelete];
    }
    
    NSMutableArray *arryQuery = [[NSMutableArray alloc]init];
    // Insert Into tbl_own_contact
	for (int i=0; i<[[dictionary valueForKey:@"array"] count]; i++)
	{
		NSString *Strcontid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:contactId"]];
		NSString *StrfirstName = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:firstName"]];
		NSString *StrlastName = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:lastName"]];
		
		NSString *strQueryInsert = [NSString stringWithFormat:@"insert into tbl_own_contact(contactid,firstName,lastName) values(%d,'%@','%@')",[Strcontid intValue],StrfirstName,StrlastName];
        [arryQuery addObject:strQueryInsert];
	}
    if ([arryQuery count] > 0)
    {
        [DatabaseAccess updatetblWithArrayQuery:arryQuery];
    }
    
    //Send Org Contacts Request
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_GetOrgCont] action:[webService getSA_GetOrgCont] message:[webService getSM_GetOrgCont:strAccesstoken Ack:strAckNo userId:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"]]] rootTag:@"ns1:contactRequests" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:contactRequestId",@"ns1:firstName",@"ns1:lastName",@"ns1:senderId",@"ns1:receiverId",@"ns1:contactStatus",@"ns1:contactStatus",@"ns1:receiverId",@"ns1:senderId",@"ns1:lastName",@"ns1:firstName",@"ns1:contactRequestId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil]  sel:@selector(finishGetOrgContact:)	andHandler:self];
}

// Get Org Contacts Response
-(void)finishGetOrgContact:(NSDictionary*)dictionary
{
    // Delete All Data from tbl_org_contact
    if ([[dictionary valueForKey:@"array"] count] > 0)
    {
        NSString *strQueryDelete = @"DELETE FROM tbl_org_contact";
        [DatabaseAccess updatetbl:strQueryDelete];
    }
    
    NSMutableArray *arryQuery = [[NSMutableArray alloc]init];
    // Insert Into tbl_org_contact
	for (int i=0; i<[[dictionary valueForKey:@"array"] count]; i++)
	{
		NSString *StrcontReqid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:contactRequestId"]];
		NSString *StrfirstName = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:firstName"]];
		NSString *StrlastName = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:lastName"]];
		NSString *StrsenderId = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:senderId"]];
		NSString *StrreceiverId = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:receiverId"]];
		NSString *StrcontactStatus = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:contactStatus"]];
        
		NSString *strQueryInsert = [NSString stringWithFormat:@"insert into tbl_org_contact(contactRequestId,firstName,lastName,senderId,receiverId,contactStatus) values(%d,'%@','%@',%d,%d,%d)",[StrcontReqid intValue],StrfirstName,StrlastName,[StrsenderId intValue],[StrreceiverId intValue],[StrcontactStatus intValue]];
        [arryQuery addObject:strQueryInsert];
	}
    if ([arryQuery count] > 0)
    {
        [DatabaseAccess updatetblWithArrayQuery:arryQuery];
    }
    
    // Send Message Request
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_GetMessage] action:[webService getSA_GetMessage] message:[webService getSM_GetMessage:strAccesstoken Ack:strAckNo userId:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"]]] rootTag:@"ns1:messages" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:messageId",@"ns1:messageDescription",@"ns1:messageType",@"ns1:receiverId",@"ns1:senderId",@"ns1:taskId",@"ns1:taskId",@"ns1:senderId",@"ns1:receiverId",@"ns1:messageType",@"ns1:messageDescription",@"ns1:messageId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil]  sel:@selector(finishGetMessage:)	andHandler:self];
	
}
// Get Message Response
-(void)finishGetMessage:(NSDictionary*)dictionary
{
    // Delete All Data from tbl_messages
    if ([[dictionary valueForKey:@"array"] count] > 0)
    {
        NSString *strQueryDelete = @"DELETE FROM tbl_messages";
        [DatabaseAccess updatetbl:strQueryDelete];
    }
    
    NSMutableArray *arryQuery = [[NSMutableArray alloc]init];
    // Insert Into tbl_messages
	for (int i=0; i<[[dictionary valueForKey:@"array"] count]; i++)
	{
		NSString *Strmsgid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:messageId"]];
		NSString *StrmsgDescS = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:messageDescription"]];
		NSString *StrmsgType = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:messageType"]];
		NSString *StrreceiverId = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:receiverId"]];
        NSString *StrsenderId = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:senderId"]];
		NSString *StrtaskId = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:taskId"]];
        
        NSString *strQueryInsert = [NSString stringWithFormat:@"insert into tbl_messages(messageId,messageDescription,messageType,recieverId,senderId,taskId) values(%d,'%@','%@',%d,%d,%d)",[Strmsgid intValue],StrmsgDescS,StrmsgType,[StrreceiverId intValue],[StrsenderId intValue],[StrtaskId intValue]];
        [arryQuery addObject:strQueryInsert];
	}
	
    if ([arryQuery count] > 0)
    {
        [DatabaseAccess updatetblWithArrayQuery:arryQuery];
    }
    
    [self sendTaskInDetail:0 From:@"List" navTitle:[[ArryList objectAtIndex:0]valueForKey:@"listName"]];
    [AppDel dismissGlobalHUD];
    
    // Send Channel Request
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_GetChannel] action:[webService getSA_GetChannel] message:[webService getSM_GetChannel:strAccesstoken Ack:strAckNo userId:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"]]]
													   rootTag:@"ns1:channels"
												   startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil]
													 endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:channelId",@"ns1:channelName",@"ns1:channelCategory",@"ns1:isDefault",@"ns1:isDefault",@"ns1:channelCategory",@"ns1:channelName",@"ns1:channelId",nil]
													 otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil]
														   sel:@selector(finishGetChannel:)
													andHandler:self];
    
}
// Get Channel Response
-(void)finishGetChannel:(NSDictionary*)dictionary
{
	// Delete All Data from tbl_messages
    if ([[dictionary valueForKey:@"array"] count] > 0)
    {
        NSString *strQueryDelete = @"DELETE FROM tbl_channels";
        [DatabaseAccess updatetbl:strQueryDelete];
    }
    
    NSMutableArray *arryQuery = [[NSMutableArray alloc]init];
    // Insert Into tbl_channels
	for (int i=0; i<[[dictionary valueForKey:@"array"] count]; i++)
	{
		NSString *Strchannelid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:channelId"]];
		NSString *StrchannelName = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:channelName"]];
		NSString *StrchannelCategory = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:channelCategory"]];
		NSString *StrisDefault = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:isDefault"]];
        
        NSString *strQueryInsert = [NSString stringWithFormat:@"insert into tbl_channels(channelId,channelName,channelCategory,isDefault) values('%@','%@',%d,%d)",Strchannelid,StrchannelName,[StrchannelCategory intValue],[StrisDefault intValue]];
        [arryQuery addObject:strQueryInsert];
	}
    if ([arryQuery count] > 0)
    {
        [DatabaseAccess updatetblWithArrayQuery:arryQuery];
    }
    
    // Send Standard Reminder Request
	wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_GetStandardReminder] action:[webService getSA_GetStandardReminder] message:[webService getSM_GetStandardReminder:strAccesstoken Ack:strAckNo userId:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"]]] rootTag:@"ns1:soapOut"  startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:startDay",@"ns1:isEveryDay",@"ns1:beforeDuedateTime1",@"ns1:beforeDuedateTime2",@"ns1:beforeDuedateTime3",@"ns1:onDuedateTime1",@"ns1:onDuedateTime2",@"ns1:onDuedateTime3",@"ns1:beforeDuedateChannelId",@"ns1:onDuedateChannelId",@"ns1:reminderId",@"ns1:reminderId",@"ns1:onDuedateChannelId",@"ns1:beforeDuedateChannelId",@"ns1:onDuedateTime3",@"ns1:onDuedateTime2",@"ns1:onDuedateTime1",@"ns1:beforeDuedateTime3",@"ns1:beforeDuedateTime2",@"ns1:beforeDuedateTime1",@"ns1:isEveryDay",@"ns1:startDay",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishGetStandardReminder:) andHandler:self];
}
// Get Standard Reminder Response
-(void)finishGetStandardReminder:(NSDictionary*)dictionary
{
    // Delete All Data from tbl_standerd_reminder
    if ([[dictionary valueForKey:@"array"] count] > 0)
    {
        NSString *strQueryDelete = @"DELETE FROM tbl_standerd_reminder";
        [DatabaseAccess updatetbl:strQueryDelete];
    }
    
    NSMutableArray *arryQuery = [[NSMutableArray alloc]init];
    // Insert Into tbl_standerd_reminder
	for (int i=0; i<[[dictionary valueForKey:@"array"] count]; i++)
	{
		NSString *reminderIdStr = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:reminderId"]]];
		NSString *startDayStr = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:startDay"]]];
		NSString *isEveryDayStr = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:isEveryDay"]]];
		NSString *beforeDuedateTime1Str = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:beforeDuedateTime1"]]];
		NSString *beforeDuedateTime2Str = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:beforeDuedateTime2"]]];
		NSString *beforeDuedateTime3Str = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:beforeDuedateTime3"]]];
		NSString *onDuedateTime1Str = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:onDuedateTime1"]]];
		NSString *onDuedateTime2Str = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:onDuedateTime2"]]];
		NSString *onDuedateTime3Str = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:onDuedateTime3"]]];
		NSString *beforeDuedateChannelIdStr = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:beforeDuedateChannelId"]]];
		NSString *onDuedateChannelIdStr = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:onDuedateChannelId"]]];
        
		NSString *strQueryInsert = [NSString stringWithFormat:@"insert into tbl_standerd_reminder(reminderId,startDay,isEveryDay,beforeDuedateTime1,beforeDuedateTime2,beforeDuedateTime3,onDuedateTime1,onDuedateTime2,onDuedateTime3,beforeDueDateChannelId,onDueDateChannelId) values(%d,%d,%d,'%@','%@','%@','%@','%@','%@',%d,%d)",[reminderIdStr intValue],[startDayStr intValue],[isEveryDayStr intValue],beforeDuedateTime1Str,beforeDuedateTime2Str,beforeDuedateTime3Str,onDuedateTime1Str,onDuedateTime2Str,onDuedateTime3Str,[beforeDuedateChannelIdStr intValue],[onDuedateChannelIdStr intValue]];
        [arryQuery addObject:strQueryInsert];
	}
    
    if ([arryQuery count] > 0)
    {
        [DatabaseAccess updatetblWithArrayQuery:arryQuery];
    }
    
    // Send Get Reminder Request
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_GetReminders] action:[webService getSA_GetReminders] message:[webService getSM_GetReminders:strAccesstoken Ack:strAckNo userId:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"]]] rootTag:@"ns1:reminders" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:startDay",@"ns1:isEveryDay",@"ns1:beforeDuedateTime1",@"ns1:beforeDuedateTime2",@"ns1:beforeDuedateTime3",@"ns1:onDuedateTime1",@"ns1:onDuedateTime2",@"ns1:onDuedateTime3",@"ns1:beforeDuedateChannelId",@"ns1:onDuedateChannelId",@"ns1:reminderId",@"ns1:reminderId",@"ns1:onDuedateChannelId",@"ns1:beforeDuedateChannelId",@"ns1:onDuedateTime3",@"ns1:onDuedateTime2",@"ns1:onDuedateTime1",@"ns1:beforeDuedateTime3",@"ns1:beforeDuedateTime2",@"ns1:beforeDuedateTime1",@"ns1:isEveryDay",@"ns1:startDay",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishGetReminders:) andHandler:self];
}
// Get Reminder Response
-(void)finishGetReminders:(NSDictionary*)dictionary
{
    // Delete All Data from tbl_reminders
    if ([[dictionary valueForKey:@"array"] count] > 0)
    {
        NSString *strQueryDelete = @"DELETE FROM tbl_reminders";
        [DatabaseAccess updatetbl:strQueryDelete];
    }
    
    NSMutableArray *arryQuery = [[NSMutableArray alloc]init];
    // Insert Into tbl_reminders
	for (int i=0; i<[[dictionary valueForKey:@"array"] count]; i++)
	{
		NSString *reminderIdStr = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:reminderId"]]];
		NSString *startDayStr = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:startDay"]]];
		NSString *isEveryDayStr = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:isEveryDay"]]];
		NSString *beforeDuedateTime1Str = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:beforeDuedateTime1"]]];
		NSString *beforeDuedateTime2Str = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:beforeDuedateTime2"]]];
		NSString *beforeDuedateTime3Str = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:beforeDuedateTime3"]]];
		NSString *onDuedateTime1Str = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:onDuedateTime1"]]];
		NSString *onDuedateTime2Str = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:onDuedateTime2"]]];
		NSString *onDuedateTime3Str = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:onDuedateTime3"]]];
		NSString *beforeDuedateChannelIdStr = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:beforeDuedateChannelId"]]];
		NSString *onDuedateChannelIdStr = [self removeNull:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:onDuedateChannelId"]]];
		
		NSString *strQueryInsert = [NSString stringWithFormat:@"insert into tbl_reminders(reminderId,startDay,isEveryDay,beforeDuedateTime1,beforeDuedateTime2,beforeDuedateTime3,onDuedateTime1,onDuedateTime2,onDuedateTime3,beforeDueDateChannelId,onDueDateChannelId,reminderstatus,isremindernew) values(%d,%d,%d,'%@','%@','%@','%@','%@','%@',%d,%d,%d,%d)",[reminderIdStr intValue],[startDayStr intValue],[isEveryDayStr intValue],beforeDuedateTime1Str,beforeDuedateTime2Str,beforeDuedateTime3Str,onDuedateTime1Str,onDuedateTime2Str,onDuedateTime3Str,[beforeDuedateChannelIdStr intValue],[onDuedateChannelIdStr intValue],0,0];
        [arryQuery addObject:strQueryInsert];
	}
    
    if ([arryQuery count] > 0)
    {
        [DatabaseAccess updatetblWithArrayQuery:arryQuery];
    }
    
    [AppDel dismissGlobalHUD];
    SetFromFG = NO;

    [self GetTasksForSetLocalNotification];
    // Finish BackGround Proccess
}

#pragma Mark - Set Local Notification
-(void)GetTasksForSetLocalNotification
{
    NSString *strQuerySelectTask = @"SELECT * FROM tbl_tasks";
    NSMutableArray *ArryTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelectTask]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    for (int i = 0; i < [ArryTasks count]; i++)
    {
        NSString *strDueDate = [NSString stringWithFormat:@"%@",[[ArryTasks objectAtIndex:i]valueForKey:@"dueDate"]];
        NSString *strReminderId = [NSString stringWithFormat:@"%@",[[ArryTasks objectAtIndex:i]valueForKey:@"reminderId"]];
        
        NSDate *Duedate = [df dateFromString:strDueDate];
        
        NSDate *Now = [NSDate date];
        NSString *strnow = [df stringFromDate:Now];
        NSDate *dateNow = [df dateFromString:strnow];
        
        if (![strDueDate isEqualToString:@"0000-00-00"] && [strReminderId intValue] != 0)
        {
            if ([Duedate compare:dateNow] == NSOrderedDescending || [Duedate compare:dateNow] == NSOrderedSame)
            {
                // Get Reminder From Local Db
                NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_reminders where reminderId=%d",[strReminderId intValue]];
                NSMutableArray *Arry_Reminder = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_standerd_reminder:strQuerySelect]];
                if ([Arry_Reminder count] != 0)
                {
                    [self setLocalNoti:[Arry_Reminder objectAtIndex:0] DueDate:strDueDate ReminderId:[strReminderId intValue] TaskDesc:[[ArryTasks objectAtIndex:i]valueForKey:@"description"]];
                }
            }
        }
    }
}
#pragma mark - Set Local Notification For Reminder
-(void)setLocalNoti:(NSDictionary*)DicNoti DueDate:(NSString*)strDueDate ReminderId:(int)ReminderId TaskDesc:(NSString *)strTaskDesc
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
            [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"beforeDuedateTime1"] addtimeInt:TimeIntBefore ReminderId:ReminderId TaskDesc:strTaskDesc];
        }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"beforeDuedateTime1"] addtimeInt:i ReminderId:ReminderId TaskDesc:strTaskDesc];
            }
        }
    }
    if ([[DicNoti valueForKey:@"beforeDuedateTime2"] length] > 0)
    {
        if (isEvryDay == 0)
        {
            [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"beforeDuedateTime2"] addtimeInt:TimeIntBefore ReminderId:ReminderId TaskDesc:strTaskDesc];
        }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"beforeDuedateTime2"] addtimeInt:i ReminderId:ReminderId TaskDesc:strTaskDesc];
            }
        }
    }
    if ([[DicNoti valueForKey:@"beforeDuedateTime3"] length] > 0)
    {
        if (isEvryDay == 0)
        {
            [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"beforeDuedateTime3"] addtimeInt:TimeIntBefore ReminderId:ReminderId TaskDesc:strTaskDesc];
        }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"beforeDuedateTime3"] addtimeInt:i ReminderId:ReminderId TaskDesc:strTaskDesc];
            }
        }
    }
    if ([[DicNoti valueForKey:@"onDuedateTime1"] length] > 0)
    {
        /*if (isEvryDay == 0)
        {*/
            [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"onDuedateTime1"] addtimeInt:0 ReminderId:ReminderId TaskDesc:strTaskDesc];
        /*}
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"onDuedateTime1"] addtimeInt:i ReminderId:ReminderId TaskDesc:strTaskDesc];
            }
        }*/
    }
    if ([[DicNoti valueForKey:@"onDuedateTime2"] length] > 0)
    {
        /*if (isEvryDay == 0)
        {*/
            [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"onDuedateTime2"] addtimeInt:0 ReminderId:ReminderId TaskDesc:strTaskDesc];
       /* }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"onDuedateTime2"] addtimeInt:i ReminderId:ReminderId TaskDesc:strTaskDesc];
            }
        }*/
    }
    if ([[DicNoti valueForKey:@"onDuedateTime3"] length] > 0)
    {
        /*if (isEvryDay == 0)
        {*/
            [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"onDuedateTime3"] addtimeInt:0 ReminderId:ReminderId TaskDesc:strTaskDesc];
       /* }
        else
        {
            for (int i = TimeIntBefore; i >= 0; i--)
            {
                [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"onDuedateTime3"] addtimeInt:i ReminderId:ReminderId TaskDesc:strTaskDesc];
            }
        }*/
    }
}
-(void)SetLocalNotificationOfTheReminderDate:(NSString*)strDueDate Time:(NSString*)strTime addtimeInt:(int)TimeInterval ReminderId:(int)ReminderId TaskDesc:(NSString *)strTaskDesc
{
    NSString *strDateTime = [NSString stringWithFormat:@"%@ %@",strDueDate,strTime];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *FireDate = [df dateFromString:strDateTime];
    
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.timeZone = [NSTimeZone systemTimeZone];
    notif.fireDate = [FireDate dateByAddingTimeInterval:-TimeInterval*86400];
    notif.alertBody = strTaskDesc;
    notif.alertAction = @"View Details";
    notif.applicationIconBadgeNumber = 1;
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.repeatInterval = 0;
    NSString *strReminderID = [NSString stringWithFormat:@"%d-%@-%d",ReminderId,strTime,TimeInterval];
    NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:strReminderID,@"ReminderUniquetag",strTaskDesc,@"AlertBody", nil];
    notif.userInfo = userDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
}

#pragma mark - IBAction Methods
-(IBAction)btnAddListPressed:(id)sender
{
    if (![obj_popOver_AddList isPopoverVisible])
    {
        obj_popOver_AddList = [[UIPopoverController alloc] initWithContentViewController:View_AddList];
        [obj_popOver_AddList setPopoverContentSize:CGSizeMake(280, 164) animated:YES];
        [obj_popOver_AddList presentPopoverFromRect:btnAdd.frame inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
-(IBAction)btnCreatePressed:(id)sender
{
    if ([ArryList count] >= 5)
    {
        NSString *strAlertMsg;
        if([UserLanguage isEqualToString:@"de"])
        {
            strAlertMsg = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"maxlimitmsg"]];
        }
        else
        {
            strAlertMsg = @"You have reached the maximum number of task lists for a basic account in Organisemee. In the premium account you will be able to create an unlimited number of task lists. Currently the premium version is not available yet. Stay tuned for news.";
        }
        DisplayAlertWithTitle(App_Name, strAlertMsg);
        return;
        
    }
    else if ([[tfAddList.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        DisplayAlertWithTitle(App_Name, @"Please enter list name");
        return;
    }
    else
    {
        NSString *strMaxListID = @"SELECT max(listid) FROM tbl_lists";
        int listID = [DatabaseAccess getMaxid:strMaxListID];
        listID = listID + 1;
        
        NSString *strQueryInsert = [NSString stringWithFormat:@"insert into tbl_lists(listId,listName,listActiveColor,listCategory,liststatus,islistnew) values(%d,'%@','%@',%d,%d,%d)",listID,tfAddList.text,@"",1,1,1];
        [DatabaseAccess updatetbl:strQueryInsert];
        
        tfAddList.text = @"";
        [tfAddList resignFirstResponder];
       
        if ([obj_popOver_AddList isPopoverVisible])
        {
            [obj_popOver_AddList dismissPopoverAnimated:YES];
        }
        [self reloadTbl_List];
    }
}

- (void)checkBtnTapped:(id)sender event:(id)event
{
    senderTag = [sender tag];
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:tbl_List];
    if (![obj_popOver_AddList isPopoverVisible])
    {
        obj_popOver_AddList = [[UIPopoverController alloc] initWithContentViewController:View_EditList];
        [obj_popOver_AddList setPopoverContentSize:CGSizeMake(280, 194) animated:YES];
        [obj_popOver_AddList presentPopoverFromRect:CGRectMake(currentTouchPosition.x-15, currentTouchPosition.y-11, 22, 22) inView:tbl_List permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
        tfEditList.text = [NSString stringWithFormat:@"%@",[[ArryList objectAtIndex:senderTag] objectForKey:@"listName"]];
    }    
}
-(IBAction)btnEditList:(id) sender
{
	if ([tbl_List isEditing])
	{
		[tbl_List setEditing:NO animated:YES];
	}
	else
	{
		[tbl_List setEditing:YES animated:YES];
	}
}
-(IBAction)btnUpdateSavePressed:(id)sender
{
    NSString *strQueryUpdate = [NSString stringWithFormat:@"update tbl_lists Set listName='%@',liststatus=2 Where listId=%d",tfEditList.text,[[[ArryList objectAtIndex:senderTag]valueForKey:@"listId"] intValue]];
    [DatabaseAccess updatetbl:strQueryUpdate];
    
    if ([obj_popOver_AddList isPopoverVisible])
    {
        [obj_popOver_AddList dismissPopoverAnimated:YES];
    }
    
    [self reloadTbl_List];
}
-(IBAction)btnCancelPressed:(id)sender
{
    if ([obj_popOver_AddList isPopoverVisible])
    {
        [obj_popOver_AddList dismissPopoverAnimated:YES];
    }
}
-(IBAction)btnDeletePressed:(id)sender
{
    NSString *strAlertMsg,*strDelete,*strCancel;
    if([UserLanguage isEqualToString:@"de"])
    {
        strAlertMsg = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"deleteConfirm"]];
        strDelete = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"btndelete"]];
        strCancel = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"btncancel"]];
    }
    else
    {
        strAlertMsg = @"Do you really want to delete the task list and all it’s tasks?";
        strDelete = @"Delete";
        strCancel = @"Cancel";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:App_Name message:strAlertMsg delegate:self cancelButtonTitle:strCancel otherButtonTitles:strDelete,nil];
    alert.tag = senderTag;
    [alert show];
}
#pragma mark - AlertView Delegate Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    else
    {
        if ([[[ArryList objectAtIndex:alertView.tag]valueForKey:@"islistnew"] intValue] == 1)
        {
            NSString *strQueryUpdate = [NSString stringWithFormat:@"DELETE FROM tbl_lists Where listId=%d",[[[ArryList objectAtIndex:alertView.tag]valueForKey:@"listId"] intValue]];
            [DatabaseAccess updatetbl:strQueryUpdate];
        }
        else
        {
            NSString *strQueryUpdate = [NSString stringWithFormat:@"update tbl_lists Set liststatus=3 Where listId=%d",[[[ArryList objectAtIndex:alertView.tag]valueForKey:@"listId"] intValue]];
            [DatabaseAccess updatetbl:strQueryUpdate];
        }
        
        NSString *strQueryDelete = [NSString stringWithFormat:@"DELETE FROM tbl_tasks Where listId=%d",[[[ArryList objectAtIndex:alertView.tag]valueForKey:@"listId"] intValue]];
        [DatabaseAccess updatetbl:strQueryDelete];

        if ([obj_popOver_AddList isPopoverVisible])
        {
            [obj_popOver_AddList dismissPopoverAnimated:YES];
        }
        
        [self reloadTbl_List];
    }
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
#pragma mark - UITextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField.layer setBorderColor: [[UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0] CGColor]];
    [textField.layer setBorderWidth: 1.0];
    [textField.layer setMasksToBounds:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self tfName:textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
#pragma mark - Set label Border
-(void)tfName:(UITextField*)tf
{
    tf.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
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
