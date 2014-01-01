//
//  ReverseGeoCoder.m
//  LawyerApp
//
//  Created by ChintaN on 7/9/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "ReverseGeoCoder.h"

@implementation ReverseGeoCoder

@synthesize strLocationCityName;


+ (id)sharedManager {
    static ReverseGeoCoder *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}



-(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    
    __block NSString *strCountryCode;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:pdblLatitude longitude:pdblLongitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             
             strCountryCode = [NSString stringWithFormat:@"%@",[placemark ISOcountryCode]];
             strLocationCityName = [NSString stringWithFormat:@"%@",[placemark locality]];
             
         }
     }];
    
    return strLocationCityName;
}

+(NSArray *)getLatLongOfUsersCurrentLocation:(id)sender{
    
    // locationManager update as location
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    CLLocation *location = [appdelegate.locationManager location];
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    NSArray *array= nil;
    array = [NSArray arrayWithObjects:latitude,longitude, nil];
    return array;
}





@end
