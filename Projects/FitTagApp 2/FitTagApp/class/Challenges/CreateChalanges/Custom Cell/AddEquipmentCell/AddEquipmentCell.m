//
//  AddEquipmentCell.m
//  FitTag
//
//  Created by Shivam on 3/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AddEquipmentCell.h"

@implementation AddEquipmentCell
@synthesize lblEquipment;
@synthesize btnAddEquipment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray=[[NSBundle mainBundle]loadNibNamed:@"AddEquipmentCell" owner:self options:nil];
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
