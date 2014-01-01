//
//  FindMapViewController.m
//  FitTagApp
//
//  Created by apple on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FindMapViewController.h"

#import "FindMapListViewController.h"
#import "ChallengeDetailViewController.h"
@implementation FindMapViewController
@synthesize mutAryNearChallenge;
@synthesize mapView;

NSMutableArray* annotations;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - View lifecycle
-(void)viewDidLoad{
//    for(UIView* view in self.navigationController.navigationBar.subviews)
//    {
//        if ([view isKindOfClass:[UILabel class]])
//        {
//            [view removeFromSuperview];
//        }
//        
//    }

//    UINavigationBar *bar = [self.navigationController navigationBar];
//    [bar setBackgroundColor:[UIColor blackColor]];
//    
//    UILabel * nav_title = [[UILabel alloc] initWithFrame:CGRectMake(0,10, 320, 25)];
//    nav_title.font = [UIFont fontWithName:@"DynoBold" size:21];
//    nav_title.textColor = [UIColor whiteColor];
//    nav_title.textAlignment=UITextAlignmentCenter;
//    nav_title.adjustsFontSizeToFitWidth = YES;
//    nav_title.text = @"Map";
//    self.title = @"";
//    nav_title.backgroundColor = [UIColor clearColor];
//    [bar addSubview:nav_title];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //navigation back Button- Arrow
    UIButton *btnback=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnHeaderbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
    UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
    [view123 addSubview:btnback];
    
    UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn123.width=-16;
    UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
    self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
    
    UIButton *btnList=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnList addTarget:self action:@selector(btnListPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnList setFrame:CGRectMake(0, 0, 40, 44)];
    [btnList setImage:[UIImage imageNamed:@"headerList"] forState:UIControlStateNormal];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40,44)];
    [view addSubview:btnList];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn.width=-11;
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItems=[[NSArray alloc]initWithObjects:btn,btn1,nil];
  
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    // Initialize the location manager for getting current location
    locationManager = [[CLLocationManager alloc]init];
    locationManager.desiredAccuracy = 10.0;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    [self getNearChallenges];
    [mapView setShowsUserLocation:YES];
}
-(void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Mark CLLOcationManager Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    currentLocation=newLocation;
    [locationManager stopUpdatingLocation];
    locationManager = nil;
 
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    DisplayAlertWithTitle(@"Fittag",@"There is some problem occur in location services please try again");
    
}
#pragma mark- own method
-(void)getNearChallenges{
    @try {
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        //Create query for all Post object by the current user
        PFQuery *postQuery = [PFQuery queryWithClassName:@"Challenge"];
        [postQuery addDescendingOrder:@"createdAt"];
        [postQuery includeKey:@"userId"];
        PFQuery *query = [PFQuery queryWithClassName:@"tbl_Likes"];
        [query whereKey:@"ChallengeId" matchesQuery:postQuery];
        [postQuery orderByDescending:@"location"];
        // Run the query
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                //Save results and update the table
                mutAryNearChallenge=[[NSMutableArray alloc]initWithArray:objects];
                [self getAnonations];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"exception");
    }

    
} 
-(void)getAnonations{
    annotations=[[NSMutableArray alloc] init];
    for(int i=0;i<mutAryNearChallenge.count;i++){
        CLLocationCoordinate2D theCoordinate;
        PFObject  *objChallengeInfo=[mutAryNearChallenge objectAtIndex:i];
        NSString *strChlange=[objChallengeInfo objectForKey:@"challengeName"];
        if([strChlange isEqualToString:@"first challenge "]){
        
        }else{
        PFGeoPoint *point=[objChallengeInfo objectForKey:@"location"];    
        
        theCoordinate.latitude = [point latitude];
        theCoordinate.longitude =[point longitude];
        MyAnnotation* myAnnotation=[[MyAnnotation alloc] init];
        myAnnotation.coordinate=theCoordinate;
        myAnnotation.title=[objChallengeInfo objectForKey:@"challengeName"];
        myAnnotation.subtitle=[objChallengeInfo objectForKey:@"locationName"];
        myAnnotation.annonationIndex=i;
        [annotations addObject:myAnnotation];
         if(theCoordinate.latitude!=0.0 )
             [mapView addAnnotation:myAnnotation];
        }
    }
    [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES ];
    MKCoordinateRegion region;
    region.center.latitude = currentLocation.coordinate.latitude;
    region.center.longitude = currentLocation.coordinate.longitude;
    region.span.latitudeDelta = 0.08;
    // Add a little extra space on the sides
    region.span.longitudeDelta = 0.08;
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];

}
#pragma mark
#pragma mark Map Delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView1 viewForAnnotation:(id <MKAnnotation>)annotation{
    
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
 
        static NSString *AnnotationViewID = @"annotationViewID";
        
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView1 dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        if (annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            
           
        }
        
        annotationView.image = [UIImage imageNamed:@"dropPinShadow"];
        annotationView.annotation = annotation;
        annotationView.canShowCallout = YES;

    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setImage:[UIImage imageNamed:@"mapArrow"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"mapArrow"] forState:UIControlStateHighlighted];

    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
    //[rightButton addTarget:self action:@selector(showDetails)forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    return annotationView;

    // try to dequeue an existing pin view first
/*
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView* pinView = [[MKPinAnnotationView alloc]
                                    initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    
    pinView.animatesDrop=YES;
    pinView.canShowCallout=YES;
    pinView.draggable=YES;
        
    UIImageView *profileIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.png"]];
    pinView.leftCalloutAccessoryView = profileIconView;
    // pinView.pinColor=MKPinAnnotationColorRed;
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [rightButton addTarget:self
                        action:@selector(showDetails)
              forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
    return pinView;
 
 */
    
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    if ([view.annotation isKindOfClass:[MyAnnotation class]]) {
        MyAnnotation *myAntn = (MyAnnotation *)view.annotation;
        
        ChallengeDetailViewController *challnegeDetailVC=[[ChallengeDetailViewController alloc] initWithNibName:@"ChallengeDetailViewController" bundle:nil];
        challnegeDetailVC.objChallengeInfo=[mutAryNearChallenge objectAtIndex:myAntn.annonationIndex];
        
        [self.navigationController pushViewController:challnegeDetailVC animated:YES];
    }
}
-(void)showDetails{
    

}
#pragma ListSelected Delegate Method
-(void)backWithListSelection:(NSMutableDictionary *)dictLocationInfo indexNo:(int)intIndexNo{
    
    [self.mapView setNeedsDisplay];
    [self.mapView setNeedsLayout];
    MyAnnotation *ano=[annotations objectAtIndex:intIndexNo];
    
    if(dictLocationInfo==nil||ano.coordinate.latitude==0.0){
       
        MKCoordinateRegion region;
        region.center.latitude = currentLocation.coordinate.latitude;
        region.center.longitude = currentLocation.coordinate.longitude;
        
        region.span.latitudeDelta = 0.08;
        
        // Add a little extra space on the sides
        region.span.longitudeDelta = 0.08;
        
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
        [self.mapView selectAnnotation:mapView.userLocation animated:YES];

    }else{
        
        MKCoordinateRegion region;
        MyAnnotation* myAnnotation = [annotations objectAtIndex:intIndexNo];
        region.center.latitude = myAnnotation.coordinate.latitude;
        region.center.longitude = myAnnotation.coordinate.longitude;
        
        region.span.latitudeDelta = 0.08;
        
        // Add a little extra space on the sides
        region.span.longitudeDelta = 0.08;
        
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
        
        [self.mapView selectAnnotation:[annotations objectAtIndex:intIndexNo] animated:YES];
    }
    
}
#pragma mark
#pragma mark Button Actions
-(IBAction)btnListPressed:(id)sender{
    // FindMapViewController *findMapViewController = [[FindMapViewController alloc] initWithNibName:@"FindMapViewController" bundle:[NSBundle mainBundle]];
    
    //    [UIView beginAnimations:@"View Flip" context:nil];
    //    [UIView setAnimationDuration:0.80];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //
    //    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
    //                           forView:self.navigationController.view cache:NO];
    //
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [UIView commitAnimations];
    
    FindMapListViewController *findMapListViewController = [[FindMapListViewController alloc] initWithNibName:@"FindMapListViewController" bundle:[NSBundle mainBundle]];
    findMapListViewController.delegate=self;
    findMapListViewController.title=@"List";
    //     findMapListViewController.mutArrayNearChlng=mutAryNearChallenge;
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:findMapListViewController animated:YES];
    
    [UIView commitAnimations];
    
}
-(IBAction)btnHeaderbackPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(IBAction)btnMapLocationPressed:(id)sender {
    
    MKCoordinateRegion region;
    region.center.latitude = currentLocation.coordinate.latitude;
    region.center.longitude = currentLocation.coordinate.longitude;
    
    region.span.latitudeDelta = 0.08;
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = 0.08;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
    
}
-(IBAction)btnMapRefreshPressed:(id)sender {
    [self getNearChallenges];
}
@end
