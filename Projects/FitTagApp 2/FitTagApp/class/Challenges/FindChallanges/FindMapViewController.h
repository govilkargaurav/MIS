//
//  FindMapViewController.h
//  FitTagApp
//
//  Created by apple on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "AppDelegate.h"
#import "FindMapListViewController.h"

@interface FindMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,ListSelectionBack>{
    CLLocationManager *locationManager;
}
@property(strong,nonatomic)NSMutableArray *mutAryNearChallenge;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
-(IBAction)btnMapRefreshPressed:(id)sender;
-(void)getAnonations;
-(void)getNearChallenges;
-(IBAction)btnMapLocationPressed:(id)sender;
@end
