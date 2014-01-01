//
//  LocationTracker.h
//  HuntingApp
//
//  Created by Habib Ali on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationManager.h"

@interface LocationTracker : NSObject<LocationManagerDelegate>
{
    LocationManager *locationManager;
}

@property (nonatomic) BOOL isLocationTracked;

+ (LocationTracker *)sharedInstance;

- (void)trackLocation;

- (MKCoordinateRegion)getRegion;

- (NSDictionary *)getLocationDictionary;

@end
