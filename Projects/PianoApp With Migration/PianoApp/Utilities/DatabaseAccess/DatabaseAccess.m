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

+(NSArray*)gettbl_newpasswords:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	AppDelegate *x=(AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) 
    {
		const char *sqlStmt=[strQuery UTF8String];             
		sqlite3_stmt *compiledStmt;                           
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
				NSString *passID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *typ=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *ttl=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *usrname=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *pass=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *ul=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *dttm=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *cnt=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *hint=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
				
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:passID,@"id",typ,@"type",ttl,@"title",usrname,@"username",pass,@"password",ul,@"url",dttm,@"timedateadd",cnt,@"viewcount",hint,@"hint",nil];
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

+(NSArray*)gettbl_addcontacts:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	AppDelegate *x=(AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) 
    {
		const char *sqlStmt=[strQuery UTF8String];             
		sqlite3_stmt *compiledStmt;                           
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *passid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *fname=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *lname=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *mbl=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *hm=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *hp=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
                NSString *ctgry=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *cmpny=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
                NSString *hmph=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *wrkph=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
                NSString *othph=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSString *wrkeml=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
                NSString *otreml=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];
                NSString *cnt=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 13)];
				
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:passid,@"id",fname,@"Firstname",lname,@"LastName",mbl,@"Mobile",hm,@"Home",hp,@"HomePage",ctgry,@"Category",cmpny,@"Company",hmph,@"homephone",wrkph,@"workphone",othph,@"otherphone",wrkeml,@"workemail",otreml,@"otheremail",cnt,@"viewcount",nil];
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

+(NSArray*)gettbl_cameraroll:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	AppDelegate *x=(AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) 
    {
		const char *sqlStmt=[strQuery UTF8String];             
		sqlite3_stmt *compiledStmt;                           
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *passid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *attch=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *typ=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *tag=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *desc=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
				
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:passid,@"id",attch,@"attachment",typ,@"type",tag,@"tag",desc,@"desc",nil];
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
+(NSArray*)gettbl_notes:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	AppDelegate *x=(AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) 
    {
		const char *sqlStmt=[strQuery UTF8String];
		sqlite3_stmt *compiledStmt;                           
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *passid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
				NSString *dt=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
                NSString *tm=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *desc=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
                NSString *edtbl=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
				
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:passid,@"id",dt,@"ndate",tm,@"ntime",desc,@"notesdesc",edtbl,@"editable",nil];
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

+(NSArray*)gettbl_type:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	AppDelegate *x=(AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) 
    {
		const char *sqlStmt=[strQuery UTF8String];             
		sqlite3_stmt *compiledStmt;                           
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                NSString *passid=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
                NSString *typ=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
				
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:passid,@"id",typ,@"type",nil];
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


+(int)InsertUpdateDeleteQuery:(NSString*)strQuery
{
    AppDelegate *x=(AppDelegate *)[[UIApplication sharedApplication]delegate];
	sqlite3 *database;
    
    if(sqlite3_open([[x dataBasePath] UTF8String],&database) == SQLITE_OK) {
        
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
@end
