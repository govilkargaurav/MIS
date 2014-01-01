//
//  FindALawyerViewController.h
//  LawyerApp
//
//  Created by ChintaN on 7/26/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageControl.h"
#import "AppDelegate.h"
#import "DisplayMap.h"
#import <MapKit/MapKit.h>
@interface FindALawyerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate>{
    
    IBOutlet UIScrollView *scrollView;
    BOOL pageControlBeingUsed;
    IBOutlet UIView *View1;
    IBOutlet UIView *View2;
    IBOutlet UIView *View3;
    IBOutlet UIPageControl *pageControll;
    IBOutlet UILabel *lblTblInfo;
    IBOutlet UITextField *txtFldLawFirm;
    IBOutlet UITextField *txtFldStateCity;
    AppDelegate *appdelegate;
    NSOperationQueue *operationQueue;
    IBOutlet UIButton *btnTypeOfPane;
}
@property (nonatomic,strong)NSMutableDictionary *_dictJsonArr;
@property(nonatomic,strong)IBOutlet UITableView *tblViewLaw;
@property (nonatomic,strong)IBOutlet UITableView *tblViewState;
@property (nonatomic,strong)IBOutlet UITableView *tblViewCity;

@end
