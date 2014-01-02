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

+(NSArray*)gettbl_Downloaded_List:(NSString*)strQuery
{
    NSMutableArray *CP=[[NSMutableArray alloc]init];
	sqlite3 *database;
	if(sqlite3_open([[AppDel dataBasePath] UTF8String],&database) == SQLITE_OK)
    {
		const char *sqlStmt=[strQuery UTF8String];             
		sqlite3_stmt *compiledStmt;                           
		if(sqlite3_prepare_v2(database, sqlStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStmt)==SQLITE_ROW) {
                
                
                NSString *iPdfID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
				NSString *vTitle=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
                NSString *tDescription=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
				NSString *vFileName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
                NSString *vPdfImage=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
				NSString *iZoneID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
                NSString *dIssueDate=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
				NSString *iEditionID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
                NSString *vAuthor=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];
				NSString *eStatus=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 10)];
                NSString *dModification=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 11)];
				NSString *tCreationDate=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 12)];
                NSString *vFileNameThumb=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 13)];
				NSString *vDownload=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 14)];
                NSString *link_status=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 15)];
				NSString *Test1=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 16)];
                NSString *Test2=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 17)];
                NSString *Test3=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 18)];
                NSString *Test4=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 19)];
                NSString *Test5=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 20)];
                             
                
				NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:iPdfID,@"iPdfID",vTitle,@"vTitle",tDescription,@"tDescription",vFileName,@"vFileName",vPdfImage,@"vPdfImage",iZoneID,@"iZoneID",dIssueDate,@"dIssueDate",iEditionID,@"iEditionID",vAuthor,@"vAuthor",eStatus,@"eStatus",dModification,@"dModification",tCreationDate,@"tCreationDate",vFileNameThumb,@"vFileNameThumb",vDownload,@"vDownload",link_status,@"link_status",Test1,@"Test1",Test2,@"Test2",Test3,@"Test3",Test4,@"Test4",Test5,@"Test5",nil];
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

+(void)updatetbl:(NSString*)strQuery
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
    sqlite3_close(database);
}

@end
