//
//  WebServices+Album.m
//  HuntingApp
//
//  Created by Habib Ali on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebServices+Album.h"

@implementation WebServices (Album)

- (void)uploadImage:(NSDictionary *)params;
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
        
        [dict setObject:KWEB_SERVICE_ACTION_UPLOAD_IMAGE forKey:KWEB_SERVICE_ACTION];
        [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_TOKEN] forKey:LOGIN_TOKEN];
        [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:PROFILE_USER_ID_KEY] forKey:KWEB_SERVICE_USERID];
        
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }

}

- (void)getAllImagesOfUser:(NSString *)userID
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:KWEB_SERVICE_ACTION_VIEW_IMAGE forKey:KWEB_SERVICE_ACTION];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        if (userID && ![userID isEqualToString:[Utility userID]] && ![userID isEmptyString])
            [dict setObject:userID forKey:KWEB_SERVICE_FRIEND_ID];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }

}

- (void)getImage:(NSString *)imgID ofUser:(NSString *)userID
{
    if (userID)
    {
        if ([self isNetAvailable])
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:KWEB_SERVICE_ACTION_VIEW_IMAGE forKey:KWEB_SERVICE_ACTION];
            [dict setObject:imgID forKey:KWEB_SERVICE_IMAGE_ID];
            if (userID && ![userID isEqualToString:[Utility userID]] && ![userID isEmptyString])
                [dict setObject:userID forKey:KWEB_SERVICE_FRIEND_ID];
            [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
            [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
            [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
        }
        else {
            [self showNetworkError];
        }
    }

}

- (void)searchImageByValue:(NSString *)key andKey:(NSString *)keyword
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:key forKey:KWEB_SERVICE_SEARCH_VALUE];
        [dict setObject:keyword forKey:KWEB_SERVICE_SEARCH_BY];
        NSString *limit = @"20";
        if ([keyword isEqualToString:KWEB_SERVICE_ALBUM_DESCRIPTION])
            limit = @"100";
        [dict setObject:limit forKey:KWEB_SERVICE_SEARCH_LIMIT];
        [dict setObject:KWEB_SERVICE_ACTION_SEARCH_IMAGE forKey:KWEB_SERVICE_ACTION];
        
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }
}

- (void)likeImage:(NSString *)imgID
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:KWEB_SERVICE_ACTION_LIKE forKey:KWEB_SERVICE_ACTION];
        [dict setObject:imgID forKey:KWEB_SERVICE_ITEM_ID];
        [dict setObject:@"image" forKey:KWEB_SERVICE_COMPONENT];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }
}

- (void)commentImageByID:(NSString *)imgID andComment:(NSString *)comment
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:KWEB_SERVICE_ACTION_COMMENT forKey:KWEB_SERVICE_ACTION];
        [dict setObject:imgID forKey:KWEB_SERVICE_ITEM_ID];
        [dict setObject:@"image" forKey:KWEB_SERVICE_COMPONENT];
        [dict setObject:comment forKey:KWEB_SERVICE_CONTENT];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];      
    }
    else {
        [self showNetworkError];
    }

}
- (void)deleteImage:(NSString *)imgID
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:KWEB_SERVICE_ACTION_DELETE forKey:KWEB_SERVICE_ACTION];
        [dict setObject:imgID forKey:KWEB_SERVICE_IMAGE_ID];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }

}

- (void)deleteComment:(NSString *)commentID ofImageID:(NSString *)imgID
{
    if ([self isNetAvailable])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:KWEB_SERVICE_ACTION_DELETE forKey:KWEB_SERVICE_ACTION];
        [dict setObject:imgID forKey:KWEB_SERVICE_IMAGE_ID];
        [dict setObject:commentID forKey:KWEB_SERVICE_COMMENT_ID];
        [dict setObject:[Utility token] forKey:LOGIN_TOKEN];
        [dict setObject:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [self perfromAsyncPostRequestWithURL:@"" withParams:dict];   
    }
    else {
        [self showNetworkError];
    }

}
@end
