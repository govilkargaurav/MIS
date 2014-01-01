//
//  DBManager.h
//  TruckInspection
//
//  Created by Apple1 on 3/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define kAppDBName @"AppDB.sqlite"

@interface DBManager : NSObject
{
    
}

+(id)sharedManager;
-(void)createEditableCopyOfSQLIteIfNeeded;
-(NSString *)getDBPath;

-(NSMutableArray *)getResultForSQLQuery:(NSString *)strSQLQuery;
-(BOOL)executeSQLQuery:(NSString *)strSQLQuery;
-(BOOL)addUniversityWithName:(NSString *)strUniName andUniId:(NSString *)strUniId abbriviation:(NSString *)strAbbriviation address:(NSString *)strAddress uniPicture:(NSString *)strUniPicture;
-(BOOL)updateUniversityWithName:(NSString *)strUniName andUniId:(NSString *)strUniId abbriviation:(NSString *)strAbbriviation address:(NSString *)strAddress uniPicture:(NSString *)strUniPicture;


@end
