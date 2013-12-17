//
//  CustomUIApplicationClass.m
//  NATIC
//
//  Created by KPIteng on 9/28/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import "CustomUIApplicationClass.h"

@implementation CustomUIApplicationClass
+(void)OpenAlertViewWithMessage:(NSString *)message title:(NSString*)title
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alertView show];
}

+(void)saveArray:(NSMutableArray *)arry inDocumentDirectoryFileName:(NSString *)fileName
{
    fileName=[[self getDocumentDiretoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",fileName ]];
     [arry writeToFile:fileName atomically:YES];
}
+(NSMutableArray *)getArrayFromDocumentDirectorty:(NSString *)fileName
{
    fileName=[[self getDocumentDiretoryPath] stringByAppendingFormat:@"/%@",fileName];
    NSMutableArray *data=[[NSMutableArray alloc] initWithContentsOfFile:fileName];
    return data;
}
+(NSString *)getDocumentDiretoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
+(CGFloat)getStringHeightforLabel:(UILabel *)label
{
    CGSize maximumLabelSize = CGSizeMake(label.frame.size.width,9999);
    CGSize stringSize= [label.text sizeWithFont:label.font
                                  constrainedToSize:maximumLabelSize
                                      lineBreakMode:label.lineBreakMode];
    return stringSize.width;
}
+(CGFloat)getStringHeigh:(NSString *)string width:(CGFloat)width font:(UIFont *)font
{
    CGSize maximumLabelSize = CGSizeMake(width,9999);
    CGSize stringSize= [string sizeWithFont:font
                              constrainedToSize:maximumLabelSize
                                  lineBreakMode:NSLineBreakByWordWrapping];
    return stringSize.height;
}

// This method return timestam from date string

+(NSString *)getUTCFormateDate:(NSString *)dateStr{
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    NSDateComponents *comps = [[NSCalendar currentCalendar]
                               components:NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit
                               fromDate:date];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    NSTimeInterval timestamp=[[[NSCalendar currentCalendar] dateFromComponents:comps] timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%f",timestamp];
}
@end
