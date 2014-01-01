//
//  InviteViewContactCell.h
//  Suvi
//
//  Created by Dhaval Vaishnani on 11/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteViewContactCell : UITableViewCell
{
    UIImageView *imgview;
    UILabel *lblcontactname;
}
@property(nonatomic,retain) UIImageView *imgview;
@property(nonatomic,retain) UILabel *lblcontactname;
@end
