//
//  ProfileViewController.h
//  MyU
//
//  Created by Vijay on 7/12/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController 

@property (nonatomic,assign) BOOL isProfileViewMine;
@property (nonatomic,assign) BOOL isProfileViewFromComment;
@property (nonatomic,strong) NSString *strTheUserId;
@property (nonatomic,strong) NSMutableArray *arrGetallChat;
@property (nonatomic,strong) NSString *strGroupOrPersonName;
@end
