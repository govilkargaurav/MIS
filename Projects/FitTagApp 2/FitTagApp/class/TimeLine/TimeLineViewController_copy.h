//
//  TimeLineViewController.h
//  FitTagApp
//
//  Created by apple on 2/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SettingViewController.h"
#import "FindChallengesViewConroller.h"
#import "TblCell.h"
#import "CacheManager.h"
#import "ActivityViewController.h"
#import "TimeLineCostumCell.h"
#import "AppDelegate.h"

@interface TimeLineViewController_copy : UIViewController<UINavigationBarDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
    PFObject *objChallengeInfo;
    PFUser *objUserInfo;
    PFUser *userForLike;
    ActivityViewController *activtyVC;
    CacheManager *_cMgr;
    TimeLineCostumCell *obj_SearchResult_Cell;
    AppDelegate *appdelegateRef;
    
    NSArray *arrLikes;
    NSMutableArray *arrUserData,*mutArrPagingResponce;
    NSMutableArray *arrLikesName;
    NSMutableArray *arrLikeUserId;
    NSMutableArray *arrClickUserLikeChallenge,*arrMoviePlayerObject;

    UITableViewCell *cell;
   
    int cellBtnTag;
    int commentSenderTag;
    int buttonIndexForShareDataOnSocial;
    int buttonTagForDeleteChallenge,addPlayButtonAtInadex;
    
    NSString *makecellNil;
    
    UIButton *buttonComment;
    UIButton *btnComment1;
    UIButton *btnComment2;
    UIButton *btnComment3;
    UIButton *btnComment4;
   
    UILabel *lblComment;
    UILabel *lblComment2;
    UILabel *lblComment3;
    UILabel *lblComment4;
    
    BOOL isLoading;
    BOOL isPullToRefresh;
    BOOL SingTimeRefresh;
}
#pragma mark Properties
@property (nonatomic,strong)NSMutableDictionary *_dictDddAvtar;
@property (nonatomic,strong)NSMutableDictionary *_dictprofileImage;
@property(strong,nonatomic)NSMutableArray *mAryCommentChallenge;
@property (strong, nonatomic) IBOutlet UITableView *tblTimeline;
@property (strong, nonatomic) IBOutlet UIView *viewHome;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRec;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,retain) IBOutlet UIView *activityIndicatorView;
@property (nonatomic,retain) UIActivityIndicatorView *footerActivityIndicator;
@property(nonatomic,retain)NSString *strSelectedTag;
@property(nonatomic)bool isOpen;

#pragma mark Set Left and right bar buttons in UINavigationBar
-(void)setNavigationComponent;
#pragma mark Click on Home Button Show and Hide Animation of menu
-(void)viewHomeOpenAnim;
-(void)viewHomeCloseAnim;
-(void)startAnimation;
-(void)stopAnimation;
#pragma mark Get All Challenges,Like and Comments of current login user
-(void)getUserAndChallengeDate;
#pragma mark call after comment on any challenge and press back button
-(void)commentbackAction;
#pragma mark Post on Twitter and Facebook
-(void)postToFcaebookUsersWall:(int )index;
-(void)postToTwitterAsTwitt:(int)index;
#pragma mark Play video Button Action
-(void)playMyVideo:(id)sender;
#pragma mark Menu buttons Actions
-(IBAction)btnHomePressed:(id)sender;
-(IBAction)btnSettingPressed:(id)sender;
-(IBAction)btnActivityPressed:(id)sender;
#pragma mark Comment Button Action
-(IBAction)btnCommentPressed:(id)sender;
#pragma Take Challenge Button Actions
-(IBAction)btnTakeChallengePressed:(id)sender;
@end
