
#import <UIKit/UIKit.h>
#import "sqlite3.h"
#define dbName @"MIS.sqlite"
#define kDataBaseName  @"MIS"
#define kDataBaseExt   @"sqlite"

@interface DAL : NSObject {
	sqlite3		*database;
	NSString	*databasePath;
}
@property (nonatomic,assign) sqlite3 *database;
+ (DAL *)				getInstance;
- (void)				openCreateDatabase;
- (void)				createEditableCopyOfDatabaseIfNeeded;
- (NSString *)			dataFilePath;
+(NSString*)            GetDatabasePath;
- (BOOL) isRecordExistInCountyInfo:(NSString *)countyIDstr;
- (BOOL) deleteAllrecords:(NSString *)QueryStr;
- (NSMutableArray *)lookupAllForSQL:(NSString *)sql;
+(BOOL)lookupChangeForSQLDictionary:(NSDictionary *)dictSql insertOrUpdate:(NSString *)DML ClauseAndCondition:(NSString *)ClauseAndCondition TableName:(NSString *)tblName;
@end
