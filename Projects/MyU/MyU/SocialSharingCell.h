//
//  SocialSharingCell.h
//  MyU
//
//  Created by Vijay on 9/7/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialSharingCell : UITableViewCell
{
    
}

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *bgimageview;
@property (nonatomic,strong) UILabel *lblFriendName;
@property (nonatomic,strong) UIButton *btnInvite;
@property (nonatomic,readwrite) BOOL isFacebookCell;

@end
