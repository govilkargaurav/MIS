//
//  ContactCustomCell.m
//  Suvi
//
//  Created by Dhaval Vaishnani on 10/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactCustomCell.h"

@implementation ContactCustomCell
@synthesize imgview,lblcontactname,btninvite;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        imgview=[[UIImageView alloc]init];
        imgview.frame=CGRectMake(5, 2.5,35,35);
        
        lblcontactname=[[UILabel alloc]init];
        lblcontactname.frame=CGRectMake(55, 0,190, 40);
        lblcontactname.font=[UIFont fontWithName:@"Arial-Bold" size:18];
        lblcontactname.backgroundColor = [UIColor clearColor];
        lblcontactname.textColor = [UIColor darkGrayColor];
        
        btninvite=[UIButton buttonWithType:UIButtonTypeCustom];
        [btninvite setImage:[UIImage imageNamed:@"btnAddFriend.png"] forState:UIControlStateNormal];
        btninvite.frame=CGRectMake(260+23,6.5, 27, 27);
        btninvite.showsTouchWhenHighlighted=YES;
        
        [self.contentView addSubview:imgview];
        [self.contentView addSubview:lblcontactname];
        [self.contentView addSubview:btninvite];
        
        UIView *viewSeparater=[[UIView alloc]initWithFrame:CGRectMake(0.0,39.0,320.0,1.0)];
        viewSeparater.backgroundColor=[UIColor darkGrayColor];
        [self.contentView addSubview:viewSeparater];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
