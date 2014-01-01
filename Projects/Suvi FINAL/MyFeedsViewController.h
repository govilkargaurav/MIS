//
//  MyFeedsViewController.h
//  Suvi
//
//  Created by Vivek Rajput on 11/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <CoreVideo/CoreVideo.h>

#import "Global.h"
#import "AppDelegate.h"
#import "common.h"
#import "ViewFeed.h"
#import "FeedComment.h"
#import "PostViewController.h"
#import "WatchVideoViewController.h"
#import "AddCommentView.h"
#import "AddFriendsViewController.h"

#import "UIImage+Utilities.h"
#import "AFPhotoEditorController.h"
#import "PullToRefreshView.h"
#import "StyleLabel.h"
#import "UIImageView+WebCache.h"
#import "NSString+Utilities.h"
#import "NSMutableDictionary+Utilities.h"
#import "MNMBottomPullToRefreshManager.h"

@interface MyFeedsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,NSURLConnectionDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,AFPhotoEditorControllerDelegate,PullToRefreshViewDelegate, MNMBottomPullToRefreshManagerClient,UIScrollViewDelegate,UITextFieldDelegate,UIWebViewDelegate,UIAlertViewDelegate>
{
    PullToRefreshView *pull;
    MNMBottomPullToRefreshManager *pullToRefreshManager_;
    NSMutableDictionary *dictWebViews;
    IBOutlet UITableView *TblView;
    UIImagePickerController *ImgPicker;
    
    NSString *action;
    NSURLConnection *connection;
    NSMutableData *webData;
    
    IBOutlet UIView *viewHeader;
    
    IBOutlet UILabel *lblUserNameTOP;
    
    IBOutlet StyleLabel *lblUserName;
    IBOutlet StyleLabel *lblNumOfFriends;
    IBOutlet UIImageView *imgProfile;
    
    IBOutlet UIImageView *imgBadge;
    
    IBOutlet StyleLabel *lblstatus;

    IBOutlet UIImageView *imgCoverPic;
    IBOutlet UIButton *btnCoverPic;
    IBOutlet UIView *viewmenu;
    BOOL isSelectedImageCover;
    NSString *imgFlag;
}
@property (nonatomic,retain)NSString *imgFlag;
@property(nonatomic,retain)NSString *action;

@property(nonatomic,strong)IBOutlet UITableView *TblView;
@property (nonatomic, strong) IBOutlet UIView *viewHeader;

-(void)customiseNavBar;
-(void)refreshHeader;
-(void)updateInviteCount;
-(void)updateInitialTable;
-(void)loadFeeds;
-(void)loadFeedUpdates;
-(void)loadOlderFeeds;

-(void)pushfriendview;
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;

-(void)ReloadTableData;
-(void)_stopReceiveWithStatus:(NSString *)statusString;
-(void)_receiveDidStopWithStatus:(NSString *)statusString;
-(void)setData:(NSDictionary*)dictionary;

-(IBAction)CameraClicked:(id)sender;
-(IBAction)ShareCliked:(id)sender;
-(IBAction)btnLocationClicked:(id)sender;
-(IBAction)videoPost:(id)sender;
-(IBAction)musicPost:(id)sender;
-(IBAction)WatchVideo:(id)sender;

-(NSString *)removeNull:(NSString *)str;

- (IBAction)thumbnilImage:(id)sender;
-(IBAction)Like:(id)sender;
-(void)_Like:(NSString *)type :(NSString *)iActivityID;
-(IBAction)UNLike:(id)sender;
-(void)_UNLike:(NSString *)type :(NSString *)iActivityID;
-(IBAction)AddComment:(id)sender;

-(void)openCamera;
-(void)openLibrary;
-(void)NotiforIMGPost:(UIImage *)image;
-(void)TakeVideo;
-(void)ChooseVideo;
-(void)NotiforVideoPost:(NSURL *)url;

-(IBAction)btnStatusSelectedClicked:(id)sender;

@property(nonatomic,strong)NSMutableData *dataProfileImage;
@property(nonatomic,strong)NSMutableData *dataCoverImage;
-(IBAction)btnProfilePicChangeClicked:(id)sender;
-(IBAction)btnCoverPicChangeClicked:(id)sender;
-(void)_updateImage:(NSNotification *)notif;
-(void)tapGest:(UITapGestureRecognizer *)gest;
-(void)_deleteHandler:(NSString *)type :(NSString *)iActivityID;

@end
