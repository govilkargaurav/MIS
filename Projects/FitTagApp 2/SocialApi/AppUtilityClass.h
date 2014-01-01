//
//  AppUtilityClass.h
//  LogInAndSignUpDemo
//
//  Created by Apple on 2/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtilityClass : NSObject
+(BOOL)Array:(NSMutableArray *)sourceAtrray containsObject:(id)object;
+(NSMutableDictionary *)DictionaryFromNSData:(NSData *)ServiceResponseData;
@end
