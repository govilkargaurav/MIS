//
//  GroupCustomCell.h
//  MyU
//
//  Created by Vijay on 7/12/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupCustomCell : UITableViewCell
{
    
}

@property (nonatomic,strong) UIImageView *imgMainBG;
@property (nonatomic,strong) UIImageView *imgGroupPic;
@property (nonatomic,strong) UILabel *lblGroupName;
@property (nonatomic,strong) UILabel *lblGroupBy;
@property (nonatomic,strong) UILabel *lblGroupMembers;
@property (nonatomic,strong) UILabel *lblGroupUpdates;
@property (nonatomic,strong) UIButton *btnJoin;


@end
