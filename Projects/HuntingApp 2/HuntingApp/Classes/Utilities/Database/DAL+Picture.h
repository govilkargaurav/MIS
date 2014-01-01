//
//  DAL+Picture.h
//  HuntingApp
//
//  Created by Habib Ali on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAL.h"

@interface DAL (Picture)

- (Picture *)createImageWithParams:(NSDictionary *)params;

- (Picture *)createOtherUserImageWithParams:(NSDictionary *)params;

- (Picture *)getImageByImageID:(NSString *)imageID;

- (Picture *)getImageByImageURL:(NSString *)URL;

- (Picture *)getImageByImageID:(NSString *)imageID ofAlbumID:(NSString *)albumid;

- (NSArray *)getAllImagesByPartialID:(NSString *)str;

- (NSArray *)getAllImagesOfAlbumID:(NSString *)albumID;

// used only by trending and timeline screens
- (NSArray *)getAllImagesByValue:(NSString *)keyword andKey:(NSString *)key;

- (NSArray *)getAllPicturesOfUser:(NSString *)userID;
@end
