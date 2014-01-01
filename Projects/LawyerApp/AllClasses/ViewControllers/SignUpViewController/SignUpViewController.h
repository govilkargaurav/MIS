//
//  SignUpViewController.h
//  LawyerApp
//
//  Created by Openxcell Game on 6/6/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DejalActivityView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@interface SignUpViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate>{
 
    IBOutlet UITextField *txtFldWebSite;
    IBOutlet UITextField *txtFldServingCity;
    IBOutlet UITextField *txtFldAboutFirm;
    IBOutlet UITextField *txtFldFirstName;
    IBOutlet UITextField *txtFldLastName;
    IBOutlet UITextField *txtFldEmail;
    IBOutlet UITextField *txtFldPassword;
    IBOutlet UITextField *txtFldAddress1;
    IBOutlet UITextField *txtFldAddress2;
    IBOutlet UITextField *txtFldFirmName;
    IBOutlet UITextField *txtFldCity;
    IBOutlet UITextField *txtFldPhNumber;
    IBOutlet UITextField *txtFldState;
    IBOutlet UITextField *txtFldPrice;
    IBOutlet UITextField *txtFldFirmAddress1;
    IBOutlet UITextField *txtFldFirmAddress2;
    IBOutlet UITextField *txtFldEducation;
    IBOutlet UITextField *txtFldContryId;
    IBOutlet UITextField *txtFldAddmissionInfo;
    IBOutlet UITextField *txtFldLawId;
    IBOutlet UITextField *txtFldOfficeStartTime;
    IBOutlet UITextField *txtFldOfficeEndTime;
    IBOutlet UIButton *btnUserImage;
    IBOutlet UIButton *btnFirmImage;
    IBOutlet UIImageView *imgUser;
    IBOutlet UIImageView *imgFirm;
    NSMutableArray *arrFillTable;
    int BUTTONTAGIMGUSERCOMPANY;
    int SUBSCRIPTION_ID;
    NSURLRequest *request;
    NSDictionary *dictionaryJSON;
    UIDatePicker *DatepickerView;
    UIToolbar *DatetoolBar;
    UITextField *globalTxtField;
    NSMutableDictionary *selectedIndexDict;
}
@property (nonatomic,strong)NSString *strIDCountry;
@property (nonatomic,strong)NSString *strIDLaw;
@property (nonatomic,strong)IBOutlet UITableView *_tableView;
@property (nonatomic,strong)NSMutableArray *arrLawIdList;
@property (nonatomic,strong)NSMutableArray *arrCountryList;
@property (nonatomic,strong)NSString *strSubscriptionIdentifire;
@property (nonatomic,strong)DejalActivityView *loadingActivityIndicator;
@property (nonatomic,strong)IBOutlet UIView *backView;
@property (nonatomic,strong)IBOutlet UIScrollView *scrlView;
@property (nonatomic,strong)IBOutlet UIView *viewInApp;
@property (strong,nonatomic)NSArray *_products;
-(IBAction)backBtnPressed:(id)sender;
-(void)OpenFieldsForSignUpAccordingToSubscription:(NSString *)strSubscription;
-(void)checkReceipt:(NSData *)receipt;
-(void)hideActivity;
@end
