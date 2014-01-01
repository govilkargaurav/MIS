//
//  AddLocationView.h
//  FitTag
//
//  Created by Shivam on 3/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@protocol setLocation <NSObject>
-(void)addLocationInPrevioseView:(NSMutableDictionary *)dictLocationInfo;
@end
@interface AddLocationView : UIViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>{

    IBOutlet UITextField *txtfldSearchLocation;
    UITextField *txtfldAddNewLocation;
    
    CLLocationManager *locationManager;
    
    NSMutableArray *mutArrNearByLocationList,*mutArrSearchDisplay,*mutArrLocationsAddedByUser;
    NSMutableDictionary *dictLatLong;
    
    MBProgressHUD *HUD;
    AppDelegate *appdelegateRefrence;
    
    BOOL isSearching;
}
@property(nonatomic,strong)id <setLocation> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tblViewNearByLocations;

-(void)getNearByLocations;
-(void)refereshNearByLocationList;
-(void)addNewCustomLocationInNearByPlaces;
-(void)addCustomLocation;
-(NSString *)removeNull:(NSString *)str;
@end
