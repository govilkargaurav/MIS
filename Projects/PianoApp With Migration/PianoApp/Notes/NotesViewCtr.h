//
//  NotesViewCtr.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OverlayViewController;
@interface NotesViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tbl_notes;
    NSMutableArray *ArryNotes;
    NSMutableArray *copyListOfItems;
	IBOutlet UISearchBar *searchBar;
	BOOL searching;
	BOOL letUserSelectRow;
	
	OverlayViewController *ovController;
}

- (void) searchTableView;
- (void) doneSearching_Clicked;
@end
