//
//  DatabaseAccess.m
//  Database
//
//  Created by apple on 01/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatabaseAccess.h"
#import <sqlite3.h>

@implementation DatabaseAccess

+(NSArray*)gettbl_TimeZone:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];             
		sqlite3_stmt *compiledStmt;                           
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *Z_id=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *Z_Name=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *Z_Time=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                             
                
				NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:Z_id,@"zoneId",Z_Name,@"zoneName",Z_Time,@"zoneTime",nil];
				[CP addObject:d];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	} 
}
+(NSArray*)gettbl_user_setting:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *U_profileId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *U_country=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *U_language=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
				NSString *U_timeZone=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *U_timeFormat=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *U_dateFormat=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *U_firstName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *U_lastName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *U_dueDates=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *U_fadeOn=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                NSString *U_userId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSString *U_fadeOnDays=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:U_profileId,@"profileId",U_country,@"country",U_language,@"language",U_timeZone,@"timeZone",U_timeFormat,@"timeFormat",U_dateFormat,@"dateFormat",U_firstName,@"firstName",U_lastName,@"lastName",U_dueDates,@"dueDates",U_fadeOn,@"fadeOn",U_userId,@"userId",U_fadeOnDays,@"fadeOnDays",nil];
				[CP addObject:d];
                
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	}
}
+(NSArray*)gettbl_lists:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                                
                NSString *L_listId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *L_listName=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *L_listActiveColor=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
				NSString *L_listCategory=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *L_listStatus=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
				NSString *L_isListNew=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                            
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:L_listId,@"listId",L_listName,@"listName",L_listActiveColor,@"listActiveColor",L_listCategory,@"listCategory",L_listStatus,@"liststatus",L_isListNew,@"islistnew",nil];
				[CP addObject:d];
                
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	}
}
+(NSArray*)gettbl_tasks:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *T_taskId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *T_listId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *T_description=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(compiledStmt, 2)];
				NSString *T_priority=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *T_dueDate=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *T_reminderId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *T_senderId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *T_receiverId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *T_taskCategoryType=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *T_fadeDate=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                NSString *T_assignedId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSString *T_taskstatus=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                NSString *T_istasknew=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];
                NSString *T_taskassignedto=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 13)];
                                
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:T_taskId,@"taskId",T_listId,@"listId",T_description,@"description",T_priority,@"priority",T_dueDate,@"dueDate",T_reminderId,@"reminderId",T_senderId,@"senderId",T_receiverId,@"receiverId",T_taskCategoryType,@"taskCategoryType",T_fadeDate,@"fadeDate",T_assignedId,@"assignedId",T_taskstatus,@"taskstatus",T_istasknew,@"istasknew",T_taskassignedto,@"taskassignedto",nil];
				[CP addObject:d];
                
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	}

}
+(NSArray*)gettbl_own_contact:(NSString*)strQuery
{
    
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *Own_contactid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *Own_firstName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *Own_lastName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:Own_contactid,@"contactid",Own_firstName,@"firstName",Own_lastName,@"lastName",nil];
				[CP addObject:d];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	}
}
+(NSArray*)gettbl_org_contact:(NSString*)strQuery
{
    
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *Org_contactRequestId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *Org_firstName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *Org_lastName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *Org_senderId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
				NSString *Org_receiverId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *Org_contactStatus=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:Org_contactRequestId,@"contactRequestId",Org_firstName,@"firstName",Org_lastName,@"lastName",Org_senderId,@"senderId",Org_receiverId,@"receiverId",Org_contactStatus,@"contactStatus",nil];
				[CP addObject:d];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	}
}
+(NSArray*)gettbl_standerd_reminder:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *SR_reminderId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *SR_startDay=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *SR_isEveryDay=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *SR_beforeDuedateTime1=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
				NSString *SR_beforeDuedateTime2=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *SR_beforeDuedateTime3=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *SR_onDuedateTime1=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
				NSString *SR_onDuedateTime2=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *SR_onDuedateTime3=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *SR_beforeDueDateChannelId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                NSString *SR_onDueDateChannelId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSString *SR_reminderstatus=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                NSString *SR_isremindernew=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];
                
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:SR_reminderId,@"reminderId",SR_startDay,@"startDay",SR_isEveryDay,@"isEveryDay",SR_beforeDuedateTime1,@"beforeDuedateTime1",SR_beforeDuedateTime2,@"beforeDuedateTime2",SR_beforeDuedateTime3,@"beforeDuedateTime3",SR_onDuedateTime1,@"onDuedateTime1",SR_onDuedateTime2,@"onDuedateTime2",SR_onDuedateTime3,@"onDuedateTime3",SR_beforeDueDateChannelId,@"beforeDueDateChannelId",SR_onDueDateChannelId,@"onDueDateChannelId",SR_reminderstatus,@"reminderstatus",SR_isremindernew,@"isremindernew",nil];
				[CP addObject:d];
                
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	}
}
+(NSArray*)gettbl_channels:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *C_channelId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *C_channelName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *C_channelCategory=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *C_isDefault=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:C_channelId,@"channelId",C_channelName,@"channelName",C_channelCategory,@"channelCategory",C_isDefault,@"isDefault",nil];
				[CP addObject:d];
                
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	}
}
+(NSArray*)gettbl_add_messages:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *M_messageId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *M_messageDescription=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *M_messageType=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *M_recieverId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *M_senderId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *M_taskId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:M_messageId,@"messageId",M_messageDescription,@"messageDescription",M_messageType,@"messageType",M_recieverId,@"recieverId",M_senderId,@"senderId",M_taskId,@"taskId",nil];
				[CP addObject:d];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	}

}
+(NSArray*)gettbl_add_fadedate:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *F_taskId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *F_fadedate=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];

				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:F_taskId,@"taskId",F_fadedate,@"fadedate",nil];
				[CP addObject:d];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	}
}
+(NSArray*)gettbl_giveback_tasks:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *G_taskId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:G_taskId,@"taskId",nil];
				[CP addObject:d];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	}
}
+(NSArray*)gettbl_archive_tasks:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *A_taskId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:A_taskId,@"taskId",nil];
				[CP addObject:d];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	}
}
+(NSArray*)gettbl_messages:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *M_messageId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *M_messageDescription=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *M_messageType=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *M_recieverId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *M_senderId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *M_taskId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:M_messageId,@"messageId",M_messageDescription,@"messageDescription",M_messageType,@"messageType",M_recieverId,@"recieverId",M_senderId,@"senderId",M_taskId,@"taskId",nil];
				[CP addObject:d];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([CP count]>0){
		NSArray *ar=[NSArray arrayWithArray:CP];
		return ar;
	} else {
		return nil;
	}
}
int MaxID;
+(int)getMaxid:(NSString*)strQuery
{
   
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                MaxID = [[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)] intValue];
                
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	return MaxID;
}
+(int)updatetbl:(NSString*)strQuery;
{
	sqlite3 *database;
    
    if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK) {
        
        const char *sqlStmt=[strQuery UTF8String];                           
        sqlite3_stmt *cmp_sqlStmt;
        if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK) {
            int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL);
            ((returnValue==SQLITE_OK) ?  NSLog(@"Success") :  NSLog(@"UnSuccess") );
            sqlite3_step(cmp_sqlStmt);
        }
        sqlite3_finalize(cmp_sqlStmt);
    }
    int rid= sqlite3_last_insert_rowid(database);
    sqlite3_close(database);
    return rid;
}

+(void)updatetblWithArrayQuery:(NSMutableArray*)arryQuery
{
	sqlite3 *database;
    
    if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK) {
        
        for (int i = 0; i < [arryQuery count]; i++)
        {
            NSString *strQuery = [NSString stringWithFormat:@"%@",[arryQuery objectAtIndex:i]];
            const char *sqlStmt=[strQuery UTF8String];
            sqlite3_stmt *cmp_sqlStmt;
            if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK) {
                int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL);
                ((returnValue==SQLITE_OK) ?  NSLog(@"Success") :  NSLog(@"UnSuccess") );
                sqlite3_step(cmp_sqlStmt);
            }
            sqlite3_finalize(cmp_sqlStmt);
        }
        
    }
    sqlite3_close(database);
}

@end
