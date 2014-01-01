//
//  ActivityCell.m
//  FitTag
//
//  Created by Mic mini 5 on 3/2/13.


#import "ActivityCell.h"
#import "EGOImageView.h"

@implementation ActivityCell
@synthesize lblTitle,lblComment,lblTime,imgViewContent,imgViewContentBg,imgViewUserProfile,btnUserName;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray=[[NSBundle mainBundle]loadNibNamed:@"ActivityCell" owner:self options:nil];
        self=[nibArray objectAtIndex:0];
    }
    return self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
