//
//  KeypadVC.h
//  T&L
//
//  Created by apple apple on 6/23/12.
//  Copyright (c) 2012 bvhkh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeypadVC : UIViewController
{
    IBOutlet UIImageView *imgView1;
    IBOutlet UIImageView *imgView2;
    IBOutlet UIImageView *imgView3;
    IBOutlet UIImageView *imgView4;
    IBOutlet UIImageView *imgView5;
    NSMutableArray *aryPinCode;
    NSMutableArray *aryImages;
    IBOutlet UIButton *btnPin1,*btnPin2,*btnPin3,*btnPin4,*btnPin5,*btnPinClear;
}

-(IBAction)Keyboardbtn:(id)sender;
-(IBAction)Cancelbtn:(id)sender;
@end
