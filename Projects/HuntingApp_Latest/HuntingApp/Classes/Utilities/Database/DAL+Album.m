//
//  DAL+Album.m
//  HuntingApp
//
//  Created by Habib Ali on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAL+Album.h"

@implementation DAL (Album)

- (Album *)createAlbumWithParams:(NSDictionary *)params
{
    Album *album = nil;
    NSManagedObjectContext *mObjectContext = nil;
    [self managedObjectContext:&mObjectContext];
    NSString *albumID = [params objectForKey:ALBUM_ID_KEY];
    NSString *name = [params objectForKey:ALBUM_NAME_KEY];
    NSString *userID = [params objectForKey:PROFILE_USER_ID_KEY];
    Profile *profile = [self getProfileByID:userID];
    if (albumID && name && ![name isEmptyString] && profile)
    {
        @try {
            if (albumID && userID)
                album = [self getAlbumByAlbumID:albumID ofUser:userID];
            
            if(!album)
            {        
                album = [NSEntityDescription insertNewObjectForEntityForName:ALBUM_ENTITY inManagedObjectContext:mObjectContext];
            }
            [album setAlbum_id:albumID];
            [album setName:name];
            if ([params objectForKey:ALBUM_COVER_PHOTO_KEY])
                [album setCover_photo:[params objectForKey:ALBUM_COVER_PHOTO_KEY]];
            if ([params objectForKey:ALBUM_DESC_KEY])
                [album setDesc:[params objectForKey:ALBUM_DESC_KEY]];
            if ([params objectForKey:ALBUM_IS_PRIVATE_KEY])
                [album setIs_private:[params objectForKey:ALBUM_IS_PRIVATE_KEY]];
            [profile addAlbumsObject:album];
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

    return album;
}

- (Album *)getAlbumByAlbumID:(NSString *)albumID ofUser:(NSString *)userID
{
    Album *album = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:albumID,ALBUM_ID_KEY,userID,@"user_profile.user_id",nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        NSArray *array = [self fetchRecords:ALBUM_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
        
        if([array count])
            album = (Album*) [array objectAtIndex:0];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return album;
    }
}

- (NSArray *)getAllAlbumNamesAndID:(NSString *)userID
{
    NSArray *fetchResults = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:userID,@"user_profile.user_id",nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        fetchResults = [self fetchRecords:ALBUM_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:ALBUM_ID_KEY assending:YES propertiesToFetch:[NSArray arrayWithObjects:ALBUM_ID_KEY, ALBUM_NAME_KEY, nil] InManageObjectContext:self.managedObjectContext distinctResults:YES];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return fetchResults;
    }

}

- (NSString *)getAlbumIDFromAlbumName:(NSString *)albumName
{
    NSString *albumID = nil;
    Album *album = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:albumName,ALBUM_NAME_KEY,nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        NSArray *array = [self fetchRecords:ALBUM_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
        
        if([array count])
            album = (Album*) [array objectAtIndex:0];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        if (album)
            albumID = album.album_id;
        return albumID;
    }

}

@end
