//
//  SubclassInAppHelper.m
//  High Frequency Sight Words
//
//  Created by Pratik Mistry on 17/12/12.
//  Copyright (c) 2012 milind.shroff@spec-india.com. All rights reserved.
//

#import "SubclassInAppHelper.h"

#define InAppNonConsuable @"com.pianopass.Inappdistr"

@implementation SubclassInAppHelper

// Define product identifiers as constants and import your contatnt.h file here for better practice.

+ (SubclassInAppHelper *)sharedInstance {
    static dispatch_once_t once;
    static SubclassInAppHelper *sharedInstance;
    // This method will initialize the InAppHelper with required products.
    dispatch_once(&once, ^{
        // Specify your product identifiers into NSSet seperated by comma.
        NSSet *productIdentifiers = [NSSet setWithObjects:InAppNonConsuable,nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    
    return sharedInstance;
}

@end
