//
//  Proffession.h
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProffessionPage2.h"
#import "ALPickerView.h"

@interface Proffession : UIViewController<UITextFieldDelegate,UITextViewDelegate,ALPickerViewDelegate>
{
    NSDictionary *results,*resultsOcc;
    
    // Toolbar for Texview Return
    UIToolbar *toolBar;
    
    // IBOutlet Declaration
    IBOutlet UITextField *tfBussName,*tfBussCategory,*occupationField;
    IBOutlet UITextView *txtDesc;
    
    //Multiple Selection in Picker
    ALPickerView *pickerView;
    NSMutableDictionary *selectionStates;
    UIToolbar *toolBar1;
    NSMutableArray *ArryOccuID,*ArryOccuName;
    
    NSString *strOccupationID;
    
    
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSURLConnection *ConnectionRequest;
    NSMutableArray *ArryOccupation;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Dic:(NSDictionary*)DValue;
-(IBAction)NextClicked:(id)sender;
-(void)CallPickerHide;
-(void)CallPickerShow;
@end
