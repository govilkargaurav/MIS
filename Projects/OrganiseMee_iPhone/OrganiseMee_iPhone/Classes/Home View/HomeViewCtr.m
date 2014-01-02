//
//  HomeViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "HomeViewCtr.h"
#import "SettingsViewCtr.h"
#import "ProductivityViewCtr.h"
#import "webService.h"
#import "WSPContinuous.h"
#import "Header.h"
#import "DatabaseAccess.h"
#import "ManageListViewCtr.h"
#import "ListViewCtr.h"
#import "NewTaskViewCtr.h"
#import "DoNowTaskViewCtr.h"
#import "AppDelegate.h"
#import "GlobalMethods.h"

@interface HomeViewCtr ()

@end

@implementation HomeViewCtr

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
    SetSyncFlag = YES;
    SetFromFG = NO;
    AppDel._delegate = self;
    
    [self performSelector:@selector(callWS) withObject:nil afterDelay:0.1];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self updateui];
   /* NSString *strHomepage = [[NSUserDefaults standardUserDefaults] stringForKey:@"HomePageSetting"];
    
    if ([strHomepage intValue] != 1 && HomePageSetFlag == YES)
    {
        ListViewCtr *obj_ListViewCtr = [[ListViewCtr alloc]init];
        if ([strHomepage intValue] == 2)
        {
            obj_ListViewCtr.strFromView = @"List";
        }
        else if ([strHomepage intValue] == 3)
        {
            obj_ListViewCtr.strFromView = @"Priority";
        }
        else if ([strHomepage intValue] == 4)
        {
            obj_ListViewCtr.strFromView = @"Scheduled";
        }
        [self.navigationController pushViewController:obj_ListViewCtr animated:NO];
        obj_ListViewCtr = nil;
        
        HomePageSetFlag = NO;
    }*/
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

#pragma mark - Web-Service Method.
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
        [AppDel dismissGlobalHUD];
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
       /* }
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
       /* if (isEvryDay == 0)
        {*/
            [self SetLocalNotificationOfTheReminderDate:strDueDate Time:[DicNoti valueForKey:@"onDuedateTime3"] addtimeInt:0 ReminderId:ReminderId TaskDesc:strTaskDesc];
        /*}
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

-(IBAction)btnSettingPressed:(id)sender
{
    SettingsViewCtr *obj_SettingsViewCtr = [[SettingsViewCtr alloc]initWithNibName:@"SettingsViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_SettingsViewCtr animated:YES];
}
-(IBAction)btnProductivityPressed:(id)sender
{
    ProductivityViewCtr *obj_ProductivityViewCtr = [[ProductivityViewCtr alloc]initWithNibName:@"ProductivityViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_ProductivityViewCtr animated:YES];
}
-(IBAction)btnManageListPressed:(id)sender
{
    ManageListViewCtr *obj_ManageListViewCtr = [[ManageListViewCtr alloc]initWithNibName:@"ManageListViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_ManageListViewCtr animated:YES];
}
-(IBAction)btnListPressed:(id)sender
{
    ListViewCtr *obj_ListViewCtr = [[ListViewCtr alloc]initWithNibName:@"ListViewCtr" bundle:nil];
    obj_ListViewCtr.strFromView = @"List";
    [self.navigationController pushViewController:obj_ListViewCtr animated:YES];
}
-(IBAction)btnPriorityPressed:(id)sender
{
    ListViewCtr *obj_ListViewCtr = [[ListViewCtr alloc]initWithNibName:@"ListViewCtr" bundle:nil];
    obj_ListViewCtr.strFromView = @"Priority";
    [self.navigationController pushViewController:obj_ListViewCtr animated:YES];
}
-(IBAction)btnNewTaskPressed:(id)sender
{
    NewTaskViewCtr *obj_NewTaskViewCtr = [[NewTaskViewCtr alloc]initWithNibName:@"NewTaskViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_NewTaskViewCtr animated:YES];
}
-(IBAction)btnScheduledPressed:(id)sender
{
    lblScheduleDate.textColor = RGBCOLOR(0.0f, 159.0f, 220.0f);
    ListViewCtr *obj_ListViewCtr = [[ListViewCtr alloc]initWithNibName:@"ListViewCtr" bundle:nil];
    obj_ListViewCtr.strFromView = @"Scheduled";
    [self.navigationController pushViewController:obj_ListViewCtr animated:YES];
}
-(IBAction)btnDoNowTaskPressed:(id)sender
{
    DoNowTaskViewCtr *obj_DoNowTaskViewCtr = [[DoNowTaskViewCtr alloc]initWithNibName:@"DoNowTaskViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_DoNowTaskViewCtr animated:YES];
}
-(IBAction)btnSyncPressed:(id)sender
{
    if ([AppDel checkConnection])
    {
        [self CallSync:@"YES"];
    }
    else
    {
        DisplayAlertWithTitle(App_Name, @"You are not connected to internet connection.");
    }
}
-(IBAction)btnHideShowSyncPressed:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.20f];
    if (btnSync.alpha == 0.0)
    {
        btnSync.alpha = 1.0;
        imgTranBottom.alpha = 1.0;
    }
    else
    {
        btnSync.alpha = 0.0;
        imgTranBottom.alpha = 0.0;
    }
    [UIView commitAnimations];
}

#pragma mark - CallSync Methods
-(void)CallSyncFromBGTask
{
    [self CallSync:@"NO"];
}


-(void)CallSync:(NSString*)strCheckProgress
{
    if ([AppDel checkConnection])
    {
        if (SetSyncFlag)
        {
            SetSyncFlag = NO;
            if ([strCheckProgress isEqualToString:@"YES"])
            {
                [AppDel showGlobalProgressHUDWithTitle:@"Please Wait..."];
            }
            NSString *strQuerySelect = @"SELECT * FROM tbl_lists where islistnew!=1 and liststatus=2";
            NSMutableArray *ArryUpdateList = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_lists:strQuerySelect]];
            iUpdateList = [ArryUpdateList count];
            if ([ArryUpdateList count] > 0)
            {
                [self PostUpdateList:ArryUpdateList];
            }
            else
            {
                [self finishPostUpdateList:nil];
            }
        }
    }
}

-(void)PostUpdateList:(NSMutableArray*)ArryUpdateList
{
    for (int i=0; i<[ArryUpdateList count]; i++)
    {
        wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_PostUpdateList] action:[webService getSA_PostUpdateList] message:[webService getSM_PostUpdateList:strAccesstoken Ack:strAckNo listName:[[ArryUpdateList objectAtIndex:i]valueForKey:@"listName"] listId:[[ArryUpdateList objectAtIndex:i]valueForKey:@"listId"] listCategory:[[ArryUpdateList objectAtIndex:i]valueForKey:@"listCategory"]]] rootTag:@"ns1:lists" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:listName",@"ns1:listId",@"ns1:listCategory",@"ns1:listCategory",@"ns1:listId",@"ns1:listName",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostUpdateList:) andHandler:self];
    }
}
-(void)finishPostUpdateList:(NSDictionary*)dictionary
{
    if (iUpdateList > 0)
    {
        iUpdateList--;
    }
    if (iUpdateList == 0)
    {
        NSString *strQuerySelect = @"SELECT * FROM tbl_lists where liststatus=3";
        NSMutableArray *ArryDeleteList = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_lists:strQuerySelect]];
        iDeleteList = [ArryDeleteList count];
        if ([ArryDeleteList count] > 0)
        {
            [self PostDeleteList:ArryDeleteList];
        }
        else
        {
            [self finishPostDeleteList:nil];
        }
    }
}
-(void)PostDeleteList:(NSMutableArray*)ArryDeletList
{
    for (int i=0; i<[ArryDeletList count]; i++)
    {
        wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_DeleteList] action:[webService getSA_DeleteList] message:[webService getSM_DeleteList:strAccesstoken Ack:strAckNo ListId:[[ArryDeletList objectAtIndex:i]valueForKey:@"listId"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:listId",@"ns1:listId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostDeleteList:) andHandler:self];
    }
}
-(void)finishPostDeleteList:(NSDictionary*)dictionary
{
    if (iDeleteList > 0)
    {
        iDeleteList--;
    }
    if (iDeleteList == 0)
    {
        NSString *strQuerySelect = @"SELECT * FROM tbl_lists where islistnew=1";
        ArryAddList = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_lists:strQuerySelect]];
        if ([ArryAddList count] > 0)
        {
            ListUpdateRequiredDB = YES;
            iAddList = 0;
            [self PostAddList];
        }
        else
        {
            [self finishPostAddList:nil];
        }
    }
}
-(void)PostAddList
{
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_PostList] action:[webService getSA_PostList] message:[webService getSM_PostList:strAccesstoken Ack:strAckNo listName:[[ArryAddList objectAtIndex:iAddList]valueForKey:@"listName"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil]  endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:listName",@"ns1:listId",@"ns1:listCategory",@"ns1:listCategory",@"ns1:listId",@"ns1:listName",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostAddList:) andHandler:self];
}
-(void)finishPostAddList:(NSDictionary*)dictionary
{
    if (ListUpdateRequiredDB)
    {
        NSMutableArray *arryQuery = [[NSMutableArray alloc]init];
        // Update Into tbl_lists & tbl_tasks
        for (int i=0; i<[[dictionary valueForKey:@"array"] count]; i++)
        {
            NSString *Strlistid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:listId"]];
            
            NSString *strQueryUpdate = [NSString stringWithFormat:@"update tbl_lists Set listId=%d Where listId=%d",[Strlistid intValue],[[[ArryAddList objectAtIndex:iAddList]valueForKey:@"listId"] intValue]];
            [arryQuery addObject:strQueryUpdate];
            
            NSString *strQueryUpdateTaskListId = [NSString stringWithFormat:@"update tbl_tasks Set listId=%d Where listId=%d",[Strlistid intValue],[[[ArryAddList objectAtIndex:iAddList]valueForKey:@"listId"] intValue]];
            [arryQuery addObject:strQueryUpdateTaskListId];
        }
        
        if ([arryQuery count] > 0)
        {
            [DatabaseAccess updatetblWithArrayQuery:arryQuery];
        }
        
        if (iAddList < [ArryAddList count]-1)
        {
            iAddList = iAddList + 1;
            [self PostAddList];
        }
        else
        {
            ListUpdateRequiredDB = NO;
            [self FetchDeleteQueryForTask];
        }
    }
    else
    {
        ListUpdateRequiredDB = NO;
        [self FetchDeleteQueryForTask];
    }
}
-(void)FetchDeleteQueryForTask
{
    NSString *strQueryDeleteList = @"DELETE FROM tbl_lists Where liststatus=3";
    [DatabaseAccess updatetbl:strQueryDeleteList];
    
    NSString *strQueryUpdate = @"update tbl_lists Set liststatus=0,islistnew=0";
    [DatabaseAccess updatetbl:strQueryUpdate];
    
    NSString *strQueryDeleteTask = @"SELECT * FROM tbl_tasks where istasknew!=1 and taskstatus=3";
    NSMutableArray *ArryDeleteTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQueryDeleteTask]];
    iDeleteTask = [ArryDeleteTasks count];
    if ([ArryDeleteTasks count] > 0)
    {
        [self PostDeleteTasks:ArryDeleteTasks];
    }
    else
    {
        [self finishPostDeleteTask:nil];
    }
}
-(void)PostDeleteTasks:(NSMutableArray*)ArryDeleteTasks
{
    for (int i = 0; i < [ArryDeleteTasks count]; i++)
    {
        wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_DeleteTask] action:[webService getSA_DeleteTask] message:[webService getSM_DeleteTask:strAccesstoken Ack:strAckNo TaskId:[[ArryDeleteTasks objectAtIndex:i]valueForKey:@"taskId"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:taskId",@"ns1:taskId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostDeleteTask:) andHandler:self];
        
        if ([[[ArryDeleteTasks objectAtIndex:i]valueForKey:@"reminderId"] intValue] != 0)
        {
            [self PostDeleteReminder:[[ArryDeleteTasks objectAtIndex:i]valueForKey:@"taskId"] ReminderId:[[ArryDeleteTasks objectAtIndex:i]valueForKey:@"reminderId"]];
        }
    }
}
-(void)finishPostDeleteTask:(NSDictionary*)dictionary
{
    if (iDeleteTask > 0)
    {
        iDeleteTask--;
    }
    if (iDeleteTask == 0)
    {
        NSString *strQueryDeleteTask = @"DELETE FROM tbl_tasks Where istasknew!=1 and taskstatus=3";
        [DatabaseAccess updatetbl:strQueryDeleteTask];
        NSString *strQueryDeleteReminder = @"DELETE FROM tbl_reminders Where isremindernew!=1 and reminderstatus=3";
        [DatabaseAccess updatetbl:strQueryDeleteReminder];
        
        NSString *strQueryUpdateTask = @"SELECT * FROM tbl_tasks where istasknew!=1 and taskstatus=2";
        ArryUpdateTasks = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQueryUpdateTask]];
        if ([ArryUpdateTasks count] > 0)
        {
            iUpdateTask = 0;
            UpdateTaskUpdateRequiredDB = YES;
            [self PostUpdateTaskReminder];
        }
        else
        {
            [self FetchAddTask];
        }
    }
}
-(void)PostDeleteReminder:(NSString*)strTaskId ReminderId:(NSString*)strReminderId
{
    wsparser = [[WSPContinuous alloc]initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_DeleteReminder] action:[webService getSA_DeleteReminder] message:[webService getSM_DeleteReminder:strAccesstoken Ack:strAccesstoken taskId:strTaskId reminderId:strReminderId]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostDeleteReminder:) andHandler:self];
}
-(void)finishPostDeleteReminder:(NSDictionary*)dictionary
{
    
}
-(void)PostUpdateTaskReminder
{
    if ([[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"reminderId"] intValue] != 0)
    {
        NSString *strQueryUpdateReminders = [NSString stringWithFormat:@"SELECT * FROM tbl_reminders where reminderId =%d",[[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"reminderId"] intValue]];
        NSMutableArray *ArryUpdateReminders = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_standerd_reminder:strQueryUpdateReminders]];
        if ([ArryUpdateReminders count] != 0)
        {
            if ([[[ArryUpdateReminders objectAtIndex:0] valueForKey:@"isremindernew"] intValue] != 1 && [[[ArryUpdateReminders objectAtIndex:0] valueForKey:@"reminderstatus"] intValue] == 2)
            {
                [self PostUpdateReminder:[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"taskId"] Reminder:ArryUpdateReminders];
            }
            else if ([[[ArryUpdateReminders objectAtIndex:0] valueForKey:@"isremindernew"] intValue] == 1)
            {
                [self PostAddReminder:[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"taskId"] Reminder:ArryUpdateReminders];
            }
            else
            {
                [self PostUpdateTasks:[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"reminderId"]];
            }
        }
    }
    else
    {
        [self PostUpdateTasks:[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"reminderId"]];
    }
}
-(void)PostUpdateTasks:(NSString*)strReminderID
{
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_PostUpdateTask] action:[webService getSA_PostUpdateTask] message:[webService getSM_PostUpdateTask:strAccesstoken Ack:strAckNo TaskId:[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"taskId"] Priority:[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"priority"] Description:[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"description"] dueDate:[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"dueDate"] listId:[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"listId"] assignId:[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"assignedId"] reminderId:strReminderID]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:taskId",@"ns1:listId",@"ns1:description",@"ns1:priority",@"ns1:dueDate",@"ns1:assignedId",@"ns1:reminderId",@"ns1:reminderId",@"ns1:assignedId",@"ns1:dueDate",@"ns1:priority",@"ns1:description",@"ns1:listId",@"taskId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostUpdateTask:) andHandler:self];
}
-(void)finishPostUpdateTask:(NSDictionary*)dictionary
{
    [self CheckUpdateReminderRemainingOrNot];
}
-(void)PostUpdateReminder:(NSString*)strTaskId Reminder:(NSMutableArray*)ArryReminder
{
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_UpdateReminder] action:[webService getSA_UpdateReminder] message:[webService getSM_UpdateReminder:strAccesstoken Ack:strAckNo taskId:strTaskId startDay:[[ArryReminder objectAtIndex:0]valueForKey:@"startDay"] isEveryDay:[[ArryReminder objectAtIndex:0]valueForKey:@"isEveryDay"] beforeDuedateTime1:[[ArryReminder objectAtIndex:0]valueForKey:@"beforeDuedateTime1"] beforeDuedateTime2:[[ArryReminder objectAtIndex:0]valueForKey:@"beforeDuedateTime2"] beforeDuedateTime3:[[ArryReminder objectAtIndex:0]valueForKey:@"beforeDuedateTime3"] onDuedateTime1:[[ArryReminder objectAtIndex:0]valueForKey:@"onDuedateTime1"] onDuedateTime2:[[ArryReminder objectAtIndex:0]valueForKey:@"onDuedateTime2"] onDuedateTime3:[[ArryReminder objectAtIndex:0]valueForKey:@"onDuedateTime3"] beforeDuedateChannelId:[[ArryReminder objectAtIndex:0]valueForKey:@"beforeDueDateChannelId"] onDuedateChannelId:[[ArryReminder objectAtIndex:0]valueForKey:@"onDueDateChannelId"] reminderId:[[ArryReminder objectAtIndex:0]valueForKey:@"reminderId"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:startDay",@"ns1:isEveryDay",@"ns1:beforeDuedateTime1",@"ns1:beforeDuedateTime2",@"ns1:beforeDuedateTime3",@"ns1:onDuedateTime1",@"ns1:onDuedateTime2",@"ns1:onDuedateTime3",@"ns1:beforeDuedateChannelId",@"ns1:onDuedateChannelId",@"ns1:reminderId",@"ns1:reminderId",@"ns1:onDuedateChannelId",@"ns1:beforeDuedateChannelId",@"ns1:onDuedateTime3",@"ns1:onDuedateTime2",@"ns1:onDuedateTime1",@"ns1:beforeDuedateTime3",@"ns1:beforeDuedateTime2",@"ns1:beforeDuedateTime1",@"ns1:isEveryDay",@"ns1:startDay",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostUpdateReminder:) andHandler:self];
}
-(void)finishPostUpdateReminder:(NSDictionary*)dictionary
{
    [self PostUpdateTasks:[[ArryUpdateTasks objectAtIndex:iUpdateTask] valueForKey:@"reminderId"]];
}
-(void)PostAddReminder:(NSString*)strTaskId Reminder:(NSMutableArray*)ArryReminder
{
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_CreateReminder] action:[webService getSA_CreateReminder] message:[webService getSM_CreateReminder:strAccesstoken Ack:strAckNo startDay:[[ArryReminder objectAtIndex:0]valueForKey:@"startDay"] isEveryDay:[[ArryReminder objectAtIndex:0]valueForKey:@"isEveryDay"] beforeDuedateTime1:[[ArryReminder objectAtIndex:0]valueForKey:@"beforeDuedateTime1"] beforeDuedateTime2:[[ArryReminder objectAtIndex:0]valueForKey:@"beforeDuedateTime2"] beforeDuedateTime3:[[ArryReminder objectAtIndex:0]valueForKey:@"beforeDuedateTime3"] onDuedateTime1:[[ArryReminder objectAtIndex:0]valueForKey:@"onDuedateTime1"] onDuedateTime2:[[ArryReminder objectAtIndex:0]valueForKey:@"onDuedateTime2"] onDuedateTime3:[[ArryReminder objectAtIndex:0]valueForKey:@"onDuedateTime3"] beforeDuedateChannelId:[[ArryReminder objectAtIndex:0]valueForKey:@"beforeDueDateChannelId"] onDuedateChannelId:[[ArryReminder objectAtIndex:0]valueForKey:@"onDueDateChannelId"] taskId:strTaskId]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:reminderId",@"ns1:taskId",@"ns1:startDay",@"ns1:isEveryDay",@"ns1:beforeDuedateTime1",@"ns1:beforeDuedateTime2",@"ns1:beforeDuedateTime3",@"ns1:onDuedateTime1",@"ns1:onDuedateTime2",@"ns1:onDuedateTime3",@"ns1:beforeDuedateChannelId",@"ns1:onDuedateChannelId",@"ns1:onDuedateChannelId",@"ns1:beforeDuedateChannelId",@"ns1:onDuedateTime3",@"ns1:onDuedateTime2",@"ns1:onDuedateTime1",@"ns1:beforeDuedateTime3",@"ns1:beforeDuedateTime2",@"ns1:beforeDuedateTime1",@"ns1:isEveryDay",@"ns1:startDay",@"ns1:taskId",@"ns1:reminderId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostAddReminder:) andHandler:self];
}
-(void)finishPostAddReminder:(NSDictionary*)dictionary
{
    
    // Update Into tbl_tasks & tbl_reminders
    if ([[dictionary valueForKey:@"array"] count] != 0)
    {
        NSString *StrReminderid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:0] valueForKey:@"ns1:reminderId"]];
        
        NSString *strQueryUpdateTaskReminderId = [NSString stringWithFormat:@"update tbl_tasks Set reminderId=%d Where taskId=%d",[StrReminderid intValue],[[[ArryUpdateTasks objectAtIndex:iUpdateTask]valueForKey:@"taskId"] intValue]];
        [DatabaseAccess updatetbl:strQueryUpdateTaskReminderId];
        
        NSString *strQueryUpdateReminderId = [NSString stringWithFormat:@"update tbl_reminders Set reminderId=%d Where reminderId=%d",[StrReminderid intValue],[[[ArryUpdateTasks objectAtIndex:iUpdateTask]valueForKey:@"reminderId"] intValue]];
        [DatabaseAccess updatetbl:strQueryUpdateReminderId];
        
        [self PostUpdateTasks:[NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:0] valueForKey:@"ns1:reminderId"]]];
    }    
}
-(void)CheckUpdateReminderRemainingOrNot
{
    if (UpdateTaskUpdateRequiredDB)
    {
        if (iUpdateTask < [ArryUpdateTasks count]-1)
        {
            iUpdateTask = iUpdateTask + 1;
            [self PostUpdateTaskReminder];
        }
        else
        {
            [self FetchAddTask];
        }
    }
    else
    {
        [self FetchAddTask];
    }
}
-(void)FetchAddTask
{
    UpdateTaskUpdateRequiredDB = NO;
    NSString *strQuerySelect = @"SELECT * FROM tbl_tasks where istasknew=1";
    ArryAddTask = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
    if ([ArryAddTask count] > 0)
    {
        AddTaskUpdateRequiredDB = YES;
        iAddTask = 0;
        [self PostAddTask];
    }
    else
    {
        [self finishPostAddTask:nil];
    }
}
-(void)PostAddTask
{
    if ([[[ArryAddTask objectAtIndex:iAddTask] valueForKey:@"reminderId"] intValue] == 0)
    {
        wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_PostTaskWOR] action:[webService getSA_PostTaskWOR] message:[webService getSM_PostTaskWOR:strAccesstoken Ack:strAckNo Priority:[[ArryAddTask objectAtIndex:iAddTask] valueForKey:@"priority"] Description:[[ArryAddTask objectAtIndex:iAddTask] valueForKey:@"description"] dueDate:[[ArryAddTask objectAtIndex:iAddTask] valueForKey:@"dueDate"] listId:[[ArryAddTask objectAtIndex:iAddTask] valueForKey:@"listId"] assignId:[[ArryAddTask objectAtIndex:iAddTask] valueForKey:@"assignedId"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:taskId",@"ns1:listId",@"ns1:description",@"ns1:priority",@"ns1:dueDate",@"ns1:reminderId",@"ns1:assignedId",@"ns1:assignedId",@"ns1:reminderId",@"ns1:dueDate",@"ns1:priority",@"ns1:description",@"ns1:listId",@"ns1:taskId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostAddTask:) andHandler:self];
    }
    else
    {
        NSString *strQueryUpdateReminders = [NSString stringWithFormat:@"SELECT * FROM tbl_reminders where reminderId =%d",[[[ArryAddTask objectAtIndex:iAddTask] valueForKey:@"reminderId"] intValue]];
        NSMutableArray *ArryUpdateReminders = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_standerd_reminder:strQueryUpdateReminders]];
        
        wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_PostTaskWR] action:[webService getSA_PostTaskWR] message:[webService getSM_PostTaskWR:strAccesstoken Ack:strAckNo Priority:[[ArryAddTask objectAtIndex:iAddTask] valueForKey:@"priority"] Description:[[ArryAddTask objectAtIndex:iAddTask] valueForKey:@"description"] dueDate:[[ArryAddTask objectAtIndex:iAddTask] valueForKey:@"dueDate"] listId:[[ArryAddTask objectAtIndex:iAddTask] valueForKey:@"listId"] startDay:[[ArryUpdateReminders objectAtIndex:0]valueForKey:@"startDay"] isEveryDay:[[ArryUpdateReminders objectAtIndex:0]valueForKey:@"isEveryDay"] beforeDuedateTime1:[[ArryUpdateReminders objectAtIndex:0]valueForKey:@"beforeDuedateTime1"] beforeDuedateTime2:[[ArryUpdateReminders objectAtIndex:0]valueForKey:@"beforeDuedateTime2"] beforeDuedateTime3:[[ArryUpdateReminders objectAtIndex:0]valueForKey:@"beforeDuedateTime3"] onDuedateTime1:[[ArryUpdateReminders objectAtIndex:0]valueForKey:@"onDuedateTime1"] onDuedateTime2:[[ArryUpdateReminders objectAtIndex:0]valueForKey:@"onDuedateTime2"] onDuedateTime3:[[ArryUpdateReminders objectAtIndex:0]valueForKey:@"onDuedateTime3"] beforeDuedateChannelId:[[ArryUpdateReminders objectAtIndex:0]valueForKey:@"beforeDueDateChannelId"] onDuedateChannelId:[[ArryUpdateReminders objectAtIndex:0]valueForKey:@"onDueDateChannelId"] assignId:[[ArryAddTask objectAtIndex:iAddTask] valueForKey:@"assignedId"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:taskId",@"ns1:listId",@"ns1:description",@"ns1:priority",@"ns1:dueDate",@"ns1:reminderId",@"ns1:senderId",@"ns1:receiverId",@"ns1:taskCategoryType",@"ns1:fadeDate",@"ns1:assignedId",@"ns1:assignedId",@"ns1:fadeDate",@"ns1:taskCategoryType",@"ns1:receiverId",@"ns1:senderId",@"ns1:reminderId",@"ns1:dueDate",@"ns1:priority",@"ns1:description",@"ns1:listId",@"ns1:taskId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostAddWithReminderTask:) andHandler:self];
    }
    
}
-(void)finishPostAddTask:(NSDictionary*)dictionary
{
    NSMutableArray *arryQuery = [[NSMutableArray alloc]init];
        // Update Into tbl_tasks & tbl_Reminders
        for (int i=0; i<[[dictionary valueForKey:@"array"] count]; i++)
        {
            NSString *StrTaskid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:i] valueForKey:@"ns1:taskId"]];
            
            NSString *strQueryUpdateTaskId = [NSString stringWithFormat:@"update tbl_tasks Set taskId=%d Where taskId=%d",[StrTaskid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"taskId"] intValue]];
            [arryQuery addObject:strQueryUpdateTaskId];
            
            NSString *strQueryUpdateTaskIdFadeDate = [NSString stringWithFormat:@"update tbl_add_fadedate Set taskId=%d Where taskId=%d",[StrTaskid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"taskId"] intValue]];
            [arryQuery addObject:strQueryUpdateTaskIdFadeDate];
            
            NSString *strQueryUpdateTaskIdGiveBack = [NSString stringWithFormat:@"update tbl_giveback_tasks Set taskId=%d Where taskId=%d",[StrTaskid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"taskId"] intValue]];
            [arryQuery addObject:strQueryUpdateTaskIdGiveBack];
            
            NSString *strQueryUpdateTaskIdArchive = [NSString stringWithFormat:@"update tbl_archive_tasks Set taskId=%d Where taskId=%d",[StrTaskid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"taskId"] intValue]];
            [arryQuery addObject:strQueryUpdateTaskIdArchive];
            
            NSString *strQueryUpdateTaskIdMessage = [NSString stringWithFormat:@"update tbl_add_messages Set taskId=%d Where taskId=%d",[StrTaskid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"taskId"] intValue]];
            [arryQuery addObject:strQueryUpdateTaskIdMessage];
        }
    if ([arryQuery count] > 0)
    {
        [DatabaseAccess updatetblWithArrayQuery:arryQuery];
    }
    [self CheckAddTaskRemainingOrNot];
}

-(void)finishPostAddWithReminderTask:(NSDictionary*)dictionary
{    
    // Update Into tbl_tasks & tbl_reminders
    if ([[dictionary valueForKey:@"array"] count] != 0)
    {
        NSString *StrReminderid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:0] valueForKey:@"ns1:reminderId"]];
        
        NSString *StrTaskid = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"array"] objectAtIndex:0] valueForKey:@"ns1:taskId"]];
        
        NSString *strQueryUpdateTaskReminderId = [NSString stringWithFormat:@"update tbl_tasks Set reminderId=%d,taskId=%d Where taskId=%d",[StrReminderid intValue],[StrTaskid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"taskId"] intValue]];
        [DatabaseAccess updatetbl:strQueryUpdateTaskReminderId];
        
        NSString *strQueryUpdateReminderId = [NSString stringWithFormat:@"update tbl_reminders Set reminderId=%d Where reminderId=%d",[StrReminderid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"reminderId"] intValue]];
        [DatabaseAccess updatetbl:strQueryUpdateReminderId];
        
        NSString *strQueryUpdateTaskIdFadeDate = [NSString stringWithFormat:@"update tbl_add_fadedate Set taskId=%d Where taskId=%d",[StrTaskid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"taskId"] intValue]];
        [DatabaseAccess updatetbl:strQueryUpdateTaskIdFadeDate];
        
        NSString *strQueryUpdateTaskIdGiveBack = [NSString stringWithFormat:@"update tbl_giveback_tasks Set taskId=%d Where taskId=%d",[StrTaskid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"taskId"] intValue]];
        [DatabaseAccess updatetbl:strQueryUpdateTaskIdGiveBack];
        
        NSString *strQueryUpdateTaskIdArchive = [NSString stringWithFormat:@"update tbl_archive_tasks Set taskId=%d Where taskId=%d",[StrTaskid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"taskId"] intValue]];
        [DatabaseAccess updatetbl:strQueryUpdateTaskIdArchive];
        
        NSString *strQueryUpdateTaskIdMessage = [NSString stringWithFormat:@"update tbl_add_messages Set taskId=%d Where taskId=%d",[StrTaskid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"taskId"] intValue]];
        [DatabaseAccess updatetbl:strQueryUpdateTaskIdMessage];
    }
    [self CheckAddTaskRemainingOrNot];
}
-(void)CheckAddTaskRemainingOrNot
{
    if (AddTaskUpdateRequiredDB)
    {
        if (iAddTask < [ArryAddTask count]-1)
        {
            iAddTask = iAddTask + 1;
            [self PostAddTask];
        }
        else
        {
            [self PostTaskAssignedToOwn];
        }
    }
    else
    {
        [self PostTaskAssignedToOwn];
    }
}
-(void)PostTaskAssignedToOwn
{
    AddTaskUpdateRequiredDB = NO;
    NSString *strQuerySelect = @"SELECT * FROM tbl_tasks where taskassignedto=1";
    NSMutableArray *ArryOwnContactTask = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
    iTaskOwnContact = [ArryOwnContactTask count];
    if ([ArryOwnContactTask count] > 0)
    {
        for (int i = 0; i < [ArryOwnContactTask count]; i++)
        {
            wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_AssignToOwnContact] action:[webService getSA_AssignToOwnContact] message:[webService getSM_AssignToOwnContact:strAccesstoken Ack:strAckNo taskId:[[ArryOwnContactTask objectAtIndex:i] valueForKey:@"taskId"] contactId:[[ArryOwnContactTask objectAtIndex:i] valueForKey:@"assignedId"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil]  endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:taskId",@"ns1:contactId",@"ns1:contactId",@"ns1:taskId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostAssignToOwn:)
                                                            andHandler:self];
        }
    }
    else
    {
        [self finishPostAssignToOwn:nil];
    }
}
-(void)finishPostAssignToOwn:(NSDictionary*)dictionary
{
    if (iTaskOwnContact > 0)
    {
        iTaskOwnContact--;
    }
    if (iTaskOwnContact == 0)
    {
        NSString *strQuerySelect = @"SELECT * FROM tbl_tasks where taskassignedto=2";
        NSMutableArray *ArryOrgContactTask = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
        iTaskOrgContact = [ArryOrgContactTask count];
        if ([ArryOrgContactTask count] > 0)
        {
            [self PostTaskAssignedToOrg:ArryOrgContactTask];
        }
        else
        {
            [self finishPostAssignToOrg:nil];
        }
    }
}
-(void)PostTaskAssignedToOrg:(NSMutableArray*)ArryOrgContactTask
{
    for (int i = 0; i< [ArryOrgContactTask count]; i++)
    {
        wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_AssignToOrgContact] action:[webService getSA_AssignToOrgContact] message:[webService getSM_AssignToOrgContact:strAccesstoken Ack:strAckNo taskId:[[ArryOrgContactTask objectAtIndex:i] valueForKey:@"taskId"] contactId:[[ArryOrgContactTask objectAtIndex:i] valueForKey:@"assignedId"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:taskId",@"ns1:contactId",@"ns1:contactId",@"ns1:taskId",nil]  otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostAssignToOrg:) andHandler:self];
    }
}
-(void)finishPostAssignToOrg:(NSDictionary*)dictionary
{
    if (iTaskOrgContact > 0)
    {
        iTaskOrgContact--;
    }
    if (iTaskOrgContact == 0)
    {
        NSString *strQuerySelect = @"SELECT * FROM tbl_tasks where taskstatus=5";
        NSMutableArray *ArryCallBackTask = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_tasks:strQuerySelect]];
        iTaskCallBack = [ArryCallBackTask count];
        if ([ArryCallBackTask count] > 0)
        {
            [self PostTaskCallBack:ArryCallBackTask];
        }
        else
        {
            [self finishPostCallBackTask:nil];
        }
    }
}
-(void)PostTaskCallBack:(NSMutableArray*)ArryCallBackTask
{
    for (int i = 0; i < [ArryCallBackTask count]; i++)
    {
        wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_CallBackTask] action:[webService getSA_CallBackTask] message:[webService getSM_CallBackTask:strAccesstoken Ack:strAckNo taskId:[[ArryCallBackTask objectAtIndex:i]valueForKey:@"taskId"] UserId:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"]]] rootTag:@"ns1:soapOut"  startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil]  endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:taskId",@"ns1:listId",@"ns1:description",@"ns1:priority",@"ns1:dueDate",@"ns1:reminderId",@"ns1:senderId",@"ns1:receiverId",@"ns1:taskCategoryType",@"ns1:fadeDate",@"ns1:assignedId",@"ns1:assignedId",@"ns1:fadeDate",@"ns1:taskCategoryType",@"ns1:receiverId",@"ns1:senderId",@"ns1:reminderId",@"ns1:dueDate",@"ns1:priority",@"ns1:description",@"ns1:listId",@"ns1:taskId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostCallBackTask:) andHandler:self];
    }
}
-(void)finishPostCallBackTask:(NSDictionary*)dictionary
{
    if (iTaskCallBack > 0)
    {
        iTaskCallBack--;
    }
    if (iTaskCallBack == 0)
    {
        NSString *strQuerySelect = @"SELECT * FROM tbl_giveback_tasks";
        NSMutableArray *ArryGiveBackTask = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_giveback_tasks:strQuerySelect]];
        iTaskGiveBack = [ArryGiveBackTask count];
        if ([ArryGiveBackTask count] > 0)
        {
            [self PostTaskGiveBack:ArryGiveBackTask];
        }
        else
        {
            [self finishPostGiveBackTask:nil];
        }
    }
}
-(void)PostTaskGiveBack:(NSMutableArray*)ArryGiveBackTask
{
    for (int i = 0; i < [ArryGiveBackTask count]; i++)
    {
        wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_GiveBackTask] action:[webService getSA_GiveBackTask] message:[webService getSM_GiveBackTask:strAccesstoken Ack:strAckNo taskId:[[ArryGiveBackTask objectAtIndex:i]valueForKey:@"taskId"] UserId:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:taskId",@"ns1:userId",@"ns1:userId",@"ns1:taskId",nil]  otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostGiveBackTask:) andHandler:self];
    }
}
-(void)finishPostGiveBackTask:(NSDictionary*)dictionary
{
    if (iTaskGiveBack > 0)
    {
        iTaskGiveBack--;
    }
    if (iTaskGiveBack == 0)
    {
        NSString *strQuerySelect = @"SELECT * FROM tbl_archive_tasks";
        NSMutableArray *ArryArchieveTask = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_archive_tasks:strQuerySelect]];
        iTaskArchieve = [ArryArchieveTask count];
        if ([ArryArchieveTask count] > 0)
        {
            [self PostTaskArchieve:ArryArchieveTask];
        }
        else
        {
            [self finishPostArchiveTask:nil];
        }
    }
}
-(void)PostTaskArchieve:(NSMutableArray*)ArryArchieveTask
{
    for (int i = 0; i < [ArryArchieveTask count]; i++)
    {
        wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_ArchiveTask] action:[webService getSA_ArchiveTask] message:[webService getSM_ArchiveTask:strAccesstoken Ack:strAckNo TaskId:[[ArryArchieveTask objectAtIndex:i] valueForKey:@"taskId"] UserId:[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:taskId",@"ns1:listId",@"ns1:description",@"ns1:priority",@"ns1:dueDate",@"ns1:reminderId",@"ns1:senderId",@"ns1:receiverId",@"ns1:taskCategoryType",@"ns1:fadeDate",@"ns1:assignedId",@"ns1:assignedId",@"ns1:fadeDate",@"ns1:taskCategoryType",@"ns1:receiverId",@"ns1:senderId",@"ns1:reminderId",@"ns1:dueDate",@"ns1:priority",@"ns1:description",@"ns1:listId",@"ns1:taskId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostArchiveTask:) andHandler:self];
    }
}
-(void)finishPostArchiveTask:(NSDictionary*)dictionary
{
    if (iTaskArchieve > 0)
    {
        iTaskArchieve--;
    }
    if (iTaskArchieve == 0)
    {
        NSString *strQuerySelect = @"SELECT * FROM tbl_add_messages";
        NSMutableArray *ArryMessageTask = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_add_messages:strQuerySelect]];
        iTaskMessage = [ArryMessageTask count];
        if ([ArryMessageTask count] > 0)
        {
            [self PostTaskMessage:ArryMessageTask];
        }
        else
        {
            [self finishPostMsg:nil];
        }
    }
}
-(void)PostTaskMessage:(NSMutableArray*)ArryMessageTask
{
    for (int i = 0; i < [ArryMessageTask count]; i++)
    {
        wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_CreateMsg] action:[webService getSA_CreateMsg] message:[webService getSM_CreateMsg:strAccesstoken Ack:strAckNo MsgId:[[ArryMessageTask objectAtIndex:i]valueForKey:@"messageId"] MsgDesc:[[ArryMessageTask objectAtIndex:i]valueForKey:@"messageDescription"] MsgType:[[ArryMessageTask objectAtIndex:i]valueForKey:@"messageType"] RecieverId:[[ArryMessageTask objectAtIndex:i]valueForKey:@"recieverId"] SenderId:[[ArryMessageTask objectAtIndex:i]valueForKey:@"senderId"] TaskId:[[ArryMessageTask objectAtIndex:i]valueForKey:@"taskId"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil]  endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:messageId",@"ns1:messageDescription",@"ns1:messageType",@"ns1:receiverId",@"ns1:senderId",@"ns1:taskId",@"ns1:taskId",@"ns1:senderId",@"ns1:receiverId",@"ns1:messageType",@"ns1:messageDescription",@"ns1:messageId",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishPostMsg:) andHandler:self];
    }
}
-(void)finishPostMsg:(NSDictionary*)dictionary
{
    if (iTaskMessage > 0)
    {
        iTaskMessage--;
    }
    if (iTaskMessage == 0)
    {
        NSString *strQueryDelete = @"DELETE FROM tbl_add_messages";
        [DatabaseAccess updatetbl:strQueryDelete];
        [self PostUpdateUserSettings];
    }
}
-(void)PostUpdateUserSettings
{
    //Send Data Of user setting from local databse
    NSString *strQuerySelect = @"SELECT * FROM tbl_user_setting";
    NSMutableArray *ArrySettings = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_user_setting:strQuerySelect]];
    
    NSString *strQuerySelectTimeZone = [NSString stringWithFormat:@"SELECT * FROM tbl_timezone where zoneTime='%@'",[[ArrySettings objectAtIndex:0] valueForKey:@"timeZone"]];
    NSMutableArray *ArryTimeZone = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_TimeZone:strQuerySelectTimeZone]];
    
    NSString *strTimeZone;
    if ([ArryTimeZone count] == 0)
    {
        NSString *strQuerySelectTimeZone = [NSString stringWithFormat:@"SELECT * FROM tbl_timezone where zoneId='%@'",[[ArrySettings objectAtIndex:0] valueForKey:@"timeZone"]];
        NSMutableArray *ArryTimeZone = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_TimeZone:strQuerySelectTimeZone]];
        
        if ([ArryTimeZone count] == 0)
        {
            strTimeZone = [NSString stringWithFormat:@"%@",[[ArrySettings objectAtIndex:0] valueForKey:@"timeZone"]];
        }
        else
        {
            strTimeZone = [NSString stringWithFormat:@"%@",[[ArryTimeZone objectAtIndex:0]valueForKey:@"zoneId"]];
        }
    }
    else
    {
        strTimeZone = [NSString stringWithFormat:@"%@",[[ArryTimeZone objectAtIndex:0]valueForKey:@"zoneId"]];
    }
    
    wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_UpdateUserSetting] action:[webService getSA_UpdateUserSetting] message:[webService getSM_UpdateUserSetting:strAccesstoken Ack:strAckNo TimeFormat:[[ArrySettings objectAtIndex:0] valueForKey:@"timeFormat"] DateFormat:[[ArrySettings objectAtIndex:0] valueForKey:@"dateFormat"] TimeZone:strTimeZone Language:[[ArrySettings objectAtIndex:0] valueForKey:@"language"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil]  endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:errorCode",@"ns1:errorCode",nil]  otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishUpdateUserSetting:) andHandler:self];
}
-(void)finishUpdateUserSetting:(NSDictionary*)dictionary
{
    NSString *strQuerySelect = @"SELECT * FROM tbl_add_fadedate";
    NSMutableArray *ArryTaskFadeDate = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_add_fadedate:strQuerySelect]];
    iFadeDate = [ArryTaskFadeDate count];
    if ([ArryTaskFadeDate count] == 0)
    {
        [self finishfadeDate:nil];
    }
    else
    {
        [self PostTaskFadeDate:ArryTaskFadeDate];
    }
    
}
-(void)PostTaskFadeDate:(NSMutableArray*)ArryTaskFadeDate
{
    for (int i = 0; i < [ArryTaskFadeDate count]; i++)
    {
        wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_UpdateTaskFadeOnDate] action:[webService getSA_UpdateTaskFadeOnDate] message:[webService getSM_UpdateTaskFadeOnDate:strAccesstoken Ack:strAckNo TaskId:[[ArryTaskFadeDate objectAtIndex:i]valueForKey:@"taskId"] TaskFadeOnDate:[[ArryTaskFadeDate objectAtIndex:i]valueForKey:@"fadedate"]]] rootTag:@"ns1:soapOut" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:taskId",@"ns1:taskFadeOnDate",@"ns1:taskFadeOnDate",@"ns1:taskId",nil]  otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishfadeDate:) andHandler:self];
    }
}
-(void)finishfadeDate:(NSDictionary*)dictionary
{
    if (iFadeDate > 0)
    {
        iFadeDate--;
    }
    if (iFadeDate == 0)
    {
        NSString *strQueryDelete = @"DELETE FROM tbl_add_fadedate";
        [DatabaseAccess updatetbl:strQueryDelete];
        
        NSString *strQueryDeleteGiveBack = @"DELETE FROM tbl_giveback_tasks";
        [DatabaseAccess updatetbl:strQueryDeleteGiveBack];
        
        NSString *strQueryDeleteArchive = @"DELETE FROM tbl_archive_tasks";
        [DatabaseAccess updatetbl:strQueryDeleteArchive];
        
        NSString *strQueryUpdateTask = @"update tbl_tasks Set taskstatus=0,istasknew=0,taskassignedto=0";
        [DatabaseAccess updatetbl:strQueryUpdateTask];
        
        NSString *strQueryUpdateReminder = @"update tbl_reminders Set reminderstatus=0,isremindernew=0";
        [DatabaseAccess updatetbl:strQueryUpdateReminder];
    }
    SetSyncFlag = YES;
   // NSLog(@"Final Done");
    [AppDel dismissGlobalHUD];
    
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
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        [[NSBundle mainBundle] loadNibNamed:@"HomeViewCtr" owner:self options:nil];
        scl_bg.contentSize = CGSizeMake(320, 535);
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        [[NSBundle mainBundle] loadNibNamed:@"HomeViewCtr_landscap" owner:self options:nil];
        scl_bg.contentSize = CGSizeMake(scl_bg.frame.size.width, 420);
    }
    if ([GlobalMethods CheckPhoneVersionisiOS7])
    {
        scl_bg.frame = CGRectMake(scl_bg.frame.origin.x, scl_bg.frame.origin.y + 20, scl_bg.frame.size.width, scl_bg.frame.size.height  - 20);
    }
    NSString *UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        [btnDoNow setImage:[UIImage imageNamed:@"home_do_now_sel_ge.png"] forState:UIControlStateNormal];
        [btnNewTask setImage:[UIImage imageNamed:@"home_new_task_sel_ge.png"] forState:UIControlStateNormal];
        [btnList setImage:[UIImage imageNamed:@"home_list_sel_ge.png"] forState:UIControlStateNormal];
        [btnManageList setImage:[UIImage imageNamed:@"home_manage_list_sel_ge.png"] forState:UIControlStateNormal];
        [btnPriority setImage:[UIImage imageNamed:@"home_priority_sel_ge.png"] forState:UIControlStateNormal];
        [btnSchedule setImage:[UIImage imageNamed:@"home_schedule_sel_ge.png"] forState:UIControlStateNormal];
        [btnProductivity setImage:[UIImage imageNamed:@"home_productivity_sel_ge.png"] forState:UIControlStateNormal];
        [btnSetting setImage:[UIImage imageNamed:@"home_settings_sel_ge.png"] forState:UIControlStateNormal];
        
        btnSchedule.imageEdgeInsets = UIEdgeInsetsMake(75, 0, 0, 0);
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM.dd"];
    lblScheduleDate.text = [format stringFromDate:[NSDate date]];
    
    // Set Current Page & No of pages of the Page Control
    PageCntr.numberOfPages = 3;
    PageCntr.currentPage = 0;
    // Set PageControl Color to Current Page and Number of pages
    PageCntr.pageIndicatorTintColor = [UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0];
	PageCntr.currentPageIndicatorTintColor = [UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0];
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
