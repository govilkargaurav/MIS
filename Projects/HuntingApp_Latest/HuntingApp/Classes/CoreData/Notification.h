//
//  Notification.h
//  HuntingApp
//
//  Created by Habib Ali on 06/02/2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notification : NSManagedObject

@property (nonatomic, retain) NSNumber * isPicture;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * notData;
@property (nonatomic, retain) NSDate * notDate;
@property (nonatomic, retain) NSString * notID;
@property (nonatomic, retain) NSString * notItemID;

@end
