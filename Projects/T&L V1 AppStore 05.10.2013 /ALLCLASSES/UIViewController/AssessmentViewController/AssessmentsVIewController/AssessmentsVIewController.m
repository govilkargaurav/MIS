//
//  AssessmentsVIewController.m
//  T&L
//
//  Created by openxcell tech.. on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "AssessmentsVIewController.h"
#import "NewAssessorViewController.h"
#import "QuestionAssessorViewController.h"
#import "TabbarController.h"
#import "AlertManger.h"
#import "GlobleClass.h"
#import "SBJSON.h"
#import "YLProgressBar.h"
#import "ViewController.h"
#import "ContexualizationViewController.h"
#import "ThirdPartyStep2ViewController.h"
#import "SysValidationViewController.h"
#import "Results_First_ViewController.h"
#import "CompetencyViewController.h"
#import "HelpViewController.h"
#import "EditParticipantInfoViewController.h"


@implementation AssessmentsVIewController

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
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //------Topbar Image Set
    [ivTopBarSelected setImage:[APPDEL topbarselectedImage:strFTabSelectedID]];
    
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel showWithGradient:@"Loading" views:self.view];
    objEditParticipantInfoViewController = [[EditParticipantInfoViewController alloc] initWithNibName:@"EditParticipantInfoViewController" bundle:nil];
    [objEditParticipantInfoViewController.view setFrame:CGRectMake(768, 0,768 ,1004)];
    [self.view addSubview:objEditParticipantInfoViewController.view];
    

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    strGoToNextView = @"NO";
    [lblIconName setText:globle_SectorName];
    [lblIconName.text uppercaseString];
    [ivIcon setImage:[UIImage imageNamed:globle_SectorIcon]];
    
    aryCount = 0;
    aryCount_1 = 0;
    

    /*-------------------- Sector Image Start ---------- */
    UIImage *imgs = [UIImage imageNamed:globle_SectorCover];
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
    [imgThumb setFrame:CGRectMake(30, 141, actualWidth, actualHeight)];
    [imgThumb setImage:[UIImage imageNamed:globle_SectorCover]];
    /*------------------ Sector Image End ----------*/
    
    
    lblPartName.text = globle_ParticipantName;
    lblRName.text = globle_UnitName;
    lblRInfo.text = [NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo];
    
    /*--------------------  Sector Information - NAssessmentView --------------*/
    [[NSUserDefaults standardUserDefaults] setValue:globle_SectorCover forKey:@"NSSectorCover"];
    [[NSUserDefaults standardUserDefaults] setValue:globle_UnitName forKey:@"NSUnitName"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo] forKey:@"NSUnitInfo"];
    [[NSUserDefaults standardUserDefaults] setValue:globle_SectorName forKey:@"NSSectorName"];
    [[NSUserDefaults standardUserDefaults] setValue:globle_SectorIcon forKey:@"NSSectorIcon"];
    [[NSUserDefaults standardUserDefaults] setValue:globle_ParticipantName forKey:@"NSParticipantName"];
    /*--------------------------------------------------------------------------------------*/
    
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
    // first check Contextualisation available for this resource
    
    aryOtherOption = [[NSMutableArray alloc]init];
    aryOtherOption = [DatabaseAccess getalltblcontext:[NSString stringWithFormat:@"Select *from tbl_Contextualisation where cast(ResourceID as int) = %@",globle_resource_id]];
    NSLog(@"%@",aryOtherOption);
    if([aryOtherOption count]>0)
    {
        contextualisationDescription = [[aryOtherOption objectAtIndex:0] valueForKey:@"Description"];
    }
    
    //-- if available then check that participant done with contextualisation or not
    aryContexOptionAnswer = [[NSMutableArray alloc]init];
    aryContexOptionAnswer = [DatabaseAccess getalltblcontextoptionanswer:[NSString stringWithFormat:@"select *from tbl_Contextualisation_Option_Answer where cast(ResourceID as int)=%@ and cast(ContextualisationID as int)=%@ and ParticipantID = '%@'",[[aryOtherOption objectAtIndex:0]valueForKey:@"ResourceID"],[[aryOtherOption objectAtIndex:0]valueForKey:@"contextID"],globle_participant_id]];
    
    
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
        arySysValidationOptionAnswer = [DatabaseAccess get_tbl_SysValidationOptionsAnswer:[NSString stringWithFormat:@"select *From tbl_SysValidationOptionsAnswer where ParticipantID = '%@' and cast(ResourceID as int) = %@",globle_participant_id,[[arySysValidation  objectAtIndex:0] valueForKey:@"ResourceID"]]];
        
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
    
    [viewInfo setFrame:CGRectMake(0, 323, 768, 67)];
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(IBAction)popTorootView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rowDefault"]]];
    [cell setSelectedBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rowSelected"]]];
    
    UIImageView *ivTNLIcon = [[UIImageView alloc]init];
    [ivTNLIcon setFrame:CGRectMake(30, 15, 32, 39)];
    [ivTNLIcon setImage:[UIImage imageNamed:@"A.png"]];
    [ivTNLIcon setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:ivTNLIcon];
    
    if(indexPath.row == [_getallTasks count])
    {
        UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,10,290,25)];
        titleLbl.backgroundColor=[UIColor clearColor];
        titleLbl.textColor=[UIColor blackColor];
        titleLbl.font=[UIFont boldSystemFontOfSize:18];
        titleLbl.text=@"Contextualisation";
        [cell addSubview:titleLbl];
        
        UILabel *descLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,39,450,25)];
        descLbl.backgroundColor=[UIColor clearColor];
        descLbl.textColor=[UIColor blackColor];
        descLbl.font=[UIFont systemFontOfSize:12];
        descLbl.text=globle_UnitName;
        [cell addSubview:descLbl];
        
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
                  forControlEvents:UIControlEventTouchUpInside];
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
                 forControlEvents:UIControlEventTouchUpInside];
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
        [cell addSubview:titleLbl];
        
        UILabel *descLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,39,450,25)];
        descLbl.backgroundColor=[UIColor clearColor];
        descLbl.textColor=[UIColor blackColor];
        descLbl.font=[UIFont systemFontOfSize:12];
        descLbl.text=globle_UnitName;
        [cell addSubview:descLbl];
        
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
                  forControlEvents:UIControlEventTouchUpInside];
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
                 forControlEvents:UIControlEventTouchUpInside];
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
        [cell addSubview:titleLbl];
        
        UILabel *descLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,39,450,25)];
        descLbl.backgroundColor=[UIColor clearColor];
        descLbl.textColor=[UIColor blackColor];
        descLbl.font=[UIFont systemFontOfSize:12];
        descLbl.text=globle_UnitName;
        [cell addSubview:descLbl];
        
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
                  forControlEvents:UIControlEventTouchUpInside];
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
                 forControlEvents:UIControlEventTouchUpInside];
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
        [cell addSubview:titleLbl];
        
        UILabel *descLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,39,450,25)];
        descLbl.backgroundColor=[UIColor clearColor];
        descLbl.textColor=[UIColor blackColor];
        descLbl.font=[UIFont systemFontOfSize:12];
        descLbl.text=globle_UnitName;
        [cell addSubview:descLbl];
        
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
                  forControlEvents:UIControlEventTouchUpInside];
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
                  forControlEvents:UIControlEventTouchUpInside];
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
        [cell addSubview:titleLbl];
        
        UILabel *descLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,39,450,25)];
        descLbl.backgroundColor=[UIColor clearColor];
        descLbl.textColor=[UIColor blackColor];
        descLbl.font=[UIFont systemFontOfSize:12];
        descLbl.text=globle_UnitName;
        [cell addSubview:descLbl];
        
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
                  forControlEvents:UIControlEventTouchUpInside];
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
                 forControlEvents:UIControlEventTouchUpInside];
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
        [cell addSubview:titleLbl];
        
        
        UILabel *descLbl=[[UILabel alloc] initWithFrame:CGRectMake(85,39,450,25)];
        descLbl.backgroundColor=[UIColor clearColor];
        descLbl.textColor=[UIColor blackColor];
        descLbl.font=[UIFont systemFontOfSize:12];
        descLbl.text=globle_UnitName;
        [cell addSubview:descLbl];
        
        
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
                  forControlEvents:UIControlEventTouchUpInside];
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
                 forControlEvents:UIControlEventTouchUpInside];
            [cellbutton setImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
            [cellbutton setImage:[UIImage imageNamed:@"StartHighLight"] forState:UIControlStateHighlighted];
            cellbutton.frame = CGRectMake(600,15,96,32);
            [cell addSubview:cellbutton];
        }
    }
    
    //cell.selectionStyle=FALSE;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(IBAction)previewView:(id)sender
{
    /*  Array & Dictionary To JSON String

     NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:@"EmailID", @"Email",@"FNAME", @"FirstName",nil];
     NSMutableArray *aryms = [[NSMutableArray alloc]init];
     [aryms addObject:tmp];
     [aryms addObject:tmp];
     NSError *error;
     NSData *postdata = [NSJSONSerialization dataWithJSONObject:aryms options:0 error:&error];
     NSLog(@"%@",postdata);
     NSLog([[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding]);
     [request setHTTPBody:postData];
     */
    
    /* --- Using JSON String
     NSLog(@"Request JSON %@",[dic JSONString]);
     */
    
    //----------------------------------    Latest PDF Send Request Code  --------------------------------------------------
    // Assessor
    aryJSONRequestAssessor = [[NSMutableArray alloc]init];
    for(int i=0;i<[_getallTasks count];i++)
    {
     
        NSString *strDBQuery = [NSString stringWithFormat:
                                @"select "
                                
                                @"UserID,"
                                @"(select part_name  from tbl_participants where empid_stuno=UserID),"
                                @"(select company  from tbl_participants where empid_stuno=UserID),"
                                @"(select empId_stuNO  from tbl_participants where empid_stuno=UserID),"
                                @"(select job_title  from tbl_participants where empid_stuno=UserID),"
                                @"(select email  from tbl_participants where empid_stuno=UserID),"
                                
                                @"optionselected,"
                                @"result,"
                                @"answer,"
                                @"assessorcomment,"
                                
                                @"assessorID,"
                                @"(select ass_name  from tbl_assessor where ass_empid=assessorID),"
                                @"(select ass_email  from tbl_assessor where ass_empid=assessorID),"
                                @"question_Id,"
                                @"resourceID,"
                                @"assessment_task_Id,"
                                @"assessment_task_part_id"
                                @" from tbl_question_answer  where cast(Assessment_task_id as int) = %@ and UserID = '%@'",
                                
                                [[_getallTasks objectAtIndex:i] valueForKey:@"assessment_task_Id"],globle_participant_id];
            
        
        NSArray *aryTmps =  [[NSArray alloc]initWithArray:[DatabaseAccess result_tblQuestionOptionForPDFCreation:strDBQuery]];
        if([aryTmps count]>0)
        {
            for(int J=0; J<[aryTmps count];J++)
            {
                [aryJSONRequestAssessor addObject:[aryTmps objectAtIndex:J]];
            }
        }     
    }
    
    // Contextualisation
    aryJSONRequestContextualisation = [[NSMutableArray alloc]init];
    NSString *strDBQuery = [NSString stringWithFormat:
                                @"select "
                                
                                @"ParticipantID,"
                                @"(select part_name  from tbl_participants where empid_stuno=ParticipantID),"
                                @"(select company  from tbl_participants where empid_stuno=ParticipantID),"
                                @"(select empId_stuNO  from tbl_participants where empid_stuno=ParticipantID),"
                                @"(select job_title  from tbl_participants where empid_stuno=ParticipantID),"
                                @"(select email  from tbl_participants where empid_stuno=ParticipantID),"
                                
                                @"AssessorID,"
                                @"reference,"
                                @"description,"
                                @"relationship,"
                                @"comments,"
                                
                                @"Contextualisation_entriesID,"
                                @"ContextualisationID,"
                                
                                @"(select ass_name  from tbl_assessor where ass_empid=AssessorID),"
                                @"(select ass_email  from tbl_assessor where ass_empid=AssessorID),"
                                
                                @"ResourceID"

                                @" from tbl_Contextualisation_Option_Answer  where cast(ResourceID as int) = %@ and ParticipantID = '%@'",
                                
                                globle_resource_id,globle_participant_id];
        
        
    NSArray *aryTmps =  [[NSArray alloc]initWithArray:[DatabaseAccess result_tblContextualisationOptionAnswerForPDFCreation:strDBQuery]];
    if([aryTmps count]>0)
    {
        for(int J=0; J<[aryTmps count];J++)
        {
            [aryJSONRequestContextualisation addObject:[aryTmps objectAtIndex:J]];
        }
    }
    
    // Third Party UserInfo
    aryThirdPartyUserInfo = [[NSMutableArray alloc]init];
    strDBQuery = [NSString stringWithFormat:
                                @"select * from tbl_ThirdPartyDetail  where cast(ResourceID as int) = %@ and ParticipantID = '%@'",
                                globle_resource_id,globle_participant_id];        
        
    aryTmps =  [[NSArray alloc]initWithArray:[DatabaseAccess result_tblThirdPartyDetailForPDFCreation:strDBQuery]];
    if([aryTmps count]>0)
    {
        for(int J=0; J<[aryTmps count];J++)
        {
            [aryThirdPartyUserInfo addObject:[aryTmps objectAtIndex:J]];
        }
    }
    
    // Third Pary Query
    aryThirdPartyQuery = [[NSMutableArray alloc]init];
    strDBQuery = [NSString stringWithFormat:
                  @"select * from tbl_ThirdPartyReports_Answer where cast(ResourceID as int) = %@ and ParticipantID = '%@'",
                  globle_resource_id,globle_participant_id];
    
    aryTmps =  [[NSArray alloc]initWithArray:[DatabaseAccess result_tblThirdPartyReportsAnswerForPDFCreation:strDBQuery]];
    if([aryTmps count]>0)
    {
        for(int J=0; J<[aryTmps count];J++)
        {
            [aryThirdPartyQuery addObject:[aryTmps objectAtIndex:J]];
        }
    }
    
    // System Validation
    aryJSONRequestSysValidation = [[NSMutableArray alloc]init];
    strDBQuery = [NSString stringWithFormat:
                  @"select * from tbl_SysValidationOptionsAnswer where cast(ResourceID as int) = %@ and ParticipantID  = '%@'",
                  globle_resource_id,globle_participant_id];
    
    aryTmps =  [[NSArray alloc]initWithArray:[DatabaseAccess result_tblSysValidationOptionsAnswerForPDFCreation:strDBQuery]];
    if([aryTmps count]>0)
    {
        for(int J=0; J<[aryTmps count];J++)
        {
            [aryJSONRequestSysValidation addObject:[aryTmps objectAtIndex:J]];
        }
    }
    
    // Results
    aryJSONRequestResults = [[NSMutableArray alloc]init];
    strDBQuery = [NSString stringWithFormat:
                  @"select * from tbl_ResultsOptionsAnswer where cast(ResourceID as int) = %@ and ParticipantID  = '%@' and ResultTaskTextID not in('Unit Competency','Comments')",
                  globle_resource_id,globle_participant_id];
    
    aryTmps =  [[NSArray alloc]initWithArray:[DatabaseAccess result_tblResultsOptionsAnswerForPDFCreation:strDBQuery]];
    if([aryTmps count]>0)
    {
        for(int J=0; J<[aryTmps count];J++)
        {
            [aryJSONRequestResults addObject:[aryTmps objectAtIndex:J]];
        }
    }
    
    // Result Competency
    aryJSONRequestResultsCompetency = [[NSMutableArray alloc]init];
    strDBQuery = [NSString stringWithFormat:
                  @"select ResourceID,ParticipantID,Status,AssessorID  from tbl_ResultsOptionsAnswer where cast(ResourceID as int) = %@ and ParticipantID  = '%@' and ResultTaskTextID in('Unit Competency','Comments')",
                  globle_resource_id,globle_participant_id];
    
    aryTmps =  [[NSArray alloc]initWithArray:[DatabaseAccess result_tblResultsOptionsCompetecyAnswerForPDFCreation:strDBQuery]];
    if([aryTmps count]>0)
    {
        NSString *competencyachieved;
        if([[[aryTmps objectAtIndex:0] valueForKey:@"outcome"] isEqualToString:@"1"])
            competencyachieved = @"true";
        else
            competencyachieved = @"false";
        
        NSString *participantid = [[aryTmps objectAtIndex:0] valueForKey:@"participantid"];
        NSString *AssessorID = [[aryTmps objectAtIndex:0] valueForKey:@"AssessorID"];
        NSString *assessmenttaskpartid = [[aryTmps objectAtIndex:0] valueForKey:@"assessmenttaskpartid"];
        NSString *ResourceID = [[aryTmps objectAtIndex:0] valueForKey:@"ResourceID"];
        NSLog(@"%@",[[aryTmps objectAtIndex:1] valueForKey:@"outcome"]);
        NSString *comment = [[aryTmps objectAtIndex:1] valueForKey:@"outcome"];
       
        NSDictionary *dictResultCompetency = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Index",comment,@"comment",competencyachieved,@"competencyachieved",participantid,@"participantid",AssessorID,@"AssessorID",assessmenttaskpartid,@"assessmenttaskpartid",ResourceID,@"ResourceID", nil];
        
        NSLog(@"%@",dictResultCompetency);
        [aryJSONRequestResultsCompetency addObject:dictResultCompetency];
    }

    
    
    //Competency Mapping JSON Request Array Declration
    aryJSONRequestCompetency = [[NSMutableArray alloc]init];
    strDBQuery = [NSString stringWithFormat:
                  @"select * from tbl_CompetencyTaskAnswer where cast(ResourceID as int) = %@ and ParticipantID  = '%@'",
                  globle_resource_id,globle_participant_id];
    
    aryTmps =  [[NSArray alloc]initWithArray:[DatabaseAccess result_tblCompetencyTaskAnswerForPDFCreation:strDBQuery]];
    if([aryTmps count]>0)
    {
        for(int J=0; J<[aryTmps count];J++)
        {
            [aryJSONRequestCompetency addObject:[aryTmps objectAtIndex:J]];
        }
    }

    
    dictJSONRoot = [[NSMutableDictionary alloc]initWithObjectsAndKeys:aryJSONRequestAssessor,@"assessment",aryJSONRequestContextualisation,@"contextualisation",aryThirdPartyUserInfo,@"thirdparty",aryThirdPartyQuery,@"thirdpartyquery",aryJSONRequestSysValidation,@"validation",aryJSONRequestResults,@"resulttasktextanswers",aryJSONRequestResultsCompetency,@"resultcompetency",aryJSONRequestCompetency,@"competency",nil];
    aryJSONRoot = [[NSMutableArray alloc] initWithObjects:dictJSONRoot, nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:aryJSONRoot options:0 error:&error];
    NSString *finalString = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    NSLog(@"%@",finalString);
    NSString *urlString = @"http://assessments.tlisc.org.au/webservices/resultspdf/index.php?jsoncallback=?";
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIRequest = [ASIFormDataRequest requestWithURL:url];
    [ASIRequest setRequestMethod:@"POST"];
    [ASIRequest setDelegate:self];
    [ASIRequest addPostValue:finalString forKey:@"results"];
    [ASIRequest startAsynchronous];

    
    
    
    
    
    
    /*
    NSMutableArray *aryAns = [[NSMutableArray alloc]init];
    for(int x=0;x<[aryTmps count];x++)
    {
        AssessorID = [[aryTmps objectAtIndex:0] valueForKey:@"AssessorID"];
        NSString *s5;
        if([[[aryTmps valueForKey:@"answer"] objectAtIndex:x] length]>0)
            s5 = [NSString stringWithFormat:@"%@___%@",[[aryTmps valueForKey:@"questionID"] objectAtIndex:x],[[aryTmps valueForKey:@"answer"] objectAtIndex:x]];
        else
            s5 = [NSString stringWithFormat:@"%@___%@",[[aryTmps valueForKey:@"questionID"] objectAtIndex:x],[[aryTmps valueForKey:@"OptionSelected"] objectAtIndex:x]];

        
        [aryAns addObject:s5];
    }
    if([aryTmps count]>0)
    {
        [ary1_AssTaskID addObject:[[aryTmps objectAtIndex:0] valueForKey:@"assessmentTaskID"]];
        [ary2_TaskPartID addObject:[[aryTmps valueForKey:@"assessmentTaskPartID"] componentsJoinedByString:@","]];
        [ary3_QuestionID addObject:[[aryTmps valueForKey:@"questionID"] componentsJoinedByString:@","]];
        [ary4_AnswerID addObject:[aryAns componentsJoinedByString:@"__"]];
    }
    */
    
    
        
    
    
    
    /*  Use this code when request data
    NSString *strdata=[NSString stringWithFormat:@"ResourceID=%@&AssessmentTaskID=%@&TaskPartID=%@&QuestionID=%@&AnswerID=%@&ParticipantID='%@'&AssessorID=%@",globle_resource_id,[ary1_AssTaskID componentsJoinedByString:@"_____"] ,[ary2_TaskPartID componentsJoinedByString:@"_____"],[ary3_QuestionID componentsJoinedByString:@"_____"],[ary4_AnswerID componentsJoinedByString:@"_____"],globle_participant_id,AssessorID];
    NSLog(@"%@",strdata);

     
    NSString *urlString = @"http://assessments.tlisc.org.au/webservices/resultspdf/index.php?jsoncallback=?&results=?";
    NSString *postLength = [NSString stringWithFormat:@"%d", [strdata length]];
    NSMutableURLRequest *request123 = [[NSMutableURLRequest alloc] init];
    [request123 setURL:[NSURL URLWithString:urlString]];
    [request123 setHTTPMethod:@"POST"];
    [request123 setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request123 setHTTPBody:[strdata dataUsingEncoding:NSUTF8StringEncoding]];
     
    NSData *responseData1 = [NSURLConnection sendSynchronousRequest:request123 returningResponse:nil error:nil];
    NSString *responseString1 = [[NSString alloc] initWithData:responseData1 encoding: NSUTF8StringEncoding];
    NSLog(@"ResponseString:- %@",responseString1);
    
    
    pdfDataDownload = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:responseString1]];
    NSString *filePath = [[[NSUserDefaults standardUserDefaults] valueForKey:@"FILESPATH"] stringByAppendingPathComponent:@"myPDF.pdf"];
    NSLog(@"%@",filePath);
    [pdfDataDownload writeToFile:filePath atomically:YES];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.view addSubview:pdfView];
    [pdfWebView setUserInteractionEnabled:YES];
    [pdfWebView setDelegate:self];
    [pdfWebView loadRequest:requestObj];
    */
    
}
- (void)requestFinished:(ASIHTTPRequest *)responseJSON
{
    //NSLog(@"%s", __FUNCTION__);
    //NSString *responseString = [responseJSON responseString];
    NSLog(@"%@",[responseJSON responseString]);
    //NSDictionary *dic = [responseString objectFromJSONString];
 
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Failed --> %s: %@", __FUNCTION__, error);
}

-(IBAction)btnEmailPDFTapped:(id)sender
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller addAttachmentData:pdfDataDownload mimeType:@"application/pdf" fileName:@"myAttachment.pdf"];
    
    [self presentModalViewController:controller animated:YES];
}

-(IBAction)exitButtonTapped:(id)sender
{
    [pdfView removeFromSuperview];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	NSString *strMailResult;
    switch (result)
	{
		case MFMailComposeResultCancelled:
			strMailResult = @"Email Canceled";
			break;
		case MFMailComposeResultSaved:
			strMailResult = @"Email Saved";
			break;
		case MFMailComposeResultSent:
			strMailResult = @"Email Sent";
			break;
		case MFMailComposeResultFailed:
			strMailResult = @"Email Failed";
			break;
		default:
			strMailResult = @"Email Not Sent";
			break;
	}
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"T&L" message:strMailResult delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
	[self dismissModalViewControllerAnimated:YES];
}

-(void)customActionPressedResume:(id)sender
{
    taskEditMode = @"YES";
    
    //------------------ Calucuation Time Duration ----------
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
    StartTime = [NSDate date];
    NSString *dateString = [format stringFromDate:StartTime];
    StartTime = [format dateFromString:dateString];
    /* -----------------------------------------------------*/
    
    globle_assessment_task_id = [NSString stringWithFormat:@"%d",[sender tag]];

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
        noOfRecord = [DatabaseAccess getNoOfRecord:[NSString stringWithFormat:@"SELECT COUNT(AUTOID)FROM TBL_QUESTION_ANSWER WHERE USERID = %@ AND CAST(ASSESSMENT_TASK_ID AS INT)=%@",globle_participant_id,globle_assessment_task_id]];
        if(noOfRecord >0)
        {
            ParticipatnsContinue = @"YES";
        }
        else
        {
            ParticipatnsContinue = @"NO";
        }
        
        /* DELETED COMMENT
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
        /* ------------------ Code For Insert Record In tbl_ResumeTask --------------- */
        int rCount = [DatabaseAccess getNoOfRecord:[NSString stringWithFormat:@"select *from tbl_ResumeTask where cast(ResourceID as int) = %@ and ParticipantID  = '%@'",globle_resource_id,globle_participant_id]];
        if(rCount==0)
        {
            for(int y=0;y<[_getallTasks count];y++)
            {
                NSString *sqlStmt = [NSString stringWithFormat:@"insert into tbl_ResumeTask (ResourceID,AssessmentTaskID,ParticipantID,Status,SectorName) values('%@','%@','%@','InProgress','%@')",globle_resource_id,[[_getallTasks objectAtIndex:y] valueForKey:@"assessment_task_Id"],globle_participant_id,[[NSUserDefaults standardUserDefaults] valueForKey:@"NSSectorName"]];
                [DatabaseAccess INSERT_UPDATE_DELETE:sqlStmt];
            }
        }
        
        /* DELETED COMMENT
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



-(IBAction)btnTPResultsTapped:(id)sender
{
    /*
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"assname"])
    {

        ThirdPartyStep2ViewController *objThirdPartyStep2ViewController = [[ThirdPartyStep2ViewController alloc] initWithNibName:@"ThirdPartyStep2ViewController" bundle:nil];
        [self.navigationController pushViewController:objThirdPartyStep2ViewController animated:YES];
    }
    else
    {
        [self loginViewPushed:@"ThirdPartyStep2ViewController"];
    }
    */
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"ThirdPartyStep2ViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
}
-(IBAction)previewTPResultsTapped:(id)sender
{
    /*
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"assname"])
    {

        ThirdPartyStep2ViewController *objThirdPartyStep2ViewController = [[ThirdPartyStep2ViewController alloc] initWithNibName:@"ThirdPartyStep2ViewController" bundle:nil];
        [self.navigationController pushViewController:objThirdPartyStep2ViewController animated:YES];
    }
    else
    {
        [self loginViewPushed:@"ThirdPartyStep2ViewController"];
    }
    */
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"ThirdPartyStep2ViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
}

-(IBAction)btnContextualisationTapped:(id)sender
{
    /*
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"assname"])
    {

        ContexualizationViewController *objcontexualizationviewcontroller = [[ContexualizationViewController alloc]initWithNibName:@"ContexualizationViewController" bundle:nil];
        [self.navigationController pushViewController:objcontexualizationviewcontroller animated:YES];
    }
    else
    {
        [self loginViewPushed:@"ContexualizationViewController"];
    }
    */   
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"ContexualizationViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
    
}

-(IBAction)previewContextualisationTapped:(id)sender
{
    /*
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"assname"])
    {

        ContexualizationViewController *objcontexualizationviewcontroller = [[ContexualizationViewController alloc]initWithNibName:@"ContexualizationViewController" bundle:nil];
        [self.navigationController pushViewController:objcontexualizationviewcontroller animated:YES];
    }
    else
    {
        [self loginViewPushed:@"ContexualizationViewController"];
    }
    */    
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"ContexualizationViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
}

-(IBAction)btnCompetencyTapped:(id)sender
{
    /*
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"assname"])
    {

        CompetencyViewController *objCompetencyViewController = [[CompetencyViewController alloc]initWithNibName:@"CompetencyViewController" bundle:nil];
        [self.navigationController pushViewController:objCompetencyViewController animated:YES];
    }
    else
    {
        [self loginViewPushed:@"CompetencyViewController"];
    }
    */
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"CompetencyViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
}

-(IBAction)btnResultsTapped:(id)sender
{
    /*
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"assname"])
    {

        if([aryResultsOptionsAnswer count]>0)
        {
            
            Results_First_ViewController *objResults_First_ViewController = [[Results_First_ViewController alloc]initWithNibName:@"Results_First_ViewController" bundle:nil];
            aryResultOpn = [[NSMutableArray alloc]initWithArray:aryResults];
            [self.navigationController pushViewController:objResults_First_ViewController animated:YES];
        }
        else
        {
            Results_First_ViewController *objResults_First_ViewController = [[Results_First_ViewController alloc]initWithNibName:@"Results_First_ViewController" bundle:nil];
            aryResultOpn = [[NSMutableArray alloc]init];
            [self.navigationController pushViewController:objResults_First_ViewController animated:YES];
        }
    }
    else
    {
        [self loginViewPushed:@"Results_First_ViewController"];
    }
    */
    if([aryResultsOptionsAnswer count]>0)
    {
        aryResultOpn = [[NSMutableArray alloc]initWithArray:aryResults];
    }
    else
    {
        aryResultOpn = [[NSMutableArray alloc]init];
    }
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"Results_First_ViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
}


-(IBAction)btnValidationTapped:(id)sender
{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"]);
    
    /*
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"assname"])
    {
        SysValidationViewController *objSysValidationViewController = [[SysValidationViewController alloc]initWithNibName:@"SysValidationViewController" bundle:nil];
        strDescription = [[arySysValidation objectAtIndex:0] valueForKey:@"Description"];
        arySysValidationAnswer = [[NSMutableArray alloc]initWithArray:arySysValidationOptionAnswer];
        [self.navigationController pushViewController:objSysValidationViewController animated:YES];
    }
    else
    {
        [self loginViewPushed:@"SysValidationViewController"];
    }
    */
    strDescription = [[arySysValidation objectAtIndex:0] valueForKey:@"Description"];
    arySysValidationAnswer = [[NSMutableArray alloc]initWithArray:arySysValidationOptionAnswer];
    
    //[self loginViewPushed:@"SysValidationViewController"];
    
    objAssessorTypeViewController = [[AssessorTypeViewController alloc]initWithNibName:@"AssessorTypeViewController" bundle:nil];
    objAssessorTypeViewController.strNextPushController = @"SysValidationViewController";
    [self.navigationController pushViewController:objAssessorTypeViewController animated:YES];
}


-(IBAction)participantDetailTapped:(id)sender
{
    [objEditParticipantInfoViewController viewWillAppear:YES];
    [self.view bringSubviewToFront:objEditParticipantInfoViewController.view];
    [objEditParticipantInfoViewController.view setFrame:CGRectMake(768, 0,768 ,1004)];    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.50];
    [objEditParticipantInfoViewController.view setFrame:CGRectMake(0, 0,768 ,1004)];
    [UIView commitAnimations];
}

-(IBAction)dismissParticipantDetail:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.50];
    [objEditParticipantInfoViewController.view setFrame:CGRectMake(-768, 0,768 ,1004)];
    [UIView commitAnimations];
    
}

#pragma mark - Tababr Method Top

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
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_14" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)loginViewPushed:(NSString*)str
{
    NewAssessorViewController *objNewAssessorViewController = [[NewAssessorViewController alloc]initWithNibName:@"NewAssessorViewController" bundle:nil];
    objNewAssessorViewController.strPushViewController = str;
    [self.navigationController pushViewController:objNewAssessorViewController animated:YES];
}

- (IBAction)btnSendMeTapped:(id)sender {
    [UIView animateWithDuration:0.5 animations:^(void) {
        [viewInfo setFrame:CGRectMake(0, 433, 768, 67)];
        [viewSendEmail setFrame:CGRectMake(0, 350, 768, 60)];
        [_tableView setFrame:CGRectMake(0, 500, 768, 504)];
    }];
}


#pragma mark - Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
