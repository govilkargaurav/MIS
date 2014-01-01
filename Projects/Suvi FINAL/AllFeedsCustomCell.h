//
//  AllFeedsCustomCell.h
//  RichLabel
//
//  Created by Gagan on 4/24/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewFeed.h"
#import <OHAttributedLabel/OHAttributedLabel.h>

typedef enum
{
	FEED_TYPE_IMAGE,
	FEED_TYPE_VIDEO,
	FEED_TYPE_YTB_VIDEO,
	FEED_TYPE_MUSIC,
	FEED_TYPE_LOCATION,
    FEED_TYPE_WINKED,
    FEED_TYPE_PROFILEPIC_UPDATE,
	FEED_TYPE_BIRTHDAY,
    FEED_TYPE_WROTE,
    FEED_TYPE_WROTEHOME,
    FEED_TYPE_NOWFRIENDS,
    FEED_TYPE_BADGE
}FeedCellType;

@interface AllFeedsCustomCell : UITableViewCell
{
    UIImageView *imgProfilePic;
    UIButton *btnProfilePic;
    UILabel *lblUserName;
    UILabel *lblDate;
    
    UIImageView *imgViewBGHeader;
    UIImageView *imgViewBGFooter;
    
    UILabel *lblLikeCount;
    UILabel *lblCommentCount;
    UILabel *lblDisLikeCount;
    UIButton *btnLikeCount;
    UIButton *btnCommentCount;
    UIButton *btnDisLikeCount;
    
    OHAttributedLabel *lblattributed;
    OHAttributedLabel *lblCellDetailTitle;
    UIView *viewCellGrayBG;
    
    //Image
    UIImageView *imgViewPicture;
    UIButton *btnViewPicture;
    
    //Video
    UIWebView *webViewVideo;
    
    //Wrote
    UIImageView *imgVWroteONUser;
    UIButton *btnWroteONUser;
    UILabel *lblWroteOn_Name;
    UILabel *lblWroteOn_School;
    UILabel *lblWroteOn_NumOfFriend;
    UIImageView *imgviewWroteBG;
    
    UIButton *btnLike;
    UIButton *btnComment;
    UIButton *btnDisLike;
    
    FeedCellType theFeedType;
    
    ViewFeed* myFeedObj;
}
@property(nonatomic,strong) UIImageView *imgProfilePic;
@property(nonatomic,strong) UIButton *btnProfilePic;

@property(nonatomic,strong) UILabel *lblUserName;
@property(nonatomic,strong) UILabel *lblDate;

@property(nonatomic,strong) UIImageView *imgViewBGHeader;
@property(nonatomic,strong) UIImageView *imgViewBGFooter;

@property(nonatomic,strong) UILabel *lblLikeCount;
@property(nonatomic,strong) UILabel *lblCommentCount;
@property(nonatomic,strong) UILabel *lblDisLikeCount;
@property(nonatomic,strong) UIButton *btnLikeCount;
@property(nonatomic,strong) UIButton *btnCommentCount;
@property(nonatomic,strong) UIButton *btnDisLikeCount;

@property(nonatomic,strong) OHAttributedLabel *lblattributed;
@property(nonatomic,strong) OHAttributedLabel *lblCellDetailTitle;
@property(nonatomic,strong) UIView *viewCellGrayBG;
@property(nonatomic,strong) UIView *viewUpperBorder;

//Image
@property(nonatomic,strong) UIImageView *imgViewPicture;
@property(nonatomic,strong) UIButton *btnViewPicture;

//Video
@property(nonatomic,strong) UIWebView *webViewVideo;

//Wrote
@property(nonatomic,strong)UIImageView *imgVWroteONUser;
@property(nonatomic,strong)UIButton *btnWroteONUser;
@property(nonatomic,strong)UILabel *lblWroteOn_Name;
@property(nonatomic,strong)UILabel *lblWroteOn_School;
@property(nonatomic,strong)UILabel *lblWroteOn_NumOfFriend;

//nowfriends,badge,profile_update
@property(nonatomic,strong) OHAttributedLabel *lbl_NowFriends;
@property(nonatomic,strong) UIImageView *imgViewFriend;
@property(nonatomic,strong) UIButton *btnFriend;
@property(nonatomic,strong) OHAttributedLabel *lbl_Badge_ProfileUpdate;

@property(nonatomic,strong) UIButton *btnLike;
@property(nonatomic,strong) UIButton *btnComment;
@property(nonatomic,strong) UIButton *btnDisLike;

@property(nonatomic,readwrite) FeedCellType theFeedType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndex:(int)indexPath dataMyFeed:(ViewFeed *)myFeed isFromHome:(BOOL)isFromHome;
@end
