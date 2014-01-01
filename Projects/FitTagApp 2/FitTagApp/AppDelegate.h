//
//  AppDelegate.h
//  FitTagApp
//
//  Created by apple on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AZColoredNavigationBar.h"
#define PARSE_APPLICATION_ID @"hKGh23CMODBkyC2jJuAlUyGIiJLuW9s3oG8RfCS7"
#define PARSE_CLIENT_KEY @"XGCJbe7WUUW89OSt1FOe88BF3128T596M63stXPu"
//com.fittag.distr
#define FACEBOOKCLIENTID @"192915557527782"

#define TWITTER_CONSUMER_KEY @"PtcbOSPms9joshfYujVqQ"
#define TWITTER_CONSUMER_SECRET_KEY @"KQccLz9LCZBPc1agyeOuYK3ZwDcMIuz0g64n2iDk"

#define FB_PERMISSIONS [NSArray arrayWithObjects:@"user_about_me",@"email",@"user_photos",nil]

CLLocation *currentLocation;
#import "ChangeUserNameViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,changeUserName>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property(nonatomic,strong)NSData *dataDeviceToken;
@property (strong,nonatomic)NSMutableArray *arrUserLikeChallenge;
@property (strong,nonatomic)NSMutableArray *arrUserFirstChallenge;

@property (strong,nonatomic)NSMutableArray *arrCurrentUserChallegesData;
@property(nonatomic,readwrite) BOOL isTimeline;
@property(nonatomic,readwrite) BOOL isLaunchFromPushNotification;

// Image steps in create challenge step 2
@property (strong,nonatomic)NSMutableArray *mutArryChallengeStepsData;
@property (strong,nonatomic)NSMutableArray *mutArryChallengeImageData;
@property (strong,nonatomic)NSMutableDictionary *mutDictStepsText;
@property (nonatomic,assign)float richLabelHeight;
@property(nonatomic,retain)NSString *controllerName;
-(void)LoginTwitterUser;
-(void)configurePushNotificationSetting;

#pragma mark Remove Null

-(NSString *)removeNull:(NSString *)str;

@end
