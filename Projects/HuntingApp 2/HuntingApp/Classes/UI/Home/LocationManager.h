//
//  LocationManager.h
//  HuntingApp
//
//  Created by Habib Ali on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>

@required

- (void)didTrackLocation;

@optional

- (void)failedToTrackLocation:(NSError *)error;

@end

@interface LocationManager : NSObject<CLLocationManagerDelegate,LocationManagerDelegate>
{
    BOOL locationServicesOn;
}

@property (retain, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) MKCoordinateRegion region;
@property (retain, nonatomic) CLGeocoder *geocoder;
@property (retain, nonatomic) NSMutableDictionary *locationDict;
@property(nonatomic,assign) id<LocationManagerDelegate> delegate;
@property (nonatomic) BOOL isLocationTracked;

- (void)trackLocation;

@end
