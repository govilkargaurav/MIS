//
//  UIBubbleTableViewCell.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <UIKit/UIKit.h>
#import "NSBubbleData.h"

@protocol BubbleCopyDelegate;

@interface UIBubbleTableViewCell : UITableViewCell
{
    id<BubbleCopyDelegate> delegate;
}

@property (nonatomic, strong) NSBubbleData *data;
@property (nonatomic, strong) NSString *strCopy;
@property (nonatomic, retain) UIView *customView;
@property (nonatomic) BOOL showAvatar;

@end

@protocol BubbleCopyDelegate<NSObject>
@required
- (void) copyableCell:(UIBubbleTableViewCell *)cell selectCellAtIndexPath:(NSIndexPath *)indexPath;
- (void) copyableCell:(UIBubbleTableViewCell *)cell deselectCellAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSString *) copyableCell:(UIBubbleTableViewCell *)cell dataForCellAtIndexPath:(NSIndexPath *)indexPath;
@end