//
//  PopoverFilter.m
//  T&L
//
//  Created by openxcell tech.. on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopoverFilter.h"
#import "GlobleClass.h"
@implementation PopoverFilter

@synthesize _tableView,cellSideColorImgArr;
@synthesize _selectedImage,_unselectedImage,_selectedArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (_selectedArray!=nil) {
            _selectedArray=nil;
        }
        _selectedArray=[[NSMutableArray alloc]init];
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
    
    
    if (_tableView!=nil) {
        _tableView=nil;
        [_tableView removeFromSuperview];
    }
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, 320,270) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=45;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    
    cellSideColorImgArr=[NSArray arrayWithObjects:@"1.png",@"2.png",@"3.png",@"4.png", nil];
    
    self._selectedImage = [UIImage imageNamed:@"CHECKBOXIN.png"];
	self._unselectedImage = [UIImage imageNamed:@"CheckboxOUT.png"];
    inPseudoEditMode = YES;
    
    
    
    array = [[NSMutableArray alloc] init];
        [array addObject:@"Aviation"];
        [array addObject:@"Logistics & Warehousing"];
        [array addObject:@"Maritime"];
        [array addObject:@"Ports"];
        [array addObject:@"Road Transport"];
        [array addObject:@"Rail"];
        
        
        
    
    
    NSMutableArray *array1=[[NSMutableArray alloc] initWithCapacity:[array count]];
    
    for (int i=0; i < [array count]; i++)
        [array1 addObject:[NSNumber numberWithBool:NO]];
    self._selectedArray = array1;
    
    
    
    
}

#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 6;
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
    
    UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(40,11,210,25)];
    titleLbl.backgroundColor=[UIColor clearColor];
    titleLbl.textColor=[UIColor whiteColor];
    titleLbl.font=[UIFont systemFontOfSize:16];
    titleLbl.text=[array objectAtIndex:indexPath.row];
    [cell.contentView addSubview:titleLbl];
    
    
    UIImageView *ivStrip = [[UIImageView alloc]init];
    NSString *colorSTr = [[dictAllResources valueForKey:@"SectorColor"] objectAtIndex:indexPath.row];
    NSArray *arC = [[NSArray alloc]init];
    arC = [colorSTr componentsSeparatedByString:@","];
    [ivStrip setBackgroundColor:[UIColor colorWithRed:[[arC objectAtIndex:0]floatValue]/255.f green:[[arC objectAtIndex:1]floatValue]/255.f blue:[[arC objectAtIndex:2]floatValue]/255.f alpha:1.0]];
    [ivStrip setFrame:CGRectMake(0 ,0, 5, cell.frame.size.height)];
    [cell addSubview:ivStrip];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17 , 15, 15)];
    NSNumber *selected2 = [_selectedArray objectAtIndex:[indexPath row]];
    imageView.image = ([selected2 boolValue]) ? _selectedImage :_unselectedImage;
    //inPseudoEditMode = ([selected2 boolValue]) ? TRUE : FALSE;
    [cell.contentView addSubview:imageView];
    imageView.hidden = !inPseudoEditMode;
    [UIView commitAnimations];
    //[imageView release];
    
    
    cell.selectionStyle=FALSE;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (inPseudoEditMode)
    {
        BOOL selected1 = [[_selectedArray objectAtIndex:[indexPath row]] boolValue];
        [_selectedArray replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithBool:!selected1]];
        NSString *strValue = [array objectAtIndex:indexPath.row];
        NSLog(@"%@",strValue);
        NSLog(@"%@",strFilterType);
        strFilterType = [array objectAtIndex:indexPath.row];
    }
    
    [_tableView reloadData];
}

-(IBAction)btnSelectAllTapped:(id)sender{
    for (int i=0; i < [array count]; i++){
        [_selectedArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
    }
    [_tableView reloadData];
}
-(IBAction)btnDeselectAllTapped:(id)sender{
    for (int i=0; i < [array count]; i++){
        [_selectedArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }
    [_tableView reloadData];
}


-(IBAction)dismissController:(id)sender
{
    NSLog(@"%@",_selectedArray);
    if([sender tag]==1)
    {
        NSMutableArray *arSector = [[NSMutableArray alloc]init];
        for(int s=0;s<[_selectedArray count];s++)
        {
            if([[_selectedArray objectAtIndex:s]boolValue]==TRUE)
            {
                [arSector addObject:[NSString stringWithFormat:@"'%@'",[array objectAtIndex:s]]];
            }
        }
        strFilterType = [arSector componentsJoinedByString:@","];
        
        if([strFilterType length]==0)
        {
            strFilterType = @"'Logistics & Warehousing','Road Transport','Rail','Maritime','Aviation','Ports'";
        }
        
        
        if([FilterFromView isEqualToString:@"LEARNING"])
        {
            NSNotification *notif = [NSNotification notificationWithName:@"RELOAD_LEARNING_FILTER" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }
        else if([FilterFromView isEqualToString:@"NPARTICIPANT"])
        {
            NSNotification *notif = [NSNotification notificationWithName:@"RELOAD_NPARTICIPANT_FILTER" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }
        else
        {
            
            NSNotification *notif = [NSNotification notificationWithName:@"RELOAD_FILTER" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }
    }
    else 
    {
        if([FilterFromView isEqualToString:@"LEARNING"])
        {
            NSNotification *notif = [NSNotification notificationWithName:@"FILTER__VIEW_HIDE_LEARNING" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }
        else if([FilterFromView isEqualToString:@"NPARTICIPANT"])
        {
            NSNotification *notif = [NSNotification notificationWithName:@"RELOAD_NPARTICIPANT_FILTER" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }
        else
        {
            NSNotification *notif = [NSNotification notificationWithName:@"FILTER_VIEW_HIDE" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }
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
