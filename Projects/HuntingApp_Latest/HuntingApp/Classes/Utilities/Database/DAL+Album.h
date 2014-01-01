//
//  DAL+Album.h
//  HuntingApp
//
//  Created by Habib Ali on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAL.h"

@interface DAL (Album)

- (Album *)createAlbumWithParams:(NSDictionary *)params;

- (Album *)getAlbumByAlbumID:(NSString *)albumID ofUser:(NSString *)userID;

- (NSArray *)getAllAlbumNamesAndID:(NSString *)userID;

- (NSString *)getAlbumIDFromAlbumName:(NSString *)albumName;

@end
