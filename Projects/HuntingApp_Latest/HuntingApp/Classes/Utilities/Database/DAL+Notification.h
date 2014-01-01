//
//  DAL+Notification.h
//  HuntingApp
//
//  Created by Habib Ali on 06/02/2013.
//
//

#import "DAL.h"

@interface DAL (Notification)

- (Notification *)createNotificationWith:(NSDictionary *)params;

- (Notification *)getNotificationByID:(NSString *)ID;

- (NSArray *)getAllNotifications;

@end
