//
//  ViewController.h
//  LawyerApp
//
//  Created by Openxcell Game on 6/6/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReverseGeoCoder.h"
#import "DejalActivityView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController : UIViewController<UISearchBarDelegate,UITextFieldDelegate>{
    
    DejalActivityView *loadingActivityIndicator;
    AppDelegate *appdelegate;
    NSMutableArray *arraySearchText;
    NSOperationQueue *_queue;
    
}
@property (nonatomic,strong)IBOutlet UIImageView *imgViewLabel;
@property (nonatomic,strong)IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong)NSMutableDictionary *dictLawyerInfo;
@property (nonatomic,strong)NSMutableArray *ArrLawyerInfo;
@property (nonatomic,strong)IBOutlet UITableView *_tableView;
@property (nonatomic,strong)IBOutlet UITextField *_searchTextField;


@end
