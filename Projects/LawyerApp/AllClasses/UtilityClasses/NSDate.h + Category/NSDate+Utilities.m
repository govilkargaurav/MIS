//
//  NSDate+Utilities.m
//  Suvi
//
//  Created by apple on 4/25/13.
//
//
/*
 4min ago
 59min ago
 1hour ago
 7hours 23m ago
 1day ago
 27days ago
 1month ago
 3months 20d ago
 1year ago
 3years 2m ago
 
 If you can put it in spanish, the english version was for you to understand it better.
 
 Spanish version:
 Hace 4min
 Hace 59min
 Hace 1hora
 Hace 7horas 23m
 Hace 1día
 Hace 27días
 Hace 1mes
 Hace 3meses 20d
 Hace 1año
 Hace 3años 2m
 */

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)


-(NSString *)getDateDiff
{
    
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:self  toDate:[NSDate date]  options:0];
    
    //NSLog(@"Conversion: %dmin %dhours %ddays %dmoths %dYear",[conversionInfo minute], [conversionInfo hour], [conversionInfo day], [conversionInfo month]%12,[conversionInfo month]/12);
    //NSString *result2 = [NSString stringWithFormat:@"%d year, %d month and %d day",[conversionInfo month]/12,[conversionInfo month]%12,[conversionInfo day]];
    
    NSString *strMin = [NSString stringWithFormat:@"%d",[conversionInfo minute]];
    NSString *strHour = [NSString stringWithFormat:@"%d",[conversionInfo hour]];
    NSString *strDay = [NSString stringWithFormat:@"%d",[conversionInfo day]];
    NSString *strMonth = [NSString stringWithFormat:@"%d",[conversionInfo month]%12];
    NSString *strYear = [NSString stringWithFormat:@"%d",[conversionInfo month]/12];
    
    NSString *strFinal;
    if ([strYear isEqualToString:@"0"])
    {
        if ([strMonth isEqualToString:@"0"])
        {
            if ([strDay isEqualToString:@"0"])
            {
                if ([strHour isEqualToString:@"0"])
                {
                    strFinal = [NSString stringWithFormat:@"Hace %@min",strMin];//   59min ago = Hace 59min
                }
                else
                {
                    
                    if ([strMin isEqualToString:@"0"])
                    {
                       strFinal = [NSString stringWithFormat:@"Hace %@horas",strHour]; //7hours= Hace 7horas
                    }
                    else
                    {
                        strFinal = [NSString stringWithFormat:@"Hace %@horas %@m",strHour,strMin]; //7hours 23m ago= Hace 7horas 23m
                    }
                    
                }
            }
            else
            {
                strFinal = [NSString stringWithFormat:@"Hace %@días",strDay]; //   27days ago =  Hace 27días
            }
        }
        else
        {
            
            if ([strDay isEqualToString:@"0"])
            {
                strFinal = [NSString stringWithFormat:@"Hace %@meses",strMonth]; //  3months 20d ago = Hace 3meses 20d
            }
            else
            {
                strFinal = [NSString stringWithFormat:@"Hace %@meses %@d",strMonth,strDay];//  3months ago = Hace 3meses
            }
            
        }
    }
    else
    {
        if ([strMonth isEqualToString:@"0"])
            // 1year ago = Hace 1año
            strFinal = [NSString stringWithFormat:@"Hace %@año",strYear];
        else
            //  3years 2m ago = Hace 3años 2m
            strFinal = [NSString stringWithFormat:@"Hace %@años %@m",strYear,strMonth];
    }
    
    return strFinal;
}


#pragma mark - GetPostDate
-(NSString *)FormatedDate
{
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
            // Hace 4min
            str=[NSString stringWithFormat:@"Hace %.0fmin",minutes];
        }
        else if(hours!=0 && minutes==0)
        {
            // Hace 1hora
            str=[NSString stringWithFormat:@"Hace %.0fhora",minutes];
        }
        else
        {
            // Hace 7horas 23m
            str=[NSString stringWithFormat:@"Hace %dhoras %.0fm",hours,minutes];
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


-(NSString *)FormateCurrentDate_with_newFormate:(NSString *)dateFormatter
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:dateFormatter];
    return [df stringFromDate:self];
}
@end
