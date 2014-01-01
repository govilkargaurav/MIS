//
//  Comment.h
//  HuntingApp
//
//  Created by Habib Ali on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Picture;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSNumber * comment_id;
@property (nonatomic, retain) Picture *picture;

@end
