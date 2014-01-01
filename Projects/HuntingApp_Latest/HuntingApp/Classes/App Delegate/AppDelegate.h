//
//  AppDelegate.h
//  HuntingApp
//
//  Created by Habib Ali on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"
#import "Picture.h"
#import "AlbumViewController.h"
#import "WebServices.h"
#import "DejalActivityView.h"
@protocol apppickerDelegate<NSObject>

- (void)notificationSelected:(NSObject *)notification;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,AlbumViewDelegate,RequestWrapperDelegate>
{
    NSInteger previousViewControllerIndex;
    Picture *selectedImage;
    WebServices *getNotificationsRequest;
    DejalActivityView *loadingActivityIndicator;
    NSMutableArray *notificationsArray;
    UIButton *btnClose;
    UIView *view;
}

@property (strong,nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, strong) NSMutableDictionary *_dictPushImage;
@property (nonatomic ,strong) NSMutableArray *arrayPostImageNotification;
@property (nonatomic,strong) NSString *strItemId;

- (void) showCameraViewController;
- (void) setImagesOnTabbar;
- (void) gotoPreviousViewController;
- (void) createAlbums:(NSString *)userID;
- (void) logout;
- (void) gotoProfileView:(id)sender;
@property (nonatomic, assign) id<apppickerDelegate> delegate;
@end
