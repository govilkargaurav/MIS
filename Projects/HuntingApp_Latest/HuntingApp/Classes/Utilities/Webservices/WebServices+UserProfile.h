//
//  WebServices+UserProfile.h
//  HuntingApp
//
//  Created by Habib Ali on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebServices.h"

@interface WebServices (UserProfile)

- (void)createUserProfile:(NSDictionary *)userInfo;
- (void)logIn:(NSDictionary *)userInfo;
- (void)getUserProfileInfoByUserID: (NSString *)userID;
- (void)updateUserProfile:(NSDictionary *)userInfo;
- (void)searchProfileBy:(NSString *)attribute andValue:(NSString *)value;
- (void)followFriend:(NSString *)ID;
- (void)unFollowFriend:(NSString *)ID;
- (void)forgetPassword:(NSString *)email;
- (void)getAllNotifications;
- (void)pushAlerts:(NSDictionary *)userInfo;
@end
