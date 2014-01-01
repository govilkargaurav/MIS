//
//  CommentCell.m
//  FitTag
//
//  Created by Gagan Mishra on 3/13/13.
//
//

#import "CommentCell.h"

@implementation CommentCell
@synthesize profileImageView,lblComment,lblTime,lblUserName;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray=[[NSBundle mainBundle]loadNibNamed:@"CommentCell" owner:self options:nil];
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
