//
//  ImageMap.h
//  HuntingApp
//
//  Created by Habib Ali on 10/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Picture;

@interface ImageMap : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *picture;
@end

@interface ImageMap (CoreDataGeneratedAccessors)

- (void)addPictureObject:(Picture *)value;
- (void)removePictureObject:(Picture *)value;
- (void)addPicture:(NSSet *)values;
- (void)removePicture:(NSSet *)values;

@end
