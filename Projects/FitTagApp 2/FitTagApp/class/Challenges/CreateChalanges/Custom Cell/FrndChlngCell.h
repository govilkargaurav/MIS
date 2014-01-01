//
//  FrndChlngCell.h
//  FitTagApp
//
//  Created by apple on 2/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface FrndChlngCell : UITableViewCell
{



}
@property (strong, nonatomic) IBOutlet EGOImageView *imgProfileview;

@property (strong, nonatomic) IBOutlet UILabel *lblFrndName;
@property (strong, nonatomic) IBOutlet UIButton *btnFrndChlnge;

@end
