//
//  LikerCustomCell.m
//  FitTag
//
//  Created by apple on 4/12/13.
//
//

#import "LikerCustomCell.h"

@implementation LikerCustomCell
@synthesize imgProfileView,lblUserName;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray=[[NSBundle mainBundle]loadNibNamed:@"LikerCustomCell" owner:self options:nil];
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
