//
//  InfoViewController.h
//  PropertyInspector
//
//  Created by apple on 10/19/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DatabaseBean.h"
@interface InfoViewController : UIViewController
@property(nonatomic,strong)NSString *countyName;
@property(nonatomic,strong)NSString *latitudeStr;
@property(nonatomic,strong)NSString *longitudeStr;
@property(nonatomic,strong)NSString *countyID;
@property(nonatomic,strong)DatabaseBean *bean;
@end
