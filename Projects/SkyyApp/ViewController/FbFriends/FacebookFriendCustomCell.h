//
//  FacebookFriendCustomCell.h
//  SkyyApp
//
//  Created by Vishal Jani on 9/5/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface FacebookFriendCustomCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UILabel *lblUserName;
@property(nonatomic,retain)IBOutlet EGOImageView *userProfileImage;
@end
