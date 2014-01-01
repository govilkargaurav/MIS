//
//  AppDelegate.h
//  SkyyApp
//
//  Created by Vishal Jani on 9/3/13.
//  Copyright (c) 2013 openxcell. All rights reserved.


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class InfoViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) InfoViewController *viewController;

@property(nonatomic,retain) UINavigationController *navController;

@property (nonatomic,retain) NSMutableArray *arrTrash;

@property (nonatomic,retain) NSMutableArray *arrInbox;

@property (nonatomic,retain) NSMutableArray *_toDoItems;

@property (nonatomic,retain) NSString *currentRightClass;

@property(nonatomic,retain) NSString *currentLeftClass;

@property(nonatomic,retain)NSData *currentDeviceToken;
@end
