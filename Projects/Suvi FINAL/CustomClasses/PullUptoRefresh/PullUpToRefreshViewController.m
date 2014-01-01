//
//  PullUpToRefreshViewController.m
//  Suvi
//
//  Created by Gagan Mishra on 2/26/13.
//
//

#import "PullUpToRefreshViewController.h"

@interface PullUpToRefreshViewController ()

//@private
-(void)loadTable;

@end

@implementation PullUpToRefreshViewController
@synthesize table = table_;

- (void)viewDidLoad
{
    [super viewDidLoad];
	reloads_ = -1;
    
    pullToRefreshManager_ = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:table_ withClient:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTable];
}

- (void)loadTable
{
    reloads_++;
    [table_ reloadData];
    [pullToRefreshManager_ tableViewReloadFinished];
}

#pragma mark - TABLEVIEW
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"CellIdentifier";
    UITableViewCell* result = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (result == nil)
    {
        result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        result.selectionStyle = UITableViewCellSelectionStyleNone;
        result.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    result.textLabel.text = [NSString stringWithFormat:@"Row %i", indexPath.row];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:result.frame];
    
    if (indexPath.row % 2 == 0) {
        
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
        
    } else {
        
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    }
    
    result.backgroundView = backgroundView;
    
    return result;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5 + (5 * reloads_);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}


#pragma mark - PULL-UP-TO-REFRESH DELEGATE
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [pullToRefreshManager_ tableViewScrolled];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [pullToRefreshManager_ tableViewReleased];
}
- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager
{
    [self performSelector:@selector(loadTable) withObject:nil afterDelay:1.0f];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [pullToRefreshManager_ relocatePullToRefreshView];
}


#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
