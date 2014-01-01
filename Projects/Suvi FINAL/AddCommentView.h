

//ramprasad@sabizuk.comSabizuk123
//happytainment@gmail.comBw012013
//gmangboy123@gmail.comaieeepeT1!
//  AddCommentView.h
//  Suvi
//
//  Created by Vivek Rajput on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "common.h"
#import "AddCommentCell.h"
#import "FeedComment.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "HPGrowingTextView.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import "PhotoZoomViewController.h"

@interface AddCommentView : UIViewController<NSURLConnectionDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate,UIWebViewDelegate>
{
    
    IBOutlet UIButton* buttonLike, *buttonDislike, *buttonComment;
    
    NSURLConnection *connection;
    NSMutableData *webData;
    NSMutableArray *arrContent;
    NSString *action;
    
    IBOutlet UITextView *txtViewPost;
    IBOutlet UITableView *TblView;
    IBOutlet AddCommentCell *myCell;
    
    IBOutlet UIView *viewYoutube;
    IBOutlet UIView *viewNoteOnFriend;
    IBOutlet UIView *viewTableHeaderImage;
    IBOutlet UIView *viewTableHeaderVideo;
    IBOutlet UIWebView *webVideo;
    
    IBOutlet UIView * viewUpdatePro;
    
    IBOutlet UIView *viewSection;
    IBOutlet OHAttributedLabel *lblFeedPost;
    IBOutlet UILabel *lblDate;
    IBOutlet UIImageView *imgViewUser;
    
    IBOutlet UIImageView *imgViewPostImage;
    IBOutlet UIButton *btnLike;
    IBOutlet UIButton *btnUnLike;
    IBOutlet UILabel *lblLikeCount;
    IBOutlet UILabel *lblDislikeCount;
    IBOutlet UILabel *lblCommentCount;
    IBOutlet UIView *viewLikeDislike;
    
    IBOutlet OHAttributedLabel* lblLikesNos;
    
    UIView *containerView;
    HPGrowingTextView *tfautoExpandPost;
    
    IBOutlet UILabel* lblUserName,*lblTimeDuration;
    IBOutlet UIImageView* imageViewBGHeader;
    
    IBOutlet UILabel* lblYouTubeTitle;
    IBOutlet UIImageView* imgViewYoutube;
    
    IBOutlet UIView* viewMusic;
    IBOutlet UIImageView* imgMusic;
    IBOutlet OHAttributedLabel* lblMusicTitle;
    
    
    IBOutlet UILabel* lblWroteBy,*lblSchool, *lblNoOfFriends;
    IBOutlet UIImageView* imgWriterImage;
    
    IBOutlet UIView* viewMap;
    IBOutlet UIImageView* imgMapView;
    IBOutlet OHAttributedLabel* lblMapTitle;
    
    IBOutlet UIWebView *webViewYoutube;
    
    int Comment_Count;
    
    IBOutlet UIImageView* imageUpdatePro;
    
    IBOutlet OHAttributedLabel* lblUpdateAct;
    IBOutlet OHAttributedLabel* lblBudgeAct;
    IBOutlet UIImageView* imageBudgePro;
    
     IBOutlet UIView* viewBudge;
}
@property(nonatomic,retain)NSMutableArray *arrContent;
@property(nonatomic,retain)NSMutableDictionary *dictAllData;
@property(nonatomic,readwrite) int vijays;

@property(nonatomic,retain)NSString *vType_of_post;
@property(nonatomic,retain)NSString *iActivityID;

-(void)addSectionView;

-(IBAction)CommentToPost:(id)sender;
-(IBAction)Back:(id)sender;
-(IBAction)PostCliked:(id)sender;
-(void)_AddComment;
-(void)_GetComment;

-(void)_stopReceiveWithStatus:(NSString *)statusString;
-(void)_receiveDidStopWithStatus:(NSString *)statusString;
-(void)setData:(NSDictionary*)dictionary;
-(void)loadHTML:(NSString *)strHTML;
-(IBAction)Like:(id)sender;
-(void)_Like:(NSString *)type :(NSString *)iActivityID;
-(IBAction)UNLike:(id)sender;
-(void)_UNLike:(NSString *)type :(NSString *)iActivityIDT;

-(void)LikeForComment:(id)sender;
-(void)UnLikeForComment:(id)sender;
-(void)openeditorview;

-(void)ChangeLikeImageHeader:(int)likeCount;
-(void)ChangeDisLikeImageHeader:(int)dislikeCount;
-(void)ChnageCommentImageHeader:(int)commentCount;

@end
