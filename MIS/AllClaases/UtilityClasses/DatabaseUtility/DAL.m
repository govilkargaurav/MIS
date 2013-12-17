
#import "DAL.h"
#import "GlobalClass.h"
static sqlite3_stmt *stmt=nil;

@implementation DAL

@synthesize database;

+ (DAL *) getInstance{
	@try{
		static DAL *instance;
		if(instance == nil) {
			instance = [[DAL alloc] init];
		}
		return instance;
	}@catch (NSException *e) {
		////////NSLog(@"%@",[e description]);
	}
	return nil;
}

- (BOOL) isRecordExistInCountyInfo:(NSString *)countyIDstr{
	BOOL flag=NO;
	@try{
		
        sqlite3_stmt *statement;
		NSString *sqlStatement =[NSString stringWithFormat:@"SELECT * FROM %@ WHERE attendeesID ='%@' ",strTblName,countyIDstr];
		sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &statement, nil);
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
			flag=YES;
		}
//		sqlite3_close(database);
		return flag;
	}@catch (NSException *e) {
		//sqlite3_close(database);
		//////NSLog(@"%@",[e description]);
		return flag;
	}

	return flag;
    
}



+(BOOL)lookupChangeForSQLDictionary:(NSDictionary *)dictSql insertOrUpdate:(NSString *)DML ClauseAndCondition:(NSString *)ClauseAndCondition TableName:(NSString *)tblName
{
    ////NSLog(@"dict Sql == >> %@\n\n",dictSql);
    
    NSArray *arrKeys = [[NSArray alloc]initWithArray:[dictSql allKeys]];
    
    NSMutableArray *arrBlob_data = [[NSMutableArray alloc] init];
    NSMutableArray *arrBlob_name = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrColumnName = [[NSMutableArray alloc] init];
    NSMutableArray *arrColumnValue = [[NSMutableArray alloc] init];
    
    for (int k=0; k<[arrKeys count]; k++)
    {
        NSString *key = [arrKeys objectAtIndex:k];
        id obj = [dictSql objectForKey:key];
        
        // #### TESTING OBJECT LOG ####
        ////NSLog(@"== Key == >> %@",key);
        //if ([obj isKindOfClass:[UIImage class]] || [obj isKindOfClass:[NSData class]])
        //{
        //      //NSLog(@"== obj == >> Object is NOT NIL");
        //}
        //else
        //{
        //    //NSLog(@"== obj == >> %@",obj);
        //}
        
        
        if ([obj isKindOfClass:[NSString class]])
        {
            // TESTED OK //KK
            
            NSString *string = (NSString *)obj;
            [arrColumnName addObject:key];
            [arrColumnValue addObject:[string stringByReplaceQueryQuoteAndBindQuote]];
        }
        else if ([obj isKindOfClass:[UIImage class]])
        {
            // TESTED OK //KK
            
            UIImage *image = (UIImage *)obj;
            NSData *imgData = UIImagePNGRepresentation(image);
            if (imgData == Nil || [imgData isEqual:[NSNull null]] )
            {
                imgData = UIImageJPEGRepresentation(image, 0.9);//Compression qulaity..
                if (imgData.length == 0 || imgData == Nil || [imgData isEqual:[NSNull null]] )
                {
                    [arrBlob_data addObject:@""];
                    [arrBlob_name addObject:key];
                }
                else
                {
                    [arrBlob_data addObject:imgData];
                    [arrBlob_name addObject:key];
                }
            }
            else
            {
                [arrBlob_data addObject:imgData];
                [arrBlob_name addObject:key];
            }
        }
        else if ([obj isKindOfClass:[NSData class]])
        {
            // TESTED OK //KK
            
            NSData *imgData = (NSData *)obj;
            if (imgData.length ==0 || imgData == Nil || [imgData isEqual:[NSNull null]] )
            {
                [arrBlob_data addObject:@""];
                [arrBlob_name addObject:key];
            }
            else
            {
                [arrBlob_data addObject:imgData];
                [arrBlob_name addObject:key];
            }
        }
        else if ([obj isKindOfClass:[NSNumber class]])
        {
            
            if (CFNumberIsFloatType ((CFNumberRef)obj))
            {
                // FLOAT & LONG VALUES
                long long fval = [obj longLongValue];
                [arrColumnName addObject:key];
                [arrColumnValue addObject:[NSString stringWithFormat:@"%lld",fval]];
            }
            else
            {
                // INT & BOOL VALUES
                int fval = [obj intValue];
                [arrColumnName addObject:key];
                [arrColumnValue addObject:[NSString stringWithFormat:@"%d",fval]];
            }
        }
        else if ([obj isKindOfClass:[NSDate class]])
        {
            
            NSDate *objDate = ((NSDate *)obj);
            NSString *stringDate = [objDate sqlColumnRepresentationOfSelf];
            if (stringDate != nil && stringDate.length != 0)
            {
                [arrColumnName addObject:key];
                //NSLog(@"stringDate == %@",stringDate);
                [arrColumnValue addObject:[stringDate stringByReplaceQueryQuoteAndBindQuote]];
            }
        }
        else if (obj != nil && ![obj isEqual:[NSNull null]])
        {
            // Tested OK //KK
            
            [arrColumnName addObject:key];
            [arrColumnValue addObject:[NSString stringWithFormat:@"%@",[obj description]]];
        }
        else
        {
            //this part of code should never Execute  ...
            
            [arrColumnName addObject:key];
            [arrColumnValue addObject:[NSString stringWithFormat:@"''"]];
        }
    }
    
    //=====================  Query Start ===================== //
    
    NSString *sql= @"";
    
    //===================================================//
    //=====================  Insert =====================//
    //===================================================//
    if ([DML caseInsensitiveCompare:@"insert"] == NSOrderedSame)
    {
        [arrColumnName addObjectsFromArray:arrBlob_name];
        
        NSString  *columsNames = [[NSString alloc]initWithString: [arrColumnName componentsJoinedByString:@","]];
        
        NSMutableString *columnValues = [[NSMutableString alloc]initWithString: [arrColumnValue componentsJoinedByString:@","]];
        
        if([arrBlob_data count]>0)
        {
            [columnValues appendString:@","];
            
            for (int j=0; j<[arrBlob_data count]; j++)
            {
                [columnValues appendString:@"?"];
                if (j != [arrBlob_data count]-1) {
                    [columnValues appendString:@","];
                }
            }
        }
        
        sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)",tblName,columsNames,columnValues];
        //NSLog(@" Query == >>  %@\n\n",sql);
    }
    
    else
        
        //===================================================//
        //=====================  Update =====================//
        //===================================================//
        
        if ([DML caseInsensitiveCompare:@"update"] == NSOrderedSame && ClauseAndCondition != nil)
        {
            NSMutableString *stringUpdate = [[NSMutableString alloc]initWithString:@""];
            
            for (int m=0; m<[arrColumnName count]; m++)
            {
                [stringUpdate appendFormat:@"%@=%@",[arrColumnName objectAtIndex:m],[arrColumnValue objectAtIndex:m]];
                
                if (m != [arrColumnName count]-1 || [arrBlob_name count] != 0)
                {
                    [stringUpdate appendString:@","];
                }
            }
            
            for (int m=0; m<[arrBlob_name count]; m++)
            {
                [stringUpdate appendFormat:@"%@=?",[arrBlob_name objectAtIndex:m]];
                
                if (m != [arrBlob_name count]-1)
                {
                    [stringUpdate appendString:@","];
                }
            }
            
            sql = [NSString stringWithFormat:@"update %@ set %@ %@",tblName,stringUpdate,ClauseAndCondition];
        }
    
    // VALIDATE BLOB
    if ([arrBlob_name count] != [arrBlob_data count])
    {
        @try
        {
            //you may like to handle this Exception Out-side of Database Class
            [NSException raise:@"Invalid Blob data" format:@"could not find any key value Coding for blob"];
        }
        @catch (NSException *exception)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:exception.description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        @finally
        {
            return FALSE;
        }
    }
    
    //NSLog(@"\n\n\n\nQUERY :: %@\n\n\n",sql);
    
    //===================================================//
    //============ Prepare & Execute Query ==============//
    //===================================================//
    
    BOOL isTransComplete = NO;
    NSString *str = sql;
    sqlite3 *database;
    
    //NSLog(@"\n\narr Blob Count == %d : %d  (bug if is is not Equal)\n\n",[arrBlob_data count],[arrBlob_name count]);
    
    if(sqlite3_open([[DAL GetDatabasePath] UTF8String],&database) == SQLITE_OK)
    {
        const char *sqlStmt = [str UTF8String];
        
        sqlite3_stmt *cmp_sqlStmt;
        if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL) == SQLITE_OK)
        {
            int returnValue = sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL);
            
            for (int l=0; l<[arrBlob_name count]; l++)
            {
                NSData *blob = [arrBlob_data objectAtIndex:l];
                if(blob != nil && blob.length != 0)
                {
                    sqlite3_bind_blob(cmp_sqlStmt, l+1, [blob bytes], [blob length], NULL);
                }
                else
                {
                    sqlite3_bind_blob(cmp_sqlStmt, l+1, nil, -1, NULL);
                }
            }
            
            if (returnValue==SQLITE_OK)
            {
                //NSLog(@"\n\n\tSuccess\n\n");
                isTransComplete = YES;
            }
            else
            {
                //NSLog(@"\n\n\tUnSuccess\n\n");
            }
            
            sqlite3_step(cmp_sqlStmt);
        }
        else
        {
            //NSLog(@"=== Invalide Query ::%@::  & Created sqlite3_stmt ==>>  %@ ",str,cmp_sqlStmt);
        }
        sqlite3_finalize(cmp_sqlStmt);
    }
	sqlite3_close(database);
    //database = nil;
    return isTransComplete;
}



- (BOOL) deleteAllrecords:(NSString *)QueryStr{
	@try{
		stmt=nil;
		if(stmt==nil){
            
            NSString *sqlQuery=[NSString stringWithFormat:@"%@",QueryStr];
            
            
            
            if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error while creating Insert statement. '%s'", sqlite3_errmsg(database));
            }
			//const char *query = [[NSString stringWithFormat:@"delete from tbl_category_Draw"] cStringUsingEncoding:NSUTF8StringEncoding];
			//if(sqlite3_prepare_v2(database, query, -1, &stmt, NULL) == SQLITE_OK){
            if (SQLITE_DONE != sqlite3_step(stmt)){
                NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
                sqlite3_reset(stmt);
                return NO;
            }
            return YES;
            sqlite3_reset(stmt);
			//}else{
			//	return NO;
			//}
		}else{
			return NO;
		}
	}@catch(NSException *e){
		//sqlite3_close(database);
		////////NSLog(@"%@",[e description]);
		////////NSLog(@"Error");
	}
	return NO;	
}


-(void) openCreateDatabase {
	@try{
		databasePath=[self dataFilePath];
		[self createEditableCopyOfDatabaseIfNeeded];
		if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) { 
			sqlite3_close(database);
			NSAssert(0, @"Failed to open database");
		}
	}@catch (NSException *e) {
		NSLog(@"%@",[e description]);

	}
}




// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
	@try{
		BOOL success;
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSError *error;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
		success = [fileManager fileExistsAtPath:writableDBPath];
		if (success) return;
		// The writable database does not exist, so copy the default to the appropriate location.
		//////NSLog(@"database not exist, therefore create here...");
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if (!success) {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}		
	}@catch (NSException *e) {
		//////NSLog(@"%@",[e description]);
	}
    // First, test for existence.
 }

- (sqlite3_stmt *)prepare:(NSString *)sql
{
    ////NSLog(@"\n\n%@\n\n\n\n",sql);
	const char *utfsql = [sql UTF8String];
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2([self database],utfsql,-1,&statement,NULL) == SQLITE_OK) {
		return statement;
	} else {
		//NSLog(@"STATEMENT:%@ \nError while creating add statement.'%s'", sql,sqlite3_errmsg(ObjDB));
		return 0;
	}
}


- (NSMutableArray *)lookupAllForSQL:(NSString *)sql
{
    if(sqlite3_open([[DAL GetDatabasePath]UTF8String], &database)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to open database" message:@"Database path is Wrong" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return nil;
    }
    
	sqlite3_stmt *statement;
	id result;
	
	NSString *path = [DAL GetDatabasePath];
	
	NSMutableArray *thisArray = [NSMutableArray array];
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
	{
        if ((statement = [self prepare:sql])) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *thisDict = [NSMutableDictionary dictionary];
                
                for (int i = 0 ; i < sqlite3_column_count(statement) ; i++) {
                    
                    if (sqlite3_column_decltype(statement,i) != NULL &&
                        strcasecmp(sqlite3_column_decltype(statement,i),"Boolean") == 0) {
                        result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
                    } else if (sqlite3_column_type(statement, i) == SQLITE_TEXT) {
                        result = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)]RemoveNull];
                    } else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
                        result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
                    } else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
                        result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];
                    } else if (sqlite3_column_type(statement, i) == SQLITE_BLOB){
                        int length = sqlite3_column_bytes(statement, i);
                        result = [NSData dataWithBytes:sqlite3_column_blob(statement, i) length:length];
                    }
                    
                    else {
                        const unsigned char *tempresult = sqlite3_column_text(statement, i);
                        if(tempresult==NULL)
                            result=@"";
                        else
                            result = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)]RemoveNull];
                    }
                    
                    if (result)
                    {
                        [thisDict setObject:result
                                     forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
                    }
                }
                
                [thisArray addObject:[NSMutableDictionary dictionaryWithDictionary:thisDict]];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        //database=nil;
	}
	
	return thisArray;
}

// Returns Database file path
- (NSString *) dataFilePath {
	@try{
		// Get the path to the documents directory and append the databaseName
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		databasePath = [documentsDir stringByAppendingPathComponent:dbName];
		return databasePath;		
	}@catch (NSException *e) {
		//////NSLog(@"%@",[e description]);
	}
	return nil;
}

+(NSString*) GetDatabasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
    NSString *documentsDirectory = [paths objectAtIndex:0] ;
	return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",kDataBaseName,kDataBaseExt]];
}

@end

