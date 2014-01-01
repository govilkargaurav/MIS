//
//  AllFeedsCustomCell.m
//  RichLabel
//
//  Created by Gagan on 4/24/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "AllFeedsCustomCell.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@implementation AllFeedsCustomCell

@synthesize  imgProfilePic,lblUserName,lblDate,imgViewBGHeader,imgViewBGFooter,lblLikeCount,lblCommentCount,lblDisLikeCount,lblattributed,imgViewPicture,btnLike,btnComment,btnDisLike,theFeedType,btnCommentCount,btnDisLikeCount,btnLikeCount,lblCellDetailTitle,viewCellGrayBG,viewUpperBorder;
@synthesize btnViewPicture;
@synthesize webViewVideo;
@synthesize btnProfilePic;

@synthesize btnWroteONUser,imgVWroteONUser;
@synthesize lblWroteOn_School,lblWroteOn_NumOfFriend,lblWroteOn_Name;

@synthesize lbl_NowFriends,lbl_Badge_ProfileUpdate;
@synthesize imgViewFriend,btnFriend;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndex:(int)indexPath dataMyFeed:(ViewFeed *)myFeed isFromHome:(BOOL)isFromHome
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       

        myFeedObj = myFeed;
        btnComment=[[UIButton alloc]initWithFrame:CGRectMake(108, 0,103,29)];
        self.backgroundColor=[UIColor clearColor];

        if([myFeed.vType_of_content isEqualToString:@"winked"])
        {
            viewCellGrayBG=[[UIView alloc]init];
            viewCellGrayBG.opaque=YES;
            [viewCellGrayBG setBackgroundColor:[UIColor whiteColor]];
            [self.contentView addSubview:viewCellGrayBG];
        }
        
        imgProfilePic=[[UIImageView alloc]init];
        imgProfilePic.frame=CGRectMake(5,5,42,42);
        imgProfilePic.tag=1001;
        imgProfilePic.opaque=YES;
        imgProfilePic.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:imgProfilePic];
        
        btnProfilePic=[UIButton buttonWithType:UIButtonTypeCustom];
        btnProfilePic.frame=imgProfilePic.frame;
        btnProfilePic.opaque=YES;
        btnProfilePic.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:btnProfilePic];
        
        if([myFeed.vType_of_content isEqualToString:@"winked"])
        {
            lbl_Badge_ProfileUpdate = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(52.0,5.0,265.0,[myFeedObj.labelHeight floatValue])];
            lbl_Badge_ProfileUpdate.backgroundColor=[UIColor clearColor];
            lbl_Badge_ProfileUpdate.font=[UIFont fontWithName:@"Helvetica" size:14.0];
            lbl_Badge_ProfileUpdate.numberOfLines=0.0;
            lbl_Badge_ProfileUpdate.opaque=YES;
            lbl_Badge_ProfileUpdate.lineBreakMode=NSLineBreakByWordWrapping;
            [self.contentView addSubview:lbl_Badge_ProfileUpdate];
            
            lblDate=[[UILabel alloc]init];
            lblDate.backgroundColor=[UIColor clearColor];
            lblDate.frame=CGRectMake(52.0,lbl_Badge_ProfileUpdate.frame.origin.y+lbl_Badge_ProfileUpdate.frame.size.height+3.0,140.0,15.0);
            lblDate.opaque=YES;
            lblDate.font=[UIFont fontWithName:@"Helvetica" size:11.0];
            lblDate.textColor = [UIColor grayColor];
            lblDate.textAlignment=UITextAlignmentLeft;
            [self.contentView addSubview:lblDate];
            
            viewCellGrayBG.frame=CGRectMake(5.0,5.0,310.0,MAX(42.0,[myFeed.labelHeight floatValue]+18.0));
            btnProfilePic.frame=viewCellGrayBG.frame;
        }
        else
        {
            lblUserName=[[UILabel alloc]init];
            lblUserName.backgroundColor=[UIColor clearColor];
            lblUserName.frame=CGRectMake(52.0,5.0,265.0,15.0);
            lblUserName.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            lblUserName.textColor = [UIColor darkGrayColor];
            lblUserName.textAlignment=UITextAlignmentLeft;
            lblUserName.opaque=YES;
            [self.contentView addSubview:lblUserName];
            
            lblDate=[[UILabel alloc]init];
            lblDate.backgroundColor=[UIColor clearColor];
            lblDate.frame=CGRectMake(52.0,20.0,140.0,15.0);
            lblDate.font=[UIFont fontWithName:@"Helvetica" size:11.0];
            lblDate.textColor = [UIColor grayColor];
            lblDate.opaque=YES;
            lblDate.textAlignment=UITextAlignmentLeft;
            [self.contentView addSubview:lblDate];
            
            imgViewBGFooter=[[UIImageView alloc]init];
            imgViewBGHeader.opaque=YES;
            imgViewBGFooter.frame=CGRectMake(0.0,133.0,320.0,53.0);
            [imgViewBGFooter setImage:[UIImage imageNamed:@"imgcellfooter.png"]];
            [self.contentView addSubview:imgViewBGFooter];
            
            imgViewBGHeader=[[UIImageView alloc]init];
            imgViewBGHeader.opaque=YES;
            imgViewBGHeader.frame=CGRectMake(0.0,21.0,320.0,130.0);
            [imgViewBGHeader setImage:[[UIImage imageNamed:@"imgcellheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0,0.0,0.0,0.0)]];
            [self.contentView addSubview:imgViewBGHeader];
            
            [btnComment setTitleColor:kColorYellow forState:UIControlStateHighlighted];

            viewUpperBorder=[[UIView alloc]init];
            viewUpperBorder.frame=CGRectMake(184.0,21.0,131.0,4.0);
            viewUpperBorder.backgroundColor=kColorYellow;
            [self.contentView addSubview:viewUpperBorder];
            
            lblLikeCount=[[UILabel alloc]init];
            lblLikeCount.opaque=YES;
            lblLikeCount.backgroundColor=[UIColor clearColor];
            lblLikeCount.frame=CGRectMake(207.0,30.5,12.0,14.0);
            lblLikeCount.font=[UIFont systemFontOfSize:9.0];
            lblLikeCount.textColor = [UIColor blackColor];
            lblLikeCount.textAlignment=UITextAlignmentCenter;
            [self.contentView addSubview:lblLikeCount];
            
            lblCommentCount=[[UILabel alloc]init];
            lblCommentCount.opaque=YES;
            lblCommentCount.backgroundColor=[UIColor clearColor];
            lblCommentCount.frame=CGRectMake(249.5,30.5,12.5,14.0);
            lblCommentCount.font=[UIFont systemFontOfSize:9.0];
            lblCommentCount.textColor = [UIColor blackColor];
            lblCommentCount.textAlignment=UITextAlignmentCenter;
            [self.contentView addSubview:lblCommentCount];
            
            lblDisLikeCount=[[UILabel alloc]init];
            lblDisLikeCount.opaque=YES;
            lblDisLikeCount.backgroundColor=[UIColor clearColor];
            lblDisLikeCount.frame=CGRectMake(289.5,30.5,12.0,14.0);
            lblDisLikeCount.font=[UIFont systemFontOfSize:9.0];
            lblDisLikeCount.textColor = [UIColor blackColor];
            lblDisLikeCount.textAlignment=UITextAlignmentCenter;
            [self.contentView addSubview:lblDisLikeCount];
            
            btnLikeCount=[[UIButton alloc]initWithFrame:CGRectMake(190.0,28,31.0,20.5)];
            btnLikeCount.showsTouchWhenHighlighted=YES;
            btnLikeCount.opaque=YES;
            [self.contentView addSubview:btnLikeCount];
            
            btnCommentCount=[[UIButton alloc]initWithFrame:CGRectMake(233.0,28,31.0,20.5)];
            btnCommentCount.showsTouchWhenHighlighted=YES;
            btnCommentCount.opaque=YES;
            [self.contentView addSubview:btnCommentCount];
            
            btnDisLikeCount=[[UIButton alloc]initWithFrame:CGRectMake(273.0,28,31.0,20.5)];
            btnDisLikeCount.showsTouchWhenHighlighted=YES;
            btnDisLikeCount.opaque=YES;
            [self.contentView addSubview:btnDisLikeCount];
            
            lblattributed = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(15.0f,58.0f,290.0f,[myFeed.labelHeight floatValue])];
            lblattributed.backgroundColor=[UIColor clearColor];
            lblattributed.numberOfLines=0.0;
            lblattributed.opaque=YES;
            lblattributed.lineBreakMode=NSLineBreakByWordWrapping;
            [self.contentView addSubview:lblattributed];

            if ([myFeed.vType_of_content isEqualToString:@"activity"])
            {
                [btnComment setTitleColor:kColorThought forState:UIControlStateHighlighted];
                
                viewUpperBorder.backgroundColor=kColorThought;
            }
            
            if ([myFeed.vType_of_content isEqualToString:@"image"])
            {
                [btnComment setTitleColor:kColorImage forState:UIControlStateHighlighted];

                viewUpperBorder.backgroundColor=kColorImage;
                imgViewPicture=[[UIImageView alloc]init];
                imgViewPicture.clipsToBounds=YES;
                imgViewPicture.opaque=YES;
                imgViewPicture.backgroundColor=[UIColor clearColor];
                [self.contentView addSubview:imgViewPicture];
                
                btnViewPicture=[[UIButton alloc]init];
                btnViewPicture.clipsToBounds=YES;
                btnViewPicture.opaque=YES;
                btnViewPicture.backgroundColor=[UIColor clearColor];
                [self.contentView addSubview:btnViewPicture];
            }
            else if ([myFeed.vType_of_content isEqualToString:@"video"] && ([myFeed.strYouTubeId length]!=0))
            {
                [btnComment setTitleColor:kColorVideo forState:UIControlStateHighlighted];

                viewUpperBorder.backgroundColor=kColorVideo;

                viewCellGrayBG=[[UIView alloc]init];
                viewCellGrayBG.opaque=YES;
                [viewCellGrayBG setBackgroundColor:[UIColor clearColor]];
                viewCellGrayBG.frame=CGRectMake(5.0,0.0,310.0,90.0);

                webViewVideo=[[UIWebView alloc]init];
                webViewVideo.scrollView.scrollEnabled=NO;
                webViewVideo.clipsToBounds=YES;
                webViewVideo.opaque=YES;
                webViewVideo.backgroundColor=[UIColor grayColor];
                webViewVideo.frame=CGRectMake(3.0,3.0,147.0,84.0);
                [viewCellGrayBG addSubview:webViewVideo];
                
                lblCellDetailTitle=[[OHAttributedLabel alloc]init];
                lblCellDetailTitle.opaque=YES;
                lblCellDetailTitle.backgroundColor=[UIColor clearColor];
                lblCellDetailTitle.frame=CGRectMake(160.0,3.0,140.0,84.0);
                lblCellDetailTitle.numberOfLines=0;
                lblCellDetailTitle.textAlignment=UITextAlignmentCenter;
                [viewCellGrayBG addSubview:lblCellDetailTitle];
                
                [self.contentView addSubview:viewCellGrayBG];
            }
            else if ([myFeed.vType_of_content isEqualToString:@"music"])
            {
                [btnComment setTitleColor:kColorMusic forState:UIControlStateHighlighted];
                
                viewUpperBorder.backgroundColor=kColorMusic;

                viewCellGrayBG=[[UIView alloc]init];
                viewCellGrayBG.opaque=YES;
                [viewCellGrayBG setBackgroundColor:[UIColor clearColor]];
                viewCellGrayBG.frame=CGRectMake(5.0,0.0,310.0,69.0);
                
                imgViewPicture=[[UIImageView alloc]init];
                imgViewPicture.opaque=YES;
                imgViewPicture.clipsToBounds=YES;
                imgViewPicture.tag=1001;
                imgViewPicture.backgroundColor=[UIColor clearColor];
                imgViewPicture.frame=CGRectMake(3.0,3.0,63.0,63.0);
                [viewCellGrayBG addSubview:imgViewPicture];
                
                btnViewPicture=[[UIButton alloc]init];
                btnViewPicture.frame=imgViewPicture.frame;
                btnViewPicture.clipsToBounds=YES;
                btnViewPicture.opaque=YES;
                btnViewPicture.backgroundColor=[UIColor clearColor];
                [viewCellGrayBG addSubview:btnViewPicture];
                
                lblCellDetailTitle=[[OHAttributedLabel alloc]init];
                lblCellDetailTitle.opaque=YES;
                lblCellDetailTitle.backgroundColor=[UIColor clearColor];
                lblCellDetailTitle.frame=CGRectMake(76.0,3.0,224.0,63.0);
                lblCellDetailTitle.numberOfLines=0;
                lblCellDetailTitle.textAlignment=UITextAlignmentCenter;
                [viewCellGrayBG addSubview:lblCellDetailTitle];
                
                [self.contentView addSubview:viewCellGrayBG];
            }
            else if ([myFeed.vType_of_content isEqualToString:@"location"])
            {
                [btnComment setTitleColor:kColorLocation forState:UIControlStateHighlighted];

                viewUpperBorder.backgroundColor=kColorLocation;

                viewCellGrayBG=[[UIView alloc]init];
                viewCellGrayBG.opaque=YES;
                [viewCellGrayBG setBackgroundColor:[UIColor clearColor]];
                viewCellGrayBG.frame=CGRectMake(5.0,0.0,310.0,90.0);
                
                imgViewPicture=[[UIImageView alloc]init];
                imgViewPicture.clipsToBounds=YES;
                imgViewPicture.opaque=YES;
                imgViewPicture.backgroundColor=[UIColor clearColor];
                imgViewPicture.frame=CGRectMake(3.0,3.0,126.0,84.0);
                [viewCellGrayBG addSubview:imgViewPicture];
                
                btnViewPicture=[[UIButton alloc]init];
                btnViewPicture.frame=imgViewPicture.frame;
                btnViewPicture.clipsToBounds=YES;
                btnViewPicture.opaque=YES;
                btnViewPicture.backgroundColor=[UIColor clearColor];
                [viewCellGrayBG addSubview:btnViewPicture];

                lblCellDetailTitle=[[OHAttributedLabel alloc]init];
                lblCellDetailTitle.backgroundColor=[UIColor clearColor];
                lblCellDetailTitle.frame=CGRectMake(140.0,3.0,160.0,84.0);
                lblCellDetailTitle.numberOfLines=0;
                lblCellDetailTitle.textAlignment=UITextAlignmentCenter;
                [viewCellGrayBG addSubview:lblCellDetailTitle];
                
                [self.contentView addSubview:viewCellGrayBG];
            }
            else if ([myFeed.vType_of_content isEqualToString:@"profile_update"]
                     || [myFeed.vType_of_content isEqualToString:@"badge"])
            {
                float cellmidheight=([myFeed.vType_of_content isEqualToString:@"profile_update"])?90.0:48.0;
                
                viewCellGrayBG=[[UIView alloc]init];
                viewCellGrayBG.opaque=YES;
                [viewCellGrayBG setBackgroundColor:[UIColor clearColor]];
                viewCellGrayBG.frame=CGRectMake(5.0,0.0,310.0,cellmidheight);
                
                imgViewPicture=[[UIImageView alloc]init];
                imgViewPicture.opaque=YES;
                imgViewPicture.clipsToBounds=YES;
                imgViewPicture.tag=1001;
                imgViewPicture.backgroundColor=[UIColor clearColor];
                imgViewPicture.frame=CGRectMake(3.0,3.0,cellmidheight-6.0,cellmidheight-6.0);
                [viewCellGrayBG addSubview:imgViewPicture];
                
                if ([myFeed.vType_of_content isEqualToString:@"profile_update"])
                {
                    btnViewPicture=[[UIButton alloc]init];
                    btnViewPicture.frame=imgViewPicture.frame;
                    btnViewPicture.clipsToBounds=YES;
                    btnViewPicture.opaque=YES;
                    btnViewPicture.backgroundColor=[UIColor clearColor];
                    [viewCellGrayBG addSubview:btnViewPicture];
                }
                
                lblCellDetailTitle=[[OHAttributedLabel alloc]init];
                lblCellDetailTitle.opaque=YES;
                lblCellDetailTitle.backgroundColor=[UIColor clearColor];
                lblCellDetailTitle.frame=CGRectMake(3.0+cellmidheight-6.0+10.0,3.0,310.0-(3.0+cellmidheight-6.0+10.0),cellmidheight-6.0);
                lblCellDetailTitle.numberOfLines=0;
                lblCellDetailTitle.textAlignment=UITextAlignmentCenter;
                [viewCellGrayBG addSubview:lblCellDetailTitle];
                
                [self.contentView addSubview:viewCellGrayBG];
            }
            else if ([myFeed.vType_of_content isEqualToString:@"video"] && ([myFeed.strYouTubeId length]==0))
            {
                [btnComment setTitleColor:kColorVideo forState:UIControlStateHighlighted];

                viewUpperBorder.backgroundColor=kColorVideo;

                webViewVideo=[[UIWebView alloc]init];
                webViewVideo.opaque=YES;
                webViewVideo.scrollView.scrollEnabled=NO;
                webViewVideo.clipsToBounds=YES;
                webViewVideo.backgroundColor=[UIColor grayColor];
                [self.contentView addSubview:webViewVideo];
            }
            else if(([myFeed.vType_of_content isEqualToString:@"wrote"] && isFromHome)
                    || [myFeed.vType_of_content isEqualToString:@"birthdaywish"]
                    || [myFeed.vType_of_content isEqualToString:@"nowfriends"])
            {
                viewCellGrayBG=[[UIView alloc]init];
                viewCellGrayBG.opaque=YES;
                [viewCellGrayBG setBackgroundColor:[UIColor clearColor]];
                viewCellGrayBG.frame=CGRectMake(5.0,0.0,310.0,69.0);
                
                imgViewPicture=[[UIImageView alloc]init];
                imgViewPicture.clipsToBounds=YES;
                imgViewPicture.tag=1001;
                imgViewPicture.opaque=YES;
                imgViewPicture.backgroundColor=[UIColor clearColor];
                imgViewPicture.frame=CGRectMake(3.0,3.0,63.0,63.0);
                [viewCellGrayBG addSubview:imgViewPicture];
                
                btnViewPicture=[[UIButton alloc]initWithFrame:imgViewPicture.frame];
                btnViewPicture.clipsToBounds=YES;
                btnViewPicture.opaque=YES;
                btnViewPicture.backgroundColor=[UIColor clearColor];
                [viewCellGrayBG addSubview:btnViewPicture];
                
                lblWroteOn_Name=[[UILabel alloc]init];
                lblWroteOn_Name.opaque=YES;
                lblWroteOn_Name.backgroundColor=[UIColor clearColor];
                lblWroteOn_Name.frame=CGRectMake(76.0,9.0,224.0,21.0);
                lblWroteOn_Name.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                lblWroteOn_Name.textColor = [UIColor blackColor];
                lblWroteOn_Name.textAlignment=UITextAlignmentLeft;
                [viewCellGrayBG addSubview:lblWroteOn_Name];
                
                lblWroteOn_School=[[UILabel alloc]init];
                lblWroteOn_School.opaque=YES;
                lblWroteOn_School.backgroundColor=[UIColor clearColor];
                lblWroteOn_School.frame=CGRectMake(76.0,26.0,224.0,21.0);
                lblWroteOn_School.font=[UIFont fontWithName:@"Helvetica" size:14.0];
                lblWroteOn_School.textColor = [UIColor darkGrayColor];
                lblWroteOn_School.textAlignment=UITextAlignmentLeft;
                [viewCellGrayBG addSubview:lblWroteOn_School];
                
                lblWroteOn_NumOfFriend=[[UILabel alloc]init];
                lblWroteOn_NumOfFriend.opaque=YES;
                lblWroteOn_NumOfFriend.backgroundColor=[UIColor clearColor];
                lblWroteOn_NumOfFriend.frame=CGRectMake(76.0,43.0,224.0,21.0);
                lblWroteOn_NumOfFriend.font=[UIFont fontWithName:@"Helvetica" size:14.0];
                lblWroteOn_NumOfFriend.textColor = [UIColor darkGrayColor];
                lblWroteOn_NumOfFriend.textAlignment=UITextAlignmentLeft;
                [viewCellGrayBG addSubview:lblWroteOn_NumOfFriend];
                
                [self.contentView addSubview:viewCellGrayBG];
            }

            
            btnLike=[[UIButton alloc]initWithFrame:CGRectMake(5, 0,103,29)];
            btnLike.showsTouchWhenHighlighted=YES;
            btnLike.opaque=YES;
            [btnLike setImage:[UIImage imageNamed:@"imgbtnlike.png"] forState:UIControlStateNormal];
            [btnLike setImage:[UIImage imageNamed:@"imgbtnlike-h.png"] forState:UIControlStateHighlighted];
            [self.contentView addSubview:btnLike];
            
            btnComment.showsTouchWhenHighlighted=YES;
            btnComment.opaque=YES;
            [btnComment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btnComment setTitle:@"Comment" forState:UIControlStateNormal];
            [btnComment.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
            [self.contentView addSubview:btnComment];
            
            btnDisLike=[[UIButton alloc]initWithFrame:CGRectMake(211, 0,103,29)];
            btnDisLike.showsTouchWhenHighlighted=YES;
            btnDisLike.opaque=YES;
            [btnDisLike setImage:[UIImage imageNamed:@"imgbtndislike.png"] forState:UIControlStateNormal];
            [btnDisLike setImage:[UIImage imageNamed:@"imgbtndislike-h.png"] forState:UIControlStateHighlighted];
            [self.contentView addSubview:btnDisLike];
        }
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor=[UIColor clearColor];

    float ht=0.0;
    
    [btnLikeCount setImage:[UIImage imageNamed:[NSString stringWithFormat:@"imglike%@count.png",([lblLikeCount.text isEqualToString:@"0"])?@"cntr":@""]] forState:UIControlStateNormal];
    [btnCommentCount setImage:[UIImage imageNamed:[NSString stringWithFormat:@"imgcomment%@count.png",([lblCommentCount.text isEqualToString:@"0"])?@"cntr":@""]] forState:UIControlStateNormal];
    [btnDisLikeCount setImage:[UIImage imageNamed:[NSString stringWithFormat:@"imgdislike%@count.png",([lblDisLikeCount.text isEqualToString:@"0"])?@"cntr":@""]] forState:UIControlStateNormal];
    
    lblLikeCount.hidden=([lblLikeCount.text isEqualToString:@"0"])?YES:NO;
    lblCommentCount.hidden=([lblCommentCount.text isEqualToString:@"0"])?YES:NO;
    lblDisLikeCount.hidden=([lblDisLikeCount.text isEqualToString:@"0"])?YES:NO;
 

    float imageoriginy=(lblattributed.frame.size.height==0)?52:(lblattributed.frame.origin.y+lblattributed.frame.size.height+10.0);
    
    switch (theFeedType)
    {
        case FEED_TYPE_IMAGE:
        {
            
            float imageHeight = [myFeedObj.imageHeight floatValue];
            float imageWidth = [myFeedObj.imageWidth floatValue];
            
            float heightImgMax = MIN(310,imageHeight);
                       
            if(heightImgMax >= 310)
            {
                if (imageWidth>imageHeight)
                {
                    imgViewPicture.tag=0;
                    imgViewPicture.frame=CGRectMake(5.0,imageoriginy,310.0,imageHeight*310.0/imageWidth);
                }
                else
                {
                    imgViewPicture.tag = 500500;
                    imgViewPicture.frame=CGRectMake(5.0,imageoriginy,310.0,310.0);
                }
            }
            else
            {
                imgViewPicture.tag = 0;
                imgViewPicture.frame=CGRectMake(5.0,imageoriginy,310.0,heightImgMax);
            }
            
            btnViewPicture.frame = imgViewPicture.frame;
            imgViewBGHeader.frame=CGRectMake(5.0,21.0,310.0,imageoriginy+imgViewPicture.frame.size.height-21.0);
        }
            break;
            
        case FEED_TYPE_VIDEO:
        {
            imgViewBGHeader.frame=CGRectMake(5.0,21.0,310.0,imageoriginy+310.0-21.0);
            webViewVideo.frame=CGRectMake(5.0,imageoriginy,310.0,310.0);
        }
            break;
            
        case FEED_TYPE_YTB_VIDEO:
        case FEED_TYPE_LOCATION:
        case FEED_TYPE_MUSIC:
        case FEED_TYPE_PROFILEPIC_UPDATE:
        case FEED_TYPE_BADGE:
        {
            float cellmidheight=(theFeedType==FEED_TYPE_MUSIC)?69.0:90.0;
            cellmidheight=(theFeedType==FEED_TYPE_BADGE)?48.0:cellmidheight;
            
            imageoriginy=((theFeedType==FEED_TYPE_PROFILEPIC_UPDATE) || (theFeedType==FEED_TYPE_BADGE))?52:imageoriginy;
            lblattributed.alpha=((theFeedType==FEED_TYPE_PROFILEPIC_UPDATE) || (theFeedType==FEED_TYPE_BADGE))?0.0:1.0;
            
            viewCellGrayBG.frame=CGRectMake(5.0,imageoriginy,310.0,cellmidheight);
            imgViewBGHeader.frame=CGRectMake(5.0,21.0,310.0,imageoriginy+cellmidheight-21.0);
            
            CGRect theRect=viewCellGrayBG.frame;
            [lblCellDetailTitle sizeToFit];
            theRect=lblCellDetailTitle.frame;
            float lbltitlemaxht=cellmidheight-6.0;
            if (lblCellDetailTitle.frame.size.height<lbltitlemaxht)
            {
                theRect.origin.y=((lbltitlemaxht-lblCellDetailTitle.frame.size.height)/2.0);
            }
            else
            {
                theRect.size.height=lbltitlemaxht;
            }
            
            lblCellDetailTitle.frame=theRect;
        }
            break;
            
        case FEED_TYPE_WROTE:
        case FEED_TYPE_WROTEHOME:
        case FEED_TYPE_NOWFRIENDS:
        case FEED_TYPE_BIRTHDAY:
        {
            float cellmidheight=((theFeedType==FEED_TYPE_WROTE) || (theFeedType==FEED_TYPE_WINKED))?0.0:69.0;
            viewCellGrayBG.frame=CGRectMake(5.0,imageoriginy,310.0,cellmidheight);
            imgViewBGHeader.frame=CGRectMake(5.0,21.0,310.0,imageoriginy+cellmidheight-21.0);
        }
            break;
            
        default:
        {
            imgViewBGHeader.frame=CGRectMake(5.0,21.0,310.0,47.0+lblattributed.frame.size.height);
        }
            break;
    }
    
    imgViewBGFooter.frame=CGRectMake(5.0,imgViewBGHeader.frame.origin.y+imgViewBGHeader.frame.size.height-19.0,310.0,53.0);
    ht=imgViewBGFooter.frame.origin.y+21;
    btnLike.frame=CGRectMake(5,ht,103,29);
    btnComment.frame=CGRectMake(108,ht,103,29);
    btnDisLike.frame=CGRectMake(211,ht,103,29);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
