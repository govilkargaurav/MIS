//
//  RootViewController.h
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgreementView.h"
#import "JSON.h"
#import "SearchResult.h"
#import "FsenetAppDelegate.h"
#import "BusyAgent.h"

@interface RootViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    id objectTextField;
    IBOutlet UITextField *tfSFor,*tfSLocation;
    IBOutlet UIButton *btnOccupation,*btnLocation;
    int settag;
    
    FsenetAppDelegate *appDel;
    
    //PickerView -----------------------------
    UIPickerView *pickerView;
    UIToolbar *toolBar;
    int catID;
    NSString *strOccuId;
    
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSDictionary *results;
    NSURLConnection *ConnectionRequest;
    NSMutableArray *ArryOccupation,*ArryLocation;
    IBOutlet UITableView *occuPationTableView;
    
}

@property(nonatomic,strong)NSString *gettableDataStr;
@property(nonatomic,strong)NSMutableArray *gettableDatastrArr;

@property(nonatomic,strong)NSMutableArray *tableData;

-(void)CallPickerHide;
-(void)CallPickerShow;
-(IBAction)SearchClicked:(id)sender;

@end
