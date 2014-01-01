//
//  NotificationViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotificationPickerDelegate<NSObject>

- (void)notificationSelected:(NSObject *)notification;

@end


@interface NotificationViewController : UITableViewController
{
    NSArray *notArray; 
}


- (id)initWithStyle:(UITableViewStyle)style andItemsArray:(NSArray *)array;

- (id)initWithStyle:(UITableViewStyle)style andItemsArray:(NSArray *)array andNotificationsArray:(NSArray *)notArray;

@property (nonatomic, retain) NSMutableArray *itemsArray;
@property (nonatomic, assign) id<NotificationPickerDelegate> delegate;

@end