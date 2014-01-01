//
//  Targets.h
//  AIS
//
//  Created by System Administrator on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupView.h"
#import "CustomCellTarget.h"
#import <CoreLocation/CoreLocation.h>
#import "AISAppDelegate.h"
#import "DetailVIew.h"
@interface Targets : UIViewController <UITableViewDelegate,UITableViewDataSource,wifiDelegate> {
	IBOutlet UITableView *tblView;
	IBOutlet UIView *detailView;
    
	IBOutlet CustomCellTarget *objCustCell;
  
    
	IBOutlet UILabel *detailMMSI;
    IBOutlet UILabel *detailCallSign;
    IBOutlet UILabel *detailLat;
    IBOutlet UILabel *detailLon;
    IBOutlet UILabel *detailCOG;
    IBOutlet UILabel *detailSOG;
    IBOutlet UILabel *detailHDG;
    IBOutlet UILabel *detailTime;
    IBOutlet UILabel *detailType;
    
    NSMutableArray *dataSource;
    NSMutableDictionary *dataDictionary;
	NSMutableArray *dataArrayName;
    NSMutableArray *dataMMSINum;
	
	CLLocation *currLoc;
    NSDictionary *unitssets ;
}
-(NSMutableArray*)sortedArray:(NSMutableArray*)arrayToSort;
-(IBAction)clickDone;
@end
