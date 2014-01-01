//
//  CustomMapViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomMapViewController.h"
#import <MapKit/MkAnnotation.h>
#import "myPos.h"


@interface CustomMapViewController ()

- (void)addAnnotationAtCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)determineState:(CLLocationCoordinate2D)coordinate;
@end

@implementation CustomMapViewController
@synthesize delegate,mapCoordinate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSDictionary *locDict = [Utility getLocationDict];
    if (locDict)
    {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[locDict objectForKey:LOCATION_LATITUDE_KEY] doubleValue];
        coordinate.longitude = [[locDict objectForKey:LOCATION_LONGITUDE_KEY] doubleValue];
        mapCoordinate = coordinate;
        [self determineState:mapCoordinate];
        [self addAnnotationAtCoordinate:mapCoordinate];
        MKCoordinateRegion region;
        region.center = coordinate;
        region.span.longitudeDelta = 0.007f;
        region.span.latitudeDelta = 0.007f;
        [mapView setRegion:region];
    }
    
}

- (void)viewDidUnload
{
    [mapView release];
    mapView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dropPin:(id)sender
{
    UIGestureRecognizer *gestureRecognizer = (UIGestureRecognizer *)sender;
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) return;
    DLog(@"long press");
    CGPoint touchPoint = [gestureRecognizer locationInView:mapView];   
    mapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    [self determineState:mapCoordinate];
    [self addAnnotationAtCoordinate:mapCoordinate];
    
    
    
}

- (IBAction)doneBtnSelected:(id)sender 
{
    if (customLocation)
    {
        [self saveCustomLocationToServerAndDB];
    }
    else {
        if(delegate && [delegate respondsToSelector:@selector(dismissCustomMapController)])
        {
            [delegate dismissCustomMapController];
        }
    }
    
}

- (void)dealloc {
    RELEASE_SAFELY(customLocation);
    RELEASE_SAFELY(reverseGeocoder);
    RELEASE_SAFELY(state);
    [mapView release];
    [super dealloc];
}

- (void)addAnnotationAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if(customLocation)
        RELEASE_SAFELY(customLocation);
    myPos *ann = [[[myPos alloc] init] autorelease];
    [ann setTitle:[NSString stringWithFormat:@"DropPin"]];
    ann.coordinate = coordinate;
    
    [mapView removeAnnotations:mapView.annotations]; 
    
    [mapView addAnnotation:ann];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"Pin";
    myPos *ann = (myPos *)annotation;
    if ([ann.title isEqualToString:@"DropPin"])
    {
        MKPinAnnotationView *pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = NO;
        [pinView setDraggable:YES];
        return pinView;
    }
    else if ([ann.title isEqualToString:@"ShowCallout"])
    {
        CustomMapCalloutView *view = [[[CustomMapCalloutView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        [view setState:nil];
        [view setDelegate:self];
        view.centerOffset = CGPointMake(30, -55);
        return view;
    }
    else {
        CustomMapCalloutView *view = [[[CustomMapCalloutView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        [view setState:state];
        [view setArea:ann.title];
        [view setDelegate:self];
        view.centerOffset = CGPointMake(30, -55);
        return view;
    }
   
}

- (void)mapView:(MKMapView *)amapView didSelectAnnotationView:(MKAnnotationView *)view
{
    myPos *ann = [[[myPos alloc] init] autorelease];
    [ann setTitle:[NSString stringWithFormat:@"ShowCallout"]];
    ann.coordinate = mapCoordinate;
    
    [mapView removeAnnotations:mapView.annotations]; 
    
    [mapView addAnnotation:ann];
}

- (void)areaNameDidEntered:(NSString *)areaName
{
    if (state)
    {
        if (customLocation)
            RELEASE_SAFELY(customLocation);
        customLocation = [[NSString alloc] initWithFormat:@"%@;%@",areaName,state];
        myPos *ann = [[[myPos alloc] init] autorelease];
        [ann setTitle:[NSString stringWithFormat:@"%@",areaName]];
        ann.coordinate = mapCoordinate;
        
        [mapView removeAnnotations:mapView.annotations]; 
        
        [mapView addAnnotation:ann];
    }
    else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Location Error" message:@"Location finder couldn't find out the state name of the placemark you entered" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];

    }
}

- (void)determineState:(CLLocationCoordinate2D)coordinate
{
    if(reverseGeocoder)
        RELEASE_SAFELY(reverseGeocoder);
    reverseGeocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[[CLLocation alloc] initWithCoordinate:coordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:[NSDate date]] autorelease];
    
    [reverseGeocoder reverseGeocodeLocation:location completionHandler: 
     ^(NSArray *placemarks, NSError *error) 
     {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         if (!error && [placemark administrativeArea] && ![[placemark administrativeArea] isEmptyString])
         {
             if (state)
                 RELEASE_SAFELY(state);
             state = [[Utility getStateAbbreviationForState:[placemark administrativeArea]] retain];
             DLog(@"State Found : %@------------------",state);
         }
         else {
             if (state)
                 RELEASE_SAFELY(state);
             state = nil;
        }
     }];

}

- (void)saveCustomLocationToServerAndDB
{
    loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Saving Location..."];
    NSMutableDictionary *locParams = [NSMutableDictionary dictionary];
    [locParams setObject:[NSString stringWithFormat:@"%@",customLocation] forKey:KWEB_SERVICE_LOCATION_TITLE];
    [locParams setObject:[NSString stringWithFormat:@"%f",mapCoordinate.latitude] forKey:KWEB_SERVICE_LOCATION_LATITUDE];
    [locParams setObject:[NSString stringWithFormat:@"%f",mapCoordinate.longitude] forKey:KWEB_SERVICE_LOCATION_LONGITUDE];
    if (saveFavLocRequest)
    {
        saveFavLocRequest.delegate = nil;
        RELEASE_SAFELY(saveFavLocRequest);
    }
    saveFavLocRequest = [[WebServices alloc] init];
    [saveFavLocRequest setDelegate:self];
    [saveFavLocRequest addFavLoc:locParams];
    
    [locParams setObject:[[customLocation componentsSeparatedByString:@";"]objectAtIndex:0] forKey:COUNTY_NAME_KEY];
    [locParams setObject:[[customLocation componentsSeparatedByString:@";"]lastObject] forKey:STATE_NAME_KEY];
    [locParams setObject:[NSString stringWithFormat:@"%f",mapCoordinate.latitude] forKey:LOCATION_LATITUDE_KEY];
    [locParams setObject:[NSString stringWithFormat:@"%f",mapCoordinate.longitude] forKey:LOCATION_LONGITUDE_KEY];
    [locParams setObject:[Utility userID] forKey:PROFILE_USER_ID_KEY];
    [[DAL sharedInstance] addFavLocToUserProfile:locParams];
    
}

# pragma mark - Request wrapper delegate

- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    NSDictionary *jsonDict = [WebServices parseJSONString:response];
    if([[userInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_FAV_LOCATION] && [jsonDict objectForKey:@"data"] && [[jsonDict objectForKey:@"data"] objectForKey:@"success"])
    {
        BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"OutdoorLoop" message:@"Location added successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:[Utility userID]];
        [loadingActivityIndicator removeFromSuperview];
        if(delegate && [delegate respondsToSelector:@selector(dismissCustomMapController)])
        {
            [delegate dismissCustomMapController];
        }
    }
}

@end
