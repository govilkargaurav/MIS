//
//  ImportParticipants.h
//  T&L
//
//  Created by openxcell tech.. on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverFilter.h"
#import "PopoverSort.h"
#import "AssessmentsVIewController.h"
#import "DatabaseAccess.h"

@interface ImportParticipants : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{

    UIButton *cellbutton;
    UIPopoverController *popoverController; 
    PopoverFilter *_popOverController;
    PopoverSort *_popOverSort;
    IBOutlet UITextField *tfSearchBox;
    //---TopBar Selected
    IBOutlet UIImageView *ivTopBarSelected;
    
}

@property(nonatomic,strong)AssessmentsVIewController *controller;
@property(nonatomic,strong)NSMutableArray *_getallParticipantsArr;
@property(nonatomic,strong)UITableView *_tableView;
-(void)createTableView;
-(void)reloadImportParticipant;
- (IBAction)btnBackTapped:(id)sender;
@end


