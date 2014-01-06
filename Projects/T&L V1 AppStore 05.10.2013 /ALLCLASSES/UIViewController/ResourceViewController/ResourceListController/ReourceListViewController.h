//
//  ReourceListViewController.h
//  T&L
//
//  Created by openxcell tech.. on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverFilter.h"
#import "PopoverSort.h"
#import "ResourceDetailView.h"
#import "ParticipantTypeViewController.h"
#import "DatabaseAccess.h"
#import "MBProgressHUD.h"

@interface ReourceListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    PopoverFilter *_popOverController;
    PopoverSort *_popOverSort;
    AppDelegate *appDel;
    ParticipantTypeViewController *objParticipantTypeViewController;
    ResourceDetailView *_rsDetailView;
    
    UIButton *cellbutton;
    UIPopoverController *popoverController; 
    UITableView *_tableView;
    
    NSMutableArray *allResources;
    NSString *SectorName,*strResourceID;
    NSMutableDictionary *dictColorStrip;
    
    IBOutlet UIButton *btnFilter;
    IBOutlet UITextField *tfSearchTextBox;
    
    //---------Strip Color
    UIColor *stipColor;
    
    //---TopBar Selected
    IBOutlet UIImageView *ivTopBarSelected;
    
}
@property(nonatomic,strong)NSURLRequest *request;
@property(nonatomic,strong)NSMutableDictionary *searchDict,*dictResouctID;
@property(nonatomic,strong)NSMutableDictionary *statuses;
@property(nonatomic,strong)NSMutableArray *searchArray,*allResources;
@property(nonatomic,strong)NSMutableArray *buttonArray;
@property(nonatomic,strong)NSMutableArray *buttonArray2;
@property(nonatomic,strong)NSString *_parsingTypeStr;
@property(nonatomic,strong) UITableView *_tableView;
//---------------KP
@property(nonatomic,strong)NSMutableArray *_getallTasks;

-(void)StartParsing:(NSString *)type;
-(void)customActionPressed:(id)sender;
-(void)viewDissmiss;
-(void)downloadIt;
-(void)reloadTableView;
-(void)reloadTableViewSorted;
-(void)reloadTableViewFilter;
-(IBAction)btnSearchTapped:(id)sender;
-(void)hideFilter;
-(void)FilterTblData:(NSString*)strSortType;
-(void)downloadInProgress;
@end
