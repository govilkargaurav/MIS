//
//  SignUpViewController.h
//  Suvi
//
//  Created by apple on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "common.h"

@interface SignUpViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,NSURLConnectionDelegate>
{
    IBOutlet UIView *viewprofileupdate;
    IBOutlet UIImageView *imgviewcover;
    IBOutlet UIImageView *imgviewprofilepic;
    IBOutlet UILabel *lblCoverImageTap;
    IBOutlet UITextField *txtSchool;
    
    IBOutlet UIView *viewsignupbox;
    IBOutlet UITextField *firstNameField;
    IBOutlet UITextField *lastNameField;
    IBOutlet UITextField *txtBirthDate;
    IBOutlet UIButton *btnMale,*btnFemale;
    IBOutlet UITextField *txtlocationname;
    
    UIDatePicker *DatepickerView;
    UIDatePicker *datepiker;
    
    NSString *strGender;
    NSString *strsEmail;
    NSString *strsPassword;
    
    NSURLConnection *connection;
    NSMutableData *webData;
    NSMutableString *action;
    BOOL isProfileCreated;
    BOOL isselectedimagecover;
    
    UIButton *btnDropDownMask;
}
@property(nonatomic,strong)NSString *strsEmail;
@property(nonatomic,strong)NSString *strsPassword;
@property(nonatomic,strong)UITextField *alltextfield;
@property(nonatomic,assign) BOOL isProfileCreated;
@property(nonatomic,assign) BOOL isSignUpFromFB;
@property(nonatomic,readwrite) NSMutableDictionary *dictFacebook;

-(BOOL)validEmail:(NSString*)emailString;

-(void)_stopReceiveWithStatus:(NSString *)statusString;
-(void)_receiveDidStopWithStatus:(NSString *)statusString;
-(void)setData:(NSMutableDictionary*)dictionary;

-(void)signUpForaccount;
-(void)updateschoolinprofile;
-(void)updateProfile;

-(IBAction)DonePressed:(id)sender;
-(IBAction)radioButton:(id)sender;
-(IBAction)openDatePiker:(id)sender;
-(NSString *)setDateViaPicker:(NSDate *)datenew;

-(IBAction)btnJoiningBackClicked:(id)sender;
-(IBAction)btnJoiningNextClicked:(id)sender;
-(IBAction)btnCoverImageClicked:(id)sender;
-(IBAction)btnProfileImageClicked:(id)sender;
-(IBAction)TermsAndCondi:(id)sender;
-(IBAction)PrivacyPolicy:(id)sender;

@end
