//
//  FacebookFriendCustomCell.m
//  SkyyApp
//
//  Created by Vishal Jani on 9/5/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import "FacebookFriendCustomCell.h"

@implementation FacebookFriendCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibArray=[[NSBundle mainBundle]loadNibNamed:@"FacebookFriendCustomCell" owner:self options:nil];
        self=[nibArray objectAtIndex:0];      }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
