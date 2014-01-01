//
//  AddCommentCell.h
//  Suvi
//
//  Created by Vivek Rajput on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface AddCommentCell : UITableViewCell
{
    
}

@property(nonatomic,retain)IBOutlet UILabel *lblComment;
@property(nonatomic,retain)IBOutlet UILabel *lblDateCell;
@property(nonatomic,retain)IBOutlet UIImageView *imgUser;
@property(nonatomic,retain)IBOutlet UILabel *lblFullName;
@property (strong, nonatomic) NSDictionary *dict;

@end
