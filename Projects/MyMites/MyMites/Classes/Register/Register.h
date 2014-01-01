//
//  Register.h
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALPickerView.h"
#import "JSON.h"
#import "FsenetAppDelegate.h"

@interface Register : UIViewController<UITextFieldDelegate,UITextViewDelegate,ALPickerViewDelegate>
{
    IBOutlet UITextField *tfEmail,*tfPassWord,*tfCPassWord,*tfFName,*tfLName,*tfCity,*tfState,*tfCountry,*tfLocation,*tfOccupation,*tfDob;
    IBOutlet UIScrollView *Scl_Regi;
    IBOutlet UITextField *tfAdd;
    NSString *strLocation;
    
    //Multiple Selection in Picker
    ALPickerView *pickerView;
    NSMutableDictionary *selectionStates;
    UIToolbar *toolBar;
    NSMutableArray *ArryOccuID,*ArryOccuName;
    
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSDictionary *results;
    NSURLConnection *ConnectionRequest;
    NSMutableArray *ArryOccupation;
    
    
    UIDatePicker *DatepickerView;
    UIToolbar *DatetoolBar;
     NSString *strDOB;
}

-(IBAction)CancelCliked:(id)sender;
-(IBAction)RegisterCliked:(id)sender;
-(void)CallPickerHide;
-(void)CallPickerShow;

@end
