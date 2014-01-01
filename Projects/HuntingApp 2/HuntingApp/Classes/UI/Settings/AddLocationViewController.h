//
//  AddLocationViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetStringPicker.h"
#import "CustomMapViewController.h"

@interface AddLocationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, RequestWrapperDelegate,CustomMapViewControllerDelegate>
{
    UIView *titleView;
    ActionSheetStringPicker *locationPicker;
    int selectedLocation;
    NSArray *stateArray;
    NSArray *countiesArray;
    NSMutableArray *favLocations;
    IBOutlet UITableView *tblView;
    WebServices *deleteLocationRequest;
}
@property (nonatomic) BOOL isLoggedFirstTime;
- (IBAction)showLocationPicker:(id)sender;
- (IBAction)PinYourCustomLocation:(id)sender;
@end
