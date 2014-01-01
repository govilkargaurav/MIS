//
//  Location.h
//  HuntingApp
//
//  Created by Habib Ali on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Profile;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * county;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * loc_id;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) Profile *user_favourite_locations;

@end
