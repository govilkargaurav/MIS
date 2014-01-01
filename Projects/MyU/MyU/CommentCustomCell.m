//
//  CommentCustomCell.m
//  MyU
//
//  Created by Vijay on 7/12/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "CommentCustomCell.h"

@implementation CommentCustomCell
@synthesize imgMainBG,imgProfilePic,lblTime,lblName,lblDescription;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        imgMainBG=[[UIImageView alloc]initWithFrame:CGRectMake(10.0,0.0,300.0,60.0)];
        UIImage *imgBG=[UIImage imageNamed:@"cellbg_comment.png"];
        imgMainBG.image=[imgBG stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
        [self.contentView addSubview:imgMainBG];
        
        imgProfilePic=[[UIButton alloc]initWithFrame:CGRectMake(20.0,10.0,40.0,40.0)];
        imgProfilePic.clipsToBounds=YES;
        imgProfilePic.layer.cornerRadius=3.0;
        imgProfilePic.tag=107;
        [self.contentView addSubview:imgProfilePic];
        
        lblTime=[[UILabel alloc]initWithFrame:CGRectMake(235.0,10.0,65.0,13.0)];
        lblTime.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        lblTime.backgroundColor=[UIColor clearColor];
        lblTime.textColor=kCustomGRBLDarkColor;
        lblTime.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:lblTime];
        
        lblName=[[UILabel alloc]initWithFrame:CGRectMake(70.0,10.0,150.0,14.0)];
        lblName.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:lblName];
        
        lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(70.0,28.0,230.0,20.0)];
        lblDescription.font=[UIFont fontWithName:@"Helvetica-Light" size:12.0];
        lblDescription.backgroundColor=[UIColor clearColor];
        lblDescription.numberOfLines=0.0;
        lblDescription.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:lblDescription];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect theRect=lblDescription.frame;
    
    CGSize textSize= [lblDescription.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:12.0] constrainedToSize:CGSizeMake(lblDescription.frame.size.width,CGFLOAT_MAX)lineBreakMode:NSLineBreakByWordWrapping];
    
    if (textSize.height>theRect.size.height)
    {
        theRect.size.height=textSize.height;
        lblDescription.frame=theRect;
        
        theRect=imgMainBG.frame;
        theRect.size.height=lblDescription.frame.origin.y+lblDescription.frame.size.height+12.0;
        imgMainBG.frame=theRect;
    }
}
@end
