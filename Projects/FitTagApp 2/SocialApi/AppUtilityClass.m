//
//  AppUtilityClass.m
//  LogInAndSignUpDemo
//
//  Created by Apple on 2/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppUtilityClass.h"

@implementation AppUtilityClass


+(BOOL)Array:(NSMutableArray *)sourceAtrray containsObject:(id)object{
    
    NSMutableSet* existingNames = [NSMutableSet set];
    for (id object in sourceAtrray) {
        if (![existingNames containsObject:[object name]]) {
            [existingNames addObject:[object name]];
            return TRUE;
        }
    }
    return FALSE;
}


+(NSMutableDictionary *)DictionaryFromNSData:(NSData *)ServiceResponseData{
    
    
    NSString *responseString = [[NSString alloc] initWithData:ServiceResponseData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *response;
    NSError *error = nil;
#if defined(__IPHONE_5_0) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
    response = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
#elif defined(__IPHONE_5_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    if ([NSJSONSerialization class]) {
        response = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    } else {
#if defined(BZ_USE_JSONKIT)
        JSONDecoder *decoder = [JSONDecoder decoder];
        response = [decoder objectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] error:&error];
#elif defined(BZ_USE_SBJSON)
        SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
        response = [parser objectWithString:responseString error:&error];
#else
#error BZ_USE_* must be defined
#endif
    }
#else
#if defined(BZ_USE_JSONKIT)
    JSONDecoder *decoder = [JSONDecoder decoder];
    response = [decoder objectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] error:&error];
#elif defined(BZ_USE_SBJSON)
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    response = [parser objectWithString:responseString error:&error];
#else
#error BZ_USE_* must be defined
#endif
#endif
    
    
    if (error) {
        //if ([delegate_ respondsToSelector:@selector(request:didFailWithError:)]) {
        //    [delegate_ request:self didFailWithError:error];
        //}
        return nil;
    } else {
        return response;
        //if ([delegate_ respondsToSelector:@selector(requestDidFinishLoading:)]) {
        //    [delegate_ requestDidFinishLoading:self];
        //}
    }
}
@end
