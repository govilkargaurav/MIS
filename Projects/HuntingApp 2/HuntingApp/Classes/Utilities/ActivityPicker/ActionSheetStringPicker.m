//
//  ActionSheetStringPicker.m
//  Bridges
//
//  Created by Habib Ali on 6/7/12.
//  Copyright (c) 2012 Folio3 Private Ltd. All rights reserved.
//

#import "ActionSheetStringPicker.h"

@implementation ActionSheetStringPicker

@synthesize doneAction;
@synthesize viewController;
@synthesize didSelectAction;
@synthesize numOfComponents;
@synthesize hideCancelButton;

- (id)initWithTitle:(NSString *)title targetViewController:(UIViewController *)controller doneAction:(SEL)doneAct pickerDidSelectAction:(SEL)didSelectAct
{
    self = [super initWithTitle:title delegate:nil cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"",@"",@"", nil];
    [self setDelegate:self];
    [self setFrame:CGRectMake(0, 0, 320, 260)];
    [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 216);
    _picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    _picker.showsSelectionIndicator = YES;
    _picker.dataSource = self;
    _picker.delegate = self;
    [self addSubview:_picker];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Done",nil]];
    doneButton.momentary = YES; 
    doneButton.frame = CGRectMake(250.0f, 7.0f, 60.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(doneButtonSelected:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:doneButton];
    RELEASE_SAFELY(doneButton);
    
    cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Cancel",nil]];
    cancelButton.momentary = YES; 
    cancelButton.frame = CGRectMake(10.0f, 7.0f, 60.0f, 30.0f);
    cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
    cancelButton.tintColor = [UIColor blackColor];
    [cancelButton addTarget:self action:@selector(cancelButtonSelected:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:cancelButton];
    
    self.numOfComponents = 1; //default value
    
    [self setViewController:controller];
    [self setDoneAction:doneAct];
    [self setDidSelectAction:didSelectAct];
    
    currentSelection = 0;
    arrayOfItemsArray = [[NSMutableArray alloc]init];
    self.hideCancelButton = NO;
    return self;
}

- (void)dealloc
{
    RELEASE_SAFELY(arrayOfItemsArray);
    RELEASE_SAFELY(_picker);
    RELEASE_SAFELY(cancelButton);
    [super dealloc];
}

- (void)doneButtonSelected:(id)sender
{
    [self dismissActionSheet];
    if (self.viewController && self.doneAction)
        [self.viewController performSelector:self.doneAction];
}

- (void)cancelButtonSelected:(id)sender
{
    [self dismissActionSheet];
}
- (void)setItems:(NSArray *)items inComponent:(NSInteger)component
{
    if ([arrayOfItemsArray count]>component)
        [arrayOfItemsArray replaceObjectAtIndex:component withObject:items];
    else {
        [arrayOfItemsArray insertObject:items atIndex:component];
    }
    [_picker reloadComponent:component];
}

- (void)setArrayOfItems:(NSArray *)arrayOfItems
{
    self.numOfComponents = [arrayOfItems count];
    RELEASE_SAFELY(arrayOfItemsArray);
    arrayOfItemsArray = [[NSMutableArray alloc]initWithArray:arrayOfItems];
    [_picker reloadAllComponents];
}

- (void)showActionSheetWithSelectedRow:(NSInteger)row
{
    currentSelection = row;
    [_picker selectRow:currentSelection inComponent:0 animated:NO];
    if (self.viewController.navigationController.tabBarController.tabBar)
        [self showFromTabBar:self.viewController.navigationController.tabBarController.tabBar];
    else
        [self showInView:self.viewController.view];
}

- (void)showActionSheet
{
    [_picker selectRow:currentSelection inComponent:0 animated:NO];
    if (self.viewController.navigationController.tabBarController.tabBar)
        [self showFromTabBar:self.viewController.navigationController.tabBarController.tabBar];
    else
        [self showInView:self.viewController.view];
}

- (NSString *)getSelectedItemInComponent:(NSInteger)component
{
    currentSelection = [_picker selectedRowInComponent:component];
    NSArray *_items = [arrayOfItemsArray objectAtIndex:component];
    NSString *currentItem = [_items objectAtIndex:currentSelection];
    return currentItem;
}

- (NSInteger)getSelectedIndexInComponent:(NSInteger)component
{
    currentSelection = [_picker selectedRowInComponent:component];
    return currentSelection;

}

- (void)dismissActionSheet
{
    [self pickerView:_picker didSelectRow:[_picker selectedRowInComponent:0] inComponent:0];
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)setHideCancelButton:(BOOL)hide
{
    [cancelButton setHidden:hide];
}

#pragma mark - picker methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numOfComponents;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([arrayOfItemsArray count]>component)
    {
        NSArray *_items = [arrayOfItemsArray objectAtIndex:component];
        return [_items count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *_items = [arrayOfItemsArray objectAtIndex:component];
    return [_items objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (didSelectAction)
        [self.viewController performSelector:didSelectAction];
}

@end
