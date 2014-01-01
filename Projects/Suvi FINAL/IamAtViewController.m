//
//  IamAtViewController.m
//  Suvi
//
//  Created by Vivek Rajput on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IamAtViewController.h"
#import "MyAppManager.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "common.h"

@implementation IamAtViewController
@synthesize foursquare,fsqrequest,searchbar,headerview,isLocationPostView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 44, 320, 170)];
    mapView.delegate=self;
    mapView.showsUserLocation=YES;
    
    issearchEnabled=NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
   
    locationdataarray=[[NSMutableArray alloc]init];
    locationsearchdataarray=[[NSMutableArray alloc]init];
    
    tblview.separatorColor=[UIColor clearColor];
    tblview.backgroundColor=[UIColor clearColor];
    
    searchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchbar.delegate=self;
    searchbar.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"search_bg.png"]];
    searchbar.placeholder=@"Search Place...";
    searchbar.tintColor=[UIColor clearColor];
    searchbar.translucent=YES;
    [searchbar setBackgroundImage:[UIImage imageNamed:@"greytransbg.png"]];
    [searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchbar_txtbg.png"] forState:UIControlStateNormal];
    [searchbar setScopeBarBackgroundImage:[UIImage imageNamed:@"greytransbg.png"]];
    
    UITextField *searchField = [searchbar valueForKey:@"_searchField"];
    searchField.textColor=[UIColor darkGrayColor];
    searchField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [searchField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 170+44+2)];
    headerview.backgroundColor=[UIColor grayColor];
    [headerview addSubview:searchbar];
    [headerview addSubview:mapView];
    
    imgviewtblfooter=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"poweredByFoursquare_gray.png"]];
    imgviewtblfooter.backgroundColor=[UIColor clearColor];
    imgviewtblfooter.frame=CGRectMake(0, 0, 320, 80);
    tblview.tableFooterView=imgviewtblfooter;
    
    tblview.tableHeaderView=headerview;
    
    [[AppDelegate sharedInstance]showLoader];
    
    foursquare = [[BZFoursquare alloc] initWithClientID:kFourSquareClientID callbackURL:kFourSquareCallbackURL];
    foursquare.version = @"20111119";
    foursquare.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    foursquare.sessionDelegate = self;
    
    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    NSString *isFSQAuth=[NSString stringWithFormat:@"%@",[socialdict objectForKey:@"foursquare"]];
    NSMutableString *isFSQToken=[[NSMutableString alloc]init];
    
    if ([isFSQAuth isEqualToString:@"Authenticate"])
    {
        NSString *isFSQTokentemp=[NSString stringWithFormat:@"%@",[socialdict objectForKey:@"foursquare_token"]];
        
        if ([isFSQTokentemp length]>10)
        {
            [isFSQToken setString:isFSQTokentemp];
        }
    }
    
    if ([isFSQToken length]<10)
    {
        [isFSQToken setString:kFourSquareAccessToken];
    }

    foursquare.accessToken=isFSQToken;
    
    isFirstTimeDataLoad=YES;
    [self performSelector:@selector(searchLocations) withObject:nil afterDelay:1.0];
}

-(IBAction)btnbackclicked:(id)sender
{
    if (isLocationPostView)
    {
        AddViewFlag = 50;
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - SEARCH BAR METHODS
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{   

    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchbar.text length]>0) 
    {
        [[AppDelegate sharedInstance]showLoader];
        [searchbar resignFirstResponder];
        [self performSelector:@selector(searchLocationsByName) withObject:nil afterDelay:0.001];
    }
    else
    {
        DisplayAlert(@"Please enter place...");
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    headerview.frame=CGRectMake(0, 0, 320,216);
    mapView.hidden=NO;
    headerview.backgroundColor=[UIColor blackColor];
    tblview.tableHeaderView=headerview;
    issearchEnabled=NO;
    searchbar.text=@"";
    [searchbar setShowsCancelButton:NO animated:YES];
    [locationsearchdataarray removeAllObjects];
    [tblview reloadData];
    [searchbar resignFirstResponder];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    CGRect viewFrame = self.view.frame;
	viewFrame.origin.y -=46.0;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.15];
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
    
    issearchEnabled=YES;
    headerview.frame=CGRectMake(0, 0, 320,44);
    CGRect tempframe=tblview.frame;
    tempframe.size.height+=44;
    tblview.frame=tempframe;
    mapView.hidden=YES;
    headerview.backgroundColor=[UIColor clearColor];
    tblview.tableHeaderView=headerview;
    
    [searchbar setShowsCancelButton:YES animated:YES];
    [tblview reloadData];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    CGRect viewFrame = self.view.frame;
	viewFrame.origin.y += 46.0;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.15];
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
    CGRect tempframe=tblview.frame;
    tempframe.size.height-=44;
    tblview.frame=tempframe;
    [searchbar resignFirstResponder];
}

#pragma mark - Webservice Called
-(void)searchLocationsByName
{
    if (fsqrequest) {
        fsqrequest.delegate = nil;
        [fsqrequest cancel];
        self.fsqrequest = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
   // NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f,%f",[[AppDelegate sharedInstance] currentLocationLastUpdated].coordinate.latitude,[[AppDelegate sharedInstance] currentLocationLastUpdated].coordinate.longitude], @"ll",[NSString stringWithFormat:@"%@",searchbar.text], @"query", nil];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f,%f",mapView.userLocation.coordinate.latitude,mapView.userLocation.coordinate.longitude], @"ll",[NSString stringWithFormat:@"%@",searchbar.text], @"query", nil];
    self.fsqrequest = [foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [fsqrequest start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)searchLocations
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        if (fsqrequest) {
            fsqrequest.delegate = nil;
            [fsqrequest cancel];
            self.fsqrequest = nil;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        
        CGFloat lattitude =mapView.userLocation.coordinate.latitude;
        
        CGFloat longitude =mapView.userLocation.coordinate.longitude;
        
        if (lattitude==0 && longitude==0)
        {
            MKUserLocation *userLocation = mapView.userLocation;
            BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
            BOOL locationAvailable = userLocation.location!=nil;
            
            if (locationAllowed==NO)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled" 
                                                                message:@"To re-enable, please go to Settings and turn on Location Service for this app." 
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil];
                [alert show];
              
            }
            else
            {
                if (locationAvailable==NO)
                {
                    
                    float thelat=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"]] floatValue];
                    float thelong=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"long"]] floatValue];
                    
                    lattitude =thelat;
                    
                    longitude =thelong;
                    
                    //DisplayAlert(@"Location Not Found..");
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Not Available"
//                                                                    message:@"Hii"
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"OK"
//                                                          otherButtonTitles:nil];
//                    [alert show];
//                    
                    //return;
                    
                    //[mapView.userLocation addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
                }
            }
        }
        
        //mapView.userLocation.coordinate.latitude
        //NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f,%f",[[AppDelegate sharedInstance] currentLocationLastUpdated].coordinate.latitude,[[AppDelegate sharedInstance] currentLocationLastUpdated].coordinate.longitude], @"ll",@"browse",@"intent",@"200",@"radius",@"10",@"llAcc", nil];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f,%f",mapView.userLocation.coordinate.latitude,mapView.userLocation.coordinate.longitude], @"ll",@"browse",@"intent",@"200",@"radius",@"10",@"llAcc", nil];
        //,@"15",@"limit"
        
        
        self.fsqrequest = [foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
        [fsqrequest start];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

#pragma mark BZFoursquareRequestDelegate
- (void)requestDidFinishLoading:(BZFoursquareRequest *)request 
{
    NSDictionary *tempdict=[NSDictionary dictionaryWithDictionary:request.response];

    [[AppDelegate sharedInstance]hideLoader];
    self.fsqrequest = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([tempdict objectForKey:@"venues"]) {
        if ([[tempdict objectForKey:@"venues"] count]>0)
        {
            if (issearchEnabled) {
                [locationsearchdataarray removeAllObjects];
                [locationsearchdataarray addObjectsFromArray:[tempdict objectForKey:@"venues"]];  
            }
            else
            {
                [locationdataarray removeAllObjects];
                [locationdataarray addObjectsFromArray:[tempdict objectForKey:@"venues"]];
            }
        }
    }
    
    if (isFirstTimeDataLoad) {
        isFirstTimeDataLoad=NO;
        [self plotPositions:locationdataarray];
    }
    
    
    tblview.separatorColor=[UIColor grayColor];
    [tblview reloadData];
}
- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
    self.fsqrequest = nil;
    [[AppDelegate sharedInstance]hideLoader];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)plotPositions:(NSMutableArray *)data
{
    for (id<MKAnnotation> annotation in mapView.annotations) 
    {
        if ([annotation isKindOfClass:[MapPoint class]]) 
        {
            [mapView removeAnnotation:annotation];
        }
    }
    
    double minLatitude=0.0;
    double maxLatitude=0.0;
    double minLongitude=0.0;
    double maxLongitude=0.0;
    
    
    //Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++)
    {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        
        //There is a specific NSDictionary object that gives us location info.
        
        //Get our name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[[place objectForKey:@"location"]objectForKey:@"address"];
        
        //Get the lat and long for the location.
        
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        
        //Set the lat and long.
        placeCoord.latitude=[[[place objectForKey:@"location"]objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[[place objectForKey:@"location"]objectForKey:@"lng"] doubleValue];
        
        minLatitude=MIN(minLatitude,[[[place objectForKey:@"location"]objectForKey:@"lat"] doubleValue]);
        maxLatitude=MAX(maxLatitude,[[[place objectForKey:@"location"]objectForKey:@"lat"] doubleValue]);
        minLongitude=MIN(minLongitude,[[[place objectForKey:@"location"]objectForKey:@"lng"] doubleValue]);
        maxLongitude=MAX(maxLongitude,[[[place objectForKey:@"location"]objectForKey:@"lng"] doubleValue]);
        
        //Create a new annotiation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        [mapView addAnnotation:placeObject];
    }
    
    
    CLLocationCoordinate2D maxCoord = mapView.userLocation.coordinate;
    CLLocationCoordinate2D minCoord = mapView.userLocation.coordinate;
    MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
    region.center.longitude = (minCoord.longitude + maxCoord.longitude) / 2.0;
    region.center.latitude = (minCoord.latitude + maxCoord.latitude) / 2.0;
    region.span.longitudeDelta =0.001;
    region.span.latitudeDelta =0.001;
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
    
    
//    MKMapRect flyTo = MKMapRectNull;
//    for (id <MKAnnotation> annotation in mapView.annotations)
//    {
//        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
//        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
//        if (MKMapRectIsNull(flyTo))
//        {
//            flyTo = pointRect;
//        }
//        else
//        {
//            flyTo = MKMapRectUnion(flyTo, pointRect);
//        }
//    }
//
//    mapView.visibleMapRect = flyTo;
}

#pragma mark -TABLEVIEW
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (issearchEnabled) {
        return [locationsearchdataarray count];
    }
    else
    {
        return [locationdataarray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor=[UIColor darkGrayColor];
    
    if (issearchEnabled) {
        cell.textLabel.text=[[locationsearchdataarray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detailTextLabel.text=[[[locationsearchdataarray objectAtIndex:indexPath.row] objectForKey:@"location"]objectForKey:@"address"]; 
    }
    else
    {
        cell.textLabel.text=[[locationdataarray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detailTextLabel.text=[[[locationdataarray objectAtIndex:indexPath.row] objectForKey:@"location"]objectForKey:@"address"];
    }
    
    UIView *viewSeparater=[[UIView alloc]initWithFrame:CGRectMake(0.0,59.0,320.0,1.0)];
    viewSeparater.backgroundColor=[UIColor darkGrayColor];
    [cell.contentView addSubview:viewSeparater];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *tempdict;
    if (issearchEnabled) {
        tempdict=[[NSDictionary alloc]initWithObjectsAndKeys:[locationsearchdataarray objectAtIndex:indexPath.row],@"locationdata",nil];
    }
    else
    {
        tempdict=[[NSDictionary alloc]initWithObjectsAndKeys:[locationdataarray objectAtIndex:indexPath.row],@"locationdata",nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IAmAt" object:nil userInfo:tempdict];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - EXTRA
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate
{
    return NO;
}

@end
