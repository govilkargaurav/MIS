//
//  TimeLineCostumCell.h
//  FitTag
//
//  Created by apple on 3/14/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LORichTextLabel.h"
#import "UIView+Layout.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@class STTweetLabel;
@protocol clickLikerDelegate <NSObject>
-(void)likerBtnPressedDelegate :(NSInteger)senderIndex;
@end

@interface TimeLineCostumCell : UIViewController

{
    AppDelegate *appDelegate;
    PFObject *objChallengeInfo;
    PFUser *objUserInfo;
    PFUser *userForLike;
    NSMutableArray *arrLikesName;
    NSMutableArray *arrLikeUserId;
    NSArray *arrUserDataClass;

    NSString *StrLikesRow;
   
    IBOutlet UIScrollView *srcView;
    
    IBOutlet UIButton *lblUserName;
    IBOutlet UIButton *btnSeeOlgerComment;
    IBOutlet UIButton *btnLikeChallenge;
    IBOutlet UIButton *btnComment;
    IBOutlet UIButton *btnReport;
    IBOutlet UIButton *btnShare;
    IBOutlet  UIButton *btnLikers;
    IBOutlet  UIButton *btnLikeLink1;
    
    IBOutlet UILabel *lblChallengeName;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblComment2;
    IBOutlet UILabel *lblComment3;
    IBOutlet UILabel *lblComment4;
    
    IBOutlet UITextView *txtViewDescriptionTag;
    IBOutlet UITextView *txtViewLikes;
   
    IBOutlet UIImageView *profilrEgoImageView,*imgTeaserBackImage;
    IBOutlet UIImageView *teaserEgoImageView;
    IBOutlet UIImageView *lineImageView1;
    IBOutlet UIImageView *lineImageView2;

    IBOutlet LORichTextLabel *lblComment1;
    LORichTextLabel *lblrichTextLblAttherate;
    
    int indexpathRow;
}
@property (retain, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIButton *btnTakeChallenge;
@property (nonatomic, retain) IBOutlet UIButton *btnuserName1;
@property (nonatomic, retain) IBOutlet UIButton *btnuserName2;
@property (nonatomic, retain) IBOutlet UIButton *btnuserName3;
@property (nonatomic, retain) IBOutlet UIButton *btnuserName4;
@property (nonatomic,strong)id <clickLikerDelegate> delegate;
@property (nonatomic, retain) IBOutlet LORichTextLabel *lblComment1;
@property (nonatomic, retain) IBOutlet UILabel *lblComment2;
@property (nonatomic, retain) IBOutlet UILabel *lblComment3;
@property (nonatomic, retain) IBOutlet UILabel *lblComment4;
@property(nonatomic,retain)   IBOutlet UIButton *btnSeeOlgerComment;
@property (strong, nonatomic) IBOutlet UITextView *txtViewLikes;
@property(strong,nonatomic)UIButton *btnLikeLink1;
@property (strong, nonatomic) IBOutlet UIButton *btnLikeChallenge;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) STTweetLabel *tweetLikeUserNameLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(PFObject *)dVal row:(int)rowIndexPath userData:(NSMutableArray *)arrUserData;
-(UIButton *)likebtnCreate:(NSString*)strUserName;
@end
