//
//  GlobalMethods.h
//  OrganiseMee_iPhone
//
//  Created by Imac 2 on 3/14/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMethods : NSObject
{
    
    
}
// Get Contact Name
+(NSDictionary*)GetContactName:(NSString*)strAssignId TaskCategoryType:(NSString*)strType;
+(NSString*)GetStringDateWithFormate:(NSString*)strDate;
+(UIImage*)GetImagePriority:(NSString*)strPriority;
+(CGFloat)CheckIphoneAndReturnWidth:(CGFloat)Potraitewidth Landscap5:(CGFloat)LandWidthIp5 Landscap:(CGFloat)LandWidth Orientation:(int)OrientationValue;
+(BOOL)CheckReminderSetOrNot:(NSString*)strReminderId;
+(BOOL)CheckPhoneVersionisiOS7;
@end
