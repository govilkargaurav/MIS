//
//  ProfileViewController.h
//  FitTagApp
//
//  Created by apple on 2/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "EGOImageButton.h"
#import "EGOImageView.h"
#import "CacheManager.h"

#import "TblCell.h"
#import "TimeLineCostumCell.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
@class TblCell;
@interface ProfileViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>{

    CacheManager *_cMgr;
    AppDelegate *appDelegate;
    NSMutableArray *arrFollower;
    PFObject *objFollow;
    IBOutlet UILabel *lblLikeCount;
    IBOutlet UILabel *lblLikeChallengeCount;
    TimeLineCostumCell *obj_SearchResult_Cell;
    NSMutableArray *arrFilterLikeChallenge;
    BOOL isLike;
    BOOL IsLiked;
    PFObject *objChallengeInfo;
    int commentSenderTag;
    IBOutlet UITableView *tblLike;
    IBOutlet UIView *anmatidView;
    IBOutlet UILabel *lblChallengeAndLike;
    UIButton *buttonComment;
    UILabel *lblComment;
    UIButton *btnComment1;
    UIButton *btnComment2;
    UIButton *btnComment3;
    UIButton *btnComment4;
    
    UILabel *lblComment2;
    UILabel *lblComment3;
    UILabel *lblComment4;
    
    IBOutlet UIButton *btnTabCreated;
    IBOutlet UIButton *btnTabLikeChallenge;
    IBOutlet UIButton *btnTabFollower;
    IBOutlet UIButton *btnTabFollowing;
    IBOutlet UIButton *btnOpenUrl;
    
    IBOutlet UIButton *btnBlock;
    IBOutlet UIButton *btnLikeTab;
    IBOutlet UIImageView *imgBlock;
    
    NSMutableArray *temparrFollower;
    NSMutableArray *temparrFollowing;
    NSMutableArray *arrBlockUserData;
    int buttonTagForDeleteChallenge,addPlayButtonAtInadex;
    int buttonIndexForShareDataOnSocial;
    
    NSMutableArray *arrCopyCreatedChallenge,*arrMoviePlayerObjectLike,*arrMoviePlayerObjectCreated;
    
    BOOL iscreated,isFirstload;
    
    // Flash vertical scroller method
    
    NSTimer *timerScrollerFlash;
    
    BOOL isNavigationgFirstTime;

}

@property(strong,nonatomic)NSMutableArray *arrBlockUsers;
@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;
@property (strong, nonatomic) IBOutlet UILabel *lbl3;
@property (strong, nonatomic) IBOutlet UILabel *lbl4;
@property (strong, nonatomic) IBOutlet EGOImageView *btnProfileImg;
@property (strong, nonatomic) IBOutlet UILabel *lblFollowerCount;
@property (strong, nonatomic) IBOutlet UILabel *lblFollowingCount;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UITextView *txtViewBIO;
@property (strong, nonatomic) IBOutlet UILabel *lblWebSite;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UIView *viewProfileUpper;

@property (strong, nonatomic) IBOutlet UIButton *btnFollow;
@property (strong, nonatomic) IBOutlet UIButton *btnClngCreated;
@property (strong, nonatomic) IBOutlet UIButton *btnClngLiked;
@property (strong, nonatomic) IBOutlet UIView *viewMenu;
//ß∫@property (strong,nonatomic)NSMutableArray *arrUserLikeXhallenge;
@property (strong, nonatomic) IBOutlet UITableView *tblCreated;

@property (strong, nonatomic) IBOutlet UILabel *lblCreatedTabValue;

@property (strong, nonatomic) IBOutlet UILabel *lblCreatedValue;
@property(strong,nonatomic)NSMutableArray *mutArrayCreatedChlng;
@property(nonatomic)bool isOpen;
@property (strong, nonatomic) IBOutlet UILabel *lblLocationName;

@property(strong,nonatomic)PFUser *profileUser;

-(IBAction)btnCreatedPressed:(id)sender;
-(IBAction)btnLikedPressed:(id)sender;
-(IBAction)btnBlockedPressed:(id)sender;
-(IBAction)btnOpenUrlClicked:(id)sender;
-(IBAction)btnSharePressed:(id)sender;
-(void)getUserCreatedChallenge;

-(void)viewMenuOpenAnim;
-(void)viewMenuCloseAnim;
-(void)getCommentsInMainView123:(id)sender;
-(void)commentbackAction123;
-(void)followUser;
-(void)unfollowUser;
-(void)postToFcaebookUsersWall:(int )index;
-(void)postToTwitterAsTwitt:(int)index;
@end
