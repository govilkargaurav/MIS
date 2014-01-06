//
//  ViewController.m
//  T&L
//
//  Created by openxcell tech.. on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "GlobleClass.h"
#import "Reachability.h"
#import "SBJSON.h"
#import "JSON.h"
#import "AlertManger.h"
#import "HelpViewController.h"
#import "LearningViewController.h"
#import "NParticipantViewController.h"

@implementation ViewController
@synthesize request;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//-(IBAction)btns:(id)sender
//{
//    NSMutableArray *ary = [[NSMutableArray alloc]initWithObjects:@"kashyap",@"ankit",@"chirag", nil];
//    NSLog(@"%@",[ary componentsJoinedByString:@","]);
//    
//    NSString *strdata=[NSString stringWithFormat:@"ResourceID=1&AssessmentTaskID=2&TaskPartID=3&QuestionID=4&AnswerID=5"];
//    NSString *urlString = @"http://charleselenaweb.com/kash/getresult.php?";
//    NSString *postLength = [NSString stringWithFormat:@"%d", [strdata length]];
//    NSMutableURLRequest *request123 = [[NSMutableURLRequest alloc] init];
//    
//    [request123 setURL:[NSURL URLWithString:urlString]];
//    [request123 setHTTPMethod:@"POST"];
//    [request123 setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request123 setHTTPBody:[strdata dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSData *responseData1 = [NSURLConnection sendSynchronousRequest:request123 returningResponse:nil error:nil];
//    NSString *responseString1 = [[NSString alloc] initWithData:responseData1 encoding: NSUTF8StringEncoding];
//    NSLog(@"%@",responseString1);
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [lblAssessmentResources setFont:[UIFont fontWithName:@"Play-Bold" size:35.0]];
    [self.navigationController setNavigationBarHidden:YES];

    //---------kp ----db records-----
    
    Reachability *reachableForWiFy=[Reachability reachabilityForLocalWiFi];
    
    NetworkStatus netStatusWify = [reachableForWiFy currentReachabilityStatus];
    
    if (netStatusWify==ReachableViaWiFi || netStatusWify==ReachableViaWWAN) 
    {
        SBJSON *parser = [[SBJSON alloc] init];
        
            
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://assessments.tlisc.org.au/webservices/resources/getall.php?jsoncallback=?&token=%@",GLOBLE_TOCKEN] stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        if (statuses!=nil) {
            statuses=nil;
            statuses=[NSMutableDictionary new];
        }
        if (dictResouctID!=nil) {
            dictResouctID=nil;
            dictResouctID=[NSMutableDictionary new];
        }
        
        statuses = [parser objectWithString:json_string error:nil];
        dictResouctID=[statuses copy];
        [statuses removeAllObjects];
        //----Assign this AllResource Dictionary To Global Dictionary So Use in Filter
        dictAllResources = [[NSMutableDictionary alloc]init];
        dictAllResources = [dictResouctID copy];;
        NSLog(@"%@",dictAllResources);
        
        for(int i=0;i<3;i++)//[dictResouctID count]
        {
           NSLog(@"%d",[dictResouctID count]);
           NSLog(@"%@",dictResouctID);
           NSString *str1 =[[dictResouctID valueForKey:@"ResourceID"] objectAtIndex:i];
           NSString *str2 =[[dictResouctID valueForKey:@"UnitCode"] objectAtIndex:i];
           NSString *str3 =[[dictResouctID valueForKey:@"UnitName"] objectAtIndex:i];
           NSString *str4 =[[dictResouctID valueForKey:@"Version"] objectAtIndex:i];
           NSString *str5 =[[dictResouctID valueForKey:@"Status"] objectAtIndex:i];
           NSString *str6 =[[dictResouctID valueForKey:@"Resourceinfo"] objectAtIndex:i];
           NSString *str7 =[[dictResouctID valueForKey:@"Published"] objectAtIndex:i];
           NSString *str8 =[[dictResouctID valueForKey:@"Published_date"] objectAtIndex:i];
           NSString *str9 =[[dictResouctID valueForKey:@"Progress"] objectAtIndex:i];
           NSString *str10 =[[dictResouctID valueForKey:@"SectorID"] objectAtIndex:i];
           NSString *str11 =[[dictResouctID valueForKey:@"SectorName"] objectAtIndex:i];
           NSString *str12 =[[dictResouctID valueForKey:@"SectorColor"] objectAtIndex:i];
           NSString *str13 =[[dictResouctID valueForKey:@"CoverImage"] objectAtIndex:i];
           NSString *str14 =[[dictResouctID valueForKey:@"ipadtext"] objectAtIndex:i];
           NSString *str15 =[[dictResouctID valueForKey:@"assessortextcount"] objectAtIndex:i];
           NSString *str16 =[[dictResouctID valueForKey:@"participant_introduction"] objectAtIndex:i];
           NSString *str17 =[[dictResouctID valueForKey:@"participanttextcount"] objectAtIndex:i];
           NSString *str18 =[[dictResouctID valueForKey:@"resourcetype"] objectAtIndex:i];

            NSLog(@"databaseBean.assessment_task_part_id::-->%@",str1);
            
            if (![DatabaseAccess isrecordExistin_tbl_resources:[NSString stringWithFormat:@"Select *from tbl_Resources where cast( ResourceID as int) = %@",[[dictResouctID valueForKey:@"ResourceID"] objectAtIndex:i]]])
            {
                [DatabaseAccess insert_tbl_Resources:str1 UnitCode:str2 UnitName:str3 Version:str4 Status:str5 Resourceinfo:str6 Published:str7 Published_date:str8 Progress:str9 SectorID:str10 SectorName:str11 SectorColor:str12 CoverImage:str13 assessor_introduction:str14 assessortextcount:str15 participant_introduction:str16 participanttextcount:str17 resourcetype:str18 DownloadStatus:@"1"];
                
                
                    //-------------code for insertion contextualisation --------------
                    dictContex = [[NSMutableDictionary alloc]init];

                    SBJSON *parser = [[SBJSON alloc] init];
                    
                    NSString *strURL = [NSString stringWithFormat:@"http://assessments.tlisc.org.au/webservices/contextualisation/getbyresource.php?token=%@&resourceid=%@",GLOBLE_TOCKEN,[[dictResouctID valueForKey:@"ResourceID"] objectAtIndex:i]];
                    request = [NSURLRequest requestWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                    
                    dictContex = [parser objectWithString:json_string error:nil];
                    NSLog(@"%@",dictContex);
                    if([dictContex count]>0)
                    {
                        NSLog(@"%@",[[dictContex valueForKey:@"ContextualisationID"] objectAtIndex:0]);
                        NSLog(@"%@",[[dictContex valueForKey:@"ResourceID"] objectAtIndex:0]);
                        NSMutableArray *ary = [[NSMutableArray alloc]init];
                        
                        [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"insert into tbl_Contextualisation (ContextualisationID,ResourceID,Description) values('%@','%@','%@')",[[dictContex valueForKey:@"ContextualisationID"] objectAtIndex:0],[[dictContex valueForKey:@"ResourceID"] objectAtIndex:0],[[dictContex valueForKey:@"Description"] objectAtIndex:0]]];
                        
                        contResourceID = [[dictResouctID valueForKey:@"ResourceID"] objectAtIndex:i];
                        ary = [[dictContex valueForKey:@"options"] objectAtIndex:0];
                        
                        NSLog(@"%@",ary);
                        [DatabaseAccess DBINSERT:ary];
                    }
                
                
                    //----- code for insertion - third party reports ---------
                    dictTPartyReports = [[NSMutableDictionary alloc]init];
                    parser = [[SBJSON alloc] init];
                    
                    strURL = [NSString stringWithFormat:@"http://assessments.tlisc.org.au/webservices/thirdpartyreports/getbyresource.php?token=%@&resourceid=%@",GLOBLE_TOCKEN,[[dictResouctID valueForKey:@"ResourceID"] objectAtIndex:i]];
                    request = [NSURLRequest requestWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                    response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                    
                    dictTPartyReports = [parser objectWithString:json_string error:nil];
                    NSLog(@"%@",dictTPartyReports);
                    if([dictTPartyReports count]>0)
                    {
                        NSString *reportID = [[dictTPartyReports valueForKey:@"ReportID"] objectAtIndex:0];
                        NSLog(@"%@", [[dictTPartyReports valueForKey:@"ReportID"] objectAtIndex:0]);
                        NSLog(@"%@",reportID);
                        NSString *resourceID = [[dictTPartyReports valueForKey:@"ResourceID"] objectAtIndex:0];
                        NSString *description = [[dictTPartyReports valueForKey:@"Description"] objectAtIndex:0];
                        [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"insert into tbl_ThirdPartyReports(ReportID,ResourceID,Description) values('%@','%@','%@')",reportID,resourceID,description]];
                    }
                
                
                    //----- code for insertion - System Validation ---------
                    dictSysValidation = [[NSMutableDictionary alloc]init];
                    parser = [[SBJSON alloc] init];
                    
                    strURL = [NSString stringWithFormat:@"http://assessments.tlisc.org.au/webservices/systematicvalidation/getbyresource.php?token=%@&resourceid=%@",GLOBLE_TOCKEN,[[dictResouctID valueForKey:@"ResourceID"] objectAtIndex:i]];
                    request = [NSURLRequest requestWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                    response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                    
                    dictSysValidation = [parser objectWithString:json_string error:nil];
                    NSLog(@"%@",dictSysValidation);
                    if([dictSysValidation count]>0)
                    {
                        NSString *validationID = [[dictSysValidation valueForKey:@"validationid"] objectAtIndex:0];
                        NSString *resourceID = [[dictSysValidation valueForKey:@"ResourceID"] objectAtIndex:0];
                        NSString *description = [[dictSysValidation valueForKey:@"Description"] objectAtIndex:0];
                        [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"insert into tbl_SysValidation(ValidationID,ResourceID,Description) values('%@','%@','%@')",validationID,resourceID,description]];
                        
                        NSMutableArray *aryTemp = [[NSMutableArray alloc]initWithArray:[[dictSysValidation valueForKey:@"options"] objectAtIndex:0]];
                        if([aryTemp count]>0)
                        {
                            for(int sv=0;sv<[aryTemp count];sv++)
                            {
                                NSString *ValidationID = [[aryTemp objectAtIndex:sv] valueForKey:@"validationid"];
                                NSString *ResourceID = [[dictSysValidation valueForKey:@"ResourceID"] objectAtIndex:0];
                                NSString *EntryID = [[aryTemp objectAtIndex:sv] valueForKey:@"entryid"];
                                NSString *TypeofValidation = [[aryTemp objectAtIndex:sv] valueForKey:@"typeofvalidation"];
                                NSString *ScheduleDate = [[aryTemp objectAtIndex:sv] valueForKey:@"scheduleddate"];
                                NSString *Process = [[aryTemp objectAtIndex:sv] valueForKey:@"process"];
                                NSString *Participants = [[aryTemp objectAtIndex:sv] valueForKey:@"participants"];
                                
                                [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"insert into tbl_SysValidationOptions(ValidationID,ResourceID,EntryID,TypeofValidation,ScheduleDate,Process,Participants) values('%@','%@','%@','%@','%@','%@','%@')",ValidationID,ResourceID,EntryID,TypeofValidation,ScheduleDate,Process,Participants]];
                            }
                        }
                    }
                    //------------------------------------------------------------------------------------------------
                
                    //----------------------------------   Results ---------------------------------------------------------------
                    dictResults = [[NSMutableDictionary alloc]init];
                    parser = [[SBJSON alloc] init];
                    
                    strURL = [NSString stringWithFormat:@"http://assessments.tlisc.org.au/webservices/results/getbyresource.php?token=%@&resourceid=%@",GLOBLE_TOCKEN,[[dictResouctID valueForKey:@"ResourceID"] objectAtIndex:i]];
                    request = [NSURLRequest requestWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                    response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                    
                    dictResults = [parser objectWithString:json_string error:nil];
                    NSLog(@"%@",dictResults);
                    if([dictResults count]>0)
                    {
                        NSString *resultid = [[dictResults valueForKey:@"resultid"] objectAtIndex:0];
                        NSString *ResourceID = [[dictResults valueForKey:@"ResourceID"] objectAtIndex:0];
                        NSString *Description = [[dictResults valueForKey:@"Description"] objectAtIndex:0];
                        [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"insert into tbl_Results(resultid,ResourceID,Description) values('%@','%@','%@')",resultid,ResourceID,Description]];
                        
                        NSMutableArray *aryTemp = [[NSMutableArray alloc]initWithArray:[[dictResults valueForKey:@"options"] objectAtIndex:0]];
                        if([aryTemp count]>0)
                        {
                            for(int sv=0;sv<[aryTemp count];sv++)
                            {
                                NSString *ResultsTaskTextID = [[aryTemp objectAtIndex:sv] valueForKey:@"ResultsTaskTextID"];
                                NSString *AssessmentTaskID = [[aryTemp objectAtIndex:sv] valueForKey:@"AssessmentTaskID"];
                                NSString *Description = [[aryTemp objectAtIndex:sv] valueForKey:@"text"];
                                
                                [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"insert into tbl_ResultsOptions(ResultTaskTextID,AssessmentTaskID,Description,ResourceID) values('%@','%@','%@','%@')",ResultsTaskTextID,AssessmentTaskID,Description,ResourceID]];
                            }
                        }
                    }
                    //------------------------------------------------------------------------------------------------
                
                
                    //----------------------------------   Results ---------------------------------------------------------------
                    dictResults = [[NSMutableDictionary alloc]init];
                    parser = [[SBJSON alloc] init];
                    
                    strURL = [NSString stringWithFormat:@"http://assessments.tlisc.org.au/webservices/competencymapping/getbyresource.php?token=%@&resourceid=%@",GLOBLE_TOCKEN,[[dictResouctID valueForKey:@"ResourceID"] objectAtIndex:i]];
                    request = [NSURLRequest requestWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                    response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                    
                    dictResults = [parser objectWithString:json_string error:nil];
                    NSLog(@"%@",dictResults);
                    if([dictResults count]>0)
                    {
                        NSString *CompetencyOutlineID = [[dictResults valueForKey:@"CompetencyOutlineID"] objectAtIndex:0];
                        NSString *Title = [[dictResults valueForKey:@"Title"] objectAtIndex:0];
                        NSString *Description = [[dictResults valueForKey:@"description"] objectAtIndex:0];
                        NSString *ResourceID = [[dictResults valueForKey:@"ResourceID"] objectAtIndex:0];
                       
                        //---------- One time Insert - tbl_Competency
                        [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"insert into tbl_Competency(CompetencyOutlineID,Title,Description,ResourceID) values('%@','%@','%@','%@')",CompetencyOutlineID,Title,Description,ResourceID]];
                        
                        NSMutableArray *aryTemp = [[NSMutableArray alloc]initWithArray:[[dictResults valueForKey:@"taskcriteria"] objectAtIndex:0]];
                        NSLog(@"%@",aryTemp);
                        if([aryTemp count]>0)
                        {
                            for(int sv=0;sv<[aryTemp count];sv++)
                            {
                                
                                //----------------------------------------  tbl_Competency Task  -------------------------------
                                [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"insert into tbl_CompetencyTask(CompetencyTaskID,CompetencyOutlineID,Parent_CompetencyTaskID,Title,Description) values('%@','%@','%@','%@','%@')",[[aryTemp objectAtIndex:sv] valueForKey:@"CompetencyTaskID"],[[aryTemp objectAtIndex:sv] valueForKey:@"CompetencyOutlineID"],[[aryTemp objectAtIndex:sv] valueForKey:@"Parent_CompetencyTaskID"],[[aryTemp objectAtIndex:sv] valueForKey:@"Title"],[[aryTemp objectAtIndex:sv] valueForKey:@"Description"]]];

                                tempArray1 = [[NSMutableArray alloc]initWithArray:[[aryTemp objectAtIndex:sv]valueForKey:@"questions"]];
                                
                                
                                for(int q=0;q<[tempArray1 count];q++)
                                {
                                    //----------------------------------------  tbl_CompetencyTaskQuestions -------------------------------
                                    [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"insert into tbl_CompetencyTaskQuestions(competencyquestionid,Description,parentquestionid,competencytaskid) values('%@','%@','%@','%@')",[[tempArray1 objectAtIndex:q] valueForKey:@"competencyquestionid"],[[tempArray1 objectAtIndex:q] valueForKey:@"description"],[[tempArray1 objectAtIndex:q] valueForKey:@"parentquestionid"],[[tempArray1 objectAtIndex:q] valueForKey:@"competencytaskid"]]];
                                }
                                
                            }
                        }
                    }
                    //--------------------------------------------------------------------------------------
            }
        }
        
        
        
    }
    
    appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if([appDel.strWhichTabBar isEqualToString:@"SecondTabBar"])
    {
        CustomTabbarViewController_1 *objCustomTabbarViewController_1=[[CustomTabbarViewController_1 alloc] initWithNibName:@"CustomTabbarViewController_1" bundle:nil];
        [self.navigationController pushViewController:objCustomTabbarViewController_1 animated:YES];
        objCustomTabbarViewController_1=nil;
    }
    else if([appDel.strWhichTabBar isEqualToString:@"FirstSecondTabBar"])
    {
        appDel.strWhichTabBar = @"FirstTabBar";
        CustomTabbarViewController_1 *objCustomTabbarViewController_1=[[CustomTabbarViewController_1 alloc] initWithNibName:@"CustomTabbarViewController_1" bundle:nil];
        [self.navigationController pushViewController:objCustomTabbarViewController_1 animated:YES];
        objCustomTabbarViewController_1=nil;
    }
    

	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    viewWillAppearStr=@"1";
    
    NSLog(@"%@",appDel.strWhichTabBar);
    if([appDel.strWhichTabBar isEqualToString:@"SecondTabBar"])
    {
        CustomTabbarViewController_1 *objCustomTabbarViewController_1=[[CustomTabbarViewController_1 alloc] initWithNibName:@"CustomTabbarViewController_1" bundle:nil];
        [self.navigationController pushViewController:objCustomTabbarViewController_1 animated:YES];
        objCustomTabbarViewController_1=nil;
    }
    else if([appDel.strWhichTabBar isEqualToString:@"FirstSecondTabBar"])
    {
        appDel.strWhichTabBar = @"FirstTabBar";
        CustomTabbarViewController_1 *objCustomTabbarViewController_1=[[CustomTabbarViewController_1 alloc] initWithNibName:@"CustomTabbarViewController_1" bundle:nil];
        [self.navigationController pushViewController:objCustomTabbarViewController_1 animated:YES];
        objCustomTabbarViewController_1=nil;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark SECTORVISE WEBSERVICE APPLY
-(IBAction)btnResourceTypePressed:(id)sender
{
    CustomTabbarViewController_1 *objCustomTabbarViewController_1=[[CustomTabbarViewController_1 alloc] initWithNibName:@"CustomTabbarViewController_1" bundle:nil];
    tabFocus = @"NONE";
    if([sender tag]==7)
    {
        globle_SectorName = @"SearchResult";
        NSMutableArray *ar =[[NSMutableArray alloc]initWithArray:[DatabaseAccess getall_tbl_Resources:[NSString stringWithFormat:@"select *from tbl_Resources where SectorName like '%%%@%%' or UnitName like '%%%@%%' or Version like '%%%@%%'",tfSearchText.text,tfSearchText.text,tfSearchText.text]]];
        NSLog(@"%@",ar);
        if([ar count]>0)
        {
            if(arAllResourcesGloble != nil)
            {
                arAllResourcesGloble = nil;
                [arAllResourcesGloble removeAllObjects];
            }
            arAllResourcesGloble = [[NSMutableArray alloc]initWithArray:ar];
            [self.navigationController pushViewController:objCustomTabbarViewController_1 animated:YES];
            objCustomTabbarViewController_1=nil; 
        }
        else 
        {
            [[AlertManger defaultAgent]showAlertForDelegateWithTitle:APP_NAME message:@"No Resources are available" cancelButtonTitle:@"OK" okButtonTitle:nil parentController:self];
        }
    }
    else
    {
        if([sender tag]==1)
        {
            strFilterType = @"'Logistics & Warehousing'";
            globle_SectorIcon = @"Logistics & Warehousing_Icon.png";
            globle_SectorName=@"logisticsNwarehousing";
        }
        else if([sender tag]==2)
        {
            strFilterType = @"'Road Transport'";
            globle_SectorIcon = @"Road Transport_Icon.png";
            globle_SectorName=@"RoadTransport";
        }
        else if([sender tag]==3)
        {
            strFilterType = @"'Rail'";
            globle_SectorIcon = @"Rail_Icon.png";
            globle_SectorName=@"Rail";
        }
        else if([sender tag]==4)
        {
            strFilterType = @"'Maritime'";
            globle_SectorIcon = @"Maritime_Icon.png";
            globle_SectorName=@"Maritime";
        }
        else if([sender tag]==5)
        {
            strFilterType = @"'Aviation'";
            globle_SectorIcon = @"Aviation_Icon.png";
            globle_SectorName=@"Aviation";
        }
        else if([sender tag]==6)
        {
            strFilterType = @"'Ports'";
            globle_SectorIcon = @"Ports_Icon.png";
            globle_SectorName=@"Ports";
        }
        [self.navigationController pushViewController:objCustomTabbarViewController_1 animated:YES];
        objCustomTabbarViewController_1=nil;
    }
}

-(IBAction)helpButtonTapped:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    
    if(![popoverController isPopoverVisible]){
		HelpViewController *objHelpViewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
		popoverController = [[UIPopoverController alloc] initWithContentViewController:objHelpViewController];
		
		[popoverController setPopoverContentSize:CGSizeMake(350.0f, 500.0f)];
        [popoverController presentPopoverFromRect:CGRectMake(25,870,60,39) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
	[UIView setAnimationDuration:2.75];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
    self.view.alpha = 1;
	
	[UIView commitAnimations];
}

-(IBAction)learningButtonTapped:(id)sender
{
    tabFocus = @"Learning";
    CustomTabbarViewController_1 *objCustomTabbarViewController_1=[[CustomTabbarViewController_1 alloc] initWithNibName:@"CustomTabbarViewController_1" bundle:nil];
    [self.navigationController pushViewController:objCustomTabbarViewController_1 animated:YES];
    objCustomTabbarViewController_1=nil;
}

-(IBAction)goToResourceView:(id)sender
{
    strFilterType = @"'Logistics & Warehousing','Road Transport','Rail','Maritime','Aviation','Ports'";
    tabFocus = @"NONE";
    globle_SectorName=@"allresources";    
    CustomTabbarViewController_1 *objCustomTabbarViewController_1=[[CustomTabbarViewController_1 alloc] initWithNibName:@"CustomTabbarViewController_1" bundle:nil];
    [self.navigationController pushViewController:objCustomTabbarViewController_1 animated:YES];
    objCustomTabbarViewController_1=nil;
    
}

-(IBAction)gotoAsscessmentView:(id)sender{
    
    tabFocus = @"Assessment";
    CustomTabbarViewController_1 *objCustomTabbarViewController_1=[[CustomTabbarViewController_1 alloc] initWithNibName:@"CustomTabbarViewController_1" bundle:nil];
    [self.navigationController pushViewController:objCustomTabbarViewController_1 animated:YES];
    objCustomTabbarViewController_1=nil;    
    
}

-(IBAction)gotoLearningView:(id)sender{
    
   
}

-(IBAction)NParticipantView:(id)sender
{
    tabFocus = @"NPart";
    CustomTabbarViewController_1 *objCustomTabbarViewController_1=[[CustomTabbarViewController_1 alloc] initWithNibName:@"CustomTabbarViewController_1" bundle:nil];
    [self.navigationController pushViewController:objCustomTabbarViewController_1 animated:YES];
    objCustomTabbarViewController_1=nil;
    
    //NParticipantViewController *objNParticipantViewController = [[NParticipantViewController alloc] initWithNibName:@"NParticipantViewController" bundle:nil];
    //[self.navigationController pushViewController:objNParticipantViewController animated:YES];
}




@end
