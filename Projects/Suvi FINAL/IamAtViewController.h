//
//  IamAtViewController.h
//  Suvi
//
//  Created by Vivek Rajput on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BZFoursquare.h"
#import "MapPoint.h"

@interface IamAtViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MKMapViewDelegate, CLLocationManagerDelegate,BZFoursquareRequestDelegate, BZFoursquareSessionDelegate>
{
    IBOutlet UITableView *tblview;
    UISearchBar *searchbar;
    UIView *headerview;
    MKMapView *mapView;

    NSURLConnection *connection;
    NSMutableData *webData;
    NSMutableArray *locationdataarray;
    NSMutableArray *locationsearchdataarray;
    
    BZFoursquare        *foursquare;
    BZFoursquareRequest *fsqrequest;
    BOOL issearchEnabled;
    BOOL isLocationPostView;
    UIImageView *imgviewtblfooter;
    BOOL isFirstTimeDataLoad;
}
-(IBAction)btnbackclicked:(id)sender;

@property(nonatomic,strong) BZFoursquare *foursquare;
@property(nonatomic,strong) BZFoursquareRequest *fsqrequest;
@property(nonatomic,strong) UISearchBar *searchbar;
@property(nonatomic,strong) UIView *headerview;
@property(nonatomic,assign) BOOL isLocationPostView;

- (void)plotPositions:(NSMutableArray *)data;
-(void)searchLocations;
-(void)searchLocationsByName;
@end
