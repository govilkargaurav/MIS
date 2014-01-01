//
//  MapListCell.m
//  FitTag
//
//  Created by Mic mini 5 on 3/5/13.

#import "MapListCell.h"

@implementation MapListCell
@synthesize lblSubTitle,lblTitle,imgUsrProfile;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibArray=[[NSBundle mainBundle]loadNibNamed:@"MapListCell" owner:self options:nil ];
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
