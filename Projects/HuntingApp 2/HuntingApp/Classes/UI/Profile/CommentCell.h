//
//  CommentCell.h
//  HuntingApp
//
//  Created by Habib Ali on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLButton.h"

@interface CommentCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIButton *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblComment;
@property (nonatomic, retain) IBOutlet FLButton *profilePic;

@end
