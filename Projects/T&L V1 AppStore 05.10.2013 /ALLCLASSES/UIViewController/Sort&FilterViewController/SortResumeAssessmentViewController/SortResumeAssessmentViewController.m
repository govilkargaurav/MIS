//
//  SortResumeAssessmentViewController.m
//  TLISC
//
//  Created by KPIteng on 5/8/13.
//
//

#import "SortResumeAssessmentViewController.h"
#import "GlobleClass.h"
@interface SortResumeAssessmentViewController ()

@end

@implementation SortResumeAssessmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _arraywithName=[NSArray arrayWithObjects:@"Participant Name, A-Z",@"Participant Name, Z-A",@"Unit Name, A-Z",@"Unit Name Z-A",@"Unit Code, ascending",@"Unit Code, descending",@"Assessment Date, ascending",@"Assessment Date, descending", nil];
    
    if (tblSortResumeAss!=nil) {
        tblSortResumeAss=nil;
        [tblSortResumeAss removeFromSuperview];
    }
    
    tblSortResumeAss=[[UITableView alloc] initWithFrame:CGRectMake(0,0, 250,320) style:UITableViewStylePlain];
    tblSortResumeAss.delegate=self;
    tblSortResumeAss.dataSource=self;
    tblSortResumeAss.rowHeight=45;
    tblSortResumeAss.separatorStyle=UITableViewCellSeparatorStyleNone;
    tblSortResumeAss.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tblSortResumeAss];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arraywithName count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell) {
        cell=nil;
        [cell removeFromSuperview];
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *sapratorImage=[[UIImageView alloc] initWithFrame:CGRectMake(0,42,258,3)];
    [sapratorImage setImage:[UIImage imageNamed:@"separator.png"]];
    [cell.contentView addSubview:sapratorImage];
    
    UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(5,11,290,25)];
    titleLbl.backgroundColor=[UIColor clearColor];
    titleLbl.textColor=[UIColor whiteColor];
    titleLbl.font=[UIFont systemFontOfSize:16];
    titleLbl.text=[_arraywithName objectAtIndex:indexPath.row];
    [cell.contentView addSubview:titleLbl];
    
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sortResumeAssType = [_arraywithName objectAtIndex:indexPath.row];
    NSNotification *notif = [NSNotification notificationWithName:@"RELOAD_TABLE_WITH_SORT_OPTION" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
@end
