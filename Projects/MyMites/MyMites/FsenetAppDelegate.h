//
//  FsenetAppDelegate.h
//  MyMites
//
//  Created by openxcell technolabs on 7/10/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface FsenetAppDelegate : UIResponder <UIApplicationDelegate>
{
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
- (BOOL) checkConnection;
@end
