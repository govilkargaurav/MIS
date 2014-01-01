//
//  CustomUIApplicationClass.h
//  NATIC
//
//  Created by KPIteng on 9/28/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomUIApplicationClass : NSObject
+(void)OpenAlertViewWithMessage:(NSString *)message title:(NSString*)title;

+(void)saveArray:(NSMutableArray *)arry inDocumentDirectoryFileName:(NSString *)fileName;

+(NSMutableArray *)getArrayFromDocumentDirectorty:(NSString *)fileName;

+(NSString *)getDocumentDiretoryPath;

+(CGFloat)getStringHeightforLabel:(UILabel *)label;

+(CGFloat)getStringHeigh:(NSString *)string width:(CGFloat)width font:(UIFont *)font;

// This mehod return timestamp from date string
+(NSString *)getUTCFormateDate:(NSString *)dateStr;
@end
