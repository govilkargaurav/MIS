//
//  ContactUsViewCtr.h
//  MyMites
//
//  Created by Mac-i7 on 1/31/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ContactUsViewCtr : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UITextField *tfName,*tfSubject,*tfEmail,*tfPhoneno;
    IBOutlet UITextView *txtMsg;
    
    //PickerView -----------------------------
    UIPickerView *pickerView;
    UIToolbar *toolBar;
    int catID;
    
    NSMutableArray *ArraySubject;
    
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSDictionary *results;
    NSURLConnection *ConnectionRequest;

}
@end
