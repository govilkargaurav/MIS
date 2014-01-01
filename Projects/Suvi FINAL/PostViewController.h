//
//  PostViewController.h
//  Suvi
//
//  Created by Vivek Rajput on 10/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>

#import "common.h"
#import "IamWithViewController.h"
#import "IamAtViewController.h"
#import "AppDelegate.h"
#import "FbGraph.h"
#import "OAuthLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"
#import "FBConnect.h"

@class OAuthTwitter, OAuth, CustomLoginPopup, FoursquareLoginPopup;

@interface PostViewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,NSURLConnectionDelegate,oAuthLoginPopupDelegate,TwitterLoginUiFeedback,FBSessionDelegate,FBDialogDelegate,FBRequestDelegate>
{
    
    IBOutlet UIImageView* imgTopLabel;
    IBOutlet UIImageView* imgTextBg;
    
    IBOutlet UIView *viewPostMain;
    IBOutlet UITextView *txtViewPost;
    
    IBOutlet UIImageView *imgProfilePic;
    IBOutlet UILabel *lblPostTitle;
    IBOutlet UILabel *lblPostDate;
    
    IBOutlet UIButton *btnIAmWith;
    IBOutlet UIButton *btnIAmAt;
    
    IBOutlet UIButton *btnfacebook;
    IBOutlet UIButton *btntwitter;
    IBOutlet UIButton *btnfoursquare;
    IBOutlet UIView *viewUpperBorder;
    
    BOOL issharedonfb;
    BOOL issharedontwitter;
    BOOL issharedonfoursquare;
    
    BOOL isLocationPostingView;
    BOOL isYouTubePostingView;
    BOOL isMusicPostingView;
    
    IBOutlet UIImageView *imgImWithAt;
    
    NSMutableArray *arrfriends;
    NSMutableArray *arrcontacts;
    NSURL *videoURL;
    NSMutableDictionary *locationdata;
    
    OAuthTwitter *oAuthTwitter;
    CustomLoginPopup *loginPopup;
    FoursquareLoginPopup *loginPopupFSQ;
    OAuth *oAuth4sq;
    NSInteger socialnwtype;
    
    IBOutlet UIView *viewpostToolbar;
}

@property(nonatomic,retain)UIImage *imgIAmWith;

@property(nonatomic,retain)NSURL *videoURL;
@property(nonatomic,retain)UIImage *imgToPost;
@property(nonatomic,retain)NSMutableDictionary *locationdata;
@property(nonatomic,retain)NSMutableDictionary *muzikDict;

@property(nonatomic,assign) BOOL isLocationPostingView;
@property(nonatomic,assign) BOOL isMusicPostingView;
@property(nonatomic,assign) BOOL isYouTubePostingView;

@property (nonatomic, retain) FbGraph *fbGraph;
@property (retain, nonatomic) OAuthTwitter *oAuthTwitter;
@property (retain, nonatomic) OAuth *oAuth4sq;
@property (nonatomic, strong) Facebook *facebook;
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

@end
