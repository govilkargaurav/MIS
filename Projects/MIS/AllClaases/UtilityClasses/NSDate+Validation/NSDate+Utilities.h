//
//  NSDate+Utilities.h
//  Suvi
//
//  Created by apple on 4/25/13.
//
//



@interface NSDate (Utilities)
-(NSString *)FormatedDate;
-(NSString *)YesterdayDate:(NSDate *)returnDate;
-(NSString *)FormateCurrentDate_with_newFormate:(NSString *)dateFormatter;
-(NSString *)getDateDiff;
- (NSString *)sqlColumnRepresentationOfSelf;
@end
