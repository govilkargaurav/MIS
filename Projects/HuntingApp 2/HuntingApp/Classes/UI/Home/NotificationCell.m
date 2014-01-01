//
//  NotificationCell.m
//  HuntingApp
//
//  Created by Habib Ali on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell
@synthesize imgView;
@synthesize lblCaption;
@synthesize lblLocation;
@synthesize bgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [imgView release];
    [lblCaption release];
    [lblLocation release];
    [bgView release];
    [super dealloc];
}
@end
