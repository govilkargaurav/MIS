//
//  ActionSheetStringPicker.h
//  Bridges
//
//  Created by Habib Ali on 6/7/12.
//  Copyright (c) 2012 Folio3 Private Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionSheetStringPicker : UIActionSheet<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSInteger currentSelection;
    NSMutableArray *arrayOfItemsArray;
    UIPickerView *_picker;
    UISegmentedControl *cancelButton;
}
@property (nonatomic) SEL doneAction;
@property (nonatomic) SEL didSelectAction;
@property (nonatomic, assign) UIViewController *viewController;
@property (nonatomic) NSInteger numOfComponents;
@property (nonatomic) BOOL hideCancelButton;

- (id)initWithTitle:(NSString *)title targetViewController:(UIViewController *)controller doneAction:(SEL)doneAct pickerDidSelectAction:(SEL)didSelectAct;
- (void)showActionSheetWithSelectedRow:(NSInteger)row;
- (void)showActionSheet;
- (NSString *)getSelectedItemInComponent:(NSInteger)component;
- (NSInteger)getSelectedIndexInComponent:(NSInteger)component;
- (void)dismissActionSheet;
- (void)setItems:(NSArray *)items inComponent:(NSInteger)component;
- (void)setArrayOfItems:(NSArray *)arrayOfItems;
@end
