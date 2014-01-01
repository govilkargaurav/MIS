//
//  SettingViewController.h
//  Suvi
//
//  Created by Dhaval Vaishnani on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "common.h"
#import "FbGraph.h"
#import "OAuthLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"
#import "UIImageView+WebCache.h"
#import "NSString+Utilities.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "FBConnect.h"

@class OAuthTwitter, OAuth, CustomLoginPopup, FoursquareLoginPopup;

@interface SettingViewController : UIViewController<UIScrollViewDelegate,NSURLConnectionDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,oAuthLoginPopupDelegate,TwitterLoginUiFeedback,MFMailComposeViewControllerDelegate>
{
    OAuthTwitter *oAuthTwitter;
    CustomLoginPopup *loginPopup;
    FoursquareLoginPopup *loginPopupFSQ;
    OAuth *oAuth4sq;
    NSInteger socialnwtype;
    
    BOOL isselectedimagecover;
    
    NSURLConnection *connection;
    NSMutableData *webData;
    NSMutableString *action;
    NSMutableString *actionurl;
    NSMutableString *actionparameters;
    
    IBOutlet UIScrollView *scrollViewobj;
    IBOutlet UIView *viewsettings;
    
    IBOutlet UIImageView *imgcoverimage;
    IBOutlet UIImageView *imgprofileimg;
    
    IBOutlet UITextField *txtfirstname;
    IBOutlet UITextField *txtlastname;
    IBOutlet UITextField *txtphonenumber;
    IBOutlet UITextField *txtschool;
    IBOutlet UITextField *txtlocationname;
    IBOutlet UITextField *txtpassword;
    
    IBOutlet UIButton *btnChangePassword;
    
    IBOutlet UIButton *btnfacebookshare;
    IBOutlet UIButton *btntwittershare;
    IBOutlet UIButton *btnfoursquareshare;
    IBOutlet UIButton *btnfacebookshare2;
    IBOutlet UIButton *btntwittershare2;
    IBOutlet UIButton *btnfoursquareshare2;
    
    IBOutlet UIButton *btnmailnot_frireq;
    IBOutlet UIButton *btnmailnot_postfri;
    IBOutlet UIButton *btnmailnot_comment;
    IBOutlet UIButton *btnmailnot_postofme;
    IBOutlet UIButton *btnmobilenot_frireq;
    IBOutlet UIButton *btnmobilenot_postfri;
    IBOutlet UIButton *btnmobilenot_comment;
    IBOutlet UIButton *btnmobilenot_postofme;
    
    IBOutlet UISwitch *switchSearchable;
    
    IBOutlet UIButton *btnTermsOfUse;
    IBOutlet UIButton *btnSignOut;
    
    UITextField *txtOldPassword;
    UITextField *txtNewPassword;
    UITextField *txtConfirmPassword;
    
    UIButton *btnDropDownMask;
    
    UIImageView *imgTempStore;
}

@property(nonatomic,strong)UIImageView *imgTempStore;
@property (nonatomic, strong) Facebook *facebook;
@property (retain, nonatomic) OAuthTwitter *oAuthTwitter;
@property (retain, nonatomic) OAuth *oAuth4sq;

-(void)resetUi;
-(void)handleOAuthVerifier:(NSString *)oauth_verifier;

-(void)tokenRequestDidStart:(TwitterLoginPopup *)twitterLogin;
-(void)tokenRequestDidSucceed:(TwitterLoginPopup *)twitterLogin;
-(void)tokenRequestDidFail:(TwitterLoginPopup *)twitterLogin;
-(void)authorizationRequestDidStart:(TwitterLoginPopup *)twitterLogin;
-(void)authorizationRequestDidSucceed:(TwitterLoginPopup *)twitterLogin;
-(void)authorizationRequestDidFail:(TwitterLoginPopup *)twitterLogin;
-(void)oAuthLoginPopupDidCancel:(UIViewController *)popup; 
-(void)oAuthLoginPopupDidAuthorize:(UIViewController *)popup; 
-(void)oauth_verifier_received:(NSNotification *)notification;

@property (nonatomic, retain) FbGraph *fbGraph;
-(void)updatesocialbuttons;

-(IBAction)btnbackclicked:(id)sender;
-(IBAction)SendEmail:(id)sender;
-(IBAction)btnChangeProfilePic:(id)sender;
-(IBAction)btnChangeCoverPic:(id)sender;
-(IBAction)btnUpdatePassword:(id)sender;

-(IBAction)btnAuthoriseFacebookClicked:(id)sender;
-(IBAction)btnAuthoriseTwitterClicked:(id)sender;
-(IBAction)btnAuthoriseFoursquareClicked:(id)sender;
-(IBAction)btnUnAuthoriseFacebookClicked:(id)sender;
-(IBAction)btnUnAuthoriseTwitterClicked:(id)sender;
-(IBAction)btnUnAuthoriseFoursquareClicked:(id)sender;

-(IBAction)btnMailNotificationClicked:(id)sender;
-(IBAction)btnMobileNotificationClicked:(id)sender;

-(IBAction)switchSearchableValueChanged:(id)sender;

-(IBAction)btnTermsOfUseClicked:(id)sender;
-(IBAction)btnSignOutClicked:(id)sender;

-(void)loadlocations;
-(void)updateProfile;
-(void)_startSend;
-(void)_updateImage;
-(void)_stopReceiveWithStatus:(NSString *)statusString;
-(void)_receiveDidStopWithStatus:(NSString *)statusString;
-(void)setData:(NSDictionary*)dictionary;

@end
