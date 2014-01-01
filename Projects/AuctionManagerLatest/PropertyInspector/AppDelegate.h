//
//  AppDelegate.h
//  PropertyInspector
//
//  Created by apple on 10/15/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)UINavigationController *navigationController;
@property (strong, nonatomic) ViewController *viewController;

@end
