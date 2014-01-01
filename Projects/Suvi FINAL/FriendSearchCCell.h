//
//  FriendSearchCCell.h
//  Suvi
//
//  Created by Imac 2 on 5/16/13.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface FriendSearchCCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UIImageView *imgUser;
@property (nonatomic,strong)IBOutlet UILabel *lblUsername;
@property (nonatomic,strong)IBOutlet UILabel *lblNoFriends;
@property (nonatomic,strong)IBOutlet UILabel *lblNoMutualFriends;
@property (nonatomic,strong)IBOutlet UILabel *lblSchoolName;
@property (nonatomic,strong)IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) NSDictionary *dict;
@end
