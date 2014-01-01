//
//  CLSMapview.h
//  Library
//
//  Created by apple on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Place.h"
#import "PlaceMark.h"
#import "KMLParser.h"
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>

@interface CLSMapview : MKMapView<CLLocationManagerDelegate,MKMapViewDelegate>{
	CLLocationManager *locManager;
	NSString *currentLat;
	NSString *currentLon;
	int ZoomLevel;
	KMLParser *kml;

}
@property(nonatomic)int ZoomLevel;
@property(nonatomic,retain)NSString *currentLat;
@property(nonatomic,retain)NSString *currentLon;


-(void)initlizeMapCLSMapview;
-(void)actionShowCurrentLocation;
-(void)actionAddPinToPositionLat:(NSString*)lat andLon:(NSString*)lon;
-(void)actionAddPinToPositionLat:(NSString*)lat andLon:(NSString*)lon withName:(NSString*)name;
-(void)actionAddPinsToPositions:(NSArray*)coordinate;
-(void)actionSetZoomLevel:(int)Zoom;

-(void)actionShowPathFrom:(NSDictionary*)start To:(NSDictionary*)end;
-(void)actionShowKmlatURL:(NSURL*)url;
-(void)actionSetCurrentLocationToCenter;
-(void)actionAddImageToThisPosition:(CLLocation*)location;
-(void)actionAddImageToThisPositions:(NSArray*)locations;


@end
