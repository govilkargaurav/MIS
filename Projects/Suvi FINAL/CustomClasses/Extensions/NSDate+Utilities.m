//
//  NSDate+Utilities.m
//  Suvi
//
//  Created by apple on 4/25/13.
//
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)
#pragma mark - GetPostDate
-(NSString *)FormatedDate
{
    
    NSTimeInterval timeDiff= [[NSDate date] timeIntervalSinceDate:self];
    if (timeDiff<=0.0)
    {
        return @"0 minutes ago";
    }
    
    NSString *str;
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *strData = [df stringFromDate:self];
    //2013-05-01
    NSArray *Arrcur = [strData componentsSeparatedByString:@"-"];
    //(2013,05,01)
    NSString *strCurDate = [df stringFromDate:currentDate];//Current Date
    
    if ([strCurDate isEqualToString:strData])
    {
        NSTimeInterval timeDifference = [currentDate timeIntervalSinceDate:self];
        double minutes = timeDifference / 60;
        int hours = minutes / 60;
        //double seconds = timeDifference;
        //double days = minutes / 1440;
        if (hours==0)
        {
            //17 Mins Ago
            str=[NSString stringWithFormat:@"%.0f minutes ago",minutes];
        }
        else {
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setDateFormat:@"h:mm a"];
            NSString *strrr = [df stringFromDate:self];
            str=[NSString stringWithFormat:@"Today at %@",strrr];
        }
    }
    else
    {
        NSString *strCurrentToYesterday = [self YesterdayDate:currentDate];
        
        NSTimeInterval timeDifference = [currentDate timeIntervalSinceDate:self];
        double minutes = timeDifference / 60;
        //int hours = minutes / 60;
        //double seconds = timeDifference;
        int days = minutes / 1440;
        
        //One day ago
        if ([strData isEqualToString:strCurrentToYesterday])
        {
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setDateFormat:@"h:mm a"];
            NSString *strrr = [df stringFromDate:self];
            str=[NSString stringWithFormat:@"Yesterday at %@",strrr];
        }
        //Less than 5 days ago = Tuesday at 10:45 AM
        else if(days<5)
        {
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setDateFormat:@"h:mm a"];
            NSString *strrr = [df stringFromDate:self];
            
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setDateFormat:@"EEEE"];
            NSString *strDayType = [df stringFromDate:self];
            str=[NSString stringWithFormat:@"%@ at %@",strDayType,strrr];
        }
        
        else
        {
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setDateFormat:@"yyyy"];
            NSString *strrr = [df stringFromDate:currentDate];
            // 5 or more days ago on same year = October 25 at 5:15 PM
            if ([strrr isEqualToString:[Arrcur objectAtIndex:0]])
            {
                NSDateFormatter *df = [[NSDateFormatter alloc]init];
                [df setTimeZone:[NSTimeZone systemTimeZone]];
                [df setDateFormat:@"MMMM"];
                NSString *str_month = [df stringFromDate:self];
                
                [df setTimeZone:[NSTimeZone systemTimeZone]];
                [df setDateFormat:@"dd"];
                NSString *str_day = [df stringFromDate:self];
                
                [df setTimeZone:[NSTimeZone systemTimeZone]];
                [df setDateFormat:@"h:mm a"];
                NSString *str_Time = [df stringFromDate:self];
                
                strrr = [NSString stringWithFormat:@"%@ %@ at %@",str_month,str_day,str_Time];
                
            }
            else
            {
                //October 25, 2012
                NSDateFormatter *df = [[NSDateFormatter alloc]init];
                [df setTimeZone:[NSTimeZone systemTimeZone]];
                [df setDateFormat:@"MMMM dd,yyyy"];
                strrr = [df stringFromDate:self];
            }
            str =[NSString stringWithFormat:@"%@",strrr];
        }
    }
    return str;
}
-(NSString *)YesterdayDate:(NSDate *)returnDate
{
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )fromDate:returnDate];
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )fromDate:returnDate];
    [dateComps setDay:[dateComponents day]-1];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
    [dateComps setMinute:[timeComponents minute]];
    [dateComps setSecond:[timeComponents second]];
    NSDate *datePrevious = [calendar dateFromComponents:dateComps];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *strD = [df stringFromDate:datePrevious];
    return strD;
}
@end
