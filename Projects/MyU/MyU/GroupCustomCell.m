//
//  GroupCustomCell.m
//  MyU
//
//  Created by Vijay on 7/12/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "GroupCustomCell.h"

@implementation GroupCustomCell

@synthesize imgMainBG,imgGroupPic,lblGroupName,lblGroupBy,lblGroupMembers,lblGroupUpdates,btnJoin;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        imgMainBG=[[UIImageView alloc]initWithFrame:CGRectMake(0.0,0.0,320.0,91.0)];
        [self.contentView addSubview:imgMainBG];
        
        imgGroupPic=[[UIImageView alloc]initWithFrame:CGRectMake(10.0,10.0,70.0,70.0)];
        imgGroupPic.clipsToBounds=YES;
        imgGroupPic.layer.cornerRadius=6.0;
        [self.contentView addSubview:imgGroupPic];
        
        lblGroupName=[[UILabel alloc]initWithFrame:CGRectMake(90.0,18.0,210.0,15.0)];
        lblGroupName.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        lblGroupName.backgroundColor=[UIColor clearColor];
        lblGroupName.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:lblGroupName];
        
        lblGroupBy=[[UILabel alloc]initWithFrame:CGRectMake(90.0,42.0,140.0,15.0)];
        lblGroupBy.font=[UIFont fontWithName:@"Helvetica" size:14.0];
        lblGroupBy.backgroundColor=[UIColor clearColor];
        lblGroupBy.textColor=[UIColor grayColor];
        [self.contentView addSubview:lblGroupBy];
        
        lblGroupMembers=[[UILabel alloc]initWithFrame:CGRectMake(90.0,60.0,120.0,15.0)];
        lblGroupMembers.font=[UIFont fontWithName:@"Helvetica" size:14.0];
        lblGroupMembers.backgroundColor=[UIColor clearColor];
        lblGroupMembers.textColor=[UIColor grayColor];
        [self.contentView addSubview:lblGroupMembers];
        
        lblGroupUpdates=[[UILabel alloc]initWithFrame:CGRectMake(235.0,44.0,64.0,16.0)];
        lblGroupUpdates.font=[UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        lblGroupUpdates.backgroundColor=[UIColor grayColor];
        lblGroupUpdates.textColor=[UIColor whiteColor];
        lblGroupUpdates.layer.cornerRadius=3.0;
        lblGroupUpdates.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:lblGroupUpdates];
        
        btnJoin=[[UIButton alloc] initWithFrame:CGRectMake(220.0,44.0,90.0,30.0)];
        [self.contentView addSubview:btnJoin];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize textSize=[lblGroupUpdates.text sizeWithFont:lblGroupUpdates.font constrainedToSize:CGSizeMake(CGFLOAT_MAX,lblGroupUpdates.frame.size.height)];
    CGRect theRect=lblGroupUpdates.frame;
    theRect.size.width=MIN(textSize.width, 64.0);
    theRect.origin.x=235.0+64.0-MIN(textSize.width, 64.0);
    lblGroupUpdates.frame=theRect;
    
    
    btnJoin.alpha=([lblGroupUpdates.text length]>0)?0.0:1.0;
    
    lblGroupUpdates.alpha=(([lblGroupUpdates.text length]==0) || ([lblGroupUpdates.text isEqualToString:@"0"]))?0.0:1.0;
}

@end
