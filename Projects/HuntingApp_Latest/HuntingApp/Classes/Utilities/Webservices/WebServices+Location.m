//
//  WebServices+Location.m
//  HuntingApp
//
//  Created by Habib Ali on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebServices+Location.h"

@implementation WebServices (Location)


- (void)getLatLongForLocation:(NSString *)location
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSString *state = [[location componentsSeparatedByString:@";"] objectAtIndex:1];
        NSString *county;
        county = [[location componentsSeparatedByString:@";"] objectAtIndex:0];
        NSArray *countyList = [Utility getAllCountiesListOfState:state];
        if (![countyList containsObject:county])
            county = [countyList objectAtIndex:0];
        else 
        {
            if ([state isEqualToString:@"AK"])
                county = [[location componentsSeparatedByString:@";"] objectAtIndex:0];
            else {
                county = [NSString stringWithFormat:@"%@+County",[[location componentsSeparatedByString:@";"] objectAtIndex:0]];
            }
        }
        
        location = [NSString stringWithFormat:@"%@+%@",county,state];
        location = [location stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [dict setObject:location forKey:KGOOGLE_API_ADDRESS];
        [dict setObject:@"false" forKey:KGOOGLE_API_SENSOR];
        [self setTagAction:[NSString stringWithString:KWEB_SERVICE_ACTION_FIND_LOCATION]];
        if (requestWrapper)
        {
            [requestWrapper setDelegate:nil];
            RELEASE_SAFELY(requestWrapper);
        }
        requestWrapper = [[RequestWrapper alloc]initWithThirdPartyServer];
        [requestWrapper setDelegate:self];
        [requestWrapper perfromAsyncGetRequestWithURL:kGoogleApiUri withParams:dict];  
    }
    else {
        [self showNetworkError];
    }

}

- (void)addFavLoc:(NSDictionary *)params
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
        [dict setObject:KWEB_SERVICE_ACTION_FAV_LOCATION forKey:KWEB_SERVICE_ACTION];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }

}

- (void)deleteFavLoc:(NSString *)locID
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:KWEB_SERVICE_ACTION_DELETE forKey:KWEB_SERVICE_ACTION];
        [dict setObject:locID forKey:KWEB_SERVICE_LOCATION_ID];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }
    
}

- (void)getLocationByTitle:(NSString *)title
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:KWEB_SERVICE_ACTION_GET_LOCATION forKey:KWEB_SERVICE_ACTION];
        [dict setObject:title forKey:@"location_title"];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }

}

@end
