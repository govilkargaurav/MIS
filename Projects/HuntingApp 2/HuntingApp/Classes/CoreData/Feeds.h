//
//  Feeds.h
//  HuntingApp
//
//  Created by Habib Ali on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Feeds : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * image_id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * tweet_id;
@property (nonatomic, retain) NSString * user_id;

@end
