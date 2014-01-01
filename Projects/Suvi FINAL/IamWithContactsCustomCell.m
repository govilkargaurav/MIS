//
//  IamWithContactsCustomCell.m
//  Suvi
//
//  Created by Vivek Rajput on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IamWithContactsCustomCell.h"

@implementation IamWithContactsCustomCell

@synthesize imgview,lblcontactname;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        imgview=[[UIImageView alloc]init];
        imgview.tag=1001;
        imgview.frame=CGRectMake(2.5, 2.5, 39, 39);
        
        lblcontactname=[[UILabel alloc]init];
        lblcontactname.frame=CGRectMake(49,0,240,44);
        lblcontactname.font=[UIFont fontWithName:@"Arial" size:18];
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
}

@end
