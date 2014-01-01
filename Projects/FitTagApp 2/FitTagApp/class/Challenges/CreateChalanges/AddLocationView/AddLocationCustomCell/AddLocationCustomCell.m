//
//  AddLocationCustomCell.m
//  FitTag
//
//  Created by Shivam on 3/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AddLocationCustomCell.h"

@implementation AddLocationCustomCell

@synthesize lblLocatioName;
@synthesize lblLocationAddress;
@synthesize btnAddNewLocation;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        // Initialization code
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"AddLocationCustomCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    [super setSelected:selected animated:animated];
}

@end
