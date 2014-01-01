//
//  InvitePeopleCustomCell.m
//  MyU
//
//  Created by Vijay on 7/19/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "InvitePeopleCustomCell.h"

@implementation InvitePeopleCustomCell
@synthesize imgMainBG,lblName,btnInvite,isBigCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        imgMainBG=[[UIImageView alloc]initWithFrame:CGRectMake(0.0,0.0,298.0,30.0+(isBigCell?20.0:0.0))];
        [self.contentView addSubview:imgMainBG];

        lblName=[[UILabel alloc]initWithFrame:CGRectMake(8.0,0.0,172.0,30.0+(isBigCell?20.0:0.0))];
        lblName.font=[UIFont fontWithName:@"Helvetica" size:(14.0+(isBigCell?4.0:0.0))];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:lblName];
        
        btnInvite=[[UIButton alloc] initWithFrame:CGRectMake(195.0,5.0+(isBigCell?10.0:0.0),95.0,20.0)];
        [self.contentView addSubview:btnInvite];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    imgMainBG.frame=CGRectMake(0.0,0.0,298.0,30.0+(isBigCell?10.0:0.0));
    lblName.frame=CGRectMake(8.0,0.0,172.0,30.0+(isBigCell?10.0:0.0));
    lblName.font=[UIFont fontWithName:@"Helvetica" size:(14.0+(isBigCell?4.0:0.0))];
    btnInvite.frame=CGRectMake(195.0,5.0+(isBigCell?5.0:0.0),95.0,20.0);
}
@end
