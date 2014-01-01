//
//  MapViewControllerViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationManager.h"
#import "LocationTracker.h"
#import "myPos.h"
#import "NotificationViewController.h"
#import "WEPopoverController.h"
#import "MapTypeTableViewController.h"
#import "FavLocTableViewController.h"
#import "AlbumViewController.h"
#import "GetImageInfo.h"

@interface MapViewControllerViewController : UIViewController<MKMapViewDelegate,RequestWrapperDelegate,UIPopoverControllerDelegate,NotificationPickerDelegate,AlbumViewDelegate,GetImageInfoDelegate>
{
    UIView *titleView;
    NSArray *favLocations;
    IBOutlet UIImageView *bg;
    //IBOutlet UIScrollView *timelineView;
    DejalActivityView *loadingActivityIndicator;
    WebServices *searchImageRequest;
    WebServices *getNotificationsRequest;
    WebServices *likeRequest;
    WebServices *getImageRequest;
    NSString *imageIDLiked;
    NSString *imageIDToFetch;
    NSMutableArray *picArray;
    NSMutableArray *btnImageViews;
    NSMutableArray *lblViews;
    Picture *selectedImage;
    NSString *IDSelected;
    WEPopoverController *popOverController;
    BOOL isloading;
    BOOL hasAppearedFirstTime;
    BOOL shouldShowMapTypeDropDown;
    IBOutlet UILabel *lblTimeline;
    BOOL shouldLoadTimeLine;
    MapTypeTableViewController *mapTypeController;
    FavLocTableViewController *favLocController;
    BOOL likeSelected;
    BOOL commentSelected;
    NSMutableArray *notificationsArray;
    NSMutableArray *imageFromSearch;
    BOOL shouldReload;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL isCurrentViewMapView;
@property (retain, nonatomic) IBOutlet UITableView *timeLine;

- (IBAction)changeHomeView:(id)sender;
- (void)removeAllRequests;

@end
