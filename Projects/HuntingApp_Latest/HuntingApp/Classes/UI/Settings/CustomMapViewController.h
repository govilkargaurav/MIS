//
//  CustomMapViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomMapCalloutView.h"

@protocol CustomMapViewControllerDelegate <NSObject>

- (void)dismissCustomMapController;

@end

@interface CustomMapViewController : UIViewController<MKMapViewDelegate,CustomMapCalloutViewDelegate,RequestWrapperDelegate>
{
    IBOutlet MKMapView *mapView;
    CLGeocoder *reverseGeocoder;
    NSString *state;
    NSString *customLocation;
    WebServices *saveFavLocRequest;
    DejalActivityView *loadingActivityIndicator;
    
}
@property (nonatomic, retain)NSArray *_products;
@property (nonatomic, assign) id<CustomMapViewControllerDelegate> delegate;
@property (nonatomic) CLLocationCoordinate2D mapCoordinate;

- (IBAction)dropPin:(id)sender;
- (IBAction)doneBtnSelected:(id)sender;
@end
