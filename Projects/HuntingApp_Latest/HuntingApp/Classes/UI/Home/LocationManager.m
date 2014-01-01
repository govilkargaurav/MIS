//
//  LocationManager.m
//  HuntingApp
//
//  Created by Habib Ali on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationManager.h"


@interface LocationManager(Private)

- (void)geocoderStartDetermineLocation:(CLLocation *)location;

@end

@implementation LocationManager

@synthesize locationManager,region,geocoder,locationDict,delegate,isLocationTracked;

-(id) init {
    
    self = [super init];
    if (self ) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager setDelegate:self];
        region = (MKCoordinateRegion){{0.0,0.0},{0.0,0.0}};
        self.geocoder = [[CLGeocoder alloc]init];
        self.locationDict = [[NSMutableDictionary alloc]init];
        self.isLocationTracked = NO;
    }
    return self;
}

-(void) dealloc
{
    DLog(@"Deallocating");
    self.delegate = nil;
    RELEASE_SAFELY(self.locationDict);
    RELEASE_SAFELY(self.locationManager);
    RELEASE_SAFELY(self.geocoder);
    [super dealloc];
}

- (void) setlocationServicesOn:(BOOL)serviceState
{
    locationServicesOn = serviceState;
}

- (void)trackLocation
{
    self.isLocationTracked = NO;
    //[locationManager stopUpdatingLocation];
    [self.locationDict removeAllObjects];
    [self setlocationServicesOn:[CLLocationManager locationServicesEnabled]];
    [self.locationManager startUpdatingLocation];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


# pragma mark
# pragma CLLocation manager delegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;
{
    DLog(@"Tracking Location....");
    CLLocationDistance distanceChange = [newLocation distanceFromLocation:oldLocation];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //[self.locationManager stopUpdatingLocation];
    if (distanceChange > 3000 || [self.locationDict count]==0)
    {        
        self.isLocationTracked =NO;
        [self geocoderStartDetermineLocation:newLocation];
        
        region.center.latitude = self.locationManager.location.coordinate.latitude;
        region.center.longitude = self.locationManager.location.coordinate.longitude;
        region.span.longitudeDelta = 0.007f;
        region.span.latitudeDelta = 0.007f;
    }
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{ 
    self.isLocationTracked = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //[self.locationManager stopUpdatingLocation];
    
    BlackAlertView *alertLocationUnknown;
    
    if([error domain] == kCLErrorDomain){ //handle core location errors
        switch ([error code]) {
            case kCLErrorLocationUnknown:
            {
                alertLocationUnknown = [[BlackAlertView alloc] initWithTitle:@"Network Error" message:@"Can't track location" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alertLocationUnknown show];
                [alertLocationUnknown release];
                [self failedToTrackLocation:error];
            }
                break;
                
            case kCLErrorDenied:
                if (locationServicesOn)
                {
                    [self failedToTrackLocation:error];
                    
                }
                else
                {  
                    if( ! [CLLocationManager locationServicesEnabled] )
                    {
                        [self failedToTrackLocation:error];
                    }
                    else
                    {
                        [self setlocationServicesOn:[CLLocationManager locationServicesEnabled]];
                        [self.locationManager startUpdatingLocation];
                        
                        
                    }
                }
                break;
            default:
            {
                alertLocationUnknown = [[BlackAlertView alloc] initWithTitle:@"Unknown Network Error" message:@"Can't track location" delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alertLocationUnknown show];
                [alertLocationUnknown release];
                [self failedToTrackLocation:error];
            }
                break;
        }
    }
    
}


- (void)geocoderStartDetermineLocation:(CLLocation *)location
{
    RELEASE_SAFELY(self.geocoder);
    self.geocoder = [[CLGeocoder alloc]init];
    [self.geocoder reverseGeocodeLocation:location completionHandler: 
     ^(NSArray *placemarks, NSError *error) 
     {
         if (!self.isLocationTracked)
         {
             self.isLocationTracked = YES;
             [self.geocoder reverseGeocodeLocation:location completionHandler:nil];
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *countryName = [placemark country];
             NSString *city = [placemark locality];
             NSString *state = [placemark administrativeArea];
             NSString *countryCode = [placemark ISOcountryCode];
             NSString *county = [placemark subAdministrativeArea];
             if (countryName)
                 [self.locationDict setObject:countryName forKey:COUNTRY_NAME_KEY];
             if (countryCode)
                 [self.locationDict setObject:countryCode forKey:COUNTRY_CODE_KEY];
             if (city)
                 [self.locationDict setObject:city forKey:CITY_NAME_KEY];
             if (county)
                 [self.locationDict setObject:county forKey:COUNTY_NAME_KEY];
             if (state)
                 [self.locationDict setObject:state forKey:STATE_NAME_KEY];
             [self.locationDict setObject:[NSString stringWithFormat:@"%f",region.center.latitude] forKey:LOCATION_LATITUDE_KEY];
             [self.locationDict setObject:[NSString stringWithFormat:@"%f",region.center.longitude] forKey:LOCATION_LONGITUDE_KEY];
             [self.locationManager stopUpdatingLocation];
             [self didTrackLocation];
             DLog(@"Did track Location");
         }
         
     }];
    
}

- (void)didTrackLocation
{
    if (delegate && [delegate respondsToSelector:@selector(didTrackLocation)])
    {
        [delegate didTrackLocation];
    }

}

- (void)failedToTrackLocation:(NSError *)error
{
    if (delegate && [delegate respondsToSelector:@selector(failedToTrackLocation:)])
    {
        [delegate failedToTrackLocation:error];
    }
}

@end
