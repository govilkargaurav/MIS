//
//  ReourceListViewController.m
//  T&L
//
//  Created by openxcell tech.. on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReourceListViewController.h"
#import "GlobleClass.h"
#import "NewParticipentController.h"
#import "GlobleClass.h"
#import "SBJSON.h"
#import "JSON.h"
#import "NewAssessorViewController.h"
#import "Reachability.h"
#import "AlertManger.h"
#import "HelpViewController.h"

@implementation ReourceListViewController

@synthesize _tableView,buttonArray,buttonArray2,statuses,_parsingTypeStr,searchDict,searchArray,request;
//------KP
@synthesize _getallTasks,dictResouctID,allResources;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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


- (void)loadView {
	[super loadView];
    
    /*
    NavViewController *navScreenController  = [[NavViewController alloc] initWithNibName:@"NavView" bundle:nil];
    [self.view addSubview:navScreenController.view];
    [navScreenController setFocusButton:3];
    navScreenController.btn4.enabled=NO;
     */
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //------Topbar Image Set
    [ivTopBarSelected setImage:[appDel topbarselectedImage:strFTabSelectedID]];
    
    //---------kp ----db records-----
    dictColorStrip = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"1.png",@"Road Transport",@"2.png",@"Ports",@"2.png",@"Maritime",@"3.png",@"Logistic",@"3.png",@"Aviation",@"4.png",@"Rail",@"1.png",@"Logistics & Warehousing",nil];
    
    allResources = [[NSMutableArray alloc]init];
    if ([viewWillAppearStr isEqualToString:@"1"])
    {        
        if (_downloadStatusDict==nil) {
            
            _downloadStatusDict=[[NSMutableDictionary alloc] init];
        }
        
        Reachability *reachableForWiFy=[Reachability reachabilityForLocalWiFi];
        
        NetworkStatus netStatusWify = [reachableForWiFy currentReachabilityStatus];
        
        if (netStatusWify==ReachableViaWiFi || netStatusWify==ReachableViaWWAN) {
            
            
            _parsingTypeStr=[globle_SectorName copy];
            [self StartParsing:_parsingTypeStr];
            
            
            if (_tableView!=nil) {
                [_tableView removeFromSuperview];
                _tableView=nil;
            }
            
            _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,180,769,820) style:UITableViewStylePlain];
            _tableView.delegate=self;
            _tableView.dataSource=self;
            _tableView.rowHeight=60;
            _tableView.backgroundColor=[UIColor clearColor];
            _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            [self.view addSubview:_tableView];
            
            
        }
        else
        {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Network available!", @"AlertView") message:NSLocalizedString(@"You have no internet connection available. Please connect to network.", @"AlertView") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView") otherButtonTitles:NSLocalizedString(@"Open settings", @"AlertView"), nil];
            
            [alertView show];
        }
        
        if (buttonArray!=nil)
        {
            buttonArray=nil;
            [buttonArray removeAllObjects];
        }
        buttonArray=[[NSMutableArray alloc] init];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDissmiss) name:@"Gaurav123" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadIt) name:@"navigate" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"RELOADTABLEVIEW" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewSorted) name:@"RELOADSORTED" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewFilter) name:@"RELOAD_FILTER" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideFilter) name:@"FILTER_VIEW_HIDE" object:nil];
        
        if(![_parsingTypeStr isEqualToString:@"allresources"])
        {
            [btnFilter setHidden:TRUE];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
 
    [super viewWillAppear:animated];
    [self FilterTblData:strFilterType];
    
}


#pragma mark RELOAD VIEWS 

-(void)reloadTableView
{
    [self FilterTblData:strFilterType];
}

-(void)reloadTableViewSorted
{
    [popoverController dismissPopoverAnimated:YES];
    [self SortTblData:strSortType];
}
-(void)reloadTableViewFilter
{
    [popoverController dismissPopoverAnimated:YES];
    [self FilterTblData:strFilterType];
}
-(void)hideFilter
{
    [popoverController dismissPopoverAnimated:YES];
}




#pragma mark
#pragma mark SYNCHRONOUS PARSING STARTS

/*
 * Parsing Starts Here
 */

-(void)StartParsing:(NSString *)type
{
    
    viewWillAppearStr=@"0";
    SectorName  = type;
    if ([type isEqualToString:@"allresources"]) 
    {
        allResources = [DatabaseAccess getall_tbl_Resources:@"select *from tbl_Resources order by SectorName"];
    }
    else if([type isEqualToString:@"Aviation"])
    {
        allResources = [DatabaseAccess getall_tbl_Resources:@"select *from tbl_Resources where SectorName = 'Aviation'"];
    }
    else if([type isEqualToString:@"RoadTransport"])
    {
        allResources = [DatabaseAccess getall_tbl_Resources:@"select *from tbl_Resources where SectorName = 'Road Transport'"];
    }
    else if([type isEqualToString:@"Rail"])
    {
        allResources = [DatabaseAccess getall_tbl_Resources:@"select *from tbl_Resources where SectorName = 'Rail'"];
    }
    else if([type isEqualToString:@"logisticsNwarehousing"])
    {
        allResources = [DatabaseAccess getall_tbl_Resources:@"select *from tbl_Resources where SectorName = 'Logistics & Warehousing'"];
    }
    else if([type isEqualToString:@"Maritime"])
    {
        allResources = [DatabaseAccess getall_tbl_Resources:@"select *from tbl_Resources where SectorName = 'Maritime'"];
    }
    else if([type isEqualToString:@"Ports"])
    {
        allResources = [DatabaseAccess getall_tbl_Resources:@"select *from tbl_Resources where SectorName = 'Ports'"];
    }
    else if([type isEqualToString:@"SearchResult"])
    {
        allResources = [[NSMutableArray alloc]initWithArray:arAllResourcesGloble];
    }
    if([allResources count]>0)
        [_tableView reloadData];
    else
    {
        [[AlertManger defaultAgent]showAlertForDelegateWithTitle:APP_NAME message:@"No Resources are available" cancelButtonTitle:@"OK" okButtonTitle:nil parentController:self];
        [_tableView reloadData];           
    }
}

-(IBAction)btnSearchTapped:(id)sender
{
    NSLog(@"%@",tfSearchTextBox.text);
    NSMutableArray *ar = [[NSMutableArray alloc]init];
    if([SectorName isEqualToString:@"allresources"])
        ar =[[NSMutableArray alloc]initWithArray:[DatabaseAccess getall_tbl_Resources:[NSString stringWithFormat:@"select *from tbl_Resources where (UnitName like '%%%@%%' or UnitCode like '%%%@%%' or Version like '%%%@%%')",tfSearchTextBox.text,tfSearchTextBox.text,tfSearchTextBox.text]]];
    else 
        ar =[[NSMutableArray alloc]initWithArray:[DatabaseAccess getall_tbl_Resources:[NSString stringWithFormat:@"select *from tbl_Resources where (UnitName like '%%%@%%' or UnitCode like '%%%@%%' or Version like '%%%@%%') and (SectorName = '%@')",tfSearchTextBox.text,tfSearchTextBox.text,tfSearchTextBox.text,SectorName]]];

    if([ar count]>0)
        allResources = [[NSMutableArray alloc]initWithArray:ar];
    else 
    {
        allResources = [[NSMutableArray alloc]initWithArray:ar];
        [[AlertManger defaultAgent]showAlertForDelegateWithTitle:APP_NAME message:@"No Resources are available" cancelButtonTitle:@"OK" okButtonTitle:nil parentController:self];
    }
    [_tableView reloadData];
}

-(void)SortTblData:(NSString*)strSortType
{    
    if([strSortType isEqualToString:@"NAME, A-Z"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"UnitName" ascending:YES];
        [allResources sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([strSortType isEqualToString:@"NAME, Z-A"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"UnitName" ascending:NO];
        [allResources sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([strSortType isEqualToString:@"DATE, Ascending"])
    {
        
    }
    else if([strSortType isEqualToString:@"DATE, Descending"])
    {
        
    }
    else if([strSortType isEqualToString:@"Category, Ascending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"SectorName" ascending:YES];
        [allResources sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([strSortType isEqualToString:@"Code, Ascending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"Version" ascending:YES];
        [allResources sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([strSortType isEqualToString:@"Code, Descending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"Version" ascending:NO];
        [allResources sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    [_tableView reloadData];
}

-(void)FilterTblData:(NSString*)strFilterType
{
    NSLog(@"%@",strFilterType);
    NSMutableArray *ar = [[NSMutableArray alloc]init];
    ar =[[NSMutableArray alloc]initWithArray:[DatabaseAccess getall_tbl_Resources:[NSString stringWithFormat:@"select *from tbl_Resources where (SectorName in (%@)) order by SectorName",strFilterType]]];
    
    if([ar count]>0)
    {
        allResources = [[NSMutableArray alloc]initWithArray:ar];
        [self SortTblData:strSortType];
    }
    else 
        allResources = [[NSMutableArray alloc]init];
    
    
    [_tableView reloadData];
}

#pragma mark ALERTVIEW DELEGATE METHOD 

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex==0) {
        
        NSNotification *notif = [NSNotification notificationWithName:@"ALERT" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
        
    }
    
}


-(void)viewDissmiss{
    
    [popoverController dismissPopoverAnimated:YES];
    
}



/*
 * On click UITbaleViewCell Button this method will Call...
 */

-(void)customActionPressed:(id)sender
{   
    if([[[allResources valueForKey:@"SectorName"] objectAtIndex:[sender tag]] isEqualToString:@"Rail"])
        globle_SectorIcon = @"Rail_Icon.png";
    else if([[[allResources valueForKey:@"SectorName"] objectAtIndex:[sender tag]] isEqualToString:@"Aviation"])
        globle_SectorIcon = @"Aviation_Icon.png";
    else if([[[allResources valueForKey:@"SectorName"] objectAtIndex:[sender tag]] isEqualToString:@"Logistics & Warehousing"])
        globle_SectorIcon = @"Logistics & Warehousing_Icon.png";
    
    
    
    if([[[allResources objectAtIndex:[sender tag]]valueForKey:@"DownloadStatus"] isEqualToString:@"0"])
    {
        globle_resource_id =[[allResources valueForKey:@"ResourceID"] objectAtIndex:[sender tag]];
        globle_UnitName = [[allResources valueForKey:@"UnitName"] objectAtIndex:[sender tag]];
        globle_strUnitCode = [[allResources valueForKey:@"UnitCode"] objectAtIndex:[sender tag]];
        globle_strVersion = [[allResources valueForKey:@"Version"] objectAtIndex:[sender tag]];
        globle_UnitInfo = [[allResources valueForKey:@"Status"] objectAtIndex:[sender tag]];
        globle_SectorCover =  [NSString stringWithFormat:@"%@.png",[[allResources valueForKey:@"SectorName"] objectAtIndex:[sender tag]]];
        globle_SectorName = [[allResources valueForKey:@"SectorName"] objectAtIndex:[sender tag]];
        [self downloadIt];
    }
    else
    {
        strResourceID = [[allResources valueForKey:@"ResourceID"] objectAtIndex:[sender tag]];
        showAlert = @"NO";
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        [HUD setLabelText:@"Please wait !!"];
        HUD.delegate = self;
        [HUD showWhileExecuting:@selector(downloadInProgress) onTarget:self withObject:nil animated:YES];
        
    }
    /*
    NSLog(@"%@",globle_resource_id);
    NSLog(@"%@",[[dictResouctID valueForKey:@"ResourceID"] objectAtIndex:pathToCell.row]);
    */
}


-(void)downloadInProgress
{
    _rsDetailView=[[ResourceDetailView alloc] init];
    globle_resource_id = _rsDetailView._resourceID=strResourceID;
    [_rsDetailView parsingStartsandSaveInDatabase];
    if([strDataAvailable isEqualToString:@"YES"])
    {
        //[_downloadStatusDict setValue:@"1" forKey:[NSString stringWithFormat:@"%d",pathToCell.row]];
        [self FilterTblData:strFilterType];
    }
    else if([strDataAvailable isEqualToString:@"NO"])
    {
        [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:YES];
    }
    strDataAvailable = @"";
}
-(void)showAlert
{
    UIAlertView *alertNoData = [[UIAlertView alloc]initWithTitle:@"T&L" message:@"No Data found !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertNoData show];
}
-(void)downloadIt{
    
    objParticipantTypeViewController =[[ParticipantTypeViewController alloc] initWithNibName:@"ParticipantTypeViewController" bundle:nil];
    [self.navigationController pushViewController:objParticipantTypeViewController animated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    request=nil;
    searchDict=nil;
    statuses=nil;
    searchArray=nil;
    buttonArray=nil;
    buttonArray2=nil;
    _parsingTypeStr=nil;
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Copy Mutable Dictionary %d",[allResources count]);
    return [allResources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];


    UIImageView *imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"queBG.png"]];
    imageview.frame=CGRectMake(0,0,769,60);
    [cell addSubview:imageview];
    
    UIImageView *ivStrip = [[UIImageView alloc]init];
    NSString *colorSTr = [[allResources valueForKey:@"SectorColor"] objectAtIndex:indexPath.row];
    NSArray *arC = [[NSArray alloc]init];
    arC = [colorSTr componentsSeparatedByString:@","];
    [ivStrip setBackgroundColor:[UIColor colorWithRed:[[arC objectAtIndex:0]floatValue]/255.f green:[[arC objectAtIndex:1]floatValue]/255.f blue:[[arC objectAtIndex:2]floatValue]/255.f alpha:1.0]];
    [ivStrip setFrame:CGRectMake(0 ,0, 7, 60)];
    [cell addSubview:ivStrip];
    
        
    
    UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(80,10,290,25)];
    titleLbl.backgroundColor=[UIColor clearColor];
    titleLbl.textColor=[UIColor blackColor];
    titleLbl.font=[UIFont boldSystemFontOfSize:13];
    //titleLbl.text=[[searchArray objectAtIndex:indexPath.row] valueForKey:@"SectorName"];
    titleLbl.text=[[allResources valueForKey:@"UnitName"] objectAtIndex:indexPath.row];
    [imageview addSubview:titleLbl];
        
    UIImageView *ivTNLIcon = [[UIImageView alloc]init];
    
    
    UIButton *arrowbtn=[[UIButton alloc] initWithFrame:CGRectMake(730,23, 10, 14)];
    [arrowbtn addTarget:self action:@selector(actionPressed:) forControlEvents:UIControlEventTouchUpInside];
    [arrowbtn setImage:[UIImage imageNamed:@"ARROW.png"] forState:UIControlStateNormal];
    [arrowbtn setTag:indexPath.row];
    [cell addSubview:arrowbtn];
    
    UILabel *descLbl=[[UILabel alloc] initWithFrame:CGRectMake(80,27,600,25)];
    descLbl.backgroundColor=[UIColor clearColor];
    descLbl.textColor=[UIColor grayColor];
    descLbl.font=[UIFont systemFontOfSize:12];
    NSString *getStr1=[NSString stringWithFormat:@"%@ | %@ | %@",[[allResources valueForKey:@"UnitCode"] objectAtIndex:indexPath.row],[[allResources valueForKey:@"Version"] objectAtIndex:indexPath.row],[[allResources valueForKey:@"Status"] objectAtIndex:indexPath.row]];
    descLbl.text=getStr1;
    [imageview addSubview:descLbl];
        
    NSArray *ar = [[NSArray alloc]init];  
    ar = [[[allResources valueForKey:@"SectorColor"] objectAtIndex:indexPath.row] componentsSeparatedByString:@","];
    
    float R = [[ar objectAtIndex:0]floatValue];
    float G = [[ar objectAtIndex:1]floatValue];
    float B = [[ar objectAtIndex:2]floatValue];
    
    
    UILabel *descLbl3=[[UILabel alloc] initWithFrame:CGRectMake(350,17,290,25)];
    descLbl3.backgroundColor=[UIColor clearColor];
    descLbl3.textColor=[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1];
    descLbl3.font=[UIFont boldSystemFontOfSize:13];
    descLbl3.text=[[allResources valueForKey:@"SectorName"] objectAtIndex:indexPath.row];
    [imageview addSubview:descLbl3];

    
    cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cellbutton addTarget:self 
                   action:@selector(customActionPressed:)
         forControlEvents:UIControlEventTouchDown];
    [cellbutton setTag:indexPath.row];//[[[allResources valueForKey:@"ResourceID"] objectAtIndex:indexPath.row]intValue]];
    NSLog(@"%@",[[allResources valueForKey:@"DownloadStatus"] objectAtIndex:indexPath.row]);
    if([[[allResources valueForKey:@"DownloadStatus"] objectAtIndex:indexPath.row] isEqualToString:@"0"])
    {
        [cellbutton setImage:[UIImage imageNamed:@"startdownload.png"] forState:UIControlStateNormal];
        
        [ivTNLIcon setFrame:CGRectMake(30, 10, 42, 39)];
        [ivTNLIcon setImage:[UIImage imageNamed:@"A1.png"]];
    }
    else 
    {
        [cellbutton setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
        [ivTNLIcon setFrame:CGRectMake(30, 10, 32, 39)];
        [ivTNLIcon setImage:[UIImage imageNamed:@"A.png"]];
    }
    [ivTNLIcon setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:ivTNLIcon];
    cellbutton.frame = CGRectMake(600,14,96,33);
    [cell addSubview:cellbutton];
    [buttonArray addObject:cellbutton];
            

    cell.selectionStyle=FALSE;
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

-(void)actionPressed:(id)sender
{
    _rsDetailView=[[ResourceDetailView alloc]initWithNibName:@"ResourceDetailView" bundle:nil];
    _rsDetailView._download_dictStrValue=[[allResources valueForKey:@"DownloadStatus"] objectAtIndex:[sender tag]];
    _rsDetailView.rID_R = [[allResources valueForKey:@"ResourceID"] objectAtIndex:[sender tag]];
    _rsDetailView.HTMLStr=[[allResources valueForKey:@"assessor_introduction"] objectAtIndex:[sender tag]];
    _rsDetailView.headerLableStr=[[allResources valueForKey:@"UnitName"] objectAtIndex:[sender tag]];
    _rsDetailView.resourceImageStr=[NSString stringWithFormat:@"%@.png",[[allResources valueForKey:@"SectorName"] objectAtIndex:[sender tag]]];
    _rsDetailView._resourceID=[[allResources valueForKey:@"ResourceID"] objectAtIndex:[sender tag]];
    _rsDetailView.downloadStatusImg = [[allResources valueForKey:@"DownloadStatus"] objectAtIndex:[sender tag]];
    _rsDetailView.unitinfo = [NSString stringWithFormat:@"%@ | %@ | %@",[[allResources valueForKey:@"UnitCode"] objectAtIndex:[sender tag]],[[allResources valueForKey:@"Version"] objectAtIndex:[sender tag]],[[allResources valueForKey:@"Status"] objectAtIndex:[sender tag]]];
    
    globle_resource_id =[[allResources valueForKey:@"ResourceID"] objectAtIndex:[sender tag]];
    globle_UnitName = [[allResources valueForKey:@"UnitName"] objectAtIndex:[sender tag]];
    globle_strUnitCode = [[allResources valueForKey:@"UnitCode"] objectAtIndex:[sender tag]];
    globle_strVersion = [[allResources valueForKey:@"Version"] objectAtIndex:[sender tag]];
    globle_UnitInfo = [[allResources valueForKey:@"Status"] objectAtIndex:[sender tag]];
    globle_SectorCover =  [NSString stringWithFormat:@"%@.png",[[allResources valueForKey:@"SectorName"] objectAtIndex:[sender tag]]];
    globle_SectorName = [[allResources valueForKey:@"SectorName"] objectAtIndex:[sender tag]];
    
    
    viewWillAppearStr=@"1";
    [self.view addSubview:_rsDetailView.view];
    
    
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
		
		[popoverController setPopoverContentSize:CGSizeMake(270.0f, 323.0f)];
        [popoverController presentPopoverFromRect:CGRectMake(355,72,60,39) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    
    
	[UIView setAnimationDuration:2.75];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
    self.view.alpha = 1;
	
	[UIView commitAnimations];
    
}


-(IBAction)sortDropDown:(id)sender{
    
    [UIView beginAnimations:nil context:nil];
    
    if(![popoverController isPopoverVisible]){
		_popOverSort = [[PopoverSort alloc] initWithNibName:@"PopoverSort" bundle:nil];
		popoverController = [[UIPopoverController alloc] initWithContentViewController:_popOverSort];
		
		[popoverController setPopoverContentSize:CGSizeMake(229.0f, 323.0f)];
        [popoverController presentPopoverFromRect:CGRectMake(283,71,68,40) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
	[UIView setAnimationDuration:2.75];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
    self.view.alpha = 1;
	
	[UIView commitAnimations];
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
    strFilterType = @"'Logistics & Warehousing','Road Transport','Rail','Maritime','Aviation','Ports'";
    [self FilterTblData:strFilterType];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_14" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

@end
