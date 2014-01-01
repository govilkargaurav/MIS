
#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "DatabaseBean.h"
#define dbName @"CountyInfo.sqlite"


@interface DAL : NSObject {
	sqlite3		*database;
	NSString	*databasePath;
    DatabaseBean *dataObj;
}
+ (DAL *)				getInstance;
- (void)				openCreateDatabase;
- (void)				createEditableCopyOfDatabaseIfNeeded;
- (NSString *)			dataFilePath;

-(BOOL) insertintoCountyInfo:(DatabaseBean *)aBean;
- (BOOL) isRecordExistInCountyInfo:(NSString *)countyIDstr;
- (NSMutableArray *)getAllSubCategory:(NSString *)countyID;
- (BOOL) deleteAllrecords:(NSString *)QueryStr;
- (NSMutableDictionary *)getAllSubCategorybyId1:(NSString *)queryString;
- (NSMutableDictionary *)getAllSubCategorybyPropertyID:(NSString *)propertyID:(NSString *)queryString;
- (NSMutableDictionary *)getAllSubCategorybyId:(NSString *)propertyID:(NSString *)queryString;
-(BOOL) insertintocheckinfo:(DatabaseBean *)aBean;
- (NSString *)getCheckInfoAll:(NSString *)checkNumber;
@end
