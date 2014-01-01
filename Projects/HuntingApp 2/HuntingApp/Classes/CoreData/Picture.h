//
//  Picture.h
//  HuntingApp
//
//  Created by Habib Ali on 10/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album, Comment, ImageMap;

@interface Picture : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSNumber * comments_count;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSNumber * likes_count;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * pic_id;
@property (nonatomic, retain) NSString * user_desc;
@property (nonatomic, retain) Album *album;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) ImageMap *image;
@end

@interface Picture (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
