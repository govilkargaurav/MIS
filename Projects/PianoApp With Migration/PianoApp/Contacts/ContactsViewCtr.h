//
//  ContactsViewCtr.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@class OverlayViewController;
@interface ContactsViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ABPeoplePickerNavigationControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UITableView *tbl_contacts;
    IBOutlet UIToolbar *toolbarView;
    NSMutableArray *ArryContacts;
    NSMutableDictionary *sections;
    NSMutableArray *copyListOfItems;
    IBOutlet UISearchBar *searchBar;
    BOOL searching;
	BOOL letUserSelectRow;
    NSMutableArray *aryUnSorted,*aryDateSort;
	
	OverlayViewController *ovController;
    
    //PickerView -----------------------------
    UIPickerView *pickerView;
    UIToolbar *toolBar;
    NSMutableArray *ArryType;
    int catID;

    NSMutableArray *valueArray;
}

- (void) searchTableView;
- (void) doneSearching_Clicked;
-(void)ReloadAllTblData;
-(NSString *)RemovePhoneExtraChar:(NSString *)strphoneno;
- (NSString *)removeNull:(NSString *)str;
@end
