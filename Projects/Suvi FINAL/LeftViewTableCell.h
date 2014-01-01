//
//  LeftViewTableCell.h
//  Suvi
//
//  Created by Vivek Rajput on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Utilities.h"
#import "UIImageView+WebCache.h"

@interface LeftViewTableCell : UITableViewCell
{
    
}
@property(nonatomic,retain)IBOutlet UIImageView *imgCellBG;

@property(nonatomic,retain)IBOutlet UIImageView *imgPostType;
@property(nonatomic,retain)IBOutlet UIImageView *imgComentLikeDislike;

@property(nonatomic,retain)IBOutlet UIButton *btnCell;
@property(nonatomic,retain)IBOutlet UILabel *lblTitle;
@property(nonatomic,retain)IBOutlet UILabel *lblDate;


@property(nonatomic,retain)IBOutlet UIImageView *imgUserPic;
@property (strong, nonatomic) NSDictionary *dict;
@end
