//
//  Profile.h
//  HuntingApp
//
//  Created by Habib Ali on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album, Location, Profile;

@interface Profile : NSManagedObject

@property (nonatomic, retain) NSNumber * account_type;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * image_count;
@property (nonatomic, retain) NSNumber * is_private;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSString * preference;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSSet *albums;
@property (nonatomic, retain) NSSet *favourite_locations;
@property (nonatomic, retain) NSSet *followers;
@property (nonatomic, retain) NSSet *following;
@end

@interface Profile (CoreDataGeneratedAccessors)

- (void)addAlbumsObject:(Album *)value;
- (void)removeAlbumsObject:(Album *)value;
- (void)addAlbums:(NSSet *)values;
- (void)removeAlbums:(NSSet *)values;

- (void)addFavourite_locationsObject:(Location *)value;
- (void)removeFavourite_locationsObject:(Location *)value;
- (void)addFavourite_locations:(NSSet *)values;
- (void)removeFavourite_locations:(NSSet *)values;

- (void)addFollowersObject:(Profile *)value;
- (void)removeFollowersObject:(Profile *)value;
- (void)addFollowers:(NSSet *)values;
- (void)removeFollowers:(NSSet *)values;

- (void)addFollowingObject:(Profile *)value;
- (void)removeFollowingObject:(Profile *)value;
- (void)addFollowing:(NSSet *)values;
- (void)removeFollowing:(NSSet *)values;

@end
