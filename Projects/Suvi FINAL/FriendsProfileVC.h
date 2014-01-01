//
//  FriendsProfileVC.h
//  Suvi
//
//  Created by Vivek Rajput on 11/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewFeed.h"
#import "AddCommentView.h"
#import "UIImageView+WebCache.h"
#import "MNMBottomPullToRefreshManager.h"
#import "HPGrowingTextView.h"

@interface FriendsProfileVC : UIViewController<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,NSURLConnectionDelegate,UIImagePickerControllerDelegate, MNMBottomPullToRefreshManagerClient,UIScrollViewDelegate,HPGrowingTextViewDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
    MNMBottomPullToRefreshManager *pullToRefreshManager_;
    
    IBOutlet UITableView *TblView;
    UIImagePickerController *ImgPicker;
    NSMutableDictionary *dictWebViews;
    NSString *action;
    NSURLConnection *connection;
    NSMutableData *webData;
    NSMutableArray *arrContent;
   
    IBOutlet UIView *viewHeader;
    
    IBOutlet UILabel *lblUserNameTOP;
    
    
    IBOutlet UIImageView *imgProfile;
    
    NSString *strTotalPageCount;
    int PageCount;
    IBOutlet UIImageView *imgBadge;
    
    IBOutlet UIImageView *imgCoverPic;
    IBOutlet UIButton *btnCoverPic;
    
    BOOL shouldShowOnlyOneFeed;
    
    BOOL shouldUpdateFriendFeeds;
    
    // Button and Image Change According to View From
    IBOutlet UIImageView *imgTopNavBar;
    IBOutlet UIButton *btnAddFriend,*btnWinkFriend,*btnNoteFriend;
    
    // Auto Expand TextField
    UIView *containerView;
    HPGrowingTextView *tfautoExpandPost;
    BOOL SetKeyBoardTag;
    
    // View From
    NSString *strFrom;
}

@property (nonatomic,strong) IBOutlet UITableView *TblView;

@property (nonatomic,assign) BOOL shouldShowOnlyOneFeed;
@property(nonatomic,retain)NSString *admin_id;
@property(nonatomic,retain)NSString *action;
@property(nonatomic,readwrite)int PageCount;
@property(nonatomic,retain)NSString *strTotalPageCount;
@property (nonatomic, retain)NSMutableArray *arrContent;

@property (nonatomic,strong)NSString *strFrom;

-(IBAction)ClickBack:(id)sender;

//Call Service
-(void)_startSend;
-(void)_startSendNextData:(NSString *)count;
-(void)ReloadTableData;
-(void)_stopReceiveWithStatus:(NSString *)statusString;
-(void)_receiveDidStopWithStatus:(NSString *)statusString;
-(void)setData:(NSDictionary*)dictionary;

-(IBAction)WatchVideo:(id)sender;

- (IBAction)thumbnilImage:(id)sender;
-(IBAction)Like:(id)sender;
-(void)_Like:(NSString *)type :(NSString *)iActivityID;
-(IBAction)UNLike:(id)sender;
-(void)_UNLike:(NSString *)type :(NSString *)iActivityID;
-(IBAction)AddComment:(id)sender;

@end
