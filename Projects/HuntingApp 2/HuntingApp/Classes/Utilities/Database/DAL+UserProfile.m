//
//  DAL+UserProfile.m
//  HuntingApp
//
//  Created by Habib Ali on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAL+UserProfile.h"

@implementation DAL (UserProfile)

- (Profile *)makeNewUserProfile:(NSDictionary *)params
{
    NSManagedObjectContext *mObjectContext = nil;
    [self managedObjectContext:&mObjectContext];
    Profile *profile = nil;
    NSString *userID = [params objectForKey:PROFILE_USER_ID_KEY];
    NSString *email = [params objectForKey:PROFILE_EMAIL_KEY];
    NSString *phone = [params objectForKey:PROFILE_PHONE_KEY];
    NSString *userName = [params objectForKey:PROFILE_NAME_KEY];
    NSNumber *accType = [params objectForKey:PROFILE_ACCOUNT_TYPE_KEY];
    NSNumber *privacy = [params objectForKey:PROFILE_IS_PRIVATE_KEY]; 
    NSString *bio = [params objectForKey:PROFILE_BIO_KEY];
    NSString *preference = [params objectForKey:PROFILE_PREFERENCE_KEY];
    NSNumber *imgCount = [params objectForKey:PROFILE_IMAGE_COUNT_KEY];
    if (userID && email && phone && userName && accType)
    {
        @try {
            profile = [self getProfileByID:userID];
            
            if(!profile)
            {        
                profile = [NSEntityDescription insertNewObjectForEntityForName:PROFILE_ENTITY inManagedObjectContext:mObjectContext];
            }
            [profile setEmail:email];
            [profile setUser_id:userID];
            [profile setPhone:phone];
            [profile setName:userName];
            [profile setAccount_type:accType];
            [profile setBio:bio];
            [profile setPreference:preference];
            [profile setIs_private:privacy];
            [profile setImage_count:imgCount];
        }
        @catch (NSException *exception) 
        {
            DLog(@"%s: NSException %@",__func__,[exception description]);
        }
        @finally {
            if (![self saveContext])
                DLog(@"Context not saved");
        }
    }
    return profile;

}

- (Profile *)getProfileByID:(NSString *)ID
{
    Profile* profile = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:ID,PROFILE_USER_ID_KEY,nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        NSArray *array = [self fetchRecords:PROFILE_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
        
        if(array && [array count])
            profile = (Profile*) [array objectAtIndex:0];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return profile;
    }

}

- (NSInteger)getPicCountOfProfile:(NSString *)userID
{
    NSInteger picCount = 0;
    Profile *profile = [self getProfileByID:userID];
    if (profile)
    {
        for (Album *album in profile.albums) 
        {
            if (album.pictures)
                picCount = picCount + [album.pictures count];
        }
    }
    return picCount;
}

- (Profile *)addFollowing:(NSDictionary *)params inUserPofile:(NSString *)auserID
{
    Profile *userProfile = [self getProfileByID:auserID];
    NSManagedObjectContext *mObjectContext = nil;
    [self managedObjectContext:&mObjectContext];
    Profile *profile = nil;
    NSString *userID = [params objectForKey:PROFILE_USER_ID_KEY];
    NSString *userName = [params objectForKey:PROFILE_NAME_KEY];
    if (userID && userName && userProfile)
    {
        @try 
        {
            profile = [self getProfileByID:userID];
            if(!profile)
            {        
                profile = [NSEntityDescription insertNewObjectForEntityForName:PROFILE_ENTITY inManagedObjectContext:mObjectContext];
            }
            [profile setUser_id:userID];
            [profile setName:userName];
            [userProfile addFollowingObject:profile];
        }
        @catch (NSException *exception) 
        {
            DLog(@"%s: NSException %@",__func__,[exception description]);
        }
        @finally {
            if (![self saveContext])
                DLog(@"Context not saved");
        }
    }
    return profile;    
}

- (Profile *)addFollower:(NSDictionary *)params inUserPofile:(NSString *)auserID
{
    Profile *userProfile = [self getProfileByID:auserID];
    NSManagedObjectContext *mObjectContext = nil;
    [self managedObjectContext:&mObjectContext];
    Profile *profile = nil;
    NSString *userID = [params objectForKey:PROFILE_USER_ID_KEY];
    NSString *userName = [params objectForKey:PROFILE_NAME_KEY];
    if (userID && userName && userProfile)
    {
        @try 
        {
            profile = [self getProfileByID:userID];
            if(!profile)
            {        
                profile = [NSEntityDescription insertNewObjectForEntityForName:PROFILE_ENTITY inManagedObjectContext:mObjectContext];
            }
            [profile setUser_id:userID];
            [profile setName:userName];
            [userProfile addFollowersObject:profile];
        }
        @catch (NSException *exception) 
        {
            DLog(@"%s: NSException %@",__func__,[exception description]);
        }
        @finally {
            if (![self saveContext])
                DLog(@"Context not saved");
        }
    }
    return profile;    

}

- (NSArray *)getFollowersOfUserID:(NSString *)userID
{
    NSArray *followersArray = nil;
    Profile *profile = [self getProfileByID:userID];
    if (profile.followers)
    {
        NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:PROFILE_USER_ID_KEY ascending:YES] autorelease];
        NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
        followersArray = [profile.followers sortedArrayUsingDescriptors:sortDescriptors];
    }
    return followersArray;
}

- (NSArray *)getFollowingOfUserID:(NSString *)userID
{
    NSArray *followingArray = nil;
    Profile *profile = [self getProfileByID:userID];
    if (profile.following)
    {
        NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:PROFILE_USER_ID_KEY ascending:YES] autorelease];
        NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
        followingArray = [profile.following sortedArrayUsingDescriptors:sortDescriptors];
    }
    return followingArray;
}

- (NSInteger)getFollowersCountOfUserID:(NSString *)userID
{
    NSInteger count = 0;
    Profile *profile = [self getProfileByID:userID];
    if (profile.followers)
        count = [profile.followers count];
    return count;
}

- (NSInteger)getFollowingCountOfUserID:(NSString *)userID
{
    NSInteger count = 0;
    Profile *profile = [self getProfileByID:userID];
    if (profile.following)
        count = [profile.following count];
    return count;
}

- (NSArray *)getFavLocationsOfCurrentUser
{
    NSSortDescriptor * sortByID = [[[NSSortDescriptor alloc] initWithKey:LOCATION_ID_KEY ascending:NO] autorelease];
    NSArray * descriptors = [NSArray arrayWithObject:sortByID];
    NSArray *resultArray = [[[DAL sharedInstance]getProfileByID:[Utility userID]].favourite_locations sortedArrayUsingDescriptors:descriptors];
    return resultArray;
}

- (BOOL)isFollowing:(NSString *)userID;
{
    BOOL isFollowing = NO;
    NSArray *followerArray = [self getFollowingOfUserID:[Utility userID]];
    for (Profile *profile in followerArray)
    {
        if ([profile.user_id isEqualToString:userID])
        {
            isFollowing = YES;
            break;
        }
    }
    return isFollowing;
}
@end
