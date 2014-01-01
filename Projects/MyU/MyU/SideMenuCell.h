//
//  SideMenuCell.h
//  MyU
//
//  Created by Vijay on 7/8/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    CellType_Header,
    CellType_Middle,
    CellType_Footer    
}
CellType;

@interface SideMenuCell : UITableViewCell
{
    UIView *view_bg;
    UIImageView *imgView;
    UILabel *lblView;
    UILabel *lblUni;
    CellType theCellType;
}

@property (nonatomic,strong) UIView *view_bg;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *lblView;
@property (nonatomic,strong) UILabel *lblUni;
@property (nonatomic,readwrite) CellType theCellType;
@property (nonatomic,readwrite) BOOL isSelectedBG;
@end
