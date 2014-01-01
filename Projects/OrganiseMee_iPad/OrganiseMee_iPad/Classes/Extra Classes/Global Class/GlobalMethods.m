//
//  GlobalMethods.m
//  OrganiseMee_iPhone
//
//  Created by Imac 2 on 3/14/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "GlobalMethods.h"
#import "DatabaseAccess.h"

@implementation GlobalMethods

+(NSDictionary*)GetContactName:(NSString*)strAssignId TaskCategoryType:(NSString*)strType
{
    NSString *strResponsible;
    UIColor *lblColor;
    NSString *UserIntValue,*DeleteValue,*ArchieveValue,*MessageValue,*CallBackValue,*GiveBackValue;
    
    // Get Own Contact From Local DB
    if ([strAssignId isEqualToString:@"0"])
    {
        strResponsible = @"You";
        lblColor = [UIColor blackColor];
        UserIntValue = MessageValue = CallBackValue = GiveBackValue = @"YES";
        DeleteValue = ArchieveValue = @"NO";
    }
    else
    {
        NSMutableArray *ArryContact;
        NSString *strQuerySelectOwn = [NSString stringWithFormat:@"SELECT * FROM tbl_own_contact where contactid=%d",[strAssignId intValue]];
        ArryContact = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_own_contact:strQuerySelectOwn]];
        
        NSString *strAssignedToYouFlag = @"NO";
        // Get Org Contact From Local DB
        if ([ArryContact count] == 0)
        {
            NSString *strQuerySelectOrg = [NSString stringWithFormat:@"SELECT * FROM tbl_org_contact where contactRequestId=%d",[strAssignId intValue]];
            ArryContact = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_org_contact:strQuerySelectOrg]];
            
            if ([strType isEqualToString:@"INBOX_ACCEPTED"])
            {
                lblColor = [UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0];
                strAssignedToYouFlag = @"YES";
                UserIntValue = MessageValue = GiveBackValue = @"NO";
                DeleteValue = ArchieveValue = CallBackValue = @"YES";
            }
            else
            {
                lblColor = [UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0];
                UserIntValue = MessageValue = CallBackValue = @"NO";
                DeleteValue = ArchieveValue = GiveBackValue = @"YES";
            }
        }
        else
        {
            lblColor = [UIColor blackColor];
            UserIntValue = MessageValue = CallBackValue = GiveBackValue = @"YES";
            DeleteValue = ArchieveValue = @"NO";
        }
        if ([ArryContact count] > 0)
        {
            NSString *strFName = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryContact objectAtIndex:0] valueForKey:@"firstName"]]];
            NSString *strLName = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryContact objectAtIndex:0] valueForKey:@"lastName"]]];
            if ([strAssignedToYouFlag isEqualToString:@"YES"])
            {
                strResponsible = [NSString stringWithFormat:@"You From %@ %@",strFName,strLName];
            }
            else
            {
                strResponsible = [NSString stringWithFormat:@"%@ %@",strFName,strLName];
            }
        }
        else
        {
            strResponsible = @"";
            lblColor = [UIColor blackColor];
            UserIntValue = MessageValue = CallBackValue = GiveBackValue = @"YES";
            DeleteValue = ArchieveValue = @"NO";
        }
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strResponsible,@"Responsible",lblColor,@"Color",UserIntValue,@"BtnUserInt",DeleteValue,@"Delete",ArchieveValue,@"Archieve",MessageValue,@"Message",CallBackValue,@"CallBack",GiveBackValue,@"GiveBack", nil];
    return dic;
}
+(NSString*)GetStringDateWithFormate:(NSString*)strDate
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *Duedate = [format dateFromString:strDate];
    NSString *strDateFormate = [[NSUserDefaults standardUserDefaults] stringForKey:@"DateSetting"];
    if ([strDateFormate intValue] == 0)
    {
        [format setDateFormat:@"dd.MM"];
    }
    else
    {
        [format setDateFormat:@"MM/dd"];
    }
    NSString *d = [format stringFromDate:Duedate];
    return d;
}
+(UIImage*)GetImagePriority:(NSString*)strPriority
{
    UIImage *imgPriority;
    if ([strPriority intValue] == 0)
    {
        imgPriority = [UIImage imageNamed:@"star_low.png"];
    }
    else if ([strPriority intValue] == 1)
    {
        imgPriority = [UIImage imageNamed:@"star_med.png"];
    }
    else if ([strPriority intValue] == 2)
    {
        imgPriority = [UIImage imageNamed:@"star_high.png"];
    }
    return imgPriority;
}

+(CGFloat)CheckIphoneAndReturnWidth:(CGFloat)Potraitewidth Landscap5:(CGFloat)LandWidthIp5 Landscap:(CGFloat)LandWidth Orientation:(int)OrientationValue
{
    CGFloat width;
    if (OrientationValue == 0)
    {
        width = Potraitewidth;
    }
    else
    {
        width = LandWidth;
    }
    return width;
}

+(BOOL)CheckReminderSetOrNot:(NSString*)strReminderId
{
    NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_reminders where reminderId=%d",[strReminderId intValue]];
    NSMutableArray *Arry_Reminder = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_standerd_reminder:strQuerySelect]];
    
    if ([Arry_Reminder count] == 0)
    {
        return NO;
    }
    else
    {
        NSString *strhr1 = [self removeNull:[[Arry_Reminder objectAtIndex:0]valueForKey:@"beforeDuedateTime1"]];
        NSString *strhr2 = [self removeNull:[[Arry_Reminder objectAtIndex:0]valueForKey:@"beforeDuedateTime2"]];
        NSString *strhr3 = [self removeNull:[[Arry_Reminder objectAtIndex:0]valueForKey:@"beforeDuedateTime3"]];
        NSString *strhr4 = [self removeNull:[[Arry_Reminder objectAtIndex:0]valueForKey:@"onDuedateTime1"]];
        NSString *strhr5 = [self removeNull:[[Arry_Reminder objectAtIndex:0]valueForKey:@"onDuedateTime2"]];
        NSString *strhr6 = [self removeNull:[[Arry_Reminder objectAtIndex:0]valueForKey:@"onDuedateTime3"]];

        if ([strhr1 length] == 0 && [strhr2 length] == 0 && [strhr3 length] == 0 && [strhr4 length] == 0 && [strhr5 length] == 0 && [strhr6 length] == 0)
            return NO;
        else
            return YES;
    }
    return NO;
}
+(BOOL)CheckMessageExistOrNot:(NSString*)strTaskId CatType:(NSString*)strType
{
    NSString *strQuerySelect = @"SELECT * FROM tbl_messages";
    NSMutableArray *Arry_Messages = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_messages:strQuerySelect]];
    
    if (Arry_Messages.count > 0)
    {
        if ([[Arry_Messages valueForKey:@"taskId"] containsObject:strTaskId])
        {
            if (![strType isEqualToString:@"GENEREL"])
            {
                return YES;
            }
        }
    }
    return NO;
}

+(NSString*)GetMessagesFromTaskId:(NSString*)strTaskId
{
    NSString *strQuerySelect = [NSString stringWithFormat:@"SELECT * FROM tbl_messages Where taskId=%d",[strTaskId intValue]];
    NSMutableArray *Arry_Messages = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_messages:strQuerySelect]];
    
    //Send Data Of user setting from local databse
    NSString *strQuerySelectSetting = @"SELECT * FROM tbl_user_setting";
    NSMutableArray *ArryretriveUserSettings = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_user_setting:strQuerySelectSetting]];
    
    NSString *strMessage = @"";
    
    for (int i = 0; i < [Arry_Messages count]; i++)
    {
        if ([[[Arry_Messages objectAtIndex:i] valueForKey:@"senderId"] isEqualToString:[NSString stringWithFormat:@"%@",[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"profileId"]]])
        {
            NSString *strAppend =  [NSString stringWithFormat:@"Me : %@",[[Arry_Messages objectAtIndex:i] valueForKey:@"messageDescription"]];
            strMessage = [strMessage stringByAppendingFormat:@"\n%@",strAppend];
        }
        else
        {
            NSString *strContactName = [self GetContactNameOnly:[[Arry_Messages objectAtIndex:i] valueForKey:@"senderId"]];
            NSString *strAppend =  [NSString stringWithFormat:@"%@ : %@",strContactName,[[Arry_Messages objectAtIndex:i] valueForKey:@"messageDescription"]];
            strMessage = [strMessage stringByAppendingFormat:@"\n%@",strAppend];
        }
    }
    
    strMessage = [strMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return strMessage;
}
+(NSString*)GetContactNameOnly:(NSString*)strID
{
    NSString *strResponsible;
    
    NSMutableArray *ArryContact;
    NSString *strQuerySelectOrg = [NSString stringWithFormat:@"SELECT * FROM tbl_org_contact where senderId=%d or receiverId=%d",[strID intValue],[strID intValue]];
    ArryContact = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_org_contact:strQuerySelectOrg]];
    
    if ([ArryContact count] > 0)
    {
        NSString *strFName = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryContact objectAtIndex:0] valueForKey:@"firstName"]]];
        NSString *strLName = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryContact objectAtIndex:0] valueForKey:@"lastName"]]];
        strResponsible = [NSString stringWithFormat:@"%@ %@",strFName,strLName];
    }

    return strResponsible;
}

#pragma mark - Remove Null
+(NSString *)removeNull:(NSString *)str
{
    if (!str || [str isEqualToString:@"<null>"] || [str isEqualToString:@"(null)"])
    {
        return @"";
    }
    else
    {
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}
@end
