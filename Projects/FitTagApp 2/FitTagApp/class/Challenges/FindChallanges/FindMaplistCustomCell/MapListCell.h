//
//  MapListCell.h
//  FitTag
//
//  Created by Mic mini 5 on 3/5/13.

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface MapListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (strong, nonatomic) IBOutlet EGOImageView *imgUsrProfile;

@end
