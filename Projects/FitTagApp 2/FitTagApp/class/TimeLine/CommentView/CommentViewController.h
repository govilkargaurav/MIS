//
//  CommentViewController.h
//  FitTag
//
//  Created by apple on 3/9/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "LORichTextLabel.h"
#import "UIView+Layout.h"

@protocol getCommentCount <NSObject>

-(void)commentCount:(NSInteger)arrCount;

@end

@interface CommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

    NSMutableArray *arrAllComments,*mutArrMyFollowers,*mutArrMentionedFriends,*mutArrSearchDisplay,*mutArrUserNamesMentionInComment;
    AppDelegate *appdelegateRef;
    
    BOOL isSearching;
    UITableView *tblViewMentionFriends;
    UIView *popOverViewBackground;
    IBOutlet UIImageView *imagView;
    IBOutlet UIButton *btnDone;
    PFUser *createdUser;
    
    CGSize stringSize;
}
@property (strong, nonatomic) IBOutlet UITableView *tblComments;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldComment;
@property(nonatomic,retain)id<getCommentCount>delegate;
@property(nonatomic,strong)NSString *challengeId;
@property(nonatomic,strong)PFUser *ChallengeOwner;
@property(nonatomic,strong)NSString *strChaleengeName;
@property(nonatomic)BOOL isTakeChallenge;
@property(nonatomic)bool isFromFindTags;

@property(nonatomic,retain)PFObject *objchallenge;
- (IBAction)btnSendPressed:(id)sender;
-(void)getComments;
-(void)getfollowers;
-(IBAction)btnHeaderbackPressed:(id)sender;
-(void)getChallengeHasUsesSameHashTags:(NSArray *)arrayHasTags;
@end
