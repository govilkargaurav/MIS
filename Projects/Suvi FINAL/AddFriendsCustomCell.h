//
//  AddFriendsCustomCell.h
//  Suvi
//
//  Created by Dhaval Vaishnani on 10/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsCustomCell : UITableViewCell
{
    UIImageView *imgview;
    UILabel *lblheader;
    UILabel *lbldesc;
    UILabel *lblfriendcount;
    UIImageView *imgviewacc;
}
@property(nonatomic,retain) UIImageView *imgview;
@property(nonatomic,retain) UILabel *lblheader;
@property(nonatomic,retain) UILabel *lbldesc;
@property(nonatomic,retain) UILabel *lblfriendcount;
@property(nonatomic,retain) UIImageView *imgviewacc;
@end
