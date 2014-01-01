//
//  ManageRequestsCell.m
//  Suvi
//
//  Created by Dhaval Vaishnani on 11/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManageRequestsCell.h"

@implementation ManageRequestsCell

@synthesize imgview,lblcontactname,lblcontactuname,imgviewbadge,btnAddFriend,btnRejectFriend;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgview=[[UIImageView alloc]init];
        imgview.frame=CGRectMake(4,3,30,30);
        //imgview.layer.cornerRadius=2.0;
        //imgview.layer.borderColor=[UIColor blackColor].CGColor;
        //imgview.layer.borderWidth=1.0f;
        imgview.backgroundColor=[UIColor grayColor];
        
        imgviewbadge=[[UIImageView alloc]init];
        imgviewbadge.frame=CGRectMake(37,3,25,25);
        
        lblcontactname=[[UILabel alloc]init];
        lblcontactname.frame=CGRectMake(64,4,190,18);
        lblcontactname.font=[UIFont fontWithName:@"Arial-Bold" size:12];
        lblcontactname.backgroundColor = [UIColor clearColor];
        lblcontactname.textColor = [UIColor darkGrayColor];
        
        lblcontactuname=[[UILabel alloc]init];
        lblcontactuname.frame=CGRectMake(64,20,190,16);
        lblcontactuname.font=[UIFont fontWithName:@"Arial" size:11];
        lblcontactuname.backgroundColor = [UIColor clearColor];
        lblcontactuname.textColor = [UIColor darkGrayColor];
        
        btnRejectFriend=[[UIButton alloc]initWithFrame:CGRectMake(290,7.5,25,25)];
        btnAddFriend=[[UIButton alloc]initWithFrame:CGRectMake(265,7.5,25,25)];
        
        [self.contentView addSubview:imgview];
        [self.contentView addSubview:imgviewbadge];
        [self.contentView addSubview:lblcontactname];
        [self.contentView addSubview:lblcontactuname];
        [self.contentView addSubview:btnRejectFriend];
        [self.contentView addSubview:btnAddFriend];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
