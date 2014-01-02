//
//  SubclassInAppHelper.m
//  NewsStand
//
//  Created by openxcell technolabs on 4/17/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "SubclassInAppHelper.h"

@implementation SubclassInAppHelper

// Define product identifiers as constants and import your contatnt.h file here for better practice.
+ (SubclassInAppHelper *)sharedInstance
{
    static dispatch_once_t once;
    static SubclassInAppHelper *sharedInstance;
    dispatch_once(&once,
                  ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:@"com.njjn.2Month_WithDiscount",@"com.njjn.2Months",@"com.njjn.1Month_WithDiscount",@"com.njjn.1Month",@"com.njjn.7Days",nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
//com.dnps.single_issue
//Test
/*Test_DNPS_Consumable : com.DNPS.Test_Single_Issue
Test_DNPS_7Days      : com.DNPS.Test_7Days
Test_DNPS_1Month     : com.DNPS.Test_1Month
Test_DNPS_1Month_WithDiscount : com.DNPS.Test_1Month_WithDiscount
Test_DNPS_2Months    : com.DNPS.Test_2Months
Test_DNPS_2Months_WithDiscount : com.DNPS.Test_2Months_WithDiscount*/

//Live
/*  
    com.dnps.app_single_issue
    ccom.dnps.7Days
    com.dnps.1Month
    com.dnps.1Month_WithDiscount
    com.dnps.2Months
    com.dnps.2Month_WithDiscount

*/

