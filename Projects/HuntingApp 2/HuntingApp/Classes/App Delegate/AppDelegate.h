//
//  AppDelegate.h
//  HuntingApp
//
//  Created by Habib Ali on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSInteger previousViewControllerIndex;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

- (void) showCameraViewController;
- (void) setImagesOnTabbar;
- (void) gotoPreviousViewController;
- (void) createAlbums:(NSString *)userID;
- (void) logout;
- (void) gotoProfileView:(id)sender;
@end
