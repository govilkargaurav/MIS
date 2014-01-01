//
//  EditProfileViewController.h
//  MyMites
//
//  Created by apple on 9/17/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

{
    
    IBOutlet UITextField *firstNamefield;
    IBOutlet UITextField *lastNameField;
    IBOutlet UITextField *locationField;
    IBOutlet UITextField *emailIdField;
    IBOutlet UITextField *birthDate;
    IBOutlet UITextField *addressOneField;
    IBOutlet UITextField *addressTwoField;
    IBOutlet UITextField *cityField;
    IBOutlet UITextField *stateField;
    IBOutlet UITextField *countryField;
    IBOutlet UITextField *ZIPfield;
    IBOutlet UIImageView *imgProfile;
    NSString *strDOB;
    IBOutlet UIScrollView *scl_Profile;
    
    UIDatePicker *DatepickerView;
    UIToolbar *DatetoolBar;
    
    UITextField *tfAdd;
    NSString *strLocation;
    
}
@property(nonatomic,strong)NSDictionary *statuses;
@property(nonatomic,strong)NSDictionary *dictEditProfile;
@property(nonatomic,strong)NSURLRequest *requestMain;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Dic:(NSDictionary*)DValue;
-(void)activityRunning;
@end
