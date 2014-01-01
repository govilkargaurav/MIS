//
//  FeedComment.h
//  Suvi
//
//  Created by Vivek Rajput on 10/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedComment : NSObject

@property(nonatomic,copy)NSString *iAdminID;
@property(nonatomic,copy)NSString *iActivityID;

@property(nonatomic,copy)NSString *tsInsertDt;
@property(nonatomic,retain)NSDate *feedDate;

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *user;

@property (nonatomic, copy) NSString *admin_fname;
@property (nonatomic, copy) NSString *admin_lname;

@property (nonatomic, copy) NSString *bContent;
@property(nonatomic,copy)NSNumber *labelHeightComment;

@property(nonatomic,copy)NSString *imgURL;
@property(nonatomic,copy)NSString *Status;

@property(nonatomic,copy)NSString *unixTimeStamp;

@property(nonatomic,copy)NSString *viewWholeComment;

@end
