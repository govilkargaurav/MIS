//
//  NAssessmentViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#import "NAssessmentViewController.h"
#import "AssessmentsVIewController.h"
#import "NewAssessorViewController.h"
#import "QuestionAssessorViewController.h"
#import "TabbarController.h"
#import "AlertManger.h"
#import "GlobleClass.h"
#import "SBJSON.h"
#import "YLProgressBar.h"
#import "ViewController.h"
#import "HelpViewController.h"

@interface NAssessmentViewController ()

@end

@implementation NAssessmentViewController
@synthesize _tableView;
@synthesize _getallTasks;
@synthesize assessment_task_part_id;
@synthesize request;
@synthesize getallAssessmentTaskpartidArr,dictAssesements,_aryAssessmentIdDb,_aryAssessmentIdExists,_aryQuestionOption,strAssessmentTaskPartID_QUE;
@synthesize progressView;
#pragma mark - View lifecycle


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


-(IBAction)previewView:(id)sender{
    
   
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDel showWithGradient:@"Loading" views:self.view];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [ivTopBarSelected setImage:[APPDEL topbarselectedImage:strFTabSelectedID]];
    
    [lblIconName setText:globle_SectorName];
    [lblIconName.text uppercaseString];
    [ivIcon setImage:[UIImage imageNamed:globle_SectorIcon]];
    
    aryCount = 0;
    aryCount_1 = 0;

    /*-------------------- Sector Image Start ---------- */
    UIImage *imgs = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] valueForKey:@"NSSectorCover"]];
    float actualHeight = imgs.size.height;
    float actualWidth = imgs.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 160.0/110.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 160.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 160.0;
        }
        else{
            imgRatio = 110.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 110.0;
        }
    }
    [ivResource setFrame:CGRectMake(30, 141, actualWidth, actualHeight)];
    /*------------------ Sector Image End ----------*/
    /*------------------------------------ set resource Information Start--------------------------------------------*/
    [ivResource setImage:[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] valueForKey:@"NSSectorCover"]]];
    [lblResource_1 setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"NSUnitName"]];
    [lblResource_2 setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"NSUnitInfo"]];
    [lblSecName setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"NSSectorName"]];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"NSSectorIcon"]);
    [ivSector setImage:[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] valueForKey:@"NSSectorIcon"]]];
    [lblPName setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"NSParticipantName"]];
    /*------------------------------------ set resource Information End--------------------------------------------*/
    
    
    if (assessment_task_part_id!=nil) {
        [assessment_task_part_id removeAllObjects];
        assessment_task_part_id=nil;
    }
    assessment_task_part_id=[[NSMutableArray alloc] init];
    
    
    
    if (_getallTasks!=nil) {
        [_getallTasks removeAllObjects];
        _getallTasks=nil;
    }
    _getallTasks=[[NSMutableArray alloc] init];
    
    NSLog(@"GlobalResourceId::-->%@",globle_resource_id);
    NSString *sqlStatement =[NSString stringWithFormat:@"SELECT assessment_task_Id,outline,purpose,title,description,name,task_info_assessor,type,result_text,resource_Id FROM tbl_assessment_task WHERE resource_Id =%@",globle_resource_id];
    _getallTasks=[DatabaseAccess getallTasks:sqlStatement];
    NSLog(@"ALL Participats Count %d",[_getallTasks count]);
    
    if ([_getallTasks count]==0)
    {
        [[AlertManger defaultAgent]showAlertForDelegateWithTitle:APP_NAME message:@"No Tasks available" cancelButtonTitle:@"Ok" okButtonTitle:nil parentController:self];
    }
    else
    {
        if(_aryAssessmentIdDb!=nil)
        {
            [_aryAssessmentIdDb removeAllObjects];
            _aryAssessmentIdDb=nil;
        }
        NSString *sqlStatement = [NSString stringWithFormat:@"select distinct(cast(assessment_task_id as int)) from tbl_question_answer where UserID='%@'",globle_participant_id];
        _aryAssessmentIdDb = [[NSMutableArray alloc]initWithArray:[DatabaseAccess getFromQuestionAnswer_UserID:sqlStatement]];
        
        
        if(_aryAssessmentIdExists!=nil)
        {
            [_aryAssessmentIdExists removeAllObjects];
            _aryAssessmentIdExists = nil;
        }
        
        _aryAssessmentIdExists = [[NSMutableArray alloc]init];
        
        
        if([_aryAssessmentIdDb count]>0)
        {
            for(int i=0;i<[_getallTasks count];i++)
            {
                BOOL match = NO;
                for(int j=0;j<[_aryAssessmentIdDb count];j++)
                {
                    int resourceIdWeb = [[[_getallTasks objectAtIndex:i]valueForKey:@"assessment_task_Id"] intValue];
                    int resourceIdDb = [[_aryAssessmentIdDb objectAtIndex:j]intValue];
                    if(resourceIdWeb == resourceIdDb)
                    {
                        match = YES;
                        break;
                    }
                }
                if(match==YES)
                {
                    [_aryAssessmentIdExists insertObject:@"1" atIndex:i];
                }
                else {
                    [_aryAssessmentIdExists insertObject:@"0" atIndex:i];
                }
            }
        }
        else
        {
            for(int k=0;k<[_getallTasks count];k++)
            {
                [_aryAssessmentIdExists insertObject:@"0" atIndex:k];
            }
        }
    }
    //--------------------------------------- Contextualisation ------------------------------------------------
    
    aryOtherOption = [[NSMutableArray alloc]init];
    aryOtherOption = [DatabaseAccess getalltblcontext:[NSString stringWithFormat:@"Select *from tbl_Contextualisation where cast(ResourceID as int) = %@",globle_resource_id]];
    NSLog(@"%@",aryOtherOption);
    if([aryOtherOption count]>0)
    {
        contextualisationDescription = [[aryOtherOption objectAtIndex:0] valueForKey:@"Description"];
    }
    
    aryContexOptionAnswer = [[NSMutableArray alloc]init];
    aryContexOptionAnswer = [DatabaseAccess getalltblcontextoptionanswer:[NSString stringWithFormat:@"select *from tbl_Contextualisation_Option_Answer where cast(ResourceID as int)=%@ and cast(ContextualisationID as int)=%@ and ParticipantID ='%@'",[[aryOtherOption objectAtIndex:0]valueForKey:@"ResourceID"],[[aryOtherOption objectAtIndex:0]valueForKey:@"contextID"],globle_participant_id]];
    
    
    //--------------------------------------- Third Party Results ------------------------------------------------
    aryThirdPartyAnswer = [[NSMutableArray alloc]init];
    aryThirdPartyAnswer = [DatabaseAccess getThirdpartyresults_answer:[NSString stringWithFormat:@"select *from tbl_ThirdPartyReports_Answer where  ParticipantID = '%@' and cast(ResourceID as int) = %@",globle_participant_id,globle_resource_id]];
    
    
    
    //--------------------------------------- System Validation ------------------------------------------------
    
    arySysValidation =  [[NSMutableArray alloc]init];
    arySysValidationOption = [[NSMutableArray alloc]init];
    arySysValidationOptionAnswer = [[NSMutableArray alloc]init];
    
    arySysValidation = [DatabaseAccess get_tbl_SysValidation:[NSString stringWithFormat:@"select *from tbl_SysValidation where cast(ResourceID  as int) = %@",globle_resource_id]];
    NSLog(@"%@",arySysValidation);
    if([arySysValidation count]>0)
    {
        NSLog(@"%@",[[arySysValidation objectAtIndex:0] valueForKey:@"ResourceID"]);
        arySysValidationOption = [DatabaseAccess get_tbl_SysValidationOptions:[NSString stringWithFormat:@"select *from tbl_SysValidationOptions where cast(ResourceID as int) = %@ and cast(ValidationID as int) = %@",[arySysValidation valueForKey:@"ResourceID"],[arySysValidation valueForKey:@"ValidationID"]]];
        NSLog(@"%@",arySysValidationOption);
        arySysValidationOptionAnswer = [DatabaseAccess get_tbl_SysValidationOptionsAnswer:[NSString stringWithFormat:@"select *From tbl_SysValidationOptionsAnswer where ParticipantID = '%@' and cast(ResourceID as int) = %@",globle_participant_id,[[arySysValidation objectAtIndex:0] valueForKey:@"ResourceID"]]];
        
        NSLog(@"%@",arySysValidationOptionAnswer);
    }
    
    
    //--------------------------------------- Results ----------------------------------------------------------
    
    aryResults = [[NSMutableArray alloc]init];
    aryResultsOptionsAnswer = [[NSMutableArray alloc]init];
    
    aryResults = [DatabaseAccess get_tbl_ResultsOptions:[NSString stringWithFormat:@"select *from tbl_ResultsOptions where cast(ResourceID as int) = %@",globle_resource_id]];
    
    aryResultsOptionsAnswer = [DatabaseAccess get_tbl_ResultsOptionsAnswer:[NSString stringWithFormat:@"select *from tbl_ResultsOptionsAnswer where cast(ResourceID as int) = %@ and ParticipantID = '%@'",globle_resource_id,globle_participant_id]];
    
    NSLog(@"%@",aryResultsOptionsAnswer);
    
    
    //---------------------------------------   Competency  -----------------------------------------------------
    aryCompetency = [[NSMutableArray alloc]init];
    aryCompetencyTask = [[NSMutableArray alloc]init];
    aryCompetencyAnswer = [[NSMutableArray alloc]init];
    
    aryCompetency = [DatabaseAccess get_tbl_Competency:[NSString stringWithFormat:@"select *from tbl_Competency where cast(ResourceID as int) = %@",globle_resource_id]];
    if([aryCompetency count]>0)
    {
        aryCompetencyTask = [DatabaseAccess get_tbl_CompetencyTask:[NSString stringWithFormat:@"select *from tbl_CompetencyTask where cast(CompetencyOutlineID as int) = %@",[[aryCompetency objectAtIndex:0] valueForKey:@"CompetencyOutlineID"]]];
        
        aryCompetencyAnswer = [DatabaseAccess get_tbl_CompetencyTaskAnswer:[NSString stringWithFormat:@"select *from tbl_CompetencyTaskAnswer where ParticipantID = '%@' and cast(ResourceID as int) = %@",globle_participant_id,globle_resource_id]];
        
    }
    
    //--------------------------------------- TableView ------------------------------------------------
    
    if (_tableView!=nil) {
        [_tableView removeFromSuperview];
        _tableView=nil;
    }
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,390,768,640) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=70;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView reloadData];
    
    
    [appDel hideWithGradient];
}


-(void)createTableView
{
    
}



-(IBAction)popTorootView:(id)sender{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


/*
 * On click UITbaleViewCell Button this method will Call...
 */

-(void)customActionPressed:(id)sender
{
    taskEditMode = @"NO";
    NSLog(@"%@",globle_participant_id);
    NSLog(@"%@",[NSString stringWithFormat:@"%d",[sender tag]]);
    globle_assessment_task_id = [NSString stringWithFormat:@"%d",[sender tag]];
    int noOfRecord = [DatabaseAccess getNoOfRecord:[NSString stringWithFormat:@"SELECT COUNT(CAST(QUESTION_ID AS INT))FROM TBL_QUESTION WHERE CAST(ASSESSMENT_TASK_ID AS INT) = %d",[sender tag]]];
    
    if(noOfRecord >0)
    {
        UITableViewCell *owningCell = (UITableViewCell*)[sender superview];
        NSIndexPath *pathToCell = [self._tableView indexPathForCell:owningCell];
        [[NSUserDefaults standardUserDefaults] setObject:[[_getallTasks objectAtIndex:pathToCell.row] valueForKey:@"outline"] forKey:@"assTaskOutline"];
        
        noOfRecord = 0;
        noOfRecord = [DatabaseAccess getNoOfRecord:[NSString stringWithFormat:@"SELECT COUNT(AUTOID)FROM TBL_QUESTION_ANSWER WHERE USERID = %@ AND CAST(ASSESSMENT_TASK_ID AS INT)=%@",globle_participant_id,globle_assessment_task_id]];
        if(noOfRecord >0)
        {
            ParticipatnsContinue = @"YES";
        }
        else
        {
            ParticipatnsContinue = @"NO";
        }
        NSLog(@"%@",ParticipatnsContinue);
        
        /* OLD COMMENT
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"assname"])
        {
            ViewController *x = [[ViewController alloc] init];
            AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            app.strWhichTabBar = @"SecondTabBar";
            [app.navigationController pushViewController: x animated:YES];
        }
        else
            [self loginViewPushed:@"ViewController"];
        */
        
        /* NEW COMMENT
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        app.strWhichTabBar = @"SecondTabBar";
        [self loginViewPushed:@"ViewController"];
        */
        
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        app.strWhichTabBar = @"SecondTabBar";
        objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
        objAssessorTypeViewController.strNextPushController = @"ViewController";
        [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"T&L" message:@"Sorry, No records found !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)customActionPressedResume:(id)sender
{
    taskEditMode = @"YES";
    NSLog(@"%@",globle_participant_id);
    NSLog(@"%@",[NSString stringWithFormat:@"%d",[sender tag]]);
    globle_assessment_task_id = [NSString stringWithFormat:@"%d",[sender tag]];
    
    /* --------------------------   Duration Calculation    ----------------------------*/
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
    
    StartTime = [NSDate date];
    NSString *dateString = [format stringFromDate:StartTime];
    StartTime = [format dateFromString:dateString];
    /* --------------------------   Duration Calculation    ----------------------------*/
    
    /* ---------------------------- For Accessing Record From tbl_ResumeTask -------- */
    [[NSUserDefaults standardUserDefaults] setValue:globle_resource_id forKey:@"grID"];
    [[NSUserDefaults standardUserDefaults] setValue:globle_assessment_task_id forKey:@"gataskID"];
    [[NSUserDefaults standardUserDefaults] setValue:globle_participant_id forKey:@"gpID"];
    /* ---------------------------- ------------------------------------------------- */
    
    int noOfRecord = [DatabaseAccess getNoOfRecord:[NSString stringWithFormat:@"SELECT COUNT(CAST(QUESTION_ID AS INT))FROM TBL_QUESTION WHERE CAST(ASSESSMENT_TASK_ID AS INT) = %d",[sender tag]]];
    
    if(noOfRecord >0)
    {
        UITableViewCell *owningCell = (UITableViewCell*)[sender superview];
        NSIndexPath *pathToCell = [self._tableView indexPathForCell:owningCell];
        [[NSUserDefaults standardUserDefaults] setObject:[[_getallTasks objectAtIndex:pathToCell.row] valueForKey:@"outline"] forKey:@"assTaskOutline"];
        
        noOfRecord = 0;
        noOfRecord = [DatabaseAccess getNoOfRecord:[NSString stringWithFormat:@"SELECT COUNT(AUTOID)FROM TBL_QUESTION_ANSWER WHERE USERID = '%@' AND CAST(ASSESSMENT_TASK_ID AS INT)=%@",globle_participant_id,globle_assessment_task_id]];
        if(noOfRecord >0)
        {
            ParticipatnsContinue = @"YES";
        }
        else
        {
            ParticipatnsContinue = @"NO";
        }
        NSLog(@"%@",ParticipatnsContinue);

        /* OLD COMMENT
        ViewController *x = [[ViewController alloc] init];
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        app.strWhichTabBar = @"SecondTabBar";
        [app.navigationController pushViewController: x animated:YES];
        */
        
        /* NEW COMMENT
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        app.strWhichTabBar = @"SecondTabBar";
        [self loginViewPushed:@"ViewController"];
        */
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        app.strWhichTabBar = @"SecondTabBar";
        objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
        objAssessorTypeViewController.strNextPushController = @"ViewController";
        [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"T&L" message:@"Sorry, No records found !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(IBAction)loginViewPushed:(NSString*)str
{
    NewAssessorViewController *objNewAssessorViewController = [[NewAssessorViewController alloc]initWithNibName:@"NewAssessorViewController" bundle:nil];
    objNewAssessorViewController.strPushViewController = str;
    [self.navigationController pushViewController:objNewAssessorViewController animated:YES];
}


-(void)newEvent:(id)sender
{
    ParticipatnsContinue = @"YES";
    ViewController *x = [[ViewController alloc] init];
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.strWhichTabBar = @"SecondTabBar";
    [app.navigationController pushViewController: x animated:YES];
}


#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_getallTasks count] + 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    UIImageView *imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"assessments.png"]];
    imageview.frame=CGRectMake(0,0,769,70);
    [cell.contentView addSubview:imageview];
    
    
    
    if(indexPath.row == [_getallTasks count])
    {
        UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,10,290,25)];
        titleLbl.backgroundColor=[UIColor clearColor];
        titleLbl.textColor=[UIColor blackColor];
        titleLbl.font=[UIFont boldSystemFontOfSize:18];
        titleLbl.text=@"Contextualisation";
        [imageview addSubview:titleLbl];
        
        if([aryContexOptionAnswer count] > 0)
        {
            cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"completeHightLight"] forState:UIControlStateHighlighted];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
            
            cellbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton2 addTarget:self
                            action:@selector(previewContextualisationTapped:)
                  forControlEvents:UIControlEventTouchDown];
            [cellbutton2 setImage:[UIImage imageNamed:@"Preview.png"] forState:UIControlStateNormal];
            [cellbutton2 setImage:[UIImage imageNamed:@"PreviewHighLight"] forState:UIControlStateHighlighted];
            cellbutton2.frame = CGRectMake(525,15,65,33);
            [cell addSubview:cellbutton2];
        }
        else
        {
            cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton addTarget:self
                           action:@selector(btnContextualisationTapped:)
                 forControlEvents:UIControlEventTouchDown];
            [cellbutton setImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"StartHighLight"] forState:UIControlStateHighlighted];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
        }
        
    }
    else if(indexPath.row == [_getallTasks count] + 1)
    {
        UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,10,290,25)];
        titleLbl.backgroundColor=[UIColor clearColor];
        titleLbl.textColor=[UIColor blackColor];
        titleLbl.font=[UIFont boldSystemFontOfSize:18];
        titleLbl.text=@"Third Party Reports";
        [imageview addSubview:titleLbl];
        
        if([aryThirdPartyAnswer count] > 0)
        {
            cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton setImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"completeHightLight"] forState:UIControlStateHighlighted];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
            
            cellbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton2 addTarget:self
                            action:@selector(previewTPResultsTapped:)
                  forControlEvents:UIControlEventTouchDown];
            [cellbutton2 setImage:[UIImage imageNamed:@"Preview.png"] forState:UIControlStateNormal];
            [cellbutton2 setImage:[UIImage imageNamed:@"PreviewHighLight"] forState:UIControlStateHighlighted];
            cellbutton2.frame = CGRectMake(525,15,65,33);
            [cell addSubview:cellbutton2];
        }
        else
        {
            cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton addTarget:self
                           action:@selector(btnTPResultsTapped:)
                 forControlEvents:UIControlEventTouchDown];
            [cellbutton setImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"StartHighLight"] forState:UIControlStateHighlighted];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
        }
        
    }
    else if(indexPath.row == [_getallTasks count] + 2)
    {
        UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,10,290,25)];
        titleLbl.backgroundColor=[UIColor clearColor];
        titleLbl.textColor=[UIColor blackColor];
        titleLbl.font=[UIFont boldSystemFontOfSize:18];
        titleLbl.text=@"Results";
        [imageview addSubview:titleLbl];
        
        if([aryResultsOptionsAnswer count]>0)
        {
            cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton setImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"completeHightLight"] forState:UIControlStateHighlighted];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
            
            cellbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton2 addTarget:self
                            action:@selector(btnResultsTapped:)
                  forControlEvents:UIControlEventTouchDown];
            [cellbutton2 setImage:[UIImage imageNamed:@"Preview.png"] forState:UIControlStateNormal];
            [cellbutton2 setImage:[UIImage imageNamed:@"PreviewHighLight"] forState:UIControlStateHighlighted];
            cellbutton2.frame = CGRectMake(525,15,65,33);
            [cell addSubview:cellbutton2];
        }
        else
        {
            cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton setImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"StartHighLight"] forState:UIControlStateHighlighted];
            [cellbutton addTarget:self
                           action:@selector(btnResultsTapped:)
                 forControlEvents:UIControlEventTouchDown];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
        }
    }
    else if(indexPath.row == [_getallTasks count] + 3)
    {
        UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,10,290,25)];
        titleLbl.backgroundColor=[UIColor clearColor];
        titleLbl.textColor=[UIColor blackColor];
        titleLbl.font=[UIFont boldSystemFontOfSize:18];
        titleLbl.text=@"Competency Mapping Template";
        [imageview addSubview:titleLbl];
        
        if([aryCompetencyAnswer count]>0)
        {
            cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton setImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"completeHightLight"] forState:UIControlStateHighlighted];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
            
            cellbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton2 addTarget:self
                            action:@selector(btnCompetencyTapped:)
                  forControlEvents:UIControlEventTouchDown];
            [cellbutton2 setImage:[UIImage imageNamed:@"Preview.png"] forState:UIControlStateNormal];
            [cellbutton2 setImage:[UIImage imageNamed:@"PreviewHighLight"] forState:UIControlStateHighlighted];
            cellbutton2.frame = CGRectMake(525,15,65,33);
            [cell addSubview:cellbutton2];
        }
        else
        {
            cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton setImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"StartHighLight"] forState:UIControlStateHighlighted];
            [cellbutton addTarget:self action:@selector(btnCompetencyTapped:)
                 forControlEvents:UIControlEventTouchDown];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
        }
    }
    else if(indexPath.row == [_getallTasks count] + 4)
    {
        UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,10,290,25)];
        titleLbl.backgroundColor=[UIColor clearColor];
        titleLbl.textColor=[UIColor blackColor];
        titleLbl.font=[UIFont boldSystemFontOfSize:18];
        titleLbl.text=@"Systematic Validation";
        [imageview addSubview:titleLbl];
        
        if([arySysValidationOptionAnswer count] > 0)
        {
            cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton setImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"completeHightLight"] forState:UIControlStateHighlighted];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
            
            cellbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton2 addTarget:self
                            action:@selector(btnValidationTapped:)
                  forControlEvents:UIControlEventTouchDown];
            [cellbutton2 setImage:[UIImage imageNamed:@"Preview.png"] forState:UIControlStateNormal];
            [cellbutton2 setImage:[UIImage imageNamed:@"PreviewHighLight"] forState:UIControlStateHighlighted];
            cellbutton2.frame = CGRectMake(525,15,65,33);
            [cell addSubview:cellbutton2];
        }
        else
        {
            cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton addTarget:self
                           action:@selector(btnValidationTapped:)
                 forControlEvents:UIControlEventTouchDown];
            [cellbutton setImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"StartHighLight"] forState:UIControlStateHighlighted];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
        }
    }
    else
    {
        UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,10,500,25)];
        titleLbl.backgroundColor=[UIColor clearColor];
        titleLbl.textColor=[UIColor blackColor];
        titleLbl.font=[UIFont boldSystemFontOfSize:18];
        titleLbl.text=[[_getallTasks objectAtIndex:indexPath.row] valueForKey:@"title"];
        [imageview addSubview:titleLbl];
        
        
        UILabel *descLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,39,450,25)];
        descLbl.backgroundColor=[UIColor clearColor];
        descLbl.textColor=[UIColor blackColor];
        descLbl.font=[UIFont systemFontOfSize:12];
        descLbl.text=[[_getallTasks objectAtIndex:indexPath.row] valueForKey:@"description"];
        [imageview addSubview:descLbl];
        
        
        NSLog(@"%@",_aryAssessmentIdExists);
        if([[_aryAssessmentIdExists objectAtIndex:indexPath.row] isEqualToString:@"1"])
        {
            cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellbutton setTag:[[[_getallTasks objectAtIndex:indexPath.row] valueForKey:@"assessment_task_Id"] intValue]];
            [cellbutton setImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"completeHightLight"] forState:UIControlStateHighlighted];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
            
            cellbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            NSLog(@"%@",[[_getallTasks objectAtIndex:indexPath.row] valueForKey:@"assessment_task_Id"]);
            [cellbutton2 setTag:[[[_getallTasks objectAtIndex:indexPath.row] valueForKey:@"assessment_task_Id"] intValue]];
            [cellbutton2 addTarget:self
                            action:@selector(customActionPressedResume:)
                  forControlEvents:UIControlEventTouchDown];
            [cellbutton2 setImage:[UIImage imageNamed:@"Preview.png"] forState:UIControlStateNormal];
            [cellbutton2 setImage:[UIImage imageNamed:@"PreviewHighLight"] forState:UIControlStateHighlighted];
            cellbutton2.frame = CGRectMake(525,15,65,33);
            [cell addSubview:cellbutton2];
        }
        else
        {
            cellbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            NSLog(@"%@",[[_getallTasks objectAtIndex:indexPath.row] valueForKey:@"assessment_task_Id"]);
            [cellbutton setTag:[[[_getallTasks objectAtIndex:indexPath.row] valueForKey:@"assessment_task_Id"] intValue]];
            [cellbutton addTarget:self
                           action:@selector(customActionPressed:)
                 forControlEvents:UIControlEventTouchDown];
            [cellbutton setImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"StartHighLight"] forState:UIControlStateHighlighted];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
        }
    }
    
    cell.selectionStyle=FALSE;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(IBAction)sortDropDown:(id)sender{
    
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


#pragma mark - UIButton Events


-(IBAction)btnTPResultsTapped:(id)sender
{
    //[self loginViewPushed:@"ThirdPartyStep2ViewController"];
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"ThirdPartyStep2ViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
}
-(IBAction)previewTPResultsTapped:(id)sender
{
    //[self loginViewPushed:@"ThirdPartyStep2ViewController"];
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"ThirdPartyStep2ViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
}

-(IBAction)btnContextualisationTapped:(id)sender
{
    //[self loginViewPushed:@"ContexualizationViewController"];
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"ContexualizationViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
}

-(IBAction)previewContextualisationTapped:(id)sender
{
    //[self loginViewPushed:@"ContexualizationViewController"];
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"ContexualizationViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
}

-(IBAction)btnCompetencyTapped:(id)sender
{
    //[self loginViewPushed:@"CompetencyViewController"];
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"CompetencyViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
}

-(IBAction)btnResultsTapped:(id)sender
{
    if([aryResultsOptionsAnswer count]>0)
    {
        aryResultOpn = [[NSMutableArray alloc]initWithArray:aryResults];
    }
    else
    {
        aryResultOpn = [[NSMutableArray alloc]init];
    }
    //[self loginViewPushed:@"Results_First_ViewController"];
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"Results_First_ViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
}

-(IBAction)btnValidationTapped:(id)sender
{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"]);
    strDescription = [[arySysValidation objectAtIndex:0] valueForKey:@"Description"];
    arySysValidationAnswer = [[NSMutableArray alloc]initWithArray:arySysValidationOptionAnswer];
    //[self loginViewPushed:@"SysValidationViewController"];
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"SysValidationViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
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

- (IBAction)btnSendMeTapped:(id)sender {
    [UIView animateWithDuration:0.5 animations:^(void) {
        [viewInfo setFrame:CGRectMake(0, 433, 768, 67)];
        [viewSendEmail setFrame:CGRectMake(0, 350, 768, 60)];
        [_tableView setFrame:CGRectMake(0, 500, 768, 504)];
    }];
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
    strFilterType = @"'Logistics & Warehousing','Road Transport','Rail','Maritime','Aviation','Ports'";
    viewWillAppearStr = @"1";
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_14" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

@end
