//
//  CLSMapview.m
//  Library
//
//  Created by apple on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLSMapview.h"


@implementation CLSMapview
@synthesize currentLat,currentLon;
@synthesize ZoomLevel;
-(void)initlizeMapCLSMapview{
	
	
	self.showsUserLocation=NO;
	locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locManager.distanceFilter = 10.0f;
 //   [locManager startUpdatingLocation];
	
}
-(void)actionShowCurrentLocation{
	
	self.showsUserLocation=YES;
}
-(void)actionAddPinToPositionLat:(NSString*)lat andLon:(NSString*)lon{
	Place* home = [[[Place alloc] init] autorelease];
	home.name =@"title";
	home.latitude = [lat  doubleValue];
	home.longitude = [lon  doubleValue];
	PlaceMark* annot = [[[PlaceMark alloc] initWithPlace:home] autorelease];	
	[self addAnnotation:annot];
	
}
-(void)actionAddPinToPositionLat:(NSString*)lat andLon:(NSString*)lon withName:(NSString*)name{
	Place* home = [[[Place alloc] init] autorelease];
	home.name =name;
	home.latitude = [lat  doubleValue];
	home.longitude = [lon  doubleValue];
	PlaceMark* annot = [[[PlaceMark alloc] initWithPlace:home] autorelease];	
	[self addAnnotation:annot];
	
}
-(void)setTheZoomLevel:(int)Zoom{
	
}

-(void)actionAddPinsToPositions:(NSArray*)coordinate{
	
	for (int i=0; i<[coordinate count];i++) {
		NSDictionary *dic = [coordinate objectAtIndex:i];
		Place* home = [[[Place alloc] init] autorelease];
		home.name =@"title";
		home.latitude = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"lat"]] doubleValue];
		home.longitude = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"lon"]] doubleValue];
		PlaceMark* annot = [[[PlaceMark alloc] initWithPlace:home] autorelease];	
		[self addAnnotation:annot];		
		
	}	
}


-(void)actionSetCurrentLocationToCenter{
	

	
	
}
-(void)actionSetZoomLevel:(int)Zoom{
	

	Zoom= Zoom+1;
	Zoom = 11 - Zoom;
	Zoom=Zoom*10;
	
	float delta = Zoom;
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=delta;
	span.longitudeDelta=delta;
	region.span=span;
	
	double lat = [currentLat doubleValue];
	double lon = [currentLon doubleValue];
	region.center=CLLocationCoordinate2DMake(lat, lon);
	[self setRegion:region animated:TRUE];
	
}
-(void)actionAddImageToThisPosition:(CLLocation*)location{
	
}
-(void)actionAddImageToThisPositions:(NSArray*)locations{
	
}
-(void)actionShowPathFrom:(NSDictionary*)start To:(NSDictionary*)end{
	
	
	NSString *mapString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?daddr=%f,%f+to:%f,%f&output=kml",23.00,72.40,22.32,73.00];

//	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@,%@+to:%@,%@&output=kml",[start valueForKey:@"lat"],[start valueForKey:@"lon"],[end valueForKey:@"lat"],[end valueForKey:@"lon"]]];
	NSURL *url = [NSURL URLWithString:mapString];
	
	NSData *data = [NSData dataWithContentsOfURL:url];

	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"route.kml"];
    //NSLog(@"%@",[documentsDir stringByAppendingPathComponent:@"LikeMeFit.sqlite"]);
	//    return [documentsDir stringByAppendingPathComponent:@"LikeMeFit.sqlite"];    
	
	[data writeToFile:path atomically:YES];
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"kml"];
	
    kml = [[KMLParser parseKMLAtPath:path] retain];
    
    // Add all of the MKOverlay objects parsed from the KML file to the map.
    NSArray *overlays = [kml overlays];
    [self addOverlays:overlays];
    
    // Add all of the MKAnnotation objects parsed from the KML file to the map.
    NSArray *annotations = [kml points];
	
    //[self addAnnotations:annotations];
//	[self addAnnotation:[annotations objectAtIndex:0]];
//	[self addAnnotation:[annotations objectAtIndex:[annotations count]-1]];
    
    // Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.

    MKMapRect flyTo = MKMapRectNull;
    for (id <MKOverlay> overlay in overlays) {
        if (MKMapRectIsNull(flyTo)) {
            flyTo = [overlay boundingMapRect];
        } else {
            flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
        }
    }
    
    for (id <MKAnnotation> annotation in annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }
    
    // Position the map so that all overlays and annotations are visible on screen.
    self.visibleMapRect = flyTo;
	
}
-(void)actionShowKmlatURL:(NSURL*)url{
	
}

#pragma mark - 
#pragma mark CLLocationManager delegate methods

- (void) locationManager: (CLLocationManager *) manager didUpdateToLocation: (CLLocation *) newLocation fromLocation: (CLLocation *) oldLocation{		

	self.currentLat = [NSString stringWithFormat:@"%g",newLocation.coordinate.latitude];
	self.currentLon = [NSString stringWithFormat:@"%g",newLocation.coordinate.longitude];
	
}

@end
