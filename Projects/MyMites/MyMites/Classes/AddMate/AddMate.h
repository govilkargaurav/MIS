//
//  AddMate.h
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "BusyAgent.h"

@interface AddMate : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITextField *tfName,*tfOccu,*tfLoca;
    
    IBOutlet UIButton *btnOccupation,*btnLocation;
    int settag;
    id objectTextField;
    //PickerView -----------------------------
    UIPickerView *pickerView;
    UIToolbar *toolBar;
    int catID;
    
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSDictionary *results;
    NSURLConnection *ConnectionRequest;
    NSMutableArray *ArryOccupation,*ArryLocation;
    IBOutlet UITableView *occuPationTableView;
}
@property(nonatomic,strong)NSMutableArray *tableData;
-(void)CallPickerHide;
-(void)CallPickerShow;
@end
