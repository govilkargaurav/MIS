//
//  CommentCell.h
//  FitTag
//
//  Created by Gagan Mishra on 3/13/13.
//
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface CommentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet EGOImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UITextView *lblComment;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@end
