//
//  DAL+Picture.m
//  HuntingApp
//
//  Created by Habib Ali on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAL+Picture.h"


@implementation DAL (Picture)

- (Picture *)createImageWithParams:(NSDictionary *)params
{
    Picture *image = nil;
    NSManagedObjectContext *mObjectContext = nil;
    [self managedObjectContext:&mObjectContext];
    NSString *albumID = [params objectForKey:ALBUM_ID_KEY];
    NSString *caption = [params objectForKey:PICTURE_CAPTION_KEY];
    NSString *picID = [params objectForKey:PICTURE_ID_KEY];
    NSNumber *likesCount = [params objectForKey:PICTURE_LIKES_COUNT_KEY];
    NSNumber *commentsCount = [params objectForKey:PICTURE_COMMENT_COUNT_KEY];
    NSString *imageURL = [params objectForKey:PICTURE_IMAGE_URL_KEY];
    Album *album = nil;
    if (albumID && [params objectForKey:PROFILE_USER_ID_KEY])
        album = [self getAlbumByAlbumID:albumID ofUser:[params objectForKey:PROFILE_USER_ID_KEY]];
    
    if (album  && picID)
    {
        @try 
        {
            image = [self getImageByImageID:picID];
            if(!image)
            {        
                image = [NSEntityDescription insertNewObjectForEntityForName:PICTURE_ENTITY inManagedObjectContext:mObjectContext];
            }
            if (caption)
                [image setCaption:caption];
            [image setPic_id:picID];
            [image setDesc:album.name];
            if (imageURL)
                [image setImage_url:imageURL];
            if ([params objectForKey:PICTURE_LOCATION_KEY])
                [image setLocation:[params objectForKey:PICTURE_LOCATION_KEY]];
            if (likesCount)
                [image setLikes_count:likesCount];
            if (commentsCount)
                [image setComments_count:commentsCount];
            [album addPicturesObject:image];
        
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

    return image;
}

- (Picture *)createOtherUserImageWithParams:(NSDictionary *)params
{
    //DLog(@"%@",[params description]);
    Picture *image = nil;
    NSManagedObjectContext *mObjectContext = nil;
    [self managedObjectContext:&mObjectContext];
    NSString *desc = [params objectForKey:PICTURE_DESC_KEY];
    NSString *caption = [params objectForKey:PICTURE_CAPTION_KEY];
    NSString *picID = [params objectForKey:PICTURE_ID_KEY];
    NSNumber *likesCount = [params objectForKey:PICTURE_LIKES_COUNT_KEY];
    NSNumber *commentsCount = [params objectForKey:PICTURE_COMMENT_COUNT_KEY];
    NSString *imageURL = [params objectForKey:PICTURE_IMAGE_URL_KEY];
    NSString *userInfo = [params objectForKey:PICTURE_USER_DESC_KEY];
    if (picID)
    {
        @try 
        {
            image = [self getImageByImageID:picID];
            if (image)
            {
                if (image.image_url)
                {
                    if ([params objectForKey:PICTURE_IMAGE_URL_KEY] && ![image.image_url isEqualToString:[params objectForKey:PICTURE_IMAGE_URL_KEY]])
                    {
                        [image setImage:nil];
                        [image setImage:[[DAL sharedInstance] getImageMapByURL:[params objectForKey:PICTURE_IMAGE_URL_KEY]]];
                        [image setComments:nil];
                        [image setComments_count:[NSNumber numberWithInt:0]];
                        [image setLikes_count:[NSNumber numberWithInt:0]];
                    }
                }
            }
            if(!image)
            {        
                image = [NSEntityDescription insertNewObjectForEntityForName:PICTURE_ENTITY inManagedObjectContext:mObjectContext];
            }
            if (caption)
            {
                if (!image.caption || ![caption isEmptyString])
                    [image setCaption:caption];
            }
            [image setPic_id:picID];
            if (imageURL)
                [image setImage_url:imageURL];

            if ([params objectForKey:PICTURE_LOCATION_KEY])
                [image setLocation:[params objectForKey:PICTURE_LOCATION_KEY]];
            if (desc)
                [image setDesc:desc];
            if (likesCount)
                [image setLikes_count:likesCount];
            if (commentsCount)
                [image setComments_count:commentsCount];
            if (userInfo)
                [image setUser_desc:userInfo];
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
    
    return image;

}

- (Picture *)getImageByImageID:(NSString *)imageID
{
    Picture *image = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:imageID,PICTURE_ID_KEY,nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        NSArray *array = [self fetchRecords:PICTURE_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
        
        if([array count])
            image = (Picture*) [array objectAtIndex:0];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return image;
    }
}

- (Picture *)getImageByImageURL:(NSString *)URL
{
    Picture *image = nil;
    @try {
        DLog(@"%@",URL);
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:URL,PICTURE_IMAGE_URL_KEY,nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        NSArray *array = [self fetchRecords:PICTURE_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
        
        if([array count])
            image = (Picture*) [array objectAtIndex:0];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return image;
    }

}

- (Picture *)getImageByImageID:(NSString *)imageID ofAlbumID:(NSString *)albumid
{
    Picture *image = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:imageID,PICTURE_ID_KEY,albumid,@"album.album_id",nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        NSArray *array = [self fetchRecords:PICTURE_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
        
        if([array count])
            image = (Picture*) [array objectAtIndex:0];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return image;
    }
}

- (NSArray *)getAllImagesOfAlbumID:(NSString *)albumID
{
    NSArray *images = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:albumID,@"album.album_id",nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        images = [self fetchRecords:PICTURE_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return images;
    }
}

- (NSArray *)getAllImagesByValue:(NSString *)keyword andKey:(NSString *)key
{
    NSArray *images = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:keyword,key,[NSNull null],@"album",nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        images = [self fetchRecords:PICTURE_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return images;
    }

}

- (NSArray *)getAllImagesByPartialID:(NSString *)str
{
    
    NSArray *images = nil;
    @try {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.pic_id CONTAINS[cd] %@", str];;
        
        images = [self fetchRecords:PICTURE_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:PICTURE_IMAGE_URL_KEY assending:NO];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return images;
    }

}

- (NSArray *)getAllPicturesOfUser:(NSString *)userID
{
    NSArray *picturesArray = nil;
    @try 
    {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:userID,@"album.user_profile.user_id",nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        picturesArray = [self fetchRecords:PICTURE_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:PICTURE_ID_KEY assending:NO];
    }
    @catch (NSException *exception) 
    {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally 
    {
        return picturesArray; 
    }
}



@end
