//
//  PullUpToRefreshViewController.h
//  Suvi
//
//  Created by Gagan Mishra on 2/26/13.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MNMBottomPullToRefreshManager.h"

@interface PullUpToRefreshViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MNMBottomPullToRefreshManagerClient>
{
    @private
    UITableView *table_;
    MNMBottomPullToRefreshManager *pullToRefreshManager_;
    NSUInteger reloads_;
}

@property (nonatomic, readwrite, strong) IBOutlet UITableView *table;

@end