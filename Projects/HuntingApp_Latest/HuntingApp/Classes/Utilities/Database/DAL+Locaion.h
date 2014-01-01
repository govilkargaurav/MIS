//
//  DAL+Locaion.h
//  HuntingApp
//
//  Created by Habib Ali on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAL.h"

@interface DAL (Locaion)

- (Location *)addFavLocToUserProfile:(NSDictionary *)params;

- (Location *)getLocationByLocID:(NSString *)locID;

- (Location *)getLocationByState:(NSString *)state andCounty:(NSString *)country;

- (Location *)getUserLocation:(NSDictionary *)params;

- (NSArray *)getCountiesFromState:(NSString *)state;

- (BOOL)isFavLocation:(NSString *)loc;

@end
