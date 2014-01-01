//
//  WebServices+Location.h
//  HuntingApp
//
//  Created by Habib Ali on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebServices.h"

@interface WebServices (Location)

- (void)getLatLongForLocation:(NSString *)location;

- (void)addFavLoc:(NSDictionary *)params;

- (void)deleteFavLoc:(NSString *)locID;

- (void)getLocationByTitle:(NSString *)title;

@end
