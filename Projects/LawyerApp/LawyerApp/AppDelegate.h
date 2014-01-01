//
//  AppDelegate.h
//  LawyerApp
//
//  Created by Openxcell Game on 6/6/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DejalActivityView.h"
#import "MSNavigationPaneViewController.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>{
    
    
    
    
}

@property (nonatomic)int InternetConnectionFlag;

@property (strong, nonatomic)NSString *strCityName;

@property (strong, nonatomic)DejalActivityView *loadingActivityIndicator;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic)UINavigationController *navigationController;

@property (strong, nonatomic)CLLocationManager *locationManager;

@property (strong, nonatomic) MSNavigationPaneViewController *navigationPaneViewController;

@end
