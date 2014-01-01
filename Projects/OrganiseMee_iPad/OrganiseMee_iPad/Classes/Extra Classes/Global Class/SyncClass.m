//
//  SyncClass.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 9/2/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "SyncClass.h"
#import "AppDelegate.h"
#import "DatabaseAccess.h"
#import "WSPContinuous.h"
#import "webService.h"
#import "Header.h"

@implementation SyncClass

-(void)CallSync:(NSString*)strCheckProgress
{
    //Send Data Of user setting from local databse
    NSString *strQuerySelect = @"SELECT * FROM tbl_user_setting";
    ArryretriveUserSettings = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_user_setting:strQuerySelect]];
    
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
        
        
        NSString *strQueryUpdateTaskIdMsg = [NSString stringWithFormat:@"update tbl_messages Set taskId=%d Where taskId=%d",[StrTaskid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"taskId"] intValue]];
        [arryQuery addObject:strQueryUpdateTaskIdMsg];
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
        
        NSString *strQueryUpdateTaskIdMsg = [NSString stringWithFormat:@"update tbl_messages Set taskId=%d Where taskId=%d",[StrTaskid intValue],[[[ArryAddTask objectAtIndex:iAddTask]valueForKey:@"taskId"] intValue]];
        [DatabaseAccess updatetbl:strQueryUpdateTaskIdMsg];
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


@end
