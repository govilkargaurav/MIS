//
//  DAL+UserProfile.h
//  HuntingApp
//
//  Created by Habib Ali on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAL.h"

@interface DAL (UserProfile)

- (Profile *)makeNewUserProfile:(NSDictionary *)params;
- (Profile *)getProfileByID:(NSString *)ID;
- (NSInteger)getPicCountOfProfile:(NSString *)userID;
- (Profile *)addFollowing:(NSDictionary *)params inUserPofile:(NSString *)userID;
- (Profile *)addFollower:(NSDictionary *)params inUserPofile:(NSString *)userID;
- (NSArray *)getFollowersOfUserID:(NSString *)userID;
- (NSArray *)getFollowingOfUserID:(NSString *)userID;
- (NSInteger)getFollowersCountOfUserID:(NSString *)userID;
- (NSInteger)getFollowingCountOfUserID:(NSString *)userID;
- (NSArray *)getFavLocationsOfCurrentUser;
- (BOOL)isFollowing:(NSString *)userID;


@end
