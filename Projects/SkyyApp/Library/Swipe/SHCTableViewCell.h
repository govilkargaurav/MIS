//
//  SHCTableViewCell.h
//  ClearStyle
//
//  Created by Fahim Farook on 23/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import "SHCToDoItem.h"
#import "SHCTableViewCellDelegate.h"
#import "AppDelegate.h"
#import "SHCStrikethroughLabel.h"

// A custom table cell that renders SHCToDoItem items.
@interface SHCTableViewCell : UITableViewCell

// The item that this cell renders
@property (nonatomic) SHCToDoItem *todoItem;
// The object that acts as delegate for this cell.
@property (nonatomic, assign) id<SHCTableViewCellDelegate> delegate;


@property (weak, nonatomic)  UIView *contentViews;


@property (weak, nonatomic)  UIImageView *arrow;

@property (weak, nonatomic)  UIView *actionViews;

@property (retain,nonatomic) UIView *doubleTapView;

@property(retain,nonatomic)UILabel *_crossLabel;
@property(retain,nonatomic)SHCStrikethroughLabel *_label;
- (void) expandActionView;
- (void) collapseActionViews;

@end
