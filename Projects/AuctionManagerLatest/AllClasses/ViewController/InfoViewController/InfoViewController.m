//
//  InfoViewController.m
//  PropertyInspector
//
//  Created by apple on 10/19/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "InfoViewController.h"
#import "DisplayMap.h"
#import "MapView.h"
#import "Place.h"
#import "GetAuctionsList.h"
#import "GetTrusteesListModel.h"
#import "BusyAgent.h"
#import "ThreadManager.h"
#import "LoginModel.h"
#import "GetTrusteesListModel.h"
#import "DAL.h"
#import "AuctionStatusController.h"

@interface InfoViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property(nonatomic,strong)IBOutlet MKMapView *mapView;
@property(nonatomic,strong)DAL *dt;
@property(nonatomic,strong)IBOutlet UILabel *_addressLbl;
@property(nonatomic,strong)NSMutableArray *getallDataArr;
@end

@implementation InfoViewController
@synthesize getallDataArr;
@synthesize dt;
@synthesize bean;
@synthesize countyID;
@synthesize mapView;
@synthesize latitudeStr;
@synthesize longitudeStr;
@synthesize countyName;
@synthesize _addressLbl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
        
        if (bean!=nil) {
            bean=nil;
        }
        bean=[[DatabaseBean alloc] init];
        
        
        if (getallDataArr!=nil) {
            getallDataArr=nil;
            [getallDataArr removeAllObjects];
        }
        getallDataArr=[[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread) toTarget:self withObject:nil];
    dt=[DAL getInstance];
    _addressLbl.text=countyName;
    self.navigationItem.title=@"INFORMATION";
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(refresh:)];

    self.navigationItem.rightBarButtonItem = button;
    
    [self.navigationItem setHidesBackButton:NO];
    
    CLLocationManager *locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude =[latitudeStr floatValue];
    region.center.longitude =[longitudeStr floatValue];
    MKCoordinateSpan span;
    span.latitudeDelta = .01;
    span.longitudeDelta = .01;
    region.span = span;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh:) name:@"RefreshList" object:nil];
    
    [mapView setRegion:region animated:YES];
    [mapView setDelegate:self];
    [mapView setShowsUserLocation:YES];
    DisplayMap *ann = [[DisplayMap alloc] init];
    
    ann.title=countyName;
    ann.coordinate = region.center;
    [mapView addAnnotation:ann];
    
        NSString *soapMessage = [[NSString stringWithFormat:@"%@sessionId=%@&countyId=%@",WEB_GET_TRUSTEES_LIST,sessionID,countyID]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        ////NSLog(@"SOAP MESSAGE::-->%@",soapMessage);
    
        NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
        
        [[ThreadManager getInstance]makeRequest:GET_TRUSTEES_LIST:soapMessage:tData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(gettrusteesList) name:NOTIFICATION_GET_TRUSTEES_LIST object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];

        firstTimeStr=@"1";
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    self.navigationItem.title=@"INFORMATION";
        
    if ([insertDatabseStr isEqualToString:@"1"]) {
        
        insertDatabseStr=@"0";
        
        _arrTrusees=[[NSMutableArray alloc] init];
        
        _arrTrusees=[dt getAllSubCategory:countyID];
        

    }
    
}


-(void)refresh:(id)sender{
    
    
    
    [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread) toTarget:self withObject:nil];
    
    NSString *soapMessage = [[NSString stringWithFormat:@"%@sessionId=%@&countyId=%@",WEB_GET_TRUSTEES_LIST,sessionID,countyID]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
    
    [[ThreadManager getInstance]makeRequest:GET_TRUSTEES_LIST:soapMessage:tData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gettrusteesList) name:NOTIFICATION_GET_TRUSTEES_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];
    
    firstTimeStr=@"1";

    
}


-(void)gettrusteesList{
    
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_GET_TRUSTEES_LIST object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    
    
    
    [dt deleteAllrecords:@"DELETE FROM County"];
    
    for (NSDictionary *book in _arrTrusees) {
        
        bean.propertyID=[book valueForKey:@"ID"];
        bean.addressStr=[book valueForKey:@"ADDRESS"];
        bean.cityStr=[book valueForKey:@"CITY"];
        bean.stateStr=[book valueForKey:@"STATE"];
        bean.zipStr=[book valueForKey:@"ZIP"];
        bean.latitudeStr=[book valueForKey:@"LATTI"];
        bean.longitudeStr=[book valueForKey:@"LONGI"];
        bean.borrowerName=[book valueForKey:@"BROOWER_NAME"];
        bean.trusteeFirstNameStr=[book valueForKey:@"TRUSTEE_NAME"];
        bean.truseeId=[book valueForKey:@"TRUSTEE_ID"];
        bean.bidderlastName=[book valueForKey:@"BIDDER_LAST_NAME"];
        bean.bidderFirstName=[book valueForKey:@"BIDDER_FIRST_NAME"];
        bean.biddermiddleName=[book valueForKey:@"BIDDER_MIDDLE_NAME"];
        bean.maxBidStr=[book valueForKey:@"MAX_BID"];
        bean.openingbidStr=[book valueForKey:@"OPENING_BID"];
        bean.statusStr=[book valueForKey:@"STATUS"];
        bean.updatedbyStr=[book valueForKey:@"UPDATED_BY"];
        bean.updatedateStr=[book valueForKey:@"UPDATED_DATE"];
        bean.bidderidStr=[book valueForKey:@"BIDDER_ID"];
        bean.wonpriceStr=[book valueForKey:@"WON_PRIZE"];
        bean.AuctionId=[book valueForKey:@"AUCTION_ID"];
        bean.AuctionDateTime=[book valueForKey:@"AUCTION_DATE_TIME"];
        bean.AuctionNote=[book valueForKey:@"AUCTION_NOTES"];
        bean.legalDescription=[book valueForKey:@"LEGAL_DESCRIPTION"];
        bean.countyID=countyID;
        bean.auctionNumber=[book valueForKey:@"AUCTION_NO"];
        bean.crierName=[book valueForKey:@"CRIER"];
        bean.settleStatus=[book valueForKey:@"SETTLE_STATUS"];
        bean.loanDate=[book valueForKey:@"LOANDATE"];
        bean.loanAmount=[book valueForKey:@"LOANAMOUNT"];
        
        
        
        
        if (![dt isRecordExistInCountyInfo:bean.propertyID]) {
            
            
            if ([dt insertintoCountyInfo:bean]) {
                
                
            }else{
                
                
            }
            
            
        }
        
        
        
        
    }
    dt=[DAL getInstance];
    _arrTrusees=[dt getAllSubCategory:countyID];
    
    if ([getTableReload isEqualToString:@"TRUE"]) {
        
        getTableReload=@"FALSE";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gettrusteesList" object:nil];
        
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NewList" object:nil];
        
    }
    
    
    [[BusyAgent defaultAgent] makeBusy:NO showBusyIndicator:NO];
    
    
}

-(IBAction)RouteFromHere:(id)sender{
    
    MapView* mapViewRoot = [[MapView alloc] initWithFrame:CGRectMake(10,11,166,179)];
    
    [self.view addSubview:mapViewRoot];
    
    Place* home = [[Place alloc] init];
    home.name = @"Current Location";
    home.latitude = 23.0333;
    home.longitude = 72.6167;
    
    Place* office = [[Place alloc] init];
    office.name = @"Checkpoint";
    office.latitude = 22.7287;
    office.longitude = 75.8654;
    
    
    [mapViewRoot showRouteFrom:home to:office];
    
    
}


-(void)busyViewinSecondryThread{
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	annView.pinColor = MKPinAnnotationColorGreen;
	annView.animatesDrop=TRUE;
	annView.canShowCallout = YES;
	annView.calloutOffset = CGPointMake(-5, 5);
    annView.opaque = YES;
	return annView;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
  fromLocation:(CLLocation *)oldLocation
{
    //Strlat= newLocation.coordinate.latitude;
    //Strlong=newLocation.coordinate.longitude;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)viewProperties:(id)sender{
    
    GetAuctionsList *auction=[[GetAuctionsList alloc] initWithNibName:@"GetAuctionsList" bundle:[NSBundle mainBundle]];
    auction.countyID=countyID;
    XIBchange=@"1";
    self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:auction animated:YES];
    
}


-(IBAction)viewTrustees:(id)sender{
    
    GetAuctionsList *auction=[[GetAuctionsList alloc] initWithNibName:@"TrusteeList" bundle:[NSBundle mainBundle]];
    auction.countyID=countyID;
    XIBchange=@"0";
    self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:auction animated:YES];

}


-(IBAction)auctionStatus:(id)sender{
    
    AuctionStatusController *controller=[[AuctionStatusController alloc] initWithNibName:@"AuctionStatusController" bundle:nil];
    pushPOPStr=@"0";
    self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end
