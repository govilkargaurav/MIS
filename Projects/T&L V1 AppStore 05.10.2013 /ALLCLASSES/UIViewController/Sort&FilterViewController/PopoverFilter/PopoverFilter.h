//
//  PopoverFilter.h
//  T&L
//
//  Created by openxcell tech.. on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@interface PopoverFilter : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *cellSideColorImgArr;
    UIImage *_selectedImage;
    UIImage *_unselectedImage;
    BOOL inPseudoEditMode;
    NSMutableArray *array;
}
@property(nonatomic,strong)NSMutableArray *_selectedArray;
@property(nonatomic,strong)UIImage *_selectedImage;
@property(nonatomic,strong)UIImage *_unselectedImage;
@property(nonatomic,strong)NSArray *cellSideColorImgArr;
@property(nonatomic,strong)UITableView *_tableView;

@end
