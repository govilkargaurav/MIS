//
//  FrndChlngCell.m
//  FitTagApp
//
//  Created by apple on 2/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FrndChlngCell.h"

@implementation FrndChlngCell
@synthesize imgProfileview;
@synthesize lblFrndName;
@synthesize btnFrndChlnge;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray=[[NSBundle mainBundle]loadNibNamed:@"FrndChlngCell" owner:self options:nil];
        self=[nibArray objectAtIndex:0];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
