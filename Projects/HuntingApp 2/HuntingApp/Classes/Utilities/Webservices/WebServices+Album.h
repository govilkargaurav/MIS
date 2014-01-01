//
//  WebServices+Album.h
//  HuntingApp
//
//  Created by Habib Ali on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebServices.h"

@interface WebServices (Album)

- (void)uploadImage:(NSDictionary *)params;

- (void)getAllImagesOfUser:(NSString *)userID;

- (void)getImage:(NSString *)imgID ofUser:(NSString *)userID;

- (void)searchImageByValue:(NSString *)key andKey:(NSString *)keyword;

- (void)likeImage:(NSString *)imgID;

- (void)commentImageByID:(NSString *)imgID andComment:(NSString *)comment;

- (void)deleteImage:(NSString *)imgID;

- (void)deleteComment:(NSString *)commentID ofImageID:(NSString *)imgID;

@end
