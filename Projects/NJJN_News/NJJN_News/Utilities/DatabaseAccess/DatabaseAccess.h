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
}
+(NSArray*)gettbl_Downloaded_List:(NSString*)strQuery;

+(void)updatetbl:(NSString*)strQuery;
@end
