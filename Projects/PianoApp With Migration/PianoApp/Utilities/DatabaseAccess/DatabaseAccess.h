//
//  DatabaseAccess.h
//  Database
//
//  Created by apple on 01/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface DatabaseAccess : NSObject {
	NSString *string;
	AppDelegate *appDel;
	
}
+(NSArray*)gettbl_newpasswords:(NSString*)strQuery;

+(NSArray*)gettbl_addcontacts:(NSString*)strQuery;

+(NSArray*)gettbl_cameraroll:(NSString*)strQuery;

+(NSArray*)gettbl_notes:(NSString*)strQuery;

+(NSArray*)gettbl_type:(NSString*)strQuery;


+(int)InsertUpdateDeleteQuery:(NSString*)strQuery;
@end
