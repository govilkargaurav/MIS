//
//  MyFriendCCell.h
//  Suvi
//
//  Created by Imac 2 on 4/26/13.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface MyFriendCCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UIImageView *imgUser;
@property (nonatomic,strong)IBOutlet UILabel *lblUsername;
@property (nonatomic,strong)IBOutlet UILabel *lblNoFriends;
@property (nonatomic,strong)IBOutlet UILabel *lblNoMutualFriends;
@property (nonatomic,strong)IBOutlet UILabel *lblSchoolName;
@property (nonatomic,strong)IBOutlet UIImageView *imgGreen;
@property (nonatomic,strong)IBOutlet UIButton *btnNoteorAccept,*btnWinkorReject;
@property (strong, nonatomic) NSDictionary *dict;
@end

