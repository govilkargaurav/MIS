//
//  MapVC.m
//  Suvi
//
//  Created by apple on 5/16/13.
//
//

#import "MapVC.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "NSString+Utilities.h"
#import "Global.h"
@interface MapVC ()<MKMapViewDelegate>
{
    
    IBOutlet MKMapView *mapViewCustom;
    NSMutableArray *arrPins;
}
@end

@implementation MapVC
@synthesize dictMapVC;
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
    //self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+iPhone5ExHeight);
    mapViewCustom.delegate = self;
    mapViewCustom.showsUserLocation = NO;
    //[mapViewCustom setCenterCoordinate:mapViewCustom.userLocation.coordinate animated:YES];
    [self setPinsForMap];
}
-(void)setPinsForMap
{
    arrPins = [[NSMutableArray alloc]init];
    [arrPins  removeAllObjects];
    [mapViewCustom removeAnnotations:mapViewCustom.annotations];
    MyAnnotation *myAnn = [[MyAnnotation alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[[[self.dictMapVC valueForKey:@"dcLatitude"] removeNull] floatValue] longitude:[[[self.dictMapVC valueForKey:@"dcLongitude"] removeNull] floatValue]];
        
    myAnn.title = [[self.dictMapVC valueForKey:@"vName"] removeNull];
    myAnn.subtitle = [[self.dictMapVC valueForKey:@"vAddress"] removeNull];
    myAnn.coordinate = loc.coordinate;
    //myAnn.pinTag = i;
    [arrPins addObject:myAnn];

    [mapViewCustom addAnnotations:arrPins];
    [self setToUserLocation];
}
-(void)setToUserLocation{
    
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[[[self.dictMapVC valueForKey:@"dcLatitude"] removeNull] floatValue] longitude:[[[self.dictMapVC valueForKey:@"dcLongitude"] removeNull] floatValue]];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    region.span = span;
    //region.center = mapViewCustom.userLocation.location.coordinate;
    region.center=loc.coordinate;
    [mapViewCustom setRegion:region animated:TRUE];
    [mapViewCustom regionThatFits:region];
}
-(IBAction)Back:(id)sender
{
    AddViewFlag = 50;
    [self dismissModalViewControllerAnimated:NO];
}
#pragma mark - MapDelegate
//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    MKPinAnnotationView *annView;
//    
//    if([annView isKindOfClass:[MKUserLocation class]])
//    {
//        return Nil;
//    }
//    else
//    {
//        static NSString *identifier = @"pin";
//        annView = Nil;//(MKPinAnnotationView *)[mapViewCustom dequeueReusableAnnotationViewWithIdentifier:identifier];
//        if (annView==Nil)
//        {
//            annView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
//        }
//        MyAnnotation *myAnn = (MyAnnotation *)annotation;
//        annView.animatesDrop = YES;
//        annView.canShowCallout = YES;
//        annView.tag = myAnn.pinTag;
//        return annView;
//    }
//}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewDidUnload
{
    mapViewCustom = nil;
    [super viewDidUnload];
}
@end
