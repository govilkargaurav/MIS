//
//  ChallengeDetailViewController.h
//  FitTag
//
//  Created by Mic mini 5 on 3/5/13.

#import <UIKit/UIKit.h>
#import "StyledPullableView.h"
#import "EGOImageView.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "AppDelegate.h"
#import "CommentViewController.h"
#import "PopoverView.h"
#import <MessageUI/MessageUI.h>
#import<MediaPlayer/MediaPlayer.h>

@interface ChallengeDetailViewController : UIViewController <UIScrollViewDelegate,PullableViewDelegate,UIActionSheetDelegate,getCommentCount,PopoverViewDelegate,MFMailComposeViewControllerDelegate>{
    BOOL pageControlBeingUsed;
    int buttonIndexForShareDataOnSocial;
    BOOL IsLiked;
    AppDelegate *appdelegateRef;
    
    PFObject *objTakeChallenge;
    NSMutableArray *arrAllDataLike;
    NSMutableArray *arrAllTakeChallenges;
    IBOutlet UILabel *lblLikerCount;
    IBOutlet UIButton *btnLikers;
    IBOutlet UIButton *btnLike;
    IBOutlet UIButton *btnCOMMENT;
    IBOutlet UIButton *btnShare;
    IBOutlet UIButton *btnReport;
    IBOutlet UILabel *lblEqupment;
    IBOutlet UILabel *lblCommentCount;
    IBOutlet UIImageView *imgBG;
    IBOutlet UIImageView *imgShare;
    IBOutlet UIScrollView *scrollviewVertical;
    
    NSMutableDictionary *mutDictStepsVideoPlayer;
    
    NSMutableDictionary *params;
    
    PFFile *firstVedio;
    
}

@property(nonatomic,strong)MPMoviePlayerController *player;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewLabel;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControll;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewImage;
@property (strong, nonatomic) IBOutlet UITextView *lblDiscription;
@property (strong, nonatomic) IBOutlet StyledPullableView *viewEquipment;
@property (strong, nonatomic) IBOutlet UILabel *lblLableNo;
@property(strong,nonatomic)PopoverView *pv;
@property(strong,nonatomic)PFObject *objChallengeInfo;
@property(strong,nonatomic)PFUser *objUserInfo;
@property(strong,nonatomic)NSArray *aryStepsData;

-(void)setEquipmentView:(NSArray*)aryEquString;
- (IBAction)changePage:(id)sender;
- (IBAction)btnReportPressed:(id)sender;
- (IBAction)btnLikePressed:(id)sender;
- (IBAction)btnCommentPressed:(id)sender;
-(IBAction)btnSharePressed:(id)sender;
-(void)findLikes;
//-(void)getAllCommentsCount;

// Share on social
-(void)postToFcaebookUsersWall:(int )index;
-(void)postToTwitterAsTwitt:(int )index;

-(void)rearrangeViewAccordingToData;
@end
