//
//  GlobalCustomCell.m
//  MyU
//
//  Created by Vijay on 7/10/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "GlobalCustomCell.h"

@implementation GlobalCustomCell

@synthesize imgMainBG,imgProfilePic,lblName,lblSubject,lblTime;
@synthesize lblattributed,imgMain,btnMain,imgMainBlurred;
@synthesize imgFooter,lblLikeCount,lblCommentCount,btnLike,btnComment,imgwidth,imgheight;
@synthesize isNewsCell,isCommentCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        imgMainBG=[[UIImageView alloc]initWithFrame:CGRectMake(10.0, 0.0, 300.0, 50.0)];
        UIImage *imgBG=[UIImage imageNamed:@"cellbg_header.png"];
        imgMainBG.image=[imgBG stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
        [self.contentView addSubview:imgMainBG];
        
        imgProfilePic=[[UIButton alloc]initWithFrame:CGRectMake(20.0,10.0,40.0,40.0)];
        imgProfilePic.clipsToBounds=YES;
        imgProfilePic.layer.cornerRadius=3.0;
        imgProfilePic.tag=107.0;
        [self.contentView addSubview:imgProfilePic];
        
        lblName=[[UILabel alloc]initWithFrame:CGRectMake(70.0,10.0,150.0,16.0)];
        lblName.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:lblName];
        
        lblSubject=[[UILabel alloc]initWithFrame:CGRectMake(70.0,30.0,150.0,13.0)];
        lblSubject.font=[UIFont fontWithName:@"Helvetica-Light" size:12.0];
        lblSubject.backgroundColor=[UIColor clearColor];
        lblSubject.textColor=kCustomGRBLDarkColor;
        [self.contentView addSubview:lblSubject];
        
        lblTime=[[UILabel alloc]initWithFrame:CGRectMake(235.0,10.0,65.0,13.0)];
        lblTime.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        lblTime.backgroundColor=[UIColor clearColor];
        lblTime.textColor=kCustomGRBLDarkColor;
        lblTime.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:lblTime];
        
        imgMainBlurred=[[UIImageView alloc]initWithFrame:CGRectMake(10.0,0.0,300.0,200.0)];
        imgMainBlurred.tag=7;
        imgMainBlurred.contentMode=UIViewContentModeScaleAspectFit;
        imgMainBlurred.clipsToBounds=YES;
        imgMainBlurred.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:imgMainBlurred];
        
        imgMain=[[UIImageView alloc]initWithFrame:CGRectMake(10.0,0.0,300.0,200.0)];
        imgMain.contentMode=UIViewContentModeScaleAspectFit;
        imgMain.clipsToBounds=YES;
        imgMain.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:imgMain];
        
        btnMain=[[UIButton alloc]initWithFrame:CGRectMake(10.0,0.0,300.0,200.0)];
        [self.contentView addSubview:btnMain];
        
        imgFooter=[[UIImageView alloc]initWithFrame:CGRectMake(10.0, 0.0,300.0,30.0)];
        [self.contentView addSubview:imgFooter];
        
        lblattributed = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(20.0f,30.0f,280.0f,120.0f)];
        lblattributed.backgroundColor=[UIColor clearColor];
        lblattributed.numberOfLines=0.0;
        lblattributed.opaque=YES;
        lblattributed.lineBreakMode=NSLineBreakByWordWrapping;
        [self.contentView addSubview:lblattributed];
        
        lblLikeCount=[[UILabel alloc]initWithFrame:CGRectMake(44.0, 0.0, 35.0, 30.0)];
        lblLikeCount.font=kFONT_HOMECELL;
        lblLikeCount.backgroundColor=[UIColor clearColor];
        lblLikeCount.textColor=[UIColor whiteColor];
        lblLikeCount.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:lblLikeCount];
        
        lblCommentCount=[[UILabel alloc]initWithFrame:CGRectMake(104.0, 0.0,100.0, 30.0)];
        lblCommentCount.font=kFONT_HOMECELL;
        lblCommentCount.backgroundColor=[UIColor clearColor];
        lblCommentCount.textColor=[UIColor whiteColor];
        lblCommentCount.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:lblCommentCount];
        
        btnLike=[[UIButton alloc]initWithFrame:CGRectMake(195.0,0,40.0,30.0)];
        [btnLike.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:11.5]];
        [btnLike setTitle:@"   Like" forState:UIControlStateNormal];
        [btnLike setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnLike setTitleColor:kCustomGRBLDarkColor forState:UIControlStateHighlighted];
        [self.contentView addSubview:btnLike];

        btnComment=[[UIButton alloc]initWithFrame:CGRectMake(244.0,0,60.0,30.0)];
        [btnComment.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:11.5]];
        [btnComment setTitle:@"Comment" forState:UIControlStateNormal];
        [btnComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnComment setTitleColor:kCustomGRBLDarkColor forState:UIControlStateHighlighted];
        [self.contentView addSubview:btnComment];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect theRect=lblattributed.frame;
    float theHeight=[[lblattributed.attributedText heightforAttributedStringWithWidth:280.0]floatValue];
    theRect.size.height=(isCommentCell)?theHeight:MIN(theHeight,112.0);
    theRect.origin.y=((isNewsCell)?60.0:30.0);
    lblattributed.frame=theRect;
//    First Increment?
//    After 12 months of
//    joining date
    theRect=imgMainBG.frame;
    
    imgProfilePic.alpha=isNewsCell?1.0:0.0;
    lblName.alpha=isNewsCell?1.0:0.0;
    lblSubject.alpha=isNewsCell?1.0:0.0;
    
    float theimght=MIN(((imgwidth>300.0) && ((imgheight*300.0/imgwidth)<200.0))?(imgheight*300.0/imgwidth):imgheight, 200.0);
    
    theRect.size.height=lblattributed.frame.origin.y+lblattributed.frame.size.height+theimght+10.0;
    imgMainBG.frame=theRect;
    
    float imageoriginy =lblattributed.frame.origin.y+lblattributed.frame.size.height+10.0;
    
    if (imgheight>0.0)
    {
        theRect=imgMain.frame;
        theRect.origin.y=imageoriginy;
        imgMain.frame=theRect;
        
        theRect.size.width=imgMain.frame.size.width;
        theRect.size.height=imgMain.frame.size.height;
        theRect.origin.x=(320.0-imgMain.frame.size.width)/2.0;
        
        imageoriginy+=imgMain.frame.size.height;
        
        imgMain.frame=theRect;
        imgMainBlurred.frame=theRect;
        
        if (theimght==200.0)
        {
            theRect.size.height-=30.0;
            imageoriginy-=30.0;
        }
        
        btnMain.frame=theRect;
    }
    
    theRect=imgFooter.frame;
    imgFooter.image=[UIImage imageNamed:[NSString stringWithFormat:@"cellbg_footer_%@.png",(isCommentCell)?@"sq":@"r"]];
    theRect.origin.y=imageoriginy;
    imgFooter.frame=theRect;
    
    theRect=lblLikeCount.frame;
    theRect.origin.y=imgFooter.frame.origin.y;
    lblLikeCount.frame=theRect;
    
    theRect=lblCommentCount.frame;
    theRect.origin.y=imgFooter.frame.origin.y;
    lblCommentCount.frame=theRect;
    
    theRect=btnLike.frame;
    theRect.origin.y=imgFooter.frame.origin.y;
    btnLike.frame=theRect;
    
    theRect=btnComment.frame;
    theRect.origin.y=imgFooter.frame.origin.y;
    btnComment.frame=theRect;
}

@end
