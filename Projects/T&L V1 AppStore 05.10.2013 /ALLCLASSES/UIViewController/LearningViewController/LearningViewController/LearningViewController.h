//
//  LearningViewController.h
//  T&L
//
//  Created by openxcell tech.. on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverFilter.h"
#import "PopoverSort.h"
#import "ResourceDetailView.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "DatabaseAccess.h"
#import "LearningInfoViewController.h"
#import "MBProgressHUD.h"

@interface LearningViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,LearningInfoDelegate>{
    
    NSArray *cellSideColorImgArr;
    
    UITableViewCell *cell;
//    NSMutableDictionary *_downloadStatusDict;
    UIPopoverController *popoverController; 
    PopoverFilter *_popOverController;
    PopoverSort *_popOverSort;
    ResourceDetailView *_rsDetailView;
    
    
    IBOutlet UITextField *tfSearchTextBox;
    
    //--------------Parse URL------
    NSDictionary *results;
    NSMutableArray *LearningRecords,*LearningALLRecords,*LearningFilter;
    NSURLConnection *conn;
    AppDelegate *appDel;
    NSMutableArray *aryParseArray;
    
    NSString *strQuery;
    int CountValue;
    NSMutableArray *aryTextArray,*aryFileArray;
    
    IBOutlet UIImageView *ivTopBarSelected;
    
    LearningInfoViewController *objLearningInfoViewController;
 
    MBProgressHUD *HUD;
}

-(void)btnSuperViewReload:(id)sender;
-(void)createTableView;
-(void)customActionPressed:(id)sender;
-(void)viewDissmiss;

@property(nonatomic,strong)NSMutableArray *buttonArray;
@property(nonatomic,strong)UITableView *_tableView;
@end





