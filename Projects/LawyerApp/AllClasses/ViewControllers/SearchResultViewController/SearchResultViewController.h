//
//  SearchResultViewController.h
//  LawyerApp
//
//  Created by Openxcell Game on 6/7/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

@interface SearchResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>{

    IBOutlet UILabel *lblareaOfLaw;
    IBOutlet UILabel *lblCountryName;
    IBOutlet UILabel *lblofficeEndTime;
    IBOutlet UILabel *lblofficeStartTime;
    IBOutlet UILabel *lblaboutFirm;
    IBOutlet UILabel *lblAdmissionInfo;
    IBOutlet UILabel *lblAddress;
    IBOutlet UILabel *lblCity;
    IBOutlet UILabel *lblEducation;
    IBOutlet UILabel *lblEmail;
    IBOutlet UILabel *lblFirmAddress;
    IBOutlet UILabel *lblFirmCity;
    IBOutlet UILabel *lblFirmName;
    IBOutlet UILabel *lblFullName;
    IBOutlet UILabel *lblPhone;
    IBOutlet UILabel *lblPrice;
    IBOutlet UILabel *lblState;
    IBOutlet UILabel *lblWebsite;
    NSOperationQueue *_queue;
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UIView *viewFirm;
    IBOutlet UIImageView *userImageView;
    IBOutlet MKMapView *mapView;
    IBOutlet UILabel *lblStatus;
    IBOutlet UIImageView *ImageFirmLogo;
    IBOutlet UIWebView *wbView;
    CLLocationManager *locationManager;
}

-(IBAction)backBtnPressed:(id)sender;
@property(nonatomic,strong)IBOutlet UITableView *tblView;
@property(nonatomic,strong)IBOutlet UIView *headerViewSectionOne;
@property(nonatomic,strong)IBOutlet UIView *headerViewSectionTwo;
@property(nonatomic,strong)NSString *_strlawyerId;
@property(nonatomic,strong)NSMutableArray *_arrLawyerInfo;
@property(nonatomic,strong)AppDelegate *appdelegate;

@end
