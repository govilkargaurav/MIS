//
//  LawyerInfoViewController.h
//  LawyerApp
//
//  Created by ChintaN on 6/8/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "UICustomActionSheet.h"
#import "DejalActivityView.h"
@interface LawyerInfoViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate>{
    
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
    IBOutlet UITextField *txtFldWebSite;
    IBOutlet UITextField *txtFldServingCity;
    IBOutlet UITextField *txtFldAboutFirm;
    IBOutlet UIButton *btnUserImage;
    IBOutlet UIButton *btnFirmImage;
    NSMutableArray *arrFillTable;
    NSURLRequest *request;
    NSDictionary *dictionaryJSON;
    UIDatePicker *DatepickerView;
    UIToolbar *DatetoolBar;
    UITextField *globalTxtField;
    NSMutableDictionary *selectedIndexDict;
    int BUTTONTAGIMGUSERCOMPANY;
    DejalActivityView *loadingActivityIndicator;
}
-(IBAction)backBtnPressed:(id)sender;
-(IBAction)registrationBtnClicked:(id)sender;
-(IBAction)addUserImageButtonPressed:(id)sender;
@property (nonatomic,strong)NSMutableArray *arrLawyerInfo;
@property (nonatomic,strong)IBOutlet UIScrollView *_scrollView;
@property (nonatomic,strong)NSString *strIDCountry;
@property (nonatomic,strong)NSString *strIDLaw;
@property (nonatomic,strong)IBOutlet UITableView *_tableView;
@property (nonatomic,strong)NSMutableArray *arrLawIdList;
@property (nonatomic,strong)NSMutableArray *arrCountryList;
@end
