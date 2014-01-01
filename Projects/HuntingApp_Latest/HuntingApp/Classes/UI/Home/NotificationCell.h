//
//  NotificationCell.h
//  HuntingApp
//
//  Created by Habib Ali on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLImageView.h"

@interface NotificationCell : UITableViewCell
@property (retain, nonatomic) IBOutlet FLImageView *imgView;
@property (retain, nonatomic) IBOutlet UILabel *lblCaption;
@property (retain, nonatomic) IBOutlet UILabel *lblLocation;
@property (retain, nonatomic) IBOutlet UIView *bgView;
@end
