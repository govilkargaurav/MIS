//
//  DAL+Notification.m
//  HuntingApp
//
//  Created by Habib Ali on 06/02/2013.
//
//

#import "DAL+Notification.h"

@implementation DAL (Notification)

- (Notification *)createNotificationWith:(NSDictionary *)params
{
    Notification *notification = nil;
    NSManagedObjectContext *mObjectContext = nil;
    [self managedObjectContext:&mObjectContext];
    NSString *date = [params objectForKey:NOTIFICATION_DATE_KEY];
    NSDate *notDate = [Utility getDateFromString:date];
    NSString *data = [params objectForKey:NOTIFICATION_DATA_KEY];
    data = [data stringByReplacingOccurrencesOfString:@"added" withString:@"has posted"];
    NSString *ID = [params objectForKey:NOTIFICATION_ID_KEY];
    NSNumber *isPicture = [params objectForKey:NOTIFICATION_IS_PICTURE_KEY];
    NSString *itemID = [params objectForKey:NOTIFICATION_ITEM_ID_KEY];
    if (date && data && ID && isPicture && itemID)
    {
        @try
        {
            notification = [self getNotificationByID:ID];
            if(!notification)
            {
                notification = [NSEntityDescription insertNewObjectForEntityForName:NOTIFICATION_ENTITY inManagedObjectContext:mObjectContext];
                [notification setIsRead:[NSNumber numberWithBool:NO]];
                [notification setNotDate:notDate];
            }
            [notification setNotID:ID];
            [notification setNotData:data];
            [notification setIsPicture:isPicture];
            [notification setNotItemID:itemID];
        }
        @catch (NSException *exception)
        {
            DLog(@"%s: NSException %@",__func__,[exception description]);
        }
        @finally {
            if (![self saveContext])
                DLog(@"Context not saved");
        }
    }
    
    return notification;
}

- (Notification *)getNotificationByID:(NSString *)ID
{
    Notification *notification = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:ID,NOTIFICATION_ID_KEY,nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        NSArray *array = [self fetchRecords:NOTIFICATION_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
        
        if([array count])
            notification = (Notification*) [array objectAtIndex:0];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return notification;
    }
    

}

- (NSArray *)getAllNotifications
{
    NSArray *notifications = nil;
    @try {
        notifications = [self fetchRecords:NOTIFICATION_ENTITY withPredicate:nil withFetchOffset:0 withFetchLimit:0 sortBy:NOTIFICATION_DATE_KEY assending:NO];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return notifications;
    }

}

@end
