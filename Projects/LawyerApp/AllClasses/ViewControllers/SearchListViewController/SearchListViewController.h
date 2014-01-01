//
//  SearchListViewController.h
//  LawyerApp
//
//  Created by ChintaN on 6/8/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchListCell.h"
@interface SearchListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)IBOutlet UITableView *tblView;
-(IBAction)btnLawyerPressed :(id)sender;
@property (strong, nonatomic)NSArray *ArrJsonResponse;
@end
