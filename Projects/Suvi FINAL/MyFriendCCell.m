//
//  MyFriendCCell.m
//  Suvi
//
//  Created by Imac 2 on 4/26/13.
//
//

#import "MyFriendCCell.h"

@implementation MyFriendCCell
@synthesize imgUser;
@synthesize lblNoFriends,lblNoMutualFriends,lblUsername,lblSchoolName;
@synthesize dict;
@synthesize btnNoteorAccept,btnWinkorReject;

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

-(void)setDict:(NSDictionary *)dictionar
{
    if ([dictionar valueForKey:@"urlAvtar"]!=nil)
    {
        NSString *strURLnew = [NSString stringWithFormat:@"%@",[dictionar valueForKey:@"urlAvtar"]];
        imgUser.tag=1001;
        [imgUser setImageWithURL:[NSURL URLWithString:strURLnew] placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
    }
}
@end
