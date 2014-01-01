//
//  ManageRequestsCell.h
//  Suvi
//
//  Created by Dhaval Vaishnani on 11/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageRequestsCell : UITableViewCell
{
    UIImageView *imgview;
    UILabel *lblcontactname;
    UILabel *lblcontactuname;
    UIImageView *imgviewbadge;
    UIButton *btnAddFriend;
    UIButton *btnRejectFriend;
}
@property(nonatomic,retain) UIImageView *imgview;
@property(nonatomic,retain) UILabel *lblcontactname;
@property(nonatomic,retain) UILabel *lblcontactuname;
@property(nonatomic,retain) UIImageView *imgviewbadge;
@property(nonatomic,retain) UIButton *btnAddFriend;
@property(nonatomic,retain) UIButton *btnRejectFriend;

@end
