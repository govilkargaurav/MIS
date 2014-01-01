//
//  SearchCell.h
//  HuntingApp
//
//  Created by Habib Ali on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLImageView.h"

@interface SearchCell : UITableViewCell

@property (nonatomic,retain) IBOutlet FLImageView *imgView;
@property (nonatomic,retain) IBOutlet UILabel *lblName;

@end
