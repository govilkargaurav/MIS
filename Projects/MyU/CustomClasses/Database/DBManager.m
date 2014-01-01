//
//  DBManager.m
//  TruckInspection
//
//  Created by Apple1 on 3/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

+(id)sharedManager
{
    static DBManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    if (self = [super init])
    {

    }
    return self;
}

-(void)createEditableCopyOfSQLIteIfNeeded
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success)
    {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kAppDBName];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
		if (!success)
        {
			NSAssert1(0, @"Failed to create writable plist file with message '%@'.", [error localizedDescription]);
        }
	}
}
-(NSString *)getDBPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:kAppDBName];
}

//'username','password' ,'station' ,'email'
/*
 CREATE TABLE tblusers (
"id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL ,
"username" VARCHAR,
"password" VARCHAR,
"station" VARCHAR,
"email" VARCHAR)
*/

-(NSMutableArray *)getResultForSQLQuery:(NSString *)strSQLQuery
{
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
	sqlite3 *database;
    
	if(sqlite3_open([[self getDBPath] UTF8String],&database) == SQLITE_OK)
    {
        const char *sqlStatement = [strSQLQuery UTF8String];
        
        sqlite3_stmt *compiledStatement; 
        
        if(sqlite3_prepare_v2(database,sqlStatement,-1,&compiledStatement,NULL)==SQLITE_OK) 
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                NSMutableDictionary *dictResult=[NSMutableDictionary dictionaryWithCapacity:(sqlite3_column_count(compiledStatement)+1)];
                for (int i=0;i<sqlite3_column_count(compiledStatement);i++)
                {
                    id result;
                    
                    if(sqlite3_column_type(compiledStatement,i)==SQLITE_TEXT)
                    {
                        result=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,i)];
                    }
                    else if(sqlite3_column_type(compiledStatement,i) == SQLITE_INTEGER)
                    {
                        result = [NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement,i)];
                    }
                    else if(sqlite3_column_type(compiledStatement,i) == SQLITE_FLOAT)
                    {
                        result = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement,i)];					
                    }
                    else if(sqlite3_column_type(compiledStatement,i) == SQLITE_BLOB)
                    {
                        result = [UIImage imageWithData:[NSData dataWithBytes:sqlite3_column_blob(compiledStatement,i) length:sqlite3_column_bytes(compiledStatement,i)]];					
                    }
                    else if(sqlite3_column_type(compiledStatement,i) == SQLITE_NULL)
                    {
                        result=[NSString stringWithFormat:@" "];
                    }
                    else
                    {
                        const unsigned char *tempresult = sqlite3_column_text(compiledStatement, i);
                        if(tempresult==NULL)
                        {
                            result=@"";
                        }
                        else
                        {
                            result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,i)];
                        }
                    }
                    
                    if(result)
                    {
                        [dictResult setObject:result forKey:[NSString stringWithUTF8String:sqlite3_column_name(compiledStatement,i)]];
                    }
                }
                
                [arrResult addObject:dictResult];
            }
        }
        else
        {
            NSLog(@"Error : %s",sqlite3_errmsg(database));
            sqlite3_finalize(compiledStatement);
        }
	}
	sqlite3_close(database);
	
    return arrResult;
}

-(BOOL)executeSQLQuery:(NSString *)strSQLQuery
{
    NSLog(@"The SQL Query:%@",strSQLQuery);
    sqlite3 *database;
    BOOL isSucess=NO;
    
	if(sqlite3_open([[self getDBPath] UTF8String],&database) == SQLITE_OK)
    {
        const char *sqlStatement = [strSQLQuery UTF8String];
        
        sqlite3_stmt *compiledStatement; 
        
        if(sqlite3_prepare_v2(database,sqlStatement,-1,&compiledStatement,NULL)==SQLITE_OK) 
        {
            isSucess=YES;
        }
        else
        {
            NSLog(@"Error : %s",sqlite3_errmsg(database));
            sqlite3_finalize(compiledStatement);
            isSucess=NO;
        }
	}
	sqlite3_close(database);
	
	return isSucess;
}

/*
 CREATE TABLE tbluni (
 "id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL ,
 "universityname" VARCHAR) 
 abbreviation = " UM";
 address = USA;
 "uni_picture"
 */

-(BOOL)addUniversityWithName:(NSString *)strUniName andUniId:(NSString *)strUniId abbriviation:(NSString *)strAbbriviation address:(NSString *)strAddress uniPicture:(NSString *)strUniPicture
{
	sqlite3 *database;
    BOOL isSucess=NO;
    
	if(sqlite3_open([[self getDBPath] UTF8String],&database) == SQLITE_OK)
    {
		NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO tbluni (universityname,universityid,abbreviation,address,uni_picture) VALUES (?,?,?,?,?)"];
        const char *sqlStatement = [sqlStr UTF8String];
        
        sqlite3_stmt *compiledStatement; 
        
        if(sqlite3_prepare_v2(database,sqlStatement,-1,&compiledStatement,NULL)==SQLITE_OK) 
        {
            sqlite3_bind_text(compiledStatement,1,[strUniName UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,2,[strUniId UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,3,[strAbbriviation UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,4,[strAddress UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,5,[strUniPicture UTF8String],-1,SQLITE_TRANSIENT);
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                isSucess=YES;
            }
        }
        else
        {
            NSLog(@"Error : %s",sqlite3_errmsg(database));
            sqlite3_finalize(compiledStatement);
            isSucess=NO;
        }
	}
	sqlite3_close(database);
	
	return isSucess;
}

-(BOOL)updateUniversityWithName:(NSString *)strUniName andUniId:(NSString *)strUniId abbriviation:(NSString *)strAbbriviation address:(NSString *)strAddress uniPicture:(NSString *)strUniPicture
{
	sqlite3 *database;
    BOOL isSucess=NO;
    
	if(sqlite3_open([[self getDBPath] UTF8String],&database) == SQLITE_OK)
    {
        NSString *sqlStr =[NSString stringWithFormat:@"UPDATE tbluni SET universityname=?,abbreviation=?,address=?,uni_picture=? WHERE universityid=?"];
        
        const char *sqlStatement = [sqlStr UTF8String];
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database,sqlStatement,-1,&compiledStatement,NULL)==SQLITE_OK)
        {
            sqlite3_bind_text(compiledStatement,1,[strUniName UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,2,[strUniId UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,3,[strAbbriviation UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,4,[strAddress UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,5,[strUniPicture UTF8String],-1,SQLITE_TRANSIENT);
                       
            isSucess=YES;
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
            }
        }
        else
        {
            NSLog(@"Error : %s",sqlite3_errmsg(database));
            sqlite3_finalize(compiledStatement);
            isSucess=NO;
        }
	}
	sqlite3_close(database);
	
	return isSucess;
}


/*
-(BOOL)isUserExistsWithUserId:(NSString *)strUserId
{
    sqlite3 *database;
    BOOL isSucess=NO;
    
	if(sqlite3_open([[self getDBPath] UTF8String],&database) == SQLITE_OK)
    {
		NSString *sqlStr = [NSString stringWithFormat:@"SELECT username FROM tblusers WHERE username = ?"];
        const char *sqlStatement = [sqlStr UTF8String];
        
        sqlite3_stmt *compiledStatement; 
        
        if(sqlite3_prepare_v2(database,sqlStatement,-1,&compiledStatement,NULL)==SQLITE_OK) 
        {
            sqlite3_bind_text(compiledStatement,1,[strUserId UTF8String],-1,SQLITE_TRANSIENT);
                        
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                isSucess=YES;
            }
        }
        else
        {
            NSLog(@"Error : %s",sqlite3_errmsg(database));
            sqlite3_finalize(compiledStatement);
            isSucess=NO;
        }
	}
	sqlite3_close(database);
	
	return isSucess;
}
*/

/*
 tblinspections
 ("id","datecreated","dateprevins","datelastins",licenceno,"mileage","equiptype",comments,"segstatus",additionalqa,eqcomments,uniqueid,isCompleted)
*/
/*
-(BOOL)addInspectionWithaddDate:(NSString *)strAddedDate licenceNo:(NSString *)strLicenceNo mileage:(NSString *)strMileage equipmentType:(NSString *)strEqipType comments:(NSString *)strComments strSegmentStatus:(NSString *)strSegStatus eqComments:(NSString *)streqComments additionalQA:(NSString *)strAdditionalQA strUniqueId:(NSString *)strUniqueId isCompleted:(NSInteger)isCompleted
{
	sqlite3 *database;
    BOOL isSucess=NO;
    
	if(sqlite3_open([[self getDBPath] UTF8String],&database) == SQLITE_OK)
    {
		NSString *sqlStr =[NSString stringWithFormat:@"INSERT INTO tblinspections (datecreated,dateprevins,datelastins,licenceno,mileage,equiptype,comments,segstatus,eqcomments,additionalqa,uniqueid,isCompleted) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)"];
        const char *sqlStatement = [sqlStr UTF8String];
    
        sqlite3_stmt *compiledStatement; 
        
        if(sqlite3_prepare_v2(database,sqlStatement,-1,&compiledStatement,NULL)==SQLITE_OK) 
        {
            sqlite3_bind_text(compiledStatement,1,[strAddedDate UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,2,[strAddedDate UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,3,[strAddedDate UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,4,[strLicenceNo UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,5,[strMileage UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,6,[strEqipType UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,7,[strComments UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,8,[strSegStatus UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,9,[streqComments UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,10,[strAdditionalQA UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,11,[strUniqueId UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 12, isCompleted);
            
            isSucess=YES;
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                
            }
        }
        else
        {
            NSLog(@"Error : %s",sqlite3_errmsg(database));
            sqlite3_finalize(compiledStatement);
            isSucess=NO;
        }
	}
	sqlite3_close(database);
	
	return isSucess;
}

*/


/*
 tblinspections
 ("id","datecreated","dateprevins","datelastins",licenceno,"mileage","equiptype",comments,"segstatus",additionalqa,eqcomments,uniqueid)

-(BOOL)updateInspectionWithlastinsDate:(NSString *)strLastInsertDate previousDate:(NSString *)strPreviousDate licenceNo:(NSString *)strLicenceNo mileage:(NSString *)strMileage equipmentType:(NSString *)strEqipType comments:(NSString *)strComments strSegmentStatus:(NSString *)strSegStatus additionalQA:(NSString *)strAdditionalQA eqComments:(NSString *)streqComments forInspectionId:(NSString *)strInspectionId isCompleted:(NSInteger)isCompleted
{
	sqlite3 *database;
    BOOL isSucess=NO;
    
	if(sqlite3_open([[self getDBPath] UTF8String],&database) == SQLITE_OK)
    {
        NSString *sqlStr =[NSString stringWithFormat:@"UPDATE tblinspections SET dateprevins=?,datelastins=?,licenceno=?,mileage=?,equiptype=?,comments=?,segstatus=?,additionalqa=?,eqcomments=?,isCompleted=? WHERE id=?"];
        
        const char *sqlStatement = [sqlStr UTF8String];
        
        sqlite3_stmt *compiledStatement; 
        
        if(sqlite3_prepare_v2(database,sqlStatement,-1,&compiledStatement,NULL)==SQLITE_OK) 
        {
            sqlite3_bind_text(compiledStatement,1,[strPreviousDate UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,2,[strLastInsertDate UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,3,[strLicenceNo UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,4,[strMileage UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,5,[strEqipType UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,6,[strComments UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,7,[strSegStatus UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,8,[strAdditionalQA UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement,9,[streqComments UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement,10,isCompleted);
            sqlite3_bind_text(compiledStatement,11,[strInspectionId UTF8String],-1,SQLITE_TRANSIENT);
            
            
            isSucess=YES;
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                
            }
        }
        else
        {
            NSLog(@"Error : %s",sqlite3_errmsg(database));
            sqlite3_finalize(compiledStatement);
            isSucess=NO;
        }
	}
	sqlite3_close(database);
	
	return isSucess;
}
*/
/*
 -(NSMutableDictionary *)loginwithUserName:(NSString *)strUserName andPassword:(NSString *)strPassword
 {
 NSMutableArray *arrUsers=[[NSMutableArray alloc]init];
 sqlite3 *database;
 BOOL isSucess=NO;
 
 if(sqlite3_open([[self getDBPath] UTF8String],&database) == SQLITE_OK)
 {
 NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM tblusers WHERE username = ? AND password = ?"];
 const char *sqlStatement = [sqlStr UTF8String];
 
 sqlite3_stmt *compiledStatement;
 
 if(sqlite3_prepare_v2(database,sqlStatement,-1,&compiledStatement,NULL)==SQLITE_OK)
 {
 sqlite3_bind_text(compiledStatement,1,[strUserName UTF8String],-1,SQLITE_TRANSIENT);
 sqlite3_bind_text(compiledStatement,2,[strPassword UTF8String],-1,SQLITE_TRANSIENT);
 
 while(sqlite3_step(compiledStatement) == SQLITE_ROW)
 {
 NSMutableDictionary *dictUser=[NSMutableDictionary dictionaryWithCapacity:(sqlite3_column_count(compiledStatement)+1)];
 for (int i=0;i<sqlite3_column_count(compiledStatement);i++)
 {
 id result;
 
 if(sqlite3_column_type(compiledStatement,i)==SQLITE_TEXT)
 {
 result=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,i)];
 }
 else if(sqlite3_column_type(compiledStatement,i) == SQLITE_INTEGER)
 {
 result = [NSNumber numberWithInt:(int)sqlite3_column_int(compiledStatement,i)];
 }
 else if(sqlite3_column_type(compiledStatement,i) == SQLITE_FLOAT)
 {
 result = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement,i)];
 }
 else if(sqlite3_column_type(compiledStatement,i) == SQLITE_BLOB)
 {
 result = [UIImage imageWithData:[NSData dataWithBytes:sqlite3_column_blob(compiledStatement,i) length:sqlite3_column_bytes(compiledStatement,i)]];
 }
 else if(sqlite3_column_type(compiledStatement,i) == SQLITE_NULL)
 {
 result=[NSString stringWithFormat:@" "];
 }
 else
 {
 const unsigned char *tempresult = sqlite3_column_text(compiledStatement, i);
 if(tempresult==NULL)
 {
 result=@"";
 }
 else
 {
 result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,i)];
 }
 }
 
 if(result)
 {
 [dictUser setObject:result forKey:[NSString stringWithUTF8String:sqlite3_column_name(compiledStatement,i)]];
 }
 }
 
 [dictUser setObject:@"1" forKey:@"success"];
 
 [arrUsers addObject:dictUser];
 isSucess=YES;
 }
 }
 else
 {
 NSLog(@"Error : %s",sqlite3_errmsg(database));
 sqlite3_finalize(compiledStatement);
 isSucess=NO;
 }
 }
 sqlite3_close(database);
 
 if (isSucess)
 {
 return [arrUsers objectAtIndex:0];
 }
 else
 {
 NSMutableDictionary *dictUser = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"success",nil];
 return dictUser;
 }
 }
 */
@end
