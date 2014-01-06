//
//  ImportParticipants.m
//  T&L
//
//  Created by openxcell tech.. on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImportParticipants.h"
#import "AssessmentsVIewController.h"
#import "AlertManger.h"
#import "GlobleClass.h"
#import "HelpViewController.h"

@implementation ImportParticipants
@synthesize _tableView;
@synthesize _getallParticipantsArr;
@synthesize controller;
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
    
    //------Topbar Image Set
    [ivTopBarSelected setImage:[APPDEL topbarselectedImage:strFTabSelectedID]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadImportParticipant) name:@"RELOAD_IMPORT_PARTICIPANT" object:nil];

    
    /*
    NavViewController *navScreenController  = [[NavViewController alloc] initWithNibName:@"NavView" bundle:nil];
    [self.view addSubview:navScreenController.view];
    [navScreenController setFocusButton:2];
    navScreenController.btn3.enabled=NO;
     */
    [self createTableView];
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDissmiss) name:@"Gaurav" object:nil];
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (_getallParticipantsArr!=nil) {
        _getallParticipantsArr=nil;
        [_getallParticipantsArr removeAllObjects];
    }
    _getallParticipantsArr=[[NSMutableArray alloc] init];
    
    
    _getallParticipantsArr=[DatabaseAccess getAllParticipantName_ME:@"SELECT part_name,job_title,company,empId_stuNo,suburb_city FROM tbl_participants"];
    
    NSLog(@"ALL Participats Count %d",[_getallParticipantsArr count]);
    
    if ([_getallParticipantsArr count]==0) {
        
        [[AlertManger defaultAgent]showAlertForDelegateWithTitle:APP_NAME message:@"No Participants available" cancelButtonTitle:@"Ok" okButtonTitle:nil parentController:self];
    }

    
    [_tableView reloadData];
    
}

-(void)SortTblData:(NSString *)strSortType
{
    if([strSortType isEqualToString:@"NAME, A-Z"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"part_name" ascending:YES];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([strSortType isEqualToString:@"NAME, Z-A"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"part_name" ascending:NO];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([strSortType isEqualToString:@"DATE, Ascending"])
    {
        
    }
    else if([strSortType isEqualToString:@"DATE, Descending"])
    {
        
    }
    else if([strSortType isEqualToString:@"Category, Ascending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"company" ascending:YES];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([strSortType isEqualToString:@"Code, Ascending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"empId_stuNo" ascending:YES];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([strSortType isEqualToString:@"Code, Descending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"empId_stuNo" ascending:NO];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    [_tableView reloadData];
}

-(IBAction)btnSearchTapped:(id)sender
{
    NSMutableArray *ar = [[NSMutableArray alloc]init];
    ar =[[NSMutableArray alloc]initWithArray:[DatabaseAccess getAllParticipantName_ME:[NSString stringWithFormat:@"select part_name,job_title,company,empId_stuNo,suburb_city FROM tbl_participants where (part_name like '%%%@%%' or job_title like '%%%@%%' or company like '%%%@%%')",tfSearchBox.text,tfSearchBox.text,tfSearchBox.text]]];
    
    if([ar count]>0)
        _getallParticipantsArr = [[NSMutableArray alloc]initWithArray:ar];
    else 
    {
        _getallParticipantsArr = [[NSMutableArray alloc]initWithArray:ar];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"T&L" message:@"No records found !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [_tableView reloadData];
}

-(void)reloadImportParticipant
{
    [popoverController dismissPopoverAnimated:YES];
    [self SortTblData:strSortType];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex==0) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)viewDissmiss{
    
    [popoverController dismissPopoverAnimated:YES];
    
    
}

-(void)createTableView{
    
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,181,769,823) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=70;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
}


/*
 * On click UITbaleViewCell Button this method will Call...
 */

-(void)customActionPressed:(id)sender
{
    NSLog(@"%@",[sender currentTitle]);
    if(aryParticipantInfoGlobal != nil)
    {
        [aryParticipantInfoGlobal removeAllObjects];
        aryParticipantInfoGlobal = nil;
    }
    aryParticipantInfoGlobal = [[NSMutableArray alloc]initWithArray:[DatabaseAccess getAllRecordTbl_Participants:[NSString stringWithFormat:@"Select *from tbl_participants where empId_stuNo  = '%@'", [[_getallParticipantsArr objectAtIndex:[sender tag]] valueForKey:@"empId_stuNo"]]]];
    NSLog(@"%@",aryParticipantInfoGlobal);
    controller=[[AssessmentsVIewController alloc] initWithNibName:@"AssessmentsVIewController" bundle:nil];    
    globle_participant_id = [[_getallParticipantsArr objectAtIndex:[sender tag]] valueForKey:@"empId_stuNo"];
    globle_ParticipantName = [[_getallParticipantsArr objectAtIndex:[sender tag]] valueForKey:@"part_name"];
    
    [self.navigationController pushViewController:controller animated:YES];
    
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
	return YES;
}

#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_getallParticipantsArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //databaseBean=[_getallParticipantsArr objectAtIndex:indexPath.row];
        
        UIImageView *imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon bar.png"]];
        imageview.frame=CGRectMake(0,0,769,70);
        [cell.contentView addSubview:imageview];
        
        UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,10,290,25)];
        titleLbl.backgroundColor=[UIColor clearColor];
        titleLbl.textColor=[UIColor blackColor];
        titleLbl.font=[UIFont boldSystemFontOfSize:17];
        titleLbl.text= [[_getallParticipantsArr objectAtIndex:indexPath.row] valueForKey:@"part_name"];
        [imageview addSubview:titleLbl];
        
        UILabel *descLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,39,290,25)];
        descLbl.backgroundColor=[UIColor clearColor];
        descLbl.textColor=[UIColor blackColor];
        descLbl.font=[UIFont systemFontOfSize:14];
        NSString *str=[[_getallParticipantsArr objectAtIndex:indexPath.row] valueForKey:@"empId_stuNo"];
        descLbl.text=str;
        [imageview addSubview:descLbl];
        
        UILabel *descLblmidl=[[UILabel alloc] initWithFrame:CGRectMake(300,10,290,25)];
        descLblmidl.backgroundColor=[UIColor clearColor];
        descLblmidl.textColor=[UIColor blackColor];
        descLblmidl.font=[UIFont boldSystemFontOfSize:17];
        descLblmidl.text=[[_getallParticipantsArr objectAtIndex:indexPath.row] valueForKey:@"company"];
        [imageview addSubview:descLblmidl];
        
        UILabel *descLblmidl1=[[UILabel alloc] initWithFrame:CGRectMake(300,34,290,25)];
        descLblmidl1.backgroundColor=[UIColor clearColor];
        descLblmidl1.textColor=[UIColor blackColor];
        descLblmidl1.font=[UIFont boldSystemFontOfSize:13];
        descLblmidl1.text=[[_getallParticipantsArr objectAtIndex:indexPath.row] valueForKey:@"job_title"];
        [imageview addSubview:descLblmidl1];
        
        UILabel *descLblmidl12=[[UILabel alloc] initWithFrame:CGRectMake(550,10,290,25)];
        descLblmidl12.backgroundColor=[UIColor clearColor];
        descLblmidl12.textColor=[UIColor blackColor];
        descLblmidl12.font=[UIFont boldSystemFontOfSize:17];
        descLblmidl12.text=[[_getallParticipantsArr objectAtIndex:indexPath.row] valueForKey:@"suburb_city"];
        [imageview addSubview:descLblmidl12];
        
        
        
        cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cellbutton setTitle:[[_getallParticipantsArr objectAtIndex:indexPath.row] valueForKey:@"empId_stuNo"] forState:UIControlStateNormal];
        [cellbutton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [cellbutton setTag:indexPath.row];
        [cellbutton addTarget:self 
                       action:@selector(customActionPressed:)
             forControlEvents:UIControlEventTouchDown];
        [cellbutton setImage:[UIImage imageNamed:@"import.png"] forState:UIControlStateNormal];
        cellbutton.frame = CGRectMake(665,15,61,32);
        [cell addSubview:cellbutton];

        
    //}
    
    
    cell.selectionStyle=FALSE;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Button Action Events

-(IBAction)helpButtonTapped:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    
    if(![popoverController isPopoverVisible]){
		HelpViewController *objHelpViewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
		popoverController = [[UIPopoverController alloc] initWithContentViewController:objHelpViewController];
		
		[popoverController setPopoverContentSize:CGSizeMake(350.0f, 500.0f)];
        [popoverController presentPopoverFromRect:CGRectMake(90,0,60,39) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
	[UIView setAnimationDuration:2.75];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
    self.view.alpha = 1;
	
	[UIView commitAnimations];
}

-(IBAction)filterDropDown:(id)sender{
    
    [UIView beginAnimations:nil context:nil];
    
    if(![popoverController isPopoverVisible]){
		_popOverController = [[PopoverFilter alloc] initWithNibName:@"PopoverFilter" bundle:nil];
		popoverController = [[UIPopoverController alloc] initWithContentViewController:_popOverController];
		
		[popoverController setPopoverContentSize:CGSizeMake(229.0f, 323.0f)];
        [popoverController presentPopoverFromRect:CGRectMake(263,71,68,40) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    
    
	[UIView setAnimationDuration:2.75];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
    self.view.alpha = 1;
	
	[UIView commitAnimations];
    
    
    
}


-(IBAction)sortDropDown:(id)sender{
    
    sortViewName = @"IMPORTPARTICIPANT";
    [UIView beginAnimations:nil context:nil];
    
    if(![popoverController isPopoverVisible]){
		_popOverSort = [[PopoverSort alloc] initWithNibName:@"PopoverSort" bundle:nil];
		popoverController = [[UIPopoverController alloc] initWithContentViewController:_popOverSort];
		
		[popoverController setPopoverContentSize:CGSizeMake(229.0f, 323.0f)];
        [popoverController presentPopoverFromRect:CGRectMake(357,72,60,39) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    
    
	[UIView setAnimationDuration:2.75];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
    self.view.alpha = 1;
	
	[UIView commitAnimations];  
}

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnHomePressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"popToViewController" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnLearningPressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_12" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnAssessmentPressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_13" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnResourcePressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_14" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}


@end
