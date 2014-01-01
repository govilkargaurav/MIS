//
//  ReverseGeoCoder.h
//  LawyerApp
//
//  Created by ChintaN on 7/9/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h> 
#import "AppDelegate.h"
@interface ReverseGeoCoder : NSObject<CLLocationManagerDelegate>{

    CLLocationManager *locationManager;
    
}
@property (strong,nonatomic)NSString *strLocationCityName;
-(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude;
+(NSArray *)getLatLongOfUsersCurrentLocation:(id)sender;
+ (id)sharedManager;
@end
