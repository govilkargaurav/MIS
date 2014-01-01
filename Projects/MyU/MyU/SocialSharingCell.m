//
//  SocialSharingCell.m
//  MyU
//
//  Created by Vijay on 9/7/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "SocialSharingCell.h"

@implementation SocialSharingCell
@synthesize imgView,lblFriendName,btnInvite,bgimageview,isFacebookCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        bgimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0.0,0.0,302.0,60.0)];
        [self.contentView addSubview:bgimageview];
        
        imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0.0,0.0,60.0,60.0)];
        [self.contentView addSubview:imgView];
        
        lblFriendName=[[UILabel alloc]initWithFrame:CGRectMake(65.0,0.0,162.0,60.0)];
        lblFriendName.numberOfLines=0;
        lblFriendName.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        lblFriendName.backgroundColor=[UIColor clearColor];
        lblFriendName.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:lblFriendName];
        
        btnInvite=[[UIButton alloc]initWithFrame:CGRectMake(230.0,23.0,60.0,16.0)];
        [self.contentView addSubview:btnInvite];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (isFacebookCell) {
        lblFriendName.frame=CGRectMake(65.0,0.0,203.0,60.0);
        btnInvite.frame=CGRectMake(274.0,23.0,16.0,16.0);
    }
    else
    {
        [btnInvite setImage:[UIImage imageNamed:@"ffinvite"] forState:UIControlStateNormal];
    }
}



@end
