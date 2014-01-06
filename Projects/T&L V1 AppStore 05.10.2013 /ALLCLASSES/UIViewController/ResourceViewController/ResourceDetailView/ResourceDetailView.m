//
//  ResourceDetailView.m
//  T&L
//
//  Created by openxcell tech.. on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResourceDetailView.h"
#import "NewParticipentController.h"
#import "GlobleClass.h"
#import "GTMNSString+HTML.h"
#import "CacheManager.h"
#import "TblCell.h"
#import "SBJSON.h"
#import "AlertManger.h"


@implementation ResourceDetailView

@synthesize HTMLStr;
@synthesize _webView;
@synthesize embedHTML;
@synthesize headerLableStr;
@synthesize resourceImageStr;
@synthesize _cMgr;
@synthesize IsEmptyBOOL;
@synthesize _resourceID;
@synthesize request;
@synthesize statusesDict;
@synthesize _taskId,_taskPartId,_AssTaskIDNew,unitinfo;
@synthesize _download_dictStrValue,dicAssessementTask,rID_R,downloadStatusImg;
SEL selector;
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

-(IBAction)removeView:(id)sender
{
    [self.view removeFromSuperview];
    
    NSNotification *notif = [NSNotification notificationWithName:@"RELOADTABLEVIEW" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];    
}



//** ON CLICK DOWNLOAD RESOURCE BUTTON FIRST TIME IT WILL START PARSING AND CHANGE BUTTON'S IMAGE **//
-(IBAction)toogle:(id)sender
{
    
    //** CONDITION CHECK FOR IN WHAT STATE BUTTON IS **//
    
    if (downloadStartBtn.imageView.image==[UIImage imageNamed:@"StartResourcedown.png"])
    {
        //** AFTER PERFORM PARSING OPERATION AND AFTER PUTTING ALL DATA IN DATABASE **//
        [self.view removeFromSuperview];
        globle_resource_id=_resourceID;
        NSNotification *notif = [NSNotification notificationWithName:@"navigate" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
        
    }
    else
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        [HUD setLabelText:@"Please wait !!"];
        HUD.delegate = self;
        [HUD showWhileExecuting:@selector(parsingStartsandSaveInDatabase) onTarget:self withObject:nil animated:YES];
        showAlert = @"YES";
        NSLog(@"Hide Call");
    }
    
}

-(void)downloadInProgress
{
    //[self performSelector:@selector(parsingStartsandSaveInDatabase)];
    [self performSelectorOnMainThread:@selector(parsingStartsandSaveInDatabase) withObject:nil waitUntilDone:YES];
    NSLog(@"This line Called");
}

- (void)showWithLabel
{	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	HUD.dimBackground = YES;
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	[HUD show:TRUE];
    
    [self.view addSubview:HUD];
}

-(void)busyThread
{
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Show Call");
    [appDel showWithGradient:@"Wait !" views:self.view];
}



#pragma mark PARSING IN SECONDRY THREAD 
//** PARSING STARTS HERE WITH GIVEN RESOURCE ID AND ALL DATA WILL BE PUT INTO DATABASE AS A SINGLE RESOURCE**//

-(void)parsingStartsandSaveInDatabase
{
    dicAssessementTask=[[NSMutableDictionary alloc] init];
    
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSString *str =[NSString stringWithFormat:@"http://assessments.tlisc.org.au/webservices/assessmenttasks/getbyresource.php?jsoncallback=?&token=1726204214321678|xTAieBBJoDaWmBsG1stxfq4zLO4&resourceid=%@",_resourceID];
    NSLog(@"URL STRING ::-->%@",str);
    
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    dicAssessementTask = [parser objectWithString:json_string error:nil];
    
    if([dicAssessementTask count]>0)
    {
        [downloadStartBtn setImage:[UIImage imageNamed:@"StartResourcedown.png"] forState:UIControlStateNormal];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        strDataAvailable = @"YES";
        
        [self performSelector:@selector(saveAssessmentaTaskInDatabase)];
        [self performSelector:@selector(downloadTaskPart_taskId)];
        [self performSelector:@selector(getallQuestionsAccToTaskPart)];
        
        [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"Update tbl_Resources set DownloadStatus = '0' where ResourceID = '%@'",_resourceID]];
        rID_Resource = rID_R;
        
    }
    else
    {
        
        if([showAlert isEqualToString:@"YES"])
        {
            [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:YES];
            //[[AlertManger defaultAgent] showAlertWithTitle:APP_NAME message:@"No data found!!!" cancelButtonTitle:@"OK"];
            //UIAlertView *alertNoData = [[UIAlertView alloc]initWithTitle:@"T&L" message:@"No Data found !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //[alertNoData show];
        }
        else
        {
            strDataAvailable = @"NO";
        }
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
        
    }
}

-(void)showAlert
{
    UIAlertView *alertNoData = [[UIAlertView alloc]initWithTitle:@"T&L" message:@"No Data found !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertNoData show];
}


-(void)saveAssessmentaTaskInDatabase
{
    if (_taskId!=nil) {
        [_taskId removeAllObjects];
        _taskId=nil;
    }
    _taskId=[[NSMutableArray alloc] init];
    

    int i=0;
    
    while(i<[dicAssessementTask count])
    {
        NSString *strCheckRecord = [NSString stringWithFormat:@"select *from tbl_assessment_task where assessment_task_id = %@",[[dicAssessementTask valueForKey:@"AssessmentTaskID"] objectAtIndex:i]];
        
        if (![DatabaseAccess isrecordExistin_tbl_resources:strCheckRecord])
        {
            [_taskId addObject:[[dicAssessementTask valueForKey:@"AssessmentTaskID"] objectAtIndex:i]];
            NSString *strInsertQuery=[NSString stringWithFormat:@"insert into tbl_assessment_task (assessment_task_Id,outline,purpose,title,description,name,task_info_assessor,type,result_text,resource_Id) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[[dicAssessementTask valueForKey:@"AssessmentTaskID"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"Outline"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"Purpose"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"Title"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"Description"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"Name"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"TaskInformation_Assessor"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"Type"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"Results_Text"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"ResourceID"] objectAtIndex:i]];
            [DatabaseAccess INSERT_UPDATE_DELETE:strInsertQuery];
        }
        else
        {
            NSLog(@"Pahle se hai");
        }
        i++;
    }
}

-(void)downloadTaskPart_taskId
{
    int i=0;
    
    NSLog(@"Task Id::-->%@",_taskId);
    _taskPartId = [[NSMutableArray alloc]init];
    _AssTaskIDNew = [[NSMutableArray alloc]init];
    while (i<[_taskId count])
    {
        dicAssessementTask=[[NSMutableDictionary alloc] init];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        SBJSON *parser = [[SBJSON alloc] init];
        NSString *str =[NSString stringWithFormat:@"http://assessments.tlisc.org.au/webservices/taskparts/getbytask.php?jsoncallback=?&token=1726204214321678|xTAieBBJoDaWmBsG1stxfq4zLO4&assessmenttaskid=%@",[_taskId objectAtIndex:i]];
        NSLog(@"URL STRING ::-->%@",str);
        
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        dicAssessementTask = [parser objectWithString:json_string error:nil];
        
        if([dicAssessementTask count]>0)
        {    
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [self saveAssessment_Task_Part];
        }
        else
        {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            NSLog(@"No Data Are available");            
        }
        i++;
    }
}
-(void)saveAssessment_Task_Part{
    
    int i=0;
    
    
    while (i<[dicAssessementTask count])
    {
        NSLog(@"databaseBean.assessment_task_part_id::-->%@",[[dicAssessementTask valueForKey:@"AssessmentTaskPartID"] objectAtIndex:i]);
        
        NSString *strCheckRecord = [NSString stringWithFormat:@"SELECT * FROM tbl_assessment_task_part WHERE assessment_task_part_id = %@ ",[[dicAssessementTask valueForKey:@"AssessmentTaskPartID"] objectAtIndex:i]];
        if (![DatabaseAccess isrecordExistin_tbl_resources:strCheckRecord])
        {
            [_taskPartId addObject:[[dicAssessementTask valueForKey:@"AssessmentTaskPartID"] objectAtIndex:i]];
            [_AssTaskIDNew addObject:[[dicAssessementTask valueForKey:@"AssessmentTaskID"] objectAtIndex:i]];
            
            NSString *strInsertQuery=[NSString stringWithFormat:@"insert into tbl_assessment_task_part (assessment_task_part_id,title,description,name,assessment_task_id) values('%@','%@','%@','%@','%@')",[[dicAssessementTask valueForKey:@"AssessmentTaskPartID"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"Title"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"Description"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"Name"] objectAtIndex:i],[[dicAssessementTask valueForKey:@"AssessmentTaskID"] objectAtIndex:i]];
            
            [DatabaseAccess INSERT_UPDATE_DELETE:strInsertQuery];
        }
        i++;
    }
}

-(void)getallQuestionsAccToTaskPart
{
    int i=0;
    NSLog(@"%@",_taskPartId);
    while (i<[_taskPartId count])
    {
        assTaskID = [_AssTaskIDNew objectAtIndex:i];
        aryAllQuestion = [[NSMutableDictionary alloc] init];
        SBJSON *parser = [[SBJSON alloc] init];
        NSString *str =[NSString stringWithFormat:@"http://assessments.tlisc.org.au/webservices/questions/getbytaskpart.php?jsoncallback=?&token=1726204214321678|xTAieBBJoDaWmBsG1stxfq4zLO4&taskpartid=%@&assessor=yes",[_taskPartId objectAtIndex:i]];
        NSLog(@"URL STRING ::-->%@",str);
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        aryAllQuestion = [parser objectWithString:json_string error:nil];
        NSLog(@"%@",aryAllQuestion);
        if([aryAllQuestion count]>0)
        {
            [self performSelector:@selector(saveQuestionsInDatabase)];
        }
        i++;
    }
}



-(void)saveQuestionsInDatabase
{
    int i=0;

    NSLog(@"%@",aryAllQuestion);
    while (i<[aryAllQuestion count])
    {
        assTaskPartID = [[aryAllQuestion valueForKey:@"AssessmentTaskPartID"] objectAtIndex:i];
        
        NSString *strCheckRecord = [NSString stringWithFormat:@"SELECT * FROM tbl_question WHERE question_Id = %@",[[aryAllQuestion valueForKey:@"QuestionsID"] objectAtIndex:i]];
        
        if (![DatabaseAccess isrecordExistin_tbl_resources:strCheckRecord])
        {
            NSString *strInsertRecord = [NSString stringWithFormat:@"insert into tbl_question (question_Id,title,description,name,'order',assessment_task_part_id,assessment_task_id,KeyPoint,questiontype,activitydescription,checklist) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[[aryAllQuestion valueForKey:@"QuestionsID"] objectAtIndex:i],[[aryAllQuestion valueForKey:@"Title"] objectAtIndex:i],[[aryAllQuestion valueForKey:@"Description"] objectAtIndex:i],[[aryAllQuestion valueForKey:@"Name"] objectAtIndex:i],[[aryAllQuestion valueForKey:@"Order"] objectAtIndex:i],[[aryAllQuestion valueForKey:@"AssessmentTaskPartID"] objectAtIndex:i],assTaskID,[[aryAllQuestion valueForKey:@"Keypoints"] objectAtIndex:i],[[aryAllQuestion valueForKey:@"questiontype"] objectAtIndex:i],[[aryAllQuestion valueForKey:@"activitydescription"] objectAtIndex:i],[[aryAllQuestion valueForKey:@"checklist"] objectAtIndex:i]];
            
            [DatabaseAccess INSERT_UPDATE_DELETE:strInsertRecord];
          
            _aryQuestionOption = [[NSMutableArray alloc]initWithArray:[[aryAllQuestion valueForKey:@"options"] objectAtIndex:i]];
            NSLog(@"%@",_aryQuestionOption);
            if([_aryQuestionOption count]>0)
            {
                [self saveOptionInDatabase];
            }
        }
        i++;
    }
}

-(void)saveOptionInDatabase
{
    int i=0;

    NSLog(@"%@",_aryQuestionOption);
    while (i<[_aryQuestionOption count])
    {
        NSArray *arrSlash = [[[_aryQuestionOption valueForKey:@"src"] objectAtIndex:i] componentsSeparatedByString:@"/"];

        
        [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"insert into tbl_question_option (QuestionOptionID,question_Id,tab,src,name,Column_id,Column_value,Column_class,attr1,attr2,attr3,attr4,attr5,type,assessment_task_part_id,assessment_task_id) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[[_aryQuestionOption valueForKey:@"QuestionOptionID"] objectAtIndex:i],[[_aryQuestionOption valueForKey:@"QuestionsID"] objectAtIndex:i],[[_aryQuestionOption valueForKey:@"tab"] objectAtIndex:i],[arrSlash lastObject],[[_aryQuestionOption valueForKey:@"name"] objectAtIndex:i],[[_aryQuestionOption valueForKey:@"id"] objectAtIndex:i],[[_aryQuestionOption valueForKey:@"value"] objectAtIndex:i],[[_aryQuestionOption valueForKey:@"class"] objectAtIndex:i],[[_aryQuestionOption valueForKey:@"attr1"] objectAtIndex:i],[[_aryQuestionOption valueForKey:@"attr2"] objectAtIndex:i],[[_aryQuestionOption valueForKey:@"attr3"] objectAtIndex:i],[[_aryQuestionOption valueForKey:@"attr4"] objectAtIndex:i],[[_aryQuestionOption valueForKey:@"attr5"] objectAtIndex:i],[[_aryQuestionOption valueForKey:@"type"] objectAtIndex:i],assTaskPartID,assTaskID]];
        
        //--------------------   File Write Start   ------------------
        if([[[_aryQuestionOption valueForKey:@"type"] objectAtIndex:i] isEqualToString:@"file"])
        {
            NSString *filenamepath = [NSString stringWithFormat:@"%@/%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"FILESPATH"],[arrSlash lastObject]];
            NSLog(@"%@",filenamepath);
            NSFileManager *fm=[NSFileManager defaultManager];
            
            if(![fm fileExistsAtPath:filenamepath])
            {
                //dispatch_async(kBgQueue, ^{
                NSURL *url = [NSURL URLWithString:[[_aryQuestionOption valueForKey:@"src"] objectAtIndex:i]];
                NSLog(@"%@",url);
                NSLog(@"%@",filenamepath);
                NSData *VImageOriginal = [NSData dataWithContentsOfURL:url];
                [VImageOriginal writeToFile:filenamepath atomically:NO];
                //});
            }
        }
        i++;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    showAlertNoDataFound = NO;
    
    // Do any additional setup after loading the view from its nib.
    
    if ([downloadStatusImg isEqualToString:@"0"]) 
    {
        [downloadStartBtn setImage:[UIImage imageNamed:@"StartResourcedown.png"] forState:UIControlStateNormal];
    }
    else if([downloadStatusImg isEqualToString:@"1"])
    {
        [downloadStartBtn setImage:[UIImage imageNamed:@"Downloaddown.png"] forState:UIControlStateNormal];
        
    }
    
    
    [lblunitinfo setText:unitinfo];
    
    _cMgr=[CacheManager sharedCacheManager];
    
    /*
    if ([_cMgr._dictImages  valueForKey:resourceImageStr]) {
    
        [resourceImageView setImage:[UIImage imageWithData:[_cMgr._dictImages  valueForKey:resourceImageStr]]];
    
    }else {
        TblCell *imgView = [[TblCell alloc] initWithFrame:CGRectMake(428, 291, 177, 255 ) withImageUrl:resourceImageStr withFlag:2 isDownload:YES];
        [self.view addSubview:imgView];
    }
    */
    
 
    [resourceImageView setImage:[UIImage imageNamed:resourceImageStr]];
    
    headerLable.text=headerLableStr;
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(407 ,670 ,358, 330)];
    _webView.backgroundColor=[UIColor clearColor];
    [_webView setOpaque:NO];
    _webView.delegate=self;
    
    
    IsEmptyBOOL=IsEmpty(HTMLStr);
    
    if (IsEmptyBOOL) {
        
        NSLog(@"Nop String");
    }else{
        NSLog(@"HTML %@",HTMLStr);
    HTMLStr=[HTMLStr gtm_stringByUnescapingFromHTML];
    }
    
    embedHTML = [NSString stringWithFormat:@"<html><body><font color=#FFFFFF>%@</font></body></html>",HTMLStr];
    [_webView loadHTMLString:embedHTML baseURL:nil];
    [self.view addSubview:_webView];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark NULL Check For Any Object

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

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

@end
