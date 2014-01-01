//
//  InviteViewContactCell.m
//  Suvi
//
//  Created by Dhaval Vaishnani on 11/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InviteViewContactCell.h"

@implementation InviteViewContactCell
@synthesize imgview,lblcontactname;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgview=[[UIImageView alloc]init];
        imgview.frame=CGRectMake(285,2.5,25,25);
        
        lblcontactname=[[UILabel alloc]init];
        lblcontactname.frame=CGRectMake(12, 0,265,30);
        lblcontactname.font=[UIFont fontWithName:@"Arial-Bold" size:18];
        lblcontactname.backgroundColor = [UIColor clearColor];
        lblcontactname.textColor = [UIColor darkGrayColor];
        
        [self.contentView addSubview:imgview];
        [self.contentView addSubview:lblcontactname];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
