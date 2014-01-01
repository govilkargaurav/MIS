//
//  DatabaseAccess.h
//  Database
//
//  Created by apple on 01/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface DatabaseAccess : NSObject 
{
	NSString *string;
	AppDelegate *appDel;
}
+(NSArray*)gettbl_user_setting:(NSString*)strQuery;
+(NSArray*)gettbl_TimeZone:(NSString*)strQuery;
+(NSArray*)gettbl_lists:(NSString*)strQuery;
+(NSArray*)gettbl_tasks:(NSString*)strQuery;
+(NSArray*)gettbl_own_contact:(NSString*)strQuery;
+(NSArray*)gettbl_org_contact:(NSString*)strQuery;
+(NSArray*)gettbl_standerd_reminder:(NSString*)strQuery;
+(NSArray*)gettbl_channels:(NSString*)strQuery;
+(NSArray*)gettbl_add_messages:(NSString*)strQuery;
+(NSArray*)gettbl_add_fadedate:(NSString*)strQuery;
+(NSArray*)gettbl_giveback_tasks:(NSString*)strQuery;
+(NSArray*)gettbl_archive_tasks:(NSString*)strQuery;
+(NSArray*)gettbl_messages:(NSString*)strQuery;

+(int)getMaxid:(NSString*)strQuery;
+(int)updatetbl:(NSString*)strQuery;

+(void)updatetblWithArrayQuery:(NSMutableArray*)arryQuery;
@end
