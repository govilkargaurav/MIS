//
//  PopoverSort.m
//  T&L
//
//  Created by openxcell tech.. on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopoverSort.h"
#import "GlobleClass.h"

@implementation PopoverSort

@synthesize _tableView;

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _arraywithName=[NSArray arrayWithObjects:@"NAME, A-Z",@"NAME, Z-A",@"DATE, Ascending",@"DATE, Descending",@"Code, Ascending",@"Code, Descending", nil];
    
    if (_tableView!=nil) {
        _tableView=nil;
        [_tableView removeFromSuperview];
    }
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, 230,320) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=45;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
}



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
    if([sortViewName isEqualToString:@"IMPORTPARTICIPANT"])
    {
        strSortType = [_arraywithName objectAtIndex:indexPath.row];
        NSNotification *notif = [NSNotification notificationWithName:@"RELOAD_IMPORT_PARTICIPANT" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notif];  
    }
    else if([sortViewName isEqualToString:@"LEARNING"])
    {
        strSortType = [_arraywithName objectAtIndex:indexPath.row];
        NSNotification *notif = [NSNotification notificationWithName:@"RELOAD_LEARNING" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
    else
    {
        strSortType = [_arraywithName objectAtIndex:indexPath.row];
        NSNotification *notif = [NSNotification notificationWithName:@"RELOADSORTED" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notif];  
    }
      
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end
