//
//  DatabaseAccess.m
//  Database
//
//  Created by apple on 01/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatabaseAccess.h"
#import "GlobleClass.h"
#import <sqlite3.h>

@implementation DatabaseAccess

+(void)insertAddDepartment:(NSString*)deptname uid:(int)uid superadminid:(int)superadminid
{
     AppDelegate *x=( AppDelegate *)[[UIApplication sharedApplication]delegate];
	sqlite3 *database;
	
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) 
    {
	    
        if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
        {
            NSString *str=[NSString stringWithFormat:@"insert into AddDepartment(deptname,uid,superadminid) values('%@',%d,%d)",deptname,uid,superadminid];
            //NSLog(@"%@",str);
            const char *sqlStmt=[str UTF8String];                           
            sqlite3_stmt *cmp_sqlStmt;
            if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK) 
            {
                int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL);
                ((returnValue==SQLITE_OK) ?  NSLog(@"Success") :  NSLog(@"UnSuccess") );
                sqlite3_step(cmp_sqlStmt);
            }
            sqlite3_finalize(cmp_sqlStmt);
        }
    }    
	sqlite3_close(database);
}

+(NSArray*)getAddDepartment:(int)uid parent:(int)parent{
    NSMutableArray *Favourite=[[NSMutableArray alloc]init];
	sqlite3 *database;
	 AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
        NSString *str = [NSString stringWithFormat:@"select *from AddDepartment where uid=%d and superadminid=%d",uid,parent];
		const char *sqlStmt=[str UTF8String];             
		sqlite3_stmt *compiledStmt;                           
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) 
            {
                
                NSString *deptid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *deptname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStmt, 1)];
                NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:deptid,@"deptid",deptname,@"deptname",nil];
				[Favourite addObject:d];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([Favourite count]>0)
	{
		NSArray *ar=[NSArray arrayWithArray:Favourite];
		return ar;
	} else {
		return nil;
	}
}

+(void)updateAddDepartment:(NSString *)deptid deptname:(NSString *)deptname
{
    AppDelegate *x=( AppDelegate *)[[UIApplication sharedApplication]delegate];
	sqlite3 *database;
	
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) 
    {
	    
        if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
        {
           	NSString *str =[NSString stringWithFormat:@"update AddDepartment set deptname='%@' where deptid=%@",deptname,deptid];  
            //NSLog(@"%@",str);
            const char *sqlStmt=[str UTF8String];                           
            sqlite3_stmt *cmp_sqlStmt;
            if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK) 
            {
                int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL);
                ((returnValue==SQLITE_OK) ?  NSLog(@"Success") :  NSLog(@"UnSuccess") );
                sqlite3_step(cmp_sqlStmt);
            }
            sqlite3_finalize(cmp_sqlStmt);
        }
    }    
	sqlite3_close(database);
}

#pragma mark -
#pragma mark - ViewController Methods
+(BOOL)isrecordExistin_tbl_resources:(NSString *)strQuery
{
    BOOL flag=NO;
    sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                flag = YES;
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
    return flag;
}

+(void)insert_tbl_Resources:(NSString *)ResourceID UnitCode:(NSString*)UnitCode UnitName:(NSString*)UnitName Version:(NSString*)Version Status:(NSString*)Status Resourceinfo:(NSString *)Resourceinfo Published:(NSString*)Published Published_date:(NSString *)Published_date Progress:(NSString *)Progress SectorID:(NSString*)SectorID SectorName:(NSString*)SectorName SectorColor:(NSString*)SectorColor CoverImage:(NSString *)CoverImage assessor_introduction:(NSString*)assessor_introduction assessortextcount:(NSString*)assessorcount participant_introduction:(NSString*)participant_introduction participanttextcount:(NSString*)participanttextcount resourcetype:(NSString*)resourcetype DownloadStatus:(NSString*)DownloadStatus
{
    NSString *sqlQuery=[NSString stringWithFormat:@"insert into tbl_resources (ResourceID,UnitCode,UnitName,Version,Status,Resourceinfo,Published,Publish_date,Progress,SectorID,SectorName,SectorColor,CoverImage,assessor_introduction,assessortextcount,participant_introduction,participanttextcount,resourcetype,DownloadStatus) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",ResourceID,UnitCode,UnitName,Version,Status,Resourceinfo,Published,Published_date,Progress,SectorID,SectorName,SectorColor,CoverImage,assessor_introduction,assessorcount,participant_introduction,participanttextcount,resourcetype,DownloadStatus];
    
    AppDelegate *x=(AppDelegate *)[[UIApplication sharedApplication]delegate];
	sqlite3 *database;
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[sqlQuery UTF8String];
		sqlite3_stmt *cmp_sqlStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK) {
			int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL);
			((returnValue==SQLITE_OK) ?  NSLog(@"Insert Success") :  NSLog(@"Insert UnSuccess") );
			sqlite3_step(cmp_sqlStmt);
		}
		sqlite3_finalize(cmp_sqlStmt);
	}
	sqlite3_close(database);
}


+(void)DBINSERT:(NSMutableArray *)aryDBINSERT
{
    @autoreleasepool {
        
        
        AppDelegate *x=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        sqlite3 *database;
        if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
        {
            for(int i=0;i<[aryDBINSERT count];i++)
            {
                NSString *strcontentriesid = [[aryDBINSERT objectAtIndex:i]valueForKey:@"contextualisation_entriesID"];
                NSString *strreference = [[aryDBINSERT objectAtIndex:i]valueForKey:@"reference"];
                NSString *strdescription = [[aryDBINSERT objectAtIndex:i]valueForKey:@"description"];
                NSString *strrelationship = [[aryDBINSERT objectAtIndex:i]valueForKey:@"relationship"];
                NSString *strcomments = [[aryDBINSERT objectAtIndex:i]valueForKey:@"comments"];
                NSString *strcontextid = [[aryDBINSERT objectAtIndex:i]valueForKey:@"ContextualisationID"];
                
                NSString *sqlQuery=[NSString stringWithFormat:@"insert into tbl_Contextualisation_Option (Contextualisation_entriesID,reference,description,relationship,comments,ContextualisationID,ResourceID) values('%@','%@','%@','%@','%@','%@','%@')",strcontentriesid,strreference,strdescription,strrelationship,strcomments,strcontextid,contResourceID];
                
                const char *sqlStmt=[sqlQuery UTF8String];
                sqlite3_stmt *cmp_sqlStmt;
                if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK) {
                    int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL);
                    ((returnValue==SQLITE_OK) ?  NSLog(@"Insert Success") :  NSLog(@"Insert UnSuccess") );
                    sqlite3_step(cmp_sqlStmt);
                }
                sqlite3_finalize(cmp_sqlStmt);
            }
        }
        sqlite3_close(database);
    }
}

+(void)INSERT_UPDATE_DELETE:(NSString *)strQuery
{
	AppDelegate *x=(AppDelegate *)[[UIApplication sharedApplication]delegate];
	sqlite3 *database;
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *cmp_sqlStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK) {
			int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL);
			((returnValue==SQLITE_OK) ?  NSLog(@"Insert Success") :  NSLog(@"Insert UnSuccess") );
			sqlite3_step(cmp_sqlStmt);
		}
		sqlite3_finalize(cmp_sqlStmt);
	}
	sqlite3_close(database);
}



+(NSMutableArray *)getall_tbl_Resources:(NSString*)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *UnitCode=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *UnitName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *Version=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *Status=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                
                NSString *Resourceinfo=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *Published=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *Publish_date=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *Progress=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *SectorID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                
                NSString *SectorName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSString *SectorColor=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                NSString *CoverImage=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];
                NSString *assessor_introduction=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 13)];
                NSString *assessortextcount=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 14)];
                
                NSString *participant_introduction=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 15)];
                NSString *participanttextcount=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 16)];
                NSString *resourcetype=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 17)];
                NSString *DownloadStatus = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 18)];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:ResourceID,@"ResourceID",UnitCode,@"UnitCode",UnitName,@"UnitName",Version,@"Version",Status,@"Status",Resourceinfo,@"Resourceinfo",Published,@"Published",Publish_date,@"Publish_date",Progress,@"Progress",SectorID,@"SectorID",SectorName,@"SectorName",SectorColor,@"SectorColor",CoverImage,@"CoverImage",assessor_introduction,@"assessor_introduction",assessortextcount,@"assessortextcount",participant_introduction,@"participant_introduction",participanttextcount,@"participanttextcount",resourcetype,@"resourcetype",DownloadStatus,@"DownloadStatus",nil];
                
                [array addObject:dict];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

#pragma mark -
#pragma mark - Import Participant's Method
+(NSMutableArray *)getAllParticipantName_ME:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                    NSString *part_name=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                    NSString *job_title=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                    NSString *company=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                    NSString *empId_stuNo=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                    NSString *suburb_city=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                    
                    
                    NSDictionary *dicWithObj = [NSDictionary dictionaryWithObjectsAndKeys:part_name,@"part_name",job_title,@"job_title",company,@"company",empId_stuNo,@"empId_stuNo",suburb_city,@"suburb_city",nil];
                    
                    [array addObject:dicWithObj];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)getAllRecordTbl_Participants:(NSString *)strQuery
{ NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *participantsID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *part_name=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *job_title=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *company=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *empId_stuNo=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *address=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *suburb_city=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *state=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *post_date=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *country=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                NSString *email=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSString *ph_no=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                NSString *superviser=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:participantsID,@"participantsID",part_name,@"part_name",job_title,@"job_title",company,@"company",empId_stuNo,@"empId_stuNo",address,@"address",suburb_city,@"suburb_city",state,@"state",post_date,@"post_date",country,@"country",email,@"email",ph_no,@"ph_no",superviser,@"superviser",nil];
                
                [array addObject:dict];
                //[dataObj release];
                
            }
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}



+(NSMutableArray *)getallTasks:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *assessment_task_Id=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *outline=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *purpose=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *title=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *name=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *task_info_assessor=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *type=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *result_text=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *resource_Id=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:assessment_task_Id,@"assessment_task_Id",outline,@"outline",purpose,@"purpose",title,@"title",description,@"description",name,@"name",task_info_assessor,@"task_info_assessor",type,@"type",result_text,@"result_text",resource_Id,@"resource_Id",nil];
                
                [array addObject:dict];
                //[dataObj release];
                
            }
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

#pragma mark -
#pragma mark - Contextualization Method

+(NSMutableArray *) getalltblcontext:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *contextID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *Description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:contextID,@"contextID",ResourceID,@"ResourceID",Description,@"Description",nil];
                
                [array addObject:dict];
            }
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *) getalltblcontextoptionanswer:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *coaautoid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *conentriesID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *reference=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *relationship=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *comments=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *contexID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *resourceid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *participantid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:coaautoid,@"coaautoid",conentriesID,@"conentriesID",reference,@"reference",description,@"description",relationship,@"relationship",comments,@"comments",contexID,@"contexID",resourceid,@"resourceid",participantid,@"participantid",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)getalltblcontextOption:(NSString*)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *coautoid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *conentriesID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *reference=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *relationship=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *comments=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *contexID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *resourceid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:coautoid,@"coautoid",conentriesID,@"conentriesID",reference,@"reference",description,@"description",relationship,@"relationship",comments,@"comments",contexID,@"contexID",resourceid,@"resourceid",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}


#pragma mark -
#pragma mark - ThirdPartyResult's Method
+(NSMutableArray *) getThirdpartyresults_answer:(NSString*)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *TPRAAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ReportID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *Query=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *RTC=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *Response=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *ParticipantID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *ASSTaskID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:TPRAAutoID,@"TPRAAutoID",ReportID,@"ReportID",Query,@"Query",RTC,@"RTC",Response,@"Response",ResourceID,@"ResourceID",ParticipantID,@"ParticipantID",ASSTaskID,@"ASSTaskID",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *) getthirdpartyresults:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *ReportID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *Description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:ReportID,@"ReportID",ResourceID,@"ResourceID",Description,@"Description",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *) getthirdpartyresults_detail:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *TAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ReportID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *Name=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *Position=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *Organization=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *OffAddress=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *City=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *State=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *PostCode=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                NSString *Phone=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSString *Email=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                NSString *AssessorID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];
                NSString *ParticipantID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 13)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:TAutoID,@"TAutoID",ReportID,@"ReportID",ResourceID,@"ResourceID",Name,@"Name",Position,@"Position",Organization,@"Organization",OffAddress,@"OffAddress",City,@"City",State,@"State",PostCode,@"PostCode",Phone,@"Phone",Email,@"Email",AssessorID,@"AssessorID",ParticipantID,@"ParticipantID",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(void)insert_thrdpartydetail:(NSString*)reportid resourceid:(NSString *)resourceid name:(NSString*)name position:(NSString*)position organization:(NSString*)organization officeadd:(NSString*)officeadd city:(NSString *)city state:(NSString *)state postcode:(NSString *)postcode phone:(NSString*)phone email:(NSString *)email assid:(NSString *)assid parid:(NSString*)partid
{
    AppDelegate *x=(AppDelegate *)[[UIApplication sharedApplication]delegate];
	sqlite3 *database;
	
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
	    
        if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
        {
            NSString *sqlQuery=[NSString stringWithFormat:@"insert into tbl_ThirdPartyDetail (ReportID,ResourceID,Name,Position,Organization,OffAddress,City,State,PostCode,Phone,Email,AssessorID,ParticipantID) values(?,?,?,?,?,?,?,?,?,?,?,?,?)"];
            
            const char *sqlStmt=[sqlQuery UTF8String];
            sqlite3_stmt *cmp_sqlStmt;
            if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK)
            {
                
                int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL);
            
                sqlite3_bind_text(cmp_sqlStmt, 1, [reportid UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 2, [resourceid UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 3, [name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 4, [position UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 5, [organization UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 6, [officeadd UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 7, [city UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 8, [state UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 9, [postcode UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 10, [phone UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 11, [email UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 12, [assid UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 13, [partid UTF8String], -1, SQLITE_TRANSIENT);
            
            
            
                ((returnValue==SQLITE_OK) ?  NSLog(@"Success") :  NSLog(@"UnSuccess") );
                sqlite3_step(cmp_sqlStmt);
            }
            sqlite3_finalize(cmp_sqlStmt);
        }
    }
	sqlite3_close(database);
}

#pragma mark -
#pragma mark - System Validation
+(NSMutableArray *)get_tbl_SysValidation:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *VAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ValidationID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *Description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:VAutoID,@"VAutoID",ValidationID,@"ValidationID",ResourceID,@"ResourceID",Description,@"Description",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *) get_tbl_SysValidationOptions:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *VOAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ValidationID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *EntryID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *TypeofValidation=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *ScheduleDate=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *Process=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *Participants=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:VOAutoID,@"VOAutoID",ValidationID,@"ValidationID",ResourceID,@"ResourceID",EntryID,@"EntryID",TypeofValidation,@"TypeofValidation",ScheduleDate,@"ScheduleDate",Process,@"Process",Participants,@"Participants",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *) get_tbl_SysValidationOptionsAnswer:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *VOAAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ValidationID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *EntryID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *ScheduleDate=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *Process=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *Participants_1=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *Participants_2=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *Participants_3=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *Participants_4=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                NSString *Participants_5=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSString *OutCome=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:VOAAutoID,@"VOAAutoID",ValidationID,@"ValidationID",ResourceID,@"ResourceID",EntryID,@"EntryID",ScheduleDate,@"ScheduleDate",Process,@"Process",Participants_1,@"Participants_1",Participants_2,@"Participants_2",Participants_3,@"Participants_3",Participants_4,@"Participants_4",Participants_5,@"Participants_5",OutCome,@"OutCome",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}


#pragma mark -
#pragma mark - Results Method
+(NSMutableArray *) get_tbl_ResultsOptions:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *ROAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ResultTaskTextID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *AssessmentTaskID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *Description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *AssTaskName = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:ROAutoID,@"ROAutoID",ResultTaskTextID,@"ResultTaskTextID",AssessmentTaskID,@"AssessmentTaskID",Description,@"Description",ResourceID,@"ResourceID",AssTaskName,@"AssTaskName",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *) get_tbl_ResultsOptionsAnswer:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *ROAAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ResultTaskTextID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *AssessmentTaskID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *Description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *AssTaskPartName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *ParticipantID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *Status=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *AssessorID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:ROAAutoID,@"ROAAutoID",ResultTaskTextID,@"ResultTaskTextID",AssessmentTaskID,@"AssessmentTaskID",Description,@"Description",ResourceID,@"ResourceID",AssTaskPartName,@"AssTaskPartName",ParticipantID,@"ParticipantID",Status,@"Status",AssessorID,@"AssessorID",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		//NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return array;
	} else {
		return array;
	}
}

+(NSMutableArray *)get_tbl_Results:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *RAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *resultid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *Description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:RAutoID,@"RAutoID",resultid,@"resultid",ResourceID,@"ResourceID",Description,@"Description",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(void)insert_tbl_ResultOptionsAnswer:(NSString*)ResultTaskTextID AssessmentTaskID:(NSString*)AssessmentTaskID Description:(NSString*)Description ResourceID:(NSString*)ResourceID AssTaskPartName:(NSString*)AssTaskPartName ParticipantID:(NSString*)ParticipantID Status:(NSString*)Status AssessorID:(NSString*)AssessorID Assessment_Task_Part_ID:(NSString*)Assessment_Task_Part_ID
{
    AppDelegate *x=(AppDelegate *)[[UIApplication sharedApplication]delegate];
	sqlite3 *database;
	
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
	    
        if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
        {
            
            NSString *sqlQuery=[NSString stringWithFormat:@"insert into tbl_ResultsOptionsAnswer (ResultTaskTextID,AssessmentTaskID,Description,ResourceID,AssTaskPartName,ParticipantID,Status,AssessorID,Assessment_Task_Part_ID) values(?,?,?,?,?,?,?,?,?)"];
            
            
            const char *sqlStmt=[sqlQuery UTF8String];
            sqlite3_stmt *cmp_sqlStmt;
            if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK)
            {
                
                int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL);
            
                sqlite3_bind_text(cmp_sqlStmt, 1, [ResultTaskTextID UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 2, [AssessmentTaskID UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 3, [Description UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 4, [ResourceID UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 5, [AssTaskPartName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 6, [ParticipantID UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 7, [Status UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 8, [AssessorID UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 9, [Assessment_Task_Part_ID UTF8String], -1, SQLITE_TRANSIENT);
            
            
            
                ((returnValue==SQLITE_OK) ?  NSLog(@"Success") :  NSLog(@"UnSuccess") );
                sqlite3_step(cmp_sqlStmt);
            }
            sqlite3_finalize(cmp_sqlStmt);
        }
    }
	sqlite3_close(database);
}


#pragma mark -
#pragma mark - Competency Mappint View's Method
+(NSMutableArray *)get_tbl_Competency:(NSString*)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *CompAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *CompetencyOutlineID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *Title=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *Description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:CompAutoID,@"CompAutoID",CompetencyOutlineID,@"CompetencyOutlineID",Title,@"Title",Description,@"Description",ResourceID,@"ResourceID",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)get_tbl_CompetencyTask:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *CTaskAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *CompetencyTaskID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *CompetencyOutlineID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *Parent_CompetencyTaskID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *Title=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *Description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:CTaskAutoID,@"CTaskAutoID",CompetencyTaskID,@"CompetencyTaskID",CompetencyOutlineID,@"CompetencyOutlineID",Parent_CompetencyTaskID,@"Parent_CompetencyTaskID",Title,@"Title",Description,@"Description",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)get_assessmentTasktitle:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *title=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}



+(NSMutableArray *)get_tbl_CompetencyTaskAnswer:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *CAnsID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *CompetencyOutlineID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *CompetencyTaskID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *CompetencyQuestionID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *ParticipantID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *AssessorID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *Answer=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:CAnsID,@"CAnsID",ResourceID,@"ResourceID",CompetencyOutlineID,@"CompetencyOutlineID",CompetencyTaskID,@"CompetencyTaskID",CompetencyQuestionID,@"CompetencyQuestionID",ParticipantID,@"ParticipantID",AssessorID,@"AssessorID",Answer,@"Answer",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		return array;
	} else {
		return array;
	}
}

+(NSMutableArray *)get_tbl_CompetencyTaskQuestions:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *CTaskQueAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *competencyquestionid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *Description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *parentquestionid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *competencytaskid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:CTaskQueAutoID,@"CTaskQueAutoID",competencyquestionid,@"competencyquestionid",Description,@"Description",parentquestionid,@"parentquestionid",competencytaskid,@"competencytaskid",nil];
                
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		return array;
	} else {
		return array;
	}
}



#pragma mark - 
#pragma mark - AssessmentViewController's Method
+(int)getNoOfRecord:(NSString *)strQuery
{
    NSString *NoOfRecord = @"0";
    sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NoOfRecord=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
    NSLog(@"%d",[NoOfRecord intValue]);
    return [NoOfRecord intValue];
}

+(NSMutableArray *)getFromQuestionAnswer_UserID:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSLog(@"%@",[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)]);
                NSString *assessment_task_id=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                [array addObject:assessment_task_id];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}



#pragma mark -
#pragma mark - NewAssessorViewController's Method
+(void)insert_tbl_assessor:(NSString*)ass_name ass_jobtitle:(NSString*)ass_jobtitle ass_org:(NSString*)ass_org ass_empid:(NSString*)ass_empid ass_officeadd:(NSString*)ass_officeadd ass_city:(NSString*)ass_city ass_state:(NSString*)ass_state ass_phonenumber:(NSString*)ass_phonenumber asss_postcode:(NSString*)asss_postcode  ass_email:(NSString*)ass_email ass_supervisor:(NSString*)ass_supervisor ass_pinnumber:(NSString*)ass_pinnumber ass_secque:(NSString*)ass_secque ass_answer:(NSString*)ass_answer
{
    AppDelegate *x=(AppDelegate *)[[UIApplication sharedApplication]delegate];
	sqlite3 *database;
	
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
	    
        if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
        {
            NSString *sqlQuery=[NSString stringWithFormat:@"insert into tbl_assessor (ass_name,ass_jobtitle,ass_org,ass_empid,ass_officeadd,ass_city,ass_state,ass_phonenumber,asss_postcode,ass_email,ass_supervisor,ass_pinnumber,ass_secque,ass_answer) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
            
            const char *sqlStmt=[sqlQuery UTF8String];
            sqlite3_stmt *cmp_sqlStmt;
            if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK)
            {
                
                int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL);

            
                sqlite3_bind_text(cmp_sqlStmt, 1, [ass_name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 2, [ass_jobtitle UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 3, [ass_org UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 4, [ass_empid UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 5, [ass_officeadd UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 6, [ass_city UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 7, [ass_state UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_text(cmp_sqlStmt, 8, [ass_phonenumber UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 9, [asss_postcode UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 10, [ass_email UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 11, [ass_supervisor UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 12, [ass_pinnumber UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 13, [ass_secque UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(cmp_sqlStmt, 14, [ass_answer UTF8String], -1, SQLITE_TRANSIENT);
            
                ((returnValue==SQLITE_OK) ?  NSLog(@"Success") :  NSLog(@"UnSuccess") );
                sqlite3_step(cmp_sqlStmt);
            }
            sqlite3_finalize(cmp_sqlStmt);
        }
    }
	sqlite3_close(database);
}


+(NSMutableArray *)get_assessor_information:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *assessorsID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ass_name=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *ass_jobtitle=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *ass_org=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *ass_empid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *ass_officeadd=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *ass_city=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *ass_state =[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *ass_phonenumber=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *asss_postcode =[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                NSString *ass_email=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSString *ass_supervisor=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                NSString *ass_pinnumber=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];
                NSString *ass_secque=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 13)];
                NSString *ass_answer=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 14)];
                
                NSDictionary *dicWithObj = [NSDictionary dictionaryWithObjectsAndKeys:assessorsID,@"assessorsID",ass_name,@"ass_name",ass_jobtitle,@"ass_jobtitle",ass_org,@"ass_org",ass_empid,@"ass_empid",ass_empid,@"ass_empid",ass_officeadd,@"ass_officeadd",ass_city,@"ass_city",ass_state,@"ass_state",ass_phonenumber,@"ass_phonenumber",asss_postcode,@"asss_postcode",ass_email,@"ass_email",ass_supervisor,@"ass_supervisor",ass_pinnumber,@"ass_pinnumber",ass_secque,@"ass_secque",ass_answer,@"ass_answer",nil];
                
                [array addObject:dicWithObj];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}


#pragma mark - 
#pragma mark - QuestionAssessorView's Method
+(NSMutableArray *)getallRecord_assessment_task_part_id:(NSString*)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *setassessment_tak_part_id=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *title=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *description=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *name=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *assessment_tak_id=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:setassessment_tak_part_id,@"setassessment_tak_part_id",title,@"title",description,@"description",name,@"name",assessment_tak_id,@"assessment_tak_id",nil];
                
                [array addObject:dict];
                //[dataObj release];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)getallQuestion:(NSString *)strAssessmentTaskId strAssessmentTaskPartId:(NSString *)strAssessmentTaskPartId UserID:(NSString*)UserID
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
         NSString *sqlStatement =[NSString stringWithFormat:@"select Q.question_id,Q.title,Q.description,Q.name,Q.'order',Q.assessment_task_part_id ,Q.KeyPoint from tbl_question Q,tbl_question_answer A where cast(Q.question_id as INT) = cast(A.question_id as INT) and  cast(Q.assessment_task_part_id as INT) = cast(A.assessment_task_part_id as INT) and cast(Q.assessment_task_id as INT) = cast(A.assessment_task_id as INT) and  cast(Q.assessment_task_id as INT)  = %@ and  cast(Q.assessment_task_part_id as INT) = %@  and A.UserID = '%@' order by CAST(Q.'ORDER' AS INT)",strAssessmentTaskId,strAssessmentTaskPartId,UserID];
        
		const char *sqlStmt=[sqlStatement UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *setQuestion_Id=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *setTitleQuestion=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *setDescriptionQuestion=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *setNameQuestion=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *setOrder=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *setAssessment_task_part_id=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *setKeyPoint = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:setQuestion_Id,@"setQuestion_Id",setTitleQuestion,@"setTitleQuestion",setDescriptionQuestion,@"setDescriptionQuestion",setNameQuestion,@"setNameQuestion",setOrder,@"setOrder",setAssessment_task_part_id,@"setAssessment_task_part_id",setKeyPoint,@"setKeyPoint",nil];
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}


+(NSMutableArray *)getOptionUsingQuestionID:(NSString *)questionID asstaskpartid:(NSString*)asstaskpartid
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
        NSString *sqlStatement =[NSString stringWithFormat:@"SELECT B.QUESTIONOPTIONID,B.QUESTION_ID,B.TAB,B.SRC,B.ASSESSMENT_TASK_PART_ID,(SELECT DESCRIPTION FROM TBL_QUESTION WHERE CAST(QUESTION_ID AS INT) =CAST( B.QUESTION_ID AS INT)),B.type,B.Column_Value FROM TBL_QUESTION_OPTION B WHERE CAST(QUESTION_ID AS INT)=%@",questionID];
        
        const char *sqlStmt=[sqlStatement UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *QuestionOptionID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *question_Id=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *tab=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *src=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *atpid = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *quename = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *type = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *Column_Value = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:QuestionOptionID,@"QuestionOptionID",question_Id,@"question_Id",tab,@"tab",src,@"src",atpid,@"atpid",quename,@"quename",type,@"type",Column_Value,@"Column_Value",nil];
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}



+(NSMutableArray *)getanswer_result_tblQuestionOption:(NSString *)StrQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
        const char *sqlStmt=[StrQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *AutoID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *UserID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *assessmentTaskID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *assessmentTaskPartID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *questionID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *answer = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *result = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *assComment = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *OptionSelected = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                NSString *AssessorID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:AutoID,@"AutoID",UserID,@"UserID",assessmentTaskID,@"assessmentTaskID",assessmentTaskPartID,@"assessmentTaskPartID",questionID,@"questionID",answer,@"answer",result,@"result",assComment,@"assComment",OptionSelected,@"OptionSelected",AssessorID,@"AssessorID",nil];
                
                [array addObject:dic];
                //[dataObj release];
                
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)getallQuestion:(NSString *)strassessment_task_part_id ASS_TASK_PART_ID:(NSString *)ASS_TASK_PART_ID
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
        NSString *sqlStatement =[NSString stringWithFormat:@"select *from tbl_question where cast(assessment_task_id as int)  = %@ and cast(assessment_task_part_id as int) = %@ ORDER BY CAST('Order' AS INT)",strassessment_task_part_id,ASS_TASK_PART_ID];
        const char *sqlStmt=[sqlStatement UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *setQuestion_Id=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *setTitleQuestion=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *setDescriptionQuestion=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *setNameQuestion=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *setOrder=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *setAssessment_task_part_id=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *setKeyPoint = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *setquestiontype = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *setactivitydescription = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                NSString *setchecklist = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                
                
                
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:setQuestion_Id,@"setQuestion_Id",setTitleQuestion,@"setTitleQuestion",setDescriptionQuestion,@"setDescriptionQuestion",setNameQuestion,@"setNameQuestion",setOrder,@"setOrder",setAssessment_task_part_id,@"setAssessment_task_part_id",setKeyPoint,@"setKeyPoint",setquestiontype,@"setquestiontype",setactivitydescription,@"setactivitydescription",setchecklist,@"setchecklist",nil];
                [array addObject:dict];
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

#pragma mark -
#pragma mark - NParticipant
+(NSMutableArray *)get_ResumeTaskInfo:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *PartID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ResourceName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *PartName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *ParticipantID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *SectorName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *SectorColor=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *UnitCode=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *Version=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *Status=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                
                NSString *ResourceInfo = [NSString stringWithFormat:@"%@ | Version %@ | %@",UnitCode,Version,Status];
                
                NSDictionary *dicWithObj = [NSDictionary dictionaryWithObjectsAndKeys:PartID,@"PartID",ResourceID,@"ResourceID",ResourceName,@"ResourceName",PartName,@"NSParticipantName",ParticipantID,@"ParticipantID",SectorName,@"SectorName",SectorColor,@"SectorColor",ResourceInfo,@"ResourceInfo",UnitCode,@"UnitCode",Version,@"Version",Status,@"Status",nil];
                
                [array addObject:dicWithObj];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)get_All_ResumeTaskInfo:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *AutoId=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *AssessmentTaskID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *ParticipantID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *AssessorID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *Status=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *PartName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *PartDate=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *AssName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *AssLocation=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                NSString *AssDuration=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSString *AssDate=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                
                NSDictionary *dicWithObj = [NSDictionary dictionaryWithObjectsAndKeys:AutoId,@"AutoId",ResourceID,@"ResourceID",AssessmentTaskID,@"AssessmentTaskID",ParticipantID,@"ParticipantID",AssessorID,@"AssessorID",Status,@"Status",PartName,@"NSParticipantName",PartDate,@"PartDate",AssName,@"AssName",AssLocation,@"AssLocation",AssDuration,@"AssDuration",AssDate,@"AssDate",nil];
                
                [array addObject:dicWithObj];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

#pragma mark - tbl_ResumeFTask
+(NSMutableArray *)get_ResumeFTask:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *AutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *ParticipantID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *AssessorID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *Status=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *PartName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *AssName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *AssDate=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                
                NSDictionary *dicWithObj = [NSDictionary dictionaryWithObjectsAndKeys:AutoID,@"AutoID",ResourceID,@"ResourceID",ParticipantID,@"ParticipantID",AssessorID,@"AssessorID",Status,@"Status",PartName,@"NSParticipantName",AssName,@"AssName",AssDate,@"AssDate",nil];
                
                [array addObject:dicWithObj];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

#pragma mark - tbl_Learning_Resources
+(NSMutableArray *)get_learningResources:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *LRAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *UnitCode=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *UnitName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *Version=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *Status=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *Published=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *Published_date=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *Progress=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *SectorID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                NSString *SectorName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSString *SectorColor=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                NSString *CoverImage=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];
                NSString *textcount=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 13)];
                NSString *resourcetype=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 14)];
                NSString *DownloadStatus=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 16)];
                
                NSDictionary *dicWithObj = [NSDictionary dictionaryWithObjectsAndKeys:LRAutoID,@"LRAutoID",ResourceID,@"ResourceID",UnitCode,@"UnitCode",UnitName,@"UnitName",Version,@"Version",Status,@"Status",Published,@"Published",Published_date,@"Published_date",Progress,@"Progress",SectorID,@"SectorID",SectorName,@"SectorName",SectorColor,@"SectorColor",CoverImage,@"CoverImage",textcount,@"textcount",resourcetype,@"resourcetype",DownloadStatus,@"DownloadStatus",nil];
                
                [array addObject:dicWithObj];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)get_learningResourcesText:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *LRTAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *TextID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *TextDesc=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                
                NSDictionary *dicWithObj = [NSDictionary dictionaryWithObjectsAndKeys:LRTAutoID,@"LRTAutoID",ResourceID,@"ResourceID",TextID,@"TextID",TextDesc,@"TextDesc",nil];
                
                [array addObject:dicWithObj];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)get_learningResourcesFiles:(NSString *)strQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *LRFAutoID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *TextID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *FilesID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *FilesDescription=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                
                NSDictionary *dicWithObj = [NSDictionary dictionaryWithObjectsAndKeys:LRFAutoID,@"LRFAutoID",ResourceID,@"ResourceID",TextID,@"TextID",FilesID,@"FilesID",FilesDescription,@"FilesDescription",nil];
                
                [array addObject:dicWithObj];
			}
		}
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

#pragma mark - PDF Creation Data retrive
+(NSMutableArray *)result_tblQuestionOptionForPDFCreation:(NSString *)StrQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
        const char *sqlStmt=[StrQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK)
        {
            NSInteger indexValue = 0;
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                
                NSString *Index = [NSString stringWithFormat:@"%ld",(long)indexValue];
                indexValue++;
                NSString *ParticipantID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];  // UserID
                NSString *ParticipantFirstName = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];   // part_name
                NSString *ParticipantCompany = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)]; //  company
                NSString *ParticipantStudentNumber = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];   //empID_stuNO
                NSString *ParticipantOccupation = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];  //  job_title
                NSString *toemail = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];   //  email
                
                NSString *OptionSelected = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)]; // 0,3 option selected
                NSString *Outcome = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];   // result
                NSString *description = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)]; // Participant Comment
                NSString *comments = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)]; // Assessor Comment

                NSString *AssessorID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)]; //
                NSString *AssessorFirstName = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                NSString *AssessorEmail = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];
                NSString *QuestionsID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 13)];
                NSString *ResourceID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 14)];
                NSString *AssessmentTaskID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 15)];
                NSString *AssessmentTaskPartID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 16)];
                
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     
                                     Index,@"Index",
                                     ParticipantID,@"ParticipantID",
                                     ParticipantFirstName,@"ParticipantFirstName",
                                     ParticipantCompany,@"ParticipantCompany",
                                     ParticipantStudentNumber,@"ParticipantStudentNumber",
                                     ParticipantOccupation,@"ParticipantOccupation",
                                     toemail,@"toemail",
                                   
                                     OptionSelected,@"OptionSelected",
                                     Outcome,@"Outcome",
                                     description,@"description",
                                     comments,@"comments",
                                     
                                     AssessorID,@"AssessorID",
                                     AssessorFirstName,@"AssessorFirstName",
                                     AssessorEmail,@"AssessorEmail",
                                     QuestionsID,@"QuestionsID",
                                     ResourceID,@"ResourceID",
                                     AssessmentTaskID,@"AssessmentTaskID",
                                     AssessmentTaskPartID,@"AssessmentTaskPartID",
                                     
                                     
                                     nil];
                NSLog(@"%@",dic);
                
                [array addObject:dic];
                //[dataObj release];
                
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)result_tblContextualisationOptionAnswerForPDFCreation:(NSString *)StrQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
        const char *sqlStmt=[StrQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK)
        {
            NSInteger indexValue = 0;
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *Index = [NSString stringWithFormat:@"%ld",(long)indexValue];
                indexValue++;
                NSString *participantid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];  // UserID
                NSString *ParticipantFirstName = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];   // part_name
                NSString *ParticipantCompany = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)]; //  company
                NSString *ParticipantStudentNumber = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];   //empID_stuNO
                NSString *ParticipantOccupation = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];  //  job_title
                NSString *ParticipantEmail = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];   //  email
                
                NSString *assessorid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)]; // 0,3 option selected
                NSString *reference = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];   // result
                NSString *description = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)]; // Participant Comment
                NSString *relationship = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)]; // Assessor Comment
                NSString *comments = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)]; //
               
                NSString *ContextualistaionEntriesID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                NSString *ContextualisationID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];
               
                NSString *AssessorFirstName = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 13)];
                NSString *AssessorEmail = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 14)];
                
                NSString *ResourceID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 15)];
                
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     Index,@"Index",
                                     participantid,@"participantid",
                                     ParticipantFirstName,@"ParticipantFirstName",
                                     ParticipantCompany,@"ParticipantCompany",
                                     ParticipantStudentNumber,@"ParticipantStudentNumber",
                                     ParticipantOccupation,@"ParticipantOccupation",
                                     ParticipantEmail,@"ParticipantEmail",
                                     
                                     assessorid,@"assessorid",
                                     reference,@"reference",
                                     description,@"description",
                                     relationship,@"relationship",
                                     comments,@"comments",
                                     
                                     ContextualistaionEntriesID,@"ContextualistaionEntriesID",
                                     ContextualisationID,@"ContextualisationID",
                                     
                                     AssessorFirstName,@"AssessorFirstName",
                                     AssessorEmail,@"AssessorEmail",
                                     ResourceID,@"ResourceID",
                                     nil];
                NSLog(@"%@",dic);
                
                [array addObject:dic];
                //[dataObj release];
                
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)result_tblThirdPartyDetailForPDFCreation:(NSString *)StrQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
        const char *sqlStmt=[StrQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK)
        {
            NSInteger indexValue = 0;
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *Index = [NSString stringWithFormat:@"%ld",(long)indexValue];
                indexValue++;
                NSString *reportid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];   // part_name
                NSString *resourceid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)]; //  company
                NSString *name = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];   //empID_stuNO
                NSString *position = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];  //  job_title
                NSString *organization = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];   //  email
                
                NSString *address = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)]; // 0,3 option selected
                NSString *city = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];   // result
                NSString *state = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)]; // Participant Comment
                NSString *postcode = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)]; // Assessor Comment
                NSString *phone = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)]; //
                
                NSString *email = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                NSString *assessorid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];
                NSString *participantid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 13)];
                       
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     
                                     Index,@"Index",
                                     reportid,@"reportid",
                                     resourceid,@"resourceid",
                                     name,@"name",
                                     position,@"position",
                                     organization,@"organization",
                                     address,@"address",
                                     
                                     city,@"city",
                                     state,@"state",
                                     postcode,@"postcode",
                                     phone,@"phone",
                                     email,@"email",
                                     
                                     assessorid,@"assessorid",
                                     participantid,@"participantid",

                                     nil];
                NSLog(@"%@",dic);
                
                [array addObject:dic];
                //[dataObj release];
                
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}
+(NSMutableArray *)result_tblThirdPartyReportsAnswerForPDFCreation:(NSString *)StrQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
        const char *sqlStmt=[StrQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK)
        {
            NSInteger indexValue = 0;
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *Index = [NSString stringWithFormat:@"%ld",(long)indexValue];
                indexValue++;
                NSString *reportid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];   // part_name
                NSString *query = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)]; //  company
                NSString *relation_competency = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];   //empID_stuNO
                NSString *response = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];  //  job_title
                NSString *resourceid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];   //  email
                NSString *participantid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)]; // 0,3 option selected
                NSString *AssessorID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];   // result
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     
                                     Index,@"Index",
                                     reportid,@"reportid",
                                     query,@"query",
                                     relation_competency,@"relation_competency",
                                     response,@"response",
                                     resourceid,@"resourceid",
                                     participantid,@"participantid",
                                     AssessorID,@"AssessorID",
                                     nil];
                NSLog(@"%@",dic);
                
                [array addObject:dic];
                //[dataObj release];
                
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)result_tblSysValidationOptionsAnswerForPDFCreation:(NSString *)StrQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
        const char *sqlStmt=[StrQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK)
        {
            NSInteger indexValue = 0;
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *Index = [NSString stringWithFormat:@"%ld",(long)indexValue];
                indexValue++;
                NSString *validationID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)]; //  company
                NSString *resourcid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];   //empID_stuNO
                NSString *entryid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];  //  job_title
                NSString *scheduledate = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];   //  email
                NSString *process = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)]; // 0,3 option selected
                NSString *participant1 = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];   // result
                NSString *participant2 = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];   // result
                NSString *participant3 = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];   // result
                NSString *participant4 = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];   // result
                NSString *participant5 = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];   // result
                NSString *outcome = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];   // result
                NSString *participantid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];   // result
                NSString *AssessorID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 13)];   // result
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:

                                     Index,@"Index",
                                     validationID,@"validationID",
                                     resourcid,@"resourcid",
                                     entryid,@"entryid",
                                     scheduledate,@"scheduledate",
                                     process,@"process",
                                     participant1,@"participant1",
                                     participant2,@"participant2",
                                     participant3,@"participant3",
                                     participant4,@"participant4",
                                     participant5,@"participant5",
                                     outcome,@"outcome",
                                     participantid,@"participantid",
                                     AssessorID,@"AssessorID",
                                     nil];
                NSLog(@"%@",dic);
                
                [array addObject:dic];
                //[dataObj release];
                
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)result_tblResultsOptionsAnswerForPDFCreation:(NSString *)StrQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
        const char *sqlStmt=[StrQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK)
        {
            NSInteger indexValue = 0;
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *Index = [NSString stringWithFormat:@"%ld",(long)indexValue];
                indexValue++;

                NSString *resulttasktextid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];   //empID_stuNO
                NSString *assessmenttaskid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];  //  job_title
                NSString *resourceid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)]; // 0,3 option selected
                NSString *participantid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];   // result
                NSString *outcome;
                if([[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)] isEqualToString:@"0"])
                    outcome = @"false";
                else if([[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)] isEqualToString:@"1"])
                    outcome = @"true";
                NSString *AssessorID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];   // result
                NSString *assessmenttaskpartid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];   // result
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     
                                     Index,@"Index",
                                     resulttasktextid,@"resulttasktextid",
                                     assessmenttaskid,@"assessmenttaskid",
                                     resourceid,@"resourceid",
                                     participantid,@"participantid",
                                     outcome,@"outcome",
                                     AssessorID,@"AssessorID",
                                     assessmenttaskpartid,@"assessmenttaskpartid",
                                     nil];
                NSLog(@"%@",dic);
                
                [array addObject:dic];
                //[dataObj release];
                
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

+(NSMutableArray *)result_tblResultsOptionsCompetecyAnswerForPDFCreation:(NSString *)StrQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
        const char *sqlStmt=[StrQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK)
        {
            NSInteger indexValue = 0;
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *Index = [NSString stringWithFormat:@"%ld",(long)indexValue];
                indexValue++;
                NSString *resourceid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)]; // 0,3 option selected
                NSString *participantid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];   // result
                NSString *outcome = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *AssessorID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];   // result
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     
                                     Index,@"Index",
                                     resourceid,@"resourceid",
                                     participantid,@"participantid",
                                     outcome,@"outcome",
                                     AssessorID,@"AssessorID",
                                     nil];
                NSLog(@"%@",dic);
                
                [array addObject:dic];
                //[dataObj release];
                
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}


+(NSMutableArray *)result_tblCompetencyTaskAnswerForPDFCreation:(NSString *)StrQuery
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
	sqlite3 *database;
    AppDelegate *x=( AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
        const char *sqlStmt=[StrQuery UTF8String];
		sqlite3_stmt *compiledStmt;
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK)
        {
            NSInteger indexValue = 0;
			while(sqlite3_step(compiledStmt)==SQLITE_ROW)
            {
                NSString *Index = [NSString stringWithFormat:@"%ld",(long)indexValue];
                indexValue++;
                NSString *CAnsID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];   //empID_stuNO
                NSString *ResourceID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];  //  job_title
                NSString *CompetencyOutlineID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)]; // 0,3 option selected
                NSString *CompetencyTaskID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];   // result
               
                NSString *competencyquestionid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];   // result
                NSString *participantid = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];   // result
                NSString *AssessorID = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];   // result
                NSString *outcome = [NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];   // result
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     
                                     Index,@"Index",
                                     ResourceID,@"ResourceID",
                                     CompetencyOutlineID,@"CompetencyOutlineID",
                                     CompetencyTaskID,@"CompetencyTaskID",
                                     competencyquestionid,@"competencyquestionid",
                                     participantid,@"participantid",
                                     AssessorID,@"AssessorID",
                                     outcome,@"outcome",
                                     nil];
                NSLog(@"%@",dic);
                
                [array addObject:dic];
                //[dataObj release];
                
            }
        }
		sqlite3_finalize(compiledStmt);
	}
	sqlite3_close(database);
	
	if([array count]>0)
	{
		NSMutableArray *ar=[NSMutableArray arrayWithArray:array];
		return ar;
	} else {
		return nil;
	}
}

@end