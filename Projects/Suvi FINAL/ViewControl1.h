//
//  ViewControl1.h
//  Path
//
//  Created by apple apple on 8/6/12.
//  Copyright (c) 2012 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "common.h"
#import "ViewFeed.h"
#import "FeedComment.h"

#import "PostViewController.h"

#import "WatchVideoViewController.h"

#import "AddCommentView.h"
#import "FriendsProfileVC.h"
#import "HomeViewController.h"
#import "Global.h"
#import "PullToRefreshView.h"
#import "AddFriendsViewController.h"
#import "StyleLabel.h"
#import "UIImageView+WebCache.h"
#import "NSString+Utilities.h"
#import "NSMutableDictionary+Utilities.h"
#import "MNMBottomPullToRefreshManager.h"
#import "NSAttributedString+Extension.h"


@interface ViewControl1 : UIViewController<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,NSURLConnectionDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,PullToRefreshViewDelegate,MNMBottomPullToRefreshManagerClient,UITextFieldDelegate,UIWebViewDelegate,UIScrollViewDelegate>
{
    PullToRefreshView *pull;
    MNMBottomPullToRefreshManager *pullToRefreshManager_;
    
    IBOutlet UITableView *TblView;
    UIImagePickerController *ImgPicker;
    
    NSInteger statusindex;
    
    int FlagCamera;
    
    NSString *action;
    NSURLConnection *connection;
    NSMutableData *webData;
    NSMutableDictionary *dictWebViews;
    UIImage *imgToPost;
    
    IBOutlet UIView *viewmenu;
}
@property (nonatomic,retain)NSString *imgFlag;
@property(nonatomic,retain)NSString *action;

@property(nonatomic,strong)IBOutlet UITableView *TblView;

-(void)customiseNavBar;
-(void)updateInviteCount;
-(void)updateInitialTable;
-(void)loadFeeds;
-(void)loadFeedUpdates;
-(void)loadOlderFeeds;

-(IBAction)CameraClicked:(id)sender;
-(IBAction)ShareCliked:(id)sender;
-(IBAction)btnLocationClicked:(id)sender;
-(IBAction)videoPost:(id)sender;
-(IBAction)musicPost:(id)sender;

-(void)openCamera;
-(void)openLibrary;
-(void)NotiforIMGPost:(UIImage *)image;

-(void)TakeVideo;
-(void)ChooseVideo;
-(void)NotiforVideoPost:(NSURL *)url;

-(void)pushfriendview;

//PullToRefresh
-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
-(void)ReloadTableData;
-(void)_stopReceiveWithStatus:(NSString *)statusString;
-(void)_receiveDidStopWithStatus:(NSString *)statusString;
-(void)setData:(NSDictionary*)dictionary;

//Video Watch
-(NSString *)removeNull:(NSString *)str;
-(IBAction)thumbnilImage:(id)sender;
-(IBAction)Like:(id)sender;
-(void)_Like:(NSString *)type :(NSString *)iActivityID;
-(IBAction)UNLike:(id)sender;
-(void)_UNLike:(NSString *)type :(NSString *)iActivityID;
-(IBAction)AddComment:(id)sender;

#pragma mark - Delete Post
-(void)_deleteHandler:(NSString *)type :(NSString *)iActivityID;

@end
