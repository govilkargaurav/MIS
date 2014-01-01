//
//  webService.h
//  ZawJi
//
//  Created by openxcell open on 11/16/10.
//  Copyright 2010 xcsxzc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface webService : NSObject {

}

//---------------------------------------
+(NSString*)getWS_accessToken;
+(NSString*)getSA_accessToken;
+(NSString*)getSM_accessToken;

//---------------------------------------

+(NSString*)getWS_Login;
+(NSString*)getSA_Login;
+(NSString*)getSM_Login:(NSString*)txtUname Password:(NSString*)txtPass AccessToken:(NSString*)accessToken;

//---------------------------------------

+(NSString*)getWS_UserSetting;
+(NSString*)getSA_UserSetting;
+(NSString*)getSM_UserSetting:(NSString*)AccessToken Ack:(NSString*)ACK;
//+(NSString*)getSM_UserSetting;
//---------------------------------------

+(NSString*)getWS_GetTaskDesc;
+(NSString*)getSA_GetTaskDesc;
+(NSString*)getSM_GetTaskDesc:(NSString*)AccessToken Ack:(NSString*)ACK;

//---------------------------------------

+(NSString*)getWS_GetList;
+(NSString*)getSA_GetList;
+(NSString*)getSM_GetList:(NSString*)AccessToken Ack:(NSString*)ACK;

//---------------------------------------

+(NSString*)getWS_GetOwnCont;
+(NSString*)getSA_GetOwnCont;
+(NSString*)getSM_GetOwnCont:(NSString*)AccessToken Ack:(NSString*)ACK userId:(NSString*)UserId;

//---------------------------------------

+(NSString*)getWS_GetOrgCont;
+(NSString*)getSA_GetOrgCont;
+(NSString*)getSM_GetOrgCont:(NSString*)AccessToken Ack:(NSString*)ACK userId:(NSString*)UserId;

//---------------------------------------

+(NSString*)getWS_GetMessage;
+(NSString*)getSA_GetMessage;
+(NSString*)getSM_GetMessage:(NSString*)AccessToken Ack:(NSString*)ACK userId:(NSString*)UserId;

//---------------------------------------

+(NSString*)getWS_GetChannel;
+(NSString*)getSA_GetChannel;
+(NSString*)getSM_GetChannel:(NSString*)AccessToken Ack:(NSString*)ACK userId:(NSString*)UserId;

//---------------------------------------

+(NSString*)getWS_GetTimeZone;
+(NSString*)getSA_GetTimeZone;
+(NSString*)getSM_GetTimeZone:(NSString*)AccessToken Ack:(NSString*)ACK userId:(NSString*)UserId;

//---------------------------------------

+(NSString*)getWS_GetStandardReminder;
+(NSString*)getSA_GetStandardReminder;
+(NSString*)getSM_GetStandardReminder:(NSString*)AccessToken Ack:(NSString*)ACK userId:(NSString*)UserId;

//---------------------------------------

+(NSString*)getWS_GetReminders;
+(NSString*)getSA_GetReminders;
+(NSString*)getSM_GetReminders:(NSString*)AccessToken Ack:(NSString*)ACK userId:(NSString*)UserId;

//---------------------------------------

+(NSString*)getWS_GetCountries;
+(NSString*)getSA_GetCountries;
+(NSString*)getSM_GetCountries:(NSString*)AccessToken Ack:(NSString*)ACK userId:(NSString*)UserId;

//---------------------------------------
+(NSMutableURLRequest*)getURq_getansascreen:(NSString*)ws_name action:(NSString*)sa_Name message:(NSString*)sm_msg;

//---------------------------------------

+(NSString*)getWS_PostList;
+(NSString*)getSA_PostList;
+(NSString*)getSM_PostList:(NSString*)AccessToken Ack:(NSString*)ACK listName:(NSString*)listname;

//---------------------------------------

+(NSString*)getWS_PostUpdateList;
+(NSString*)getSA_PostUpdateList;
+(NSString*)getSM_PostUpdateList:(NSString*)AccessToken Ack:(NSString*)ACK listName:(NSString*)listname listId:(NSString*)listid listCategory:(NSString*)listcategory;

//---------------------------------------

+(NSString*)getWS_PostTaskWOR;
+(NSString*)getSA_PostTaskWOR;
+(NSString*)getSM_PostTaskWOR:(NSString*)AccessToken Ack:(NSString*)ACK Priority:(NSString*)priority Description:(NSString*)desc dueDate:(NSString*)duedate listId:(NSString*)listid assignId:(NSString*)assignid;

//---------------------------------------

+(NSString*)getWS_PostTaskWR;
+(NSString*)getSA_PostTaskWR;
+(NSString*)getSM_PostTaskWR:(NSString*)AccessToken Ack:(NSString*)ACK Priority:(NSString*)priority Description:(NSString*)desc dueDate:(NSString*)duedate listId:(NSString*)listid startDay:(NSString*)startday isEveryDay:(NSString*)iseveryday beforeDuedateTime1:(NSString*)beforeduedatetime1 beforeDuedateTime2:(NSString*)beforeduedatetime2 beforeDuedateTime3:(NSString*)beforeduedatetime3 onDuedateTime1:(NSString*)onduedatetime1 onDuedateTime2:(NSString*)onduedatetime2 onDuedateTime3:(NSString*)onduedatetime3 beforeDuedateChannelId:(NSString*)beforeduedatechannelid onDuedateChannelId:(NSString*)onduedatechannelid assignId:(NSString*)assignid;

//---------------------------------------

+(NSString*)getWS_PostUpdateTask;
+(NSString*)getSA_PostUpdateTask;
+(NSString*)getSM_PostUpdateTask:(NSString*)AccessToken Ack:(NSString*)ACK TaskId:(NSString*)taskId Priority:(NSString*)priority Description:(NSString*)desc dueDate:(NSString*)duedate listId:(NSString*)listid assignId:(NSString*)assignid reminderId:(NSString*)reminderid;

//---------------------------------------

+(NSString*)getWS_Register;
+(NSString*)getSA_Register;
+(NSString*)getSM_Register:(NSString*)UName FirstName:(NSString*)FName LastName:(NSString*)LName EMail:(NSString*)Email Password:(NSString*)Pass;

//---------------------------------------

+(NSString*)getWS_DeleteTask;
+(NSString*)getSA_DeleteTask;
+(NSString*)getSM_DeleteTask:(NSString*)AccessToken Ack:(NSString*)ACK TaskId:(NSString*)taskId ;

//---------------------------------------

+(NSString*)getWS_DeleteList;
+(NSString*)getSA_DeleteList;
+(NSString*)getSM_DeleteList:(NSString*)AccessToken Ack:(NSString*)ACK ListId:(NSString*)listId ;

//---------------------------------------

+(NSString*)getWS_CreateReminder;
+(NSString*)getSA_CreateReminder;
+(NSString*)getSM_CreateReminder:(NSString*)AccessToken Ack:(NSString*)ACK startDay:(NSString*)startday isEveryDay:(NSString*)iseveryday beforeDuedateTime1:(NSString*)beforeduedatetime1 beforeDuedateTime2:(NSString*)beforeduedatetime2 beforeDuedateTime3:(NSString*)beforeduedatetime3 onDuedateTime1:(NSString*)onduedatetime1 onDuedateTime2:(NSString*)onduedatetime2 onDuedateTime3:(NSString*)onduedatetime3 beforeDuedateChannelId:(NSString*)beforeduedatechannelid onDuedateChannelId:(NSString*)onduedatechannelid taskId:(NSString*)taskid;

//---------------------------------------

+(NSString*)getWS_UpdateReminder;
+(NSString*)getSA_UpdateReminder;
+(NSString*)getSM_UpdateReminder:(NSString*)AccessToken Ack:(NSString*)ACK taskId:(NSString*)taskid startDay:(NSString*)startday isEveryDay:(NSString*)iseveryday beforeDuedateTime1:(NSString*)beforeduedatetime1 beforeDuedateTime2:(NSString*)beforeduedatetime2 beforeDuedateTime3:(NSString*)beforeduedatetime3 onDuedateTime1:(NSString*)onduedatetime1 onDuedateTime2:(NSString*)onduedatetime2 onDuedateTime3:(NSString*)onduedatetime3 beforeDuedateChannelId:(NSString*)beforeduedatechannelid onDuedateChannelId:(NSString*)onduedatechannelid reminderId:(NSString*)reminderid ;

//---------------------------------------

+(NSString*)getWS_DeleteReminder;
+(NSString*)getSA_DeleteReminder;
+(NSString*)getSM_DeleteReminder:(NSString*)AccessToken Ack:(NSString*)ACK taskId:(NSString*)taskid reminderId:(NSString*)reminderid ;

//---------------------------------------


#pragma mark - CallBackTask.

+(NSString*)getWS_CallBackTask;
+(NSString*)getSA_CallBackTask;
+(NSString*)getSM_CallBackTask:(NSString*)AccessToken Ack:(NSString*)ACK taskId:(NSString*)taskid UserId:(NSString *)userid;

//---------------------------------------

#pragma mark - GiveBackTask.

+(NSString*)getWS_GiveBackTask;
+(NSString*)getSA_GiveBackTask;
+(NSString*)getSM_GiveBackTask:(NSString*)AccessToken Ack:(NSString*)ACK taskId:(NSString*)taskid UserId:(NSString *)userid;

//---------------------------------------

#pragma mark - assignToOwnContact.

+(NSString*)getWS_AssignToOwnContact;
+(NSString*)getSA_AssignToOwnContact;
+(NSString*)getSM_AssignToOwnContact:(NSString*)AccessToken Ack:(NSString*)ACK taskId:(NSString*)taskid contactId:(NSString*)contactid;

//---------------------------------------

#pragma mark - assignToOrgContact.

+(NSString*)getWS_AssignToOrgContact;
+(NSString*)getSA_AssignToOrgContact;
+(NSString*)getSM_AssignToOrgContact:(NSString*)AccessToken Ack:(NSString*)ACK taskId:(NSString*)taskid contactId:(NSString*)contactid;

//---------------------------------------

#pragma mark - Create Message.

+(NSString*)getWS_CreateMsg;
+(NSString*)getSA_CreateMsg;
+(NSString*)getSM_CreateMsg:(NSString*)AccessToken Ack:(NSString*)ACK MsgId:(NSString*)msgid MsgDesc:(NSString*)msgdesc MsgType:(NSString*)msgtype RecieverId:(NSString*)recieverid SenderId:(NSString*)senderid TaskId:(NSString*)taskid;

//---------------------------------------

#pragma mark - Update User Setting.

+(NSString*)getWS_UpdateUserSetting;
+(NSString*)getSA_UpdateUserSetting;
+(NSString*)getSM_UpdateUserSetting:(NSString*)AccessToken Ack:(NSString*)ACK TimeFormat:(NSString*)timeformat DateFormat:(NSString*)dateformat TimeZone:(NSString*)timezone Language:(NSString*)language;

//---------------------------------------

#pragma mark - Update TaskFadeOnDate.

+(NSString*)getWS_UpdateTaskFadeOnDate;
+(NSString*)getSA_UpdateTaskFadeOnDate;
+(NSString*)getSM_UpdateTaskFadeOnDate:(NSString*)AccessToken Ack:(NSString*)ACK TaskId:(NSString*)taskid TaskFadeOnDate:(NSString*)taskfadeondate;

//---------------------------------------

#pragma mark - Update Priority.

+(NSString*)getWS_UpdateTaskPriority;
+(NSString*)getSA_UpdateTaskPriority;
+(NSString*)getSM_UpdateTaskPriority:(NSString*)AccessToken Ack:(NSString*)ACK TaskId:(NSString*)taskid TaskPriority:(NSString*)taskpriority;

//---------------------------------------

#pragma mark - Archive Task.

+(NSString*)getWS_ArchiveTask;
+(NSString*)getSA_ArchiveTask;
+(NSString*)getSM_ArchiveTask:(NSString*)AccessToken Ack:(NSString*)ACK TaskId:(NSString*)taskid UserId:(NSString*)userid;

//---------------------------------------

@end
