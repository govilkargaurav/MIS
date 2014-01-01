//
//  WebServices+UserProfile.m
//  HuntingApp
//
//  Created by Habib Ali on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
Create New User Account
Query Url:
http://theoutdoorloop.com/api/?
getUserProfileInfoByUserID
Strings:

action=newaccount
name=demo
email=demo@test.com (treated as unique key)
bio=write something about user
location =current location
phone=92000000
avatar=DP.png
preference=bird
passkey=password
type=account type e.g [facebook] | [twitter] leave blank for normal or set [normal]
privacy=[1] for private | (leave blank or set [0] for public access)
format=json (leave blank for XML)


e.g: (click to perform action) 

http://theoutdoorloop.com/api/?action=newaccount&name=demo&email=demo@test.com&bio=write something about user&location=current location&phone=92000000&avatar=DP.png&preference=bird&passkey=pass123&privacy=0&type=normal&format=json

Previous Result :
{"data":{"success":"Account Successfully Created","token":"sCT7RR0Er0jFluDAe2RsWBsrhwsQynuenCY5TV9AShD2PE2t6I","userid":"38","email":"demo1@test.com"}} 
*/

/*
 login User Account
 Query Url:
 http://theoutdoorloop.com/api/?
 
 Strings:
 
 action=login
 email=demo1@test.com
 passkey=pass123
 format=json (leave blank for XML)
 
 note: fresh token will generate every time on login
 
 e.g: (click to perform action) 
 
 http://theoutdoorloop.com/api/?action=login&email=demo1@test.com&passkey=pass123&format=json
 
 
 
 result: 
 {"data":[{"data":{"token":"rbnuOrrk7HlP50r60RK6ndkh5b7fNTo5sPp67Uf3bEGVCvP0CX","userid":"38"}}]} 
 */
 
#import "WebServices+UserProfile.h"

@implementation WebServices (UserProfile)

- (void)createUserProfile:(NSDictionary *)userInfo
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        [dict setObject:KWEB_SERVICE_ACTION_NEW_ACCOUNT forKey:KWEB_SERVICE_ACTION];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];
        
    }
    else {
        [self showNetworkError];
    }
}

- (void)logIn:(NSDictionary *)userInfo;
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        
        [dict setObject:KWEB_SERVICE_ACTION_LOGIN forKey:KWEB_SERVICE_ACTION];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }
}

- (void)getUserProfileInfoByUserID: (NSString *)userID
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary ];
        if (userID && ![userID isEqualToString:[Utility userID]] && ![userID isEmptyString])
            [dict setObject:userID forKey:KWEB_SERVICE_FRIEND_ID];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        
        [dict setObject:KWEB_SERVICE_ACTION_PROFILE forKey:KWEB_SERVICE_ACTION];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }

}

- (void)updateUserProfile:(NSDictionary *)userInfo
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [dict setObject:KWEB_SERVICE_FORMAT_JSON forKey:KWEB_SERVICE_FORMAT];
        [dict setObject:KWEB_SERVICE_ACTION_UPDATE_ACCOUNT forKey:KWEB_SERVICE_ACTION];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }
}

- (void)searchProfileBy:(NSString *)attribute andValue:(NSString *)value
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [dict setObject:KWEB_SERVICE_ACTION_SEARCH_FRIEND forKey:KWEB_SERVICE_ACTION];
        [dict setObject:attribute forKey:KWEB_SERVICE_SEARCH_BY];
        [dict setObject:value forKey:KWEB_SERVICE_SEARCH_VALUE];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }

}

- (void)followFriend:(NSString *)ID
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [dict setObject:KWEB_SERVICE_ACTION_FOLLOW_FRIEND forKey:KWEB_SERVICE_ACTION];
        [dict setObject:ID forKey:KWEB_SERVICE_FRIEND_ID];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }

}


- (void)unFollowFriend:(NSString *)ID
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [dict setObject:KWEB_SERVICE_ACTION_UNFOLLOW forKey:KWEB_SERVICE_ACTION];
        [dict setObject:ID forKey:KWEB_SERVICE_FRIEND_ID];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }
}

- (void)forgetPassword:(NSString *)email
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:KWEB_SERVICE_ACTION_FORGET forKey:KWEB_SERVICE_ACTION];
        [dict setObject:email forKey:KWEB_SERVICE_EMAIL];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }

}


- (void)getAllNotifications
{  
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:KWEB_SERVICE_ACTION_NOTIFICATIONS forKey:KWEB_SERVICE_ACTION];
        [dict setObject:@"10" forKey:KWEB_SERVICE_SEARCH_LIMIT];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }

}



- (void)pushAlerts:(NSDictionary *)userInfo
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        [dict setObject:@"change_notification_status" forKey:KWEB_SERVICE_ACTION];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];
    }
    else {
        [self showNetworkError];
    }
}


@end
