//
//  ProffesorRateCustomCell.m
//  MyU
//
//  Created by Vijay on 7/17/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "ProffesorRateCustomCell.h"

@implementation ProffesorRateCustomCell

@synthesize imgMainBG,lblSubject,lblTime,btnReport,lblattributed,viewRate,imgRate1,imgRate2,imgRate3,imgRate4,lblLikeCount,btnLike,isCommentCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        imgMainBG=[[UIImageView alloc]initWithFrame:CGRectMake(10.0, 0.0, 300.0, 80.0)];
        UIImage *imgBG=[UIImage imageNamed:@"cellbg_rateproff.png"];
        imgMainBG.image=[imgBG resizableImageWithCapInsets:UIEdgeInsetsMake(20.0, 0.0, 60.0, 0.0)];
        [self.contentView addSubview:imgMainBG];
        
        lblSubject=[[UILabel alloc]initWithFrame:CGRectMake(20.0,9.0,200.0,10.0)];
        lblSubject.font=[UIFont fontWithName:@"Helvetica" size:10.0];
        lblSubject.backgroundColor=[UIColor clearColor];
        lblSubject.textColor=kCustomGRBLDarkColor;
        [self.contentView addSubview:lblSubject];
        
        lblTime=[[UILabel alloc]initWithFrame:CGRectMake(220.0,9.0,80.0,10.0)];
        lblTime.font=[UIFont fontWithName:@"Helvetica-Light" size:9.0];
        lblTime.backgroundColor=[UIColor clearColor];
        lblTime.textColor=[UIColor darkGrayColor];
        lblTime.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:lblTime];
        
        btnReport=[[UIButton alloc]initWithFrame:CGRectMake(267.0,20,33.0,10.0)];
        [btnReport.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
        [btnReport setTitle:@"Report" forState:UIControlStateNormal];
        [btnReport setTitleColor:kCustomGRBLDarkColor forState:UIControlStateNormal];
        [btnReport setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.contentView addSubview:btnReport];
        
        lblattributed = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(20.0f,30.0f,280.0f,30.0f)];
        lblattributed.backgroundColor=[UIColor clearColor];
        lblattributed.numberOfLines=0.0;
        lblattributed.opaque=YES;
        lblattributed.lineBreakMode=NSLineBreakByWordWrapping;
        [self.contentView addSubview:lblattributed];
        
        viewRate=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0,75.0)];
        viewRate.backgroundColor=[UIColor clearColor];
        
        imgRate1=[[UIImageView alloc]initWithFrame:CGRectMake(36.0,7.0,40.0,40.0)];
        [viewRate addSubview:imgRate1];
        
        imgRate2=[[UIImageView alloc]initWithFrame:CGRectMake(106.0,7.0,40.0,40.0)];
        [viewRate addSubview:imgRate2];
        
        imgRate3=[[UIImageView alloc]initWithFrame:CGRectMake(175.0,7.0,40.0,40.0)];
        [viewRate addSubview:imgRate3];
        
        imgRate4=[[UIImageView alloc]initWithFrame:CGRectMake(246.0,7.0,40.0,40.0)];
        [viewRate addSubview:imgRate4];
        
        [self.contentView addSubview:viewRate];
        
        lblLikeCount=[[UILabel alloc]initWithFrame:CGRectMake(44.0, 0.0, 35.0, 30.0)];
        lblLikeCount.font=kFONT_HOMECELL;
        lblLikeCount.backgroundColor=[UIColor clearColor];
        lblLikeCount.textColor=[UIColor whiteColor];
        lblLikeCount.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:lblLikeCount];
        
        btnLike=[[UIButton alloc]initWithFrame:CGRectMake(255.0,0,40.0,30.0)];
        [btnLike.titleLabel setFont:kFONT_HOMECELL];
        [btnLike setTitle:@"  Like" forState:UIControlStateNormal];
        [btnLike setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnLike setTitleColor:kCustomGRBLDarkColor forState:UIControlStateHighlighted];
        [self.contentView addSubview:btnLike];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect theRect=lblattributed.frame;
    float theHeight=[[lblattributed.attributedText heightforAttributedStringWithWidth:280.0]floatValue];
    theRect.size.height=(isCommentCell)?theHeight:MIN(theHeight,48.0);
    lblattributed.frame=theRect;
    
    theRect=imgMainBG.frame;
    theRect.size.height=lblattributed.frame.origin.y+lblattributed.frame.size.height+105.0;
    imgMainBG.frame=theRect;
    
    float footeroriginy =lblattributed.frame.origin.y+lblattributed.frame.size.height+75.0;
    
    theRect=viewRate.frame;
    theRect.origin.y=lblattributed.frame.origin.y+lblattributed.frame.size.height;
    viewRate.frame=theRect;
    
    theRect=lblLikeCount.frame;
    theRect.origin.y=footeroriginy;
    lblLikeCount.frame=theRect;
    
    theRect=btnLike.frame;
    theRect.origin.y=footeroriginy;
    btnLike.frame=theRect;
}

@end
