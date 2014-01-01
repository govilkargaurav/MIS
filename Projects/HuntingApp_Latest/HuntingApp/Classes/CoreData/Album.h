//
//  Album.h
//  HuntingApp
//
//  Created by Habib Ali on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Picture, Profile;

@interface Album : NSManagedObject

@property (nonatomic, retain) NSString * album_id;
@property (nonatomic, retain) NSString * cover_photo;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * is_private;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *pictures;
@property (nonatomic, retain) Profile *user_profile;
@end

@interface Album (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(Picture *)value;
- (void)removePicturesObject:(Picture *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

@end
