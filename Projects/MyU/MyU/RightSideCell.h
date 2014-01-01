//
//  RightSideCell.h
//  MyU
//
//  Created by Vijay on 7/9/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OHAttributedLabel/OHAttributedLabel.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicHTMLParser.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>

typedef enum
{
    CellType_Group_Updates,
    CellType_Private_Messages,
    CellType_Notification_Simple,
    CellType_Notification_Invite,
    CellType_User_Searching
}
CellType;

@interface RightSideCell : UITableViewCell
{
    
}

@property (nonatomic,strong) UIView *viewBG;
@property (nonatomic,strong) UIImageView *imgDevider;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *lblViewHeader;
@property (nonatomic,strong) UILabel *lblBadge;
@property (nonatomic,strong) OHAttributedLabel *lblattributed;
@property (nonatomic,strong) UIButton *btnAccept;
@property (nonatomic,strong) UIButton *btnIgnore;


@property (nonatomic,readwrite) CellType theCellType;
@property (nonatomic,readwrite) BOOL isSelectedBG;

@end
