//
//  NParticipantViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 11/8/12.
//
//

#import "NParticipantViewController.h"
#import "ViewController.h"

@interface NParticipantViewController ()

@end

@implementation NParticipantViewController

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
    
    strSectorName = @"'Logistics & Warehousing','Road Transport','Rail','Maritime','Aviation','Ports'";
    
    [ivTopBarSelected setImage:[APPDEL topbarselectedImage:strFTabSelectedID]];
    //select distinct(cast(participantId as int)),(select UnitName from tbl_Resources where cast(ResourceID as int) = A.ResourceID),(select part_name from tbl_Participants where empId_stuno=A.ParticipantID)  from tbl_ResumeTask A where Status like 'InProgress'
    
    _getallParticipantsArr=[DatabaseAccess get_ResumeTaskInfo:@"select distinct(participantId),(select UnitName from tbl_Resources where cast(ResourceID as int) = A.ResourceID),ResourceID,(select part_name from tbl_Participants where empId_stuno=A.ParticipantID),ParticipantID,SectorName,(select SectorColor from tbl_Resources where cast(ResourceID as int) = A.ResourceID),(select UnitCode from tbl_Resources where cast(ResourceID as int) = A.ResourceID),(select Version from tbl_Resources where cast(ResourceID as int) = A.ResourceID),(select Status from tbl_Resources where cast(ResourceID as int) = A.ResourceID)  from tbl_ResumeTask A where Status like 'InProgress'"];
    [_tableView reloadData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableWithSortOption) name:@"RELOAD_TABLE_WITH_SORT_OPTION" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableWithFilterOption) name:@"RELOAD_NPARTICIPANT_FILTER" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ivTopBarSelected setImage:[APPDEL topbarselectedImage:strFTabSelectedID]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
  
    UIImageView *imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resumeAssessmentBG"]];
    imageview.frame=CGRectMake(0,0,768,60);
    [cell addSubview:imageview];
    
    UIImageView *ivStrip = [[UIImageView alloc]init];
    NSString *colorSTr = [[_getallParticipantsArr objectAtIndex:indexPath.row] valueForKey:@"SectorColor"];
    NSArray *arC = [[NSArray alloc]init];
    arC = [colorSTr componentsSeparatedByString:@","];
    [ivStrip setBackgroundColor:[UIColor colorWithRed:[[arC objectAtIndex:0]floatValue]/255.f green:[[arC objectAtIndex:1]floatValue]/255.f blue:[[arC objectAtIndex:2]floatValue]/255.f alpha:1.0]];
    [ivStrip setFrame:CGRectMake(0 ,0, 7, 60)];
    [cell addSubview:ivStrip];
    
    UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(80,10,290,25)];
    titleLbl.font=[UIFont boldSystemFontOfSize:13];
    titleLbl.backgroundColor=[UIColor clearColor];
    titleLbl.textColor=[UIColor blackColor];
    titleLbl.text= [[_getallParticipantsArr objectAtIndex:indexPath.row] valueForKey:@"NSParticipantName"];
    [imageview addSubview:titleLbl];
    
    UILabel *partID=[[UILabel alloc] initWithFrame:CGRectMake(80,27,600,25)];
    partID.backgroundColor=[UIColor clearColor];
    partID.textColor=[UIColor darkGrayColor];
    partID.font=[UIFont systemFontOfSize:12];
    [partID setText:[NSString stringWithFormat:@"ID# %@",[[_getallParticipantsArr objectAtIndex:indexPath.row] valueForKey:@"ParticipantID"]]];
    [imageview addSubview:partID];
    
    UILabel *descLblmidl=[[UILabel alloc] initWithFrame:CGRectMake(300,10,290,25)];
    descLblmidl.backgroundColor=[UIColor clearColor];
    descLblmidl.textColor=[UIColor darkGrayColor];
    descLblmidl.font=[UIFont systemFontOfSize:13];
    descLblmidl.text=[[_getallParticipantsArr objectAtIndex:indexPath.row] valueForKey:@"ResourceName"];
    [imageview addSubview:descLblmidl];
    
    UILabel *secName=[[UILabel alloc] initWithFrame:CGRectMake(300,27,600,25)];
    secName.backgroundColor=[UIColor clearColor];
    secName.textColor=[UIColor darkGrayColor];
    secName.font=[UIFont systemFontOfSize:12];
    [secName setText:[[_getallParticipantsArr objectAtIndex:indexPath.row] valueForKey:@"ResourceInfo"]];
    [imageview addSubview:secName];


    UIImageView *ivTNLIcon = [[UIImageView alloc]init];
    [ivTNLIcon setFrame:CGRectMake(30, 10, 42, 39)];
    [ivTNLIcon setImage:[UIImage imageNamed:@"A1.png"]];
    [ivTNLIcon setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:ivTNLIcon];
    
    
    cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cellbutton setTitle:[[_getallParticipantsArr objectAtIndex:indexPath.row] valueForKey:@"ResourceID"] forState:UIControlStateNormal];
    [cellbutton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [cellbutton setTag:indexPath.row];
    [cellbutton addTarget:self action:@selector(customActionPressed:) forControlEvents:UIControlEventTouchDown];
    [cellbutton setImage:[UIImage imageNamed:@"View.png"] forState:UIControlStateNormal];
    cellbutton.frame = CGRectMake(665,14,61,32);
    [cell addSubview:cellbutton];
    
    
    //}
    
    
    cell.selectionStyle=FALSE;
    return cell;
}




#pragma mark - IBAction Methods
-(IBAction)customActionPressed:(id)sender
{
    NSLog(@"%@",globle_participant_id);
    NSLog(@"%@",globle_resource_id);
    
    globle_participant_id = [[_getallParticipantsArr objectAtIndex:[sender tag]] valueForKey:@"PartID"];
    globle_resource_id = [[_getallParticipantsArr objectAtIndex:[sender tag]] valueForKey:@"ResourceID"];
    
    //lblRName.text = globle_UnitName;
    //lblRInfo.text = [NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo];
    
    NSMutableArray *aryResourceInfo = [[NSMutableArray alloc]initWithArray:[DatabaseAccess getall_tbl_Resources:[NSString stringWithFormat:@"select *from tbl_Resources where cast(ResourceID as int) = %@",globle_resource_id]]];
    
    globle_UnitName = [[aryResourceInfo objectAtIndex:0]valueForKey:@"UnitName"];
    globle_strUnitCode = [[aryResourceInfo objectAtIndex:0]valueForKey:@"UnitCode"];
    globle_strVersion = [[aryResourceInfo objectAtIndex:0]valueForKey:@"Version"];
    globle_UnitInfo = [[aryResourceInfo objectAtIndex:0]valueForKey:@"Status"];
    
    
    /*--------------------  Sector Information - NAssessmentView --------------*/
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@.png",[[aryResourceInfo objectAtIndex:0]valueForKey:@"SectorName"]] forKey:@"NSSectorCover"];
    [[NSUserDefaults standardUserDefaults] setValue:globle_UnitName forKey:@"NSUnitName"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo] forKey:@"NSUnitInfo"];
    [[NSUserDefaults standardUserDefaults] setValue:[[aryResourceInfo objectAtIndex:0]valueForKey:@"SectorName"] forKey:@"NSSectorName"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@_Icon.png",[[aryResourceInfo objectAtIndex:0]valueForKey:@"SectorName"]] forKey:@"NSSectorIcon"];
    [[NSUserDefaults standardUserDefaults] setValue:[[_getallParticipantsArr objectAtIndex:[sender tag]] valueForKey:@"NSParticipantName"] forKey:@"NSParticipantName"];
    /*--------------------------------------------------------------------------------------*/

    
    tabFocus = @"AsTask";
    
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.strWhichTabBar = @"FirstSecondTabBar";
    NSNotification *notif = [NSNotification notificationWithName:@"popToViewController_ShowAssessment" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_13" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnResourcePressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_14" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
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

-(IBAction)btnSearchTapped:(id)sender{

    
    
    _getallParticipantsArr= [[NSMutableArray alloc] initWithArray:[DatabaseAccess get_ResumeTaskInfo:[NSString stringWithFormat:@"select distinct(participantId),(select UnitName from tbl_Resources where cast(ResourceID as int) = A.ResourceID),ResourceID,(select part_name from tbl_Participants where empId_stuno=A.ParticipantID),ParticipantID,SectorName,(select SectorColor from tbl_Resources where cast(ResourceID as int) = A.ResourceID),(select UnitCode from tbl_Resources where cast(ResourceID as int) = A.ResourceID),(select Version from tbl_Resources where cast(ResourceID as int) = A.ResourceID),(select Status from tbl_Resources where cast(ResourceID as int) = A.ResourceID)  from tbl_ResumeTask A where Status like 'InProgress' AND ((select UnitName from tbl_Resources where cast(ResourceID as int) = A.ResourceID) like '%%%@%%' OR (select UnitCode from tbl_Resources where cast(ResourceID as int) = A.ResourceID) like '%%%@%%' OR (select part_name from tbl_Participants where empId_stuno=A.ParticipantID) like '%%%@%%'  OR ParticipantID like '%%%@%%')",tfSearchField.text,tfSearchField.text,tfSearchField.text,tfSearchField.text]]];
    
    
    [_tableView reloadData];
}









/*
 NSString *PartID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 0)];
 NSString *ResourceName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 1)];
 NSString *ResourceID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 2)];
 NSString *PartName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 3)];
 NSString *ParticipantID=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 4)];
 NSString *SectorName=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 5)];
 NSString *SectorColor=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 6)];
 NSString *UnitCode=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 7)];
 NSString *Version=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 8)];
 NSString *Status=[NSString stringWithFormat: @"%s",(char *)sqlite3_column_text(compiledStmt, 9)];

 */


#pragma mark - NSNotification Methods
-(void)reloadTableWithSortOption{

    [popoverController dismissPopoverAnimated:YES];
    if([sortResumeAssType isEqualToString:@"Participant Name, A-Z"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"NSParticipantName" ascending:YES];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([sortResumeAssType isEqualToString:@"Participant Name, Z-A"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"NSParticipantName" ascending:NO];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([sortResumeAssType isEqualToString:@"Unit Name, A-Z"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"ResourceName" ascending:YES];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([sortResumeAssType isEqualToString:@"Unit Name Z-A"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"ResourceName" ascending:NO];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([sortResumeAssType isEqualToString:@"Unit Code, ascending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"UnitCode" ascending:NO];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([sortResumeAssType isEqualToString:@"Unit Code, descending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"UnitCode" ascending:YES];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([sortResumeAssType isEqualToString:@"Assessment Date, ascending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"ResourceName" ascending:YES];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    else if([sortResumeAssType isEqualToString:@"Assessment Date, descending"])
    {
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"ResourceName" ascending:YES];
        [_getallParticipantsArr sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    }
    NSLog(@"%@",_getallParticipantsArr);
    [_tableView reloadData];
}


-(IBAction)btnSortTapped:(id)sender{
    [UIView beginAnimations:nil context:nil];
    
    if(![popoverController isPopoverVisible]){
		SortResumeAssessmentViewController *objSortResumeAssessmentViewController = [[SortResumeAssessmentViewController alloc] initWithNibName:@"SortResumeAssessmentViewController" bundle:nil];
		popoverController = [[UIPopoverController alloc] initWithContentViewController:objSortResumeAssessmentViewController];
		
		[popoverController setPopoverContentSize:CGSizeMake(250.0f, 323.0f)];
        [popoverController presentPopoverFromRect:CGRectMake(283,71,68,40) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
	[UIView setAnimationDuration:2.75];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
    self.view.alpha = 1;
	
	[UIView commitAnimations];
}

-(void)reloadTableWithFilterOption{
    [popoverController dismissPopoverAnimated:YES];
    
    NSLog(@"%@",strFilterType);
    NSMutableArray *ar = [[NSMutableArray alloc]init];
    
    ar = [[NSMutableArray alloc]initWithArray:[DatabaseAccess get_ResumeTaskInfo:[NSString stringWithFormat:@"select distinct(participantId),(select UnitName from tbl_Resources where cast(ResourceID as int) = A.ResourceID),ResourceID,(select part_name from tbl_Participants where empId_stuno=A.ParticipantID),ParticipantID,SectorName,(select SectorColor from tbl_Resources where cast(ResourceID as int) = A.ResourceID),(select UnitCode from tbl_Resources where cast(ResourceID as int) = A.ResourceID),(select Version from tbl_Resources where cast(ResourceID as int) = A.ResourceID),(select Status from tbl_Resources where cast(ResourceID as int) = A.ResourceID)  from tbl_ResumeTask A where Status like 'InProgress' and (SectorName in (%@)) order by SectorName",strFilterType]]];
    
    if([ar count]>0)
    {
        _getallParticipantsArr = [[NSMutableArray alloc]initWithArray:ar];
    }
    else
        _getallParticipantsArr = [[NSMutableArray alloc]init];
    
    
    [_tableView reloadData];
}
-(IBAction)btnFilterTapped:(id)sender{
    FilterFromView = @"NPARTICIPANT";
    [UIView beginAnimations:nil context:nil];
    
    if(![popoverController isPopoverVisible]){
		PopoverFilter *_popOverController = [[PopoverFilter alloc] initWithNibName:@"PopoverFilter" bundle:nil];
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

/*
 
 aryAllParticipant = [[NSMutableArray alloc]initWithArray:[DatabaseAccess getAllParticipantName_ME:@"SELECT part_name,job_title,company,empId_stuNo,suburb_city FROM tbl_participants"]];
 getAllTasks = [[NSMutableArray alloc]initWithArray:[DatabaseAccess getallTasks:@"select *from tbl_assessment_task"]];
 aryAllNewTasks = [[NSMutableArray alloc]init];
 
 NSLog(@"%@",aryAllParticipant);
 NSLog(@"%@",getAllTasks);
 
 
 for(int x=0;x<[aryAllParticipant count];x++)
 {
 for(int y=0;y<[getAllTasks count];y++)
 {
 NSString *sqlStatement = [NSString stringWithFormat:@"select *from tbl_question_answer where cast(UserID as int) = %@ and  cast(assessment_task_id as int) = %@ and cast(ResourceId as int) = %@",[[aryAllParticipant objectAtIndex:x]valueForKey:@"empId_stuNo"],[[getAllTasks objectAtIndex:y] valueForKey:@"assessment_task_Id"],[[getAllTasks objectAtIndex:y] valueForKey:@"resource_Id"]];
 NSLog(@"%@",sqlStatement);
 int Val = [DatabaseAccess getNoOfRecord:sqlStatement];
 NSMutableDictionary *dicts = [[getAllTasks objectAtIndex:0]mutableCopy];
 
 if(Val==0)
 {
 [dicts setValue:@"NO" forKey:@"DOWNLOAD"];
 }
 else
 {
 [dicts setValue:@"YES" forKey:@"DOWNLOAD"];
 }
 
 [dicts setValue:[[aryAllParticipant objectAtIndex:x]valueForKey:@"empId_stuNo"] forKey:@"PID"];
 [dicts setValue:[[aryAllParticipant objectAtIndex:x]valueForKey:@"part_name"] forKey:@"PName"];
 
 NSLog(@"%@",dicts);
 [aryAllNewTasks addObject:dicts];
 }
 }
 
 
 */


@end
