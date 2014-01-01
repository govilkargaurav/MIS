//
//  FindMapListViewController.h
//  FitTagApp
//
//  Created by apple on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@protocol ListSelectionBack <NSObject>
-(void)backWithListSelection:(NSMutableDictionary *)dictLocationInfo indexNo:(int)intIndexNo;
@end

@interface FindMapListViewController : UIViewController{
}
@property (strong, nonatomic) IBOutlet UITableView *tblMapList;
@property(strong,nonatomic)NSMutableArray *mutArrayNearChlng;
@property(strong,nonatomic)id <ListSelectionBack> delegate;
-(IBAction)btnMapPressed:(id)sender;
@end
