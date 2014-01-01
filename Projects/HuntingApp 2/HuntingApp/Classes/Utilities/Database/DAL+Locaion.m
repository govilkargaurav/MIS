//
//  DAL+Locaion.m
//  HuntingApp
//
//  Created by Habib Ali on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAL+Locaion.h"

@implementation DAL (Locaion)

- (Location *)addFavLocToUserProfile:(NSDictionary *)params
{
    Location *userLocation = nil;
    NSManagedObjectContext *mObjectContext = nil;
    [self managedObjectContext:&mObjectContext];
    NSString *county = [params objectForKey:COUNTY_NAME_KEY];
    NSString *state = [params objectForKey:STATE_NAME_KEY];
    NSString *latitude = [params objectForKey:LOCATION_LATITUDE_KEY];
    NSString *longitude = [params objectForKey:LOCATION_LONGITUDE_KEY];
    NSString *userID = [params objectForKey:PROFILE_USER_ID_KEY];
    Profile *profile;
    if (userID && [userID isEqualToString:[Utility userID]])
        profile = [self getProfileByID:userID];
    if (state && county && latitude && longitude && profile)
    {
        @try {
            userLocation = [self getLocationByState:state andCounty:county];
            if(!userLocation)
            {        
                userLocation = [NSEntityDescription insertNewObjectForEntityForName:LOCATION_ENTITY inManagedObjectContext:mObjectContext];
            }
            if (![params objectForKey:LOCATION_ID_KEY])
                [userLocation setLoc_id:[NSString stringWithFormat:@"%@,%@,%@",userID,county,state]];
            else {
                [userLocation setLoc_id:[params objectForKey:LOCATION_ID_KEY]];
            }
            [userLocation setLatitude:latitude];
            [userLocation setLongitude:longitude];
            [userLocation setCounty:county];
            [userLocation setState:state];
            
            [profile addFavourite_locationsObject:userLocation];
            
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
    
    return userLocation;

}

- (Location *)getLocationByLocID:(id)locID
{
    Location* location = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:locID,LOCATION_ID_KEY,nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        NSArray *array = [self fetchRecords:LOCATION_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
        
        if([array count])
            location = (Location*) [array objectAtIndex:0];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return location;
    }
}


- (Location *)getLocationByState:(NSString *)state andCounty:(NSString *)county
{
    Location* location = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:state,LOCATION_STATE_KEY,county,LOCATION_COUNTY_KEY,[Utility userID],@"user_favourite_locations.user_id",nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        NSArray *array = [self fetchRecords:LOCATION_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
        
        if([array count])
            location = (Location*) [array objectAtIndex:0];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return location;
    }

}

- (Location *)getUserLocation:(NSDictionary *)params
{
    Location *userLocation = nil;
    NSManagedObjectContext *mObjectContext = nil;
    [self managedObjectContext:&mObjectContext];
    NSString *county = [params objectForKey:COUNTY_NAME_KEY];
    NSString *state = [params objectForKey:STATE_NAME_KEY];
    NSString *latitude = [params objectForKey:LOCATION_LATITUDE_KEY];
    NSString *longitude = [params objectForKey:LOCATION_LONGITUDE_KEY];
    if (latitude && longitude)
    {
        @try 
        {
            userLocation = [self getLocationByLocID:@"My Location"];
            if(!userLocation)
            {        
                userLocation = [NSEntityDescription insertNewObjectForEntityForName:LOCATION_ENTITY inManagedObjectContext:mObjectContext];
            }
            [userLocation setLoc_id:@"My Location"];
            [userLocation setLatitude:latitude];
            [userLocation setLongitude:longitude];
            [userLocation setCounty:county];
            [userLocation setState:state];
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
    
    return userLocation;
}

-(NSArray *)getCountiesFromState:(NSString *)state
{
    NSArray *fetchResults = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:state,LOCATION_STATE_KEY,nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        fetchResults = [self fetchRecords:LOCATION_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:LOCATION_COUNTY_KEY assending:YES propertiesToFetch:[NSArray arrayWithObjects:LOCATION_COUNTY_KEY, nil] InManageObjectContext:self.managedObjectContext distinctResults:YES];
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in fetchResults) 
        {
            [array addObject:[dict objectForKey:LOCATION_COUNTY_KEY]];
        }
        fetchResults = [NSArray arrayWithArray:array];
        
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return fetchResults;
    }
}

- (BOOL)isFavLocation:(NSString *)loc
{
    BOOL isFavLoc = NO;
    if (![loc isEmptyString])
    {
        NSString *county = [[loc componentsSeparatedByString:@";"] objectAtIndex:0];
        NSString *state = [[loc componentsSeparatedByString:@";"] lastObject];
        
        if ([[DAL sharedInstance] getLocationByState:state andCounty:county])
            isFavLoc = YES;
    }
    return isFavLoc;
}

@end
