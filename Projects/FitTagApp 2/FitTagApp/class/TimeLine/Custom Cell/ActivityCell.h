//
//  ActivityCell.h
//  FitTag
//
//  Created by Mic mini 5 on 3/2/13.
//
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface ActivityCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet EGOImageView *imgViewUserProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewContent;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewContentBg;
@property (strong, nonatomic) IBOutlet UILabel *lblComment;

@end
