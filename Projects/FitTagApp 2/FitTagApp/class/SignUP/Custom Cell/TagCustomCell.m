//
//  TagCustomCell.m
//  FitTagApp
//
//  Created by apple on 2/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TagCustomCell.h"

@implementation TagCustomCell
@synthesize lblTitle;
@synthesize btnAdd;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray=[[NSBundle mainBundle]loadNibNamed:@"TagCustomCell" owner:self options:nil];
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
