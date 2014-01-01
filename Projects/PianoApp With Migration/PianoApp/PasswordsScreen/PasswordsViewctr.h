//
//  PasswordsViewctr.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@class OverlayViewController;
@interface PasswordsViewctr : UIViewController <UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UITableView *tbl_passwords;
    IBOutlet UIToolbar *toolbarView;
    NSMutableArray *ArryPasswords;
    NSMutableDictionary *sections;
    NSMutableArray *copyListOfItems;
    IBOutlet UISearchBar *searchBar;
    BOOL searching;
	BOOL letUserSelectRow;
	NSMutableArray *aryUnSorted,*aryDateSort,*aryMostSort;
	OverlayViewController *ovController;
    
    //PickerView -----------------------------
    UIPickerView *pickerView;
    UIToolbar *toolBar;
    NSMutableArray *ArryType;
    int catID;
    NSString *strTypeFiltr;
    
    NSMutableArray *valueArray;
    
}

- (void) searchTableView;
- (void) doneSearching_Clicked;
-(void)ReloadAllTblData;
-(void)PickerHide;
-(void)PickerShow;
@end
