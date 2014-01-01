//
//  LocationTracker.m
//  HuntingApp
//
//  Created by Habib Ali on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationTracker.h"

@implementation LocationTracker

@synthesize isLocationTracked;

static LocationTracker *singletonInstance = nil;

+ (LocationTracker *)sharedInstance {
    
    if (singletonInstance == nil) {
        
        singletonInstance = [[super allocWithZone:NULL] init];
    }
    return singletonInstance;
}

-(id) init {
    
    self = [super init];
    if (self ) {
        
        isLocationTracked = NO;
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;    
}

- (id)retain {
    
    return self;
}

- (NSUInteger)retainCount {
    
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (id)autorelease {
    return self;
}
-(void) dealloc
{
    locationManager.delegate = nil;
    RELEASE_SAFELY(locationManager);
    [super dealloc];
}

#pragma mark
#pragma location manager delegate

- (void)didTrackLocation
{
    isLocationTracked = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_TRACKED object:nil];
}

- (void)trackLocation
{
    isLocationTracked = NO;
    if (locationManager)
    {
        [locationManager setDelegate:nil];
        RELEASE_SAFELY(locationManager);
    }
    locationManager = [[LocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager trackLocation];
}

- (MKCoordinateRegion)getRegion
{
    return locationManager.region;
}

- (NSDictionary *)getLocationDictionary
{
    if (isLocationTracked)
        return locationManager.locationDict;
    else {
        return nil;
    }
}


@end
