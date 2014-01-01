//
//  CustomCellTarget.m
//  AIS
//
//  Created by ankit patel on 4/5/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import "CustomCellTarget.h"


@implementation CustomCellTarget 
 
@synthesize lbl1;
@synthesize lbl2;
@synthesize lbl3;
 
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

- (void)dealloc
{
    [super dealloc];
}

@end
