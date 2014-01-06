//
//  QuestionAssessorViewController.m
//  T&L
//
//  Created by openxcell tech.. on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionAssessorViewController.h"
#import "NavigationController.h"
#import "TabbarController.h"
#import "NSFileManager+DirectoryLocations.h"
#import "SignatureViewController.h"
#import "AlertManger.h"
#import "ViewController.h"
#import "GlobleClass.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH 768.0f
#define CELL_CONTENT_MARGIN 0.0f

@implementation QuestionAssessorViewController

CGFloat animatedDistance;

@synthesize _tableView,buttonArray,buttonArray2;
@synthesize finalArr,ArrData;
@synthesize _allQuestion;
@synthesize arySelectStatus,aryTextField,aryassessment_task_part_id,_arrNewOne,aryVidoes,aryForCBoxRButton;

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
    
    //------All Question Array & Section Array-----
    if (_allQuestion!=nil) {
        [_allQuestion removeAllObjects];
        _allQuestion=nil;
    }
    _allQuestion=[[NSMutableArray alloc] init];
    
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow:0.01]];
    
    // Do any additional setup after loading the view from its nib.
    
    lbl_1.text = globle_UnitName;
    [lbl_2 setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];

    
    [self.view setFrame:CGRectMake(0, 0, 768, 970)];
    VideoID = 0;
    
    self.finalArr = [NSArray arrayWithObjects:@"Question 1: What is T&L?",@"", @"Question 1: What is T&L?",@"", @"Question 1: What is T&L?",@"",nil];
    self.ArrData = [NSArray arrayWithObjects:@"Question 1: What is T&L Next Question?", @"Question 1: What is T&L Next Question?", @"Question 1: What is T&L Next Question?", nil];

    if (buttonArray!=nil) {
        buttonArray=nil;
        [buttonArray removeAllObjects];
    }
    buttonArray=[[NSMutableArray alloc] init];
    
    if (buttonArray2!=nil) {
        
        buttonArray2=nil;
        [buttonArray2 removeAllObjects];
        
    }
    buttonArray2=[[NSMutableArray alloc] init];
    
    
    if (_downloadStatusDict==nil) {
        
        _downloadStatusDict=[[NSMutableDictionary alloc] init];
    }
    
    if (_downloadStatusDict2==nil) {
        
        _downloadStatusDict2=[[NSMutableDictionary alloc] init];
    }
    
    selectedIndexes = [[NSMutableDictionary alloc] init];
    
    ArrExpand = [[NSArray alloc] initWithObjects:@"Key points may include:",@"- Lorem ipsum dolor sit amet, consectetur adipisicing elit,",@"- sed do eiusmod tempor incididunt ut labore et dolore",@"- Ut enim ad minim veniam, quis nostrud exercitation",@"- Duis aute irure dolor in reprehenderit in voluptate", nil];

    //[self createTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    question_font = [UIFont fontWithName:@"Helvetica" size:14];
    aryQueOpn = [[NSMutableArray alloc]init];
 
    
    
    //---Array Question With Number Of Option-----
    if(_arrNewOne!=nil)
    {
        [_arrNewOne removeAllObjects];
        _arrNewOne = nil;
    }
    _arrNewOne = [[NSMutableArray alloc]init];
           
    
    //---Number Of Section With Name----
    if(arySectionName!=nil)
    {
        [arySectionName removeAllObjects];
        arySectionName = nil;
    }
    
    NSString *sqlStatement =[NSString stringWithFormat:@"SELECT *from tbl_assessment_task_part where assessment_task_id = %@",globle_assessment_task_id];
    
    arySectionName = [[NSMutableArray alloc]initWithArray:[DatabaseAccess getallRecord_assessment_task_part_id:sqlStatement]];
    
    //--Question Title----
    if(aryQueTitle!=nil)
    {
        [aryQueTitle removeAllObjects];
        aryQueTitle = nil;
    }
    aryQueTitle = [[NSMutableArray alloc]init];
    
    //--TextField Value----
    if (aryTField != nil) 
    {
        [aryTField removeAllObjects];
        aryTField = nil;
    }
    aryTField = [[NSMutableArray alloc]init];
    
    //--Yes No Status-----
    if(aryYNResult != nil)
    {
        [aryYNResult removeAllObjects];
        aryYNResult = nil;
    }
    aryYNResult = [[NSMutableArray alloc]init];
    
    //----Question Count Use On ParticipantQueView------
    globle_QuestionCount = 0;
    
    
    //-------- aryCBoxRButton -----
    if(aryForCBoxRButton != nil)
    {
        [aryForCBoxRButton removeAllObjects];
        aryForCBoxRButton = nil;
    }
    aryForCBoxRButton = [[NSMutableArray alloc]init];
    aryKeyPointValues = [[NSMutableArray alloc]init];
    
    
    NSLog(@"%@",ParticipatnsContinue);
    //--------From Participant & Preview Then----
    
    if([ParticipatnsContinue isEqualToString:@"YES"])
    {
        [viewOnTop setFrame:CGRectMake(0, 0, 768, 55)];
        
        if(aryTFAnswer != nil)
        {
            [aryTFAnswer removeAllObjects];
            aryTFAnswer = nil;
        }
        aryTFAnswer = [[NSMutableArray alloc]init];

        if(aryAutoID != nil)
        {
            [aryAutoID removeAllObjects];
            aryAutoID = nil;
        }
        aryAutoID = [[NSMutableArray alloc]init];
        
        for(int q=0;q<[arySectionName count];q++) //Number Of Section
        {
            _allQuestion = [[NSMutableArray alloc]initWithArray:[DatabaseAccess getallQuestion:globle_assessment_task_id strAssessmentTaskPartId:[[arySectionName objectAtIndex:q]valueForKey:@"setassessment_tak_part_id"] UserID:globle_participant_id]]; // Section ID --> assessmentTaskPartID
            [aryQueTitle addObject:_allQuestion];
            
            globle_QuestionCount = globle_QuestionCount + [_allQuestion count];
            
            NSMutableArray *ary_1 = [[NSMutableArray alloc]init];
            NSMutableArray *ary_2 = [[NSMutableArray alloc]init];
            NSMutableArray *ary_3 = [[NSMutableArray alloc]init];
            NSMutableArray *ary_4 = [[NSMutableArray alloc]init];
            NSMutableArray *ary_5 = [[NSMutableArray alloc]init];
            NSMutableArray *arQue_CB = [[NSMutableArray alloc]init];
            NSMutableArray *ary_6 = [[NSMutableArray alloc]init];
            
            //----Question Count For Specific AssessmentTaskPartID---
            for(int w=0;w<[_allQuestion count];w++)
            {
                //-----Question Id With Option-----
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[DatabaseAccess getOptionUsingQuestionID:[[_allQuestion objectAtIndex:w] valueForKey:@"setQuestion_Id"] asstaskpartid:[[_allQuestion objectAtIndex:w] valueForKey:@"setAssessment_task_part_id"]]]; 
                
                [ary_6 insertObject:@"NO" atIndex:w];
                
                //----UserComment,Yes-No Status,Answer-----
                NSString *sqlStatement =[NSString stringWithFormat:@"select *from tbl_question_answer where UserID = '%@' AND CAST(question_id AS INT)=%@ AND CAST(assessment_task_id AS INT) = %@ AND CAST(assessment_task_part_id AS INT) = %@",globle_participant_id,[[_allQuestion objectAtIndex:w] valueForKey:@"setQuestion_Id"],[[arySectionName objectAtIndex:q]valueForKey:@"assessment_tak_id"],[[_allQuestion objectAtIndex:w] valueForKey:@"setAssessment_task_part_id"]];
                
                NSMutableArray *arrTF = [[NSMutableArray alloc]initWithArray:[DatabaseAccess getanswer_result_tblQuestionOption:sqlStatement]];
                
                
                [ary_1 addObject:arr];
                [ary_2 insertObject:[[arrTF objectAtIndex:0]valueForKey:@"result"] atIndex:w];
                [ary_3 insertObject:[[arrTF objectAtIndex:0]valueForKey:@"answer"] atIndex:w]; // this is participant comment
                NSLog(@"%@",[arrTF objectAtIndex:0]);
                if([[[arrTF objectAtIndex:0]valueForKey:@"assComment"] isEqualToString:@"(null)"]) // this is assessor comment
                    [ary_4 insertObject:@"" atIndex:w];
                else                   
                    [ary_4 insertObject:[[arrTF objectAtIndex:0]valueForKey:@"assComment"] atIndex:w];//assComment
                
                [ary_5 insertObject:[[arrTF objectAtIndex:0]valueForKey:@"AutoID"] atIndex:w];
                
                NSArray *arCB = [[NSArray alloc] init];
                arCB = [[[arrTF objectAtIndex:0]valueForKey:@"OptionSelected"] componentsSeparatedByString:@","];
                [arQue_CB addObject:arCB];
                
            }
            [_arrNewOne addObject:ary_1];  //--Main Array--
            [aryYNResult addObject:ary_2]; //--Yes-No--
            [aryTFAnswer addObject:ary_4]; //--New - comment for assessor --
            [aryTField addObject:ary_3];   //--new participant comment--
            [aryAutoID addObject:ary_5];  //--Option AutoID--
            [aryKeyPointValues addObject:ary_6]; //--KeyPoint ---
            [aryForCBoxRButton addObject:arQue_CB];
        }    
    }
    else if([ParticipatnsContinue isEqualToString:@"NO"])
    {
        
        
        for(int q=0;q<[arySectionName count];q++)
        {
            _allQuestion= [[NSMutableArray alloc]initWithArray:[DatabaseAccess getallQuestion:globle_assessment_task_id ASS_TASK_PART_ID:[[arySectionName objectAtIndex:q]valueForKey:@"setassessment_tak_part_id"]]];
            
            NSLog(@"%@",_allQuestion);
            if([_allQuestion count]>0)
                [aryQueTitle addObject:_allQuestion];  // Question Information With ID
            
            globle_QuestionCount = globle_QuestionCount + [_allQuestion count];
            
            NSMutableArray *ary_1 = [[NSMutableArray alloc]init];
            NSMutableArray *ary_2 = [[NSMutableArray alloc]init];
            NSMutableArray *ary_3 = [[NSMutableArray alloc]init];
            NSMutableArray *ary_4 = [[NSMutableArray alloc]init];
            NSMutableArray *arQue_cb_2 = [[NSMutableArray alloc]init];
            
            int w =0;
            for(w=0;w<[_allQuestion count];w++)
            {
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[DatabaseAccess getOptionUsingQuestionID:[[_allQuestion objectAtIndex:w] valueForKey:@"setQuestion_Id"] asstaskpartid:[[_allQuestion objectAtIndex:w] valueForKey:@"setAssessment_task_part_id"]]];
                NSLog(@"%@",arr);
                    [ary_1 addObject:arr];
                    [ary_2 insertObject:@"None" atIndex:w];
                    [ary_3 insertObject:@"" atIndex:w];
                    [ary_4 insertObject:@"NO" atIndex:w];
                
                    NSMutableArray *arOpn_cb_1 = [[NSMutableArray alloc]init];
                    if([arr count]==0)
                        [arOpn_cb_1 addObject:@"0"];
                    else 
                    {
                        for(int l=0;l<[arr count];l++)
                        {
                            [arOpn_cb_1 addObject:@"0"];
                        }
                    }

                    [arQue_cb_2 addObject:arOpn_cb_1];
                
                NSLog(@"%@",arQue_cb_2);
            }
            [aryYNResult addObject:ary_2];
            [aryTField addObject:ary_3];
            [_arrNewOne addObject:ary_1];
            [aryForCBoxRButton addObject:arQue_cb_2];
            [aryKeyPointValues addObject:ary_4];
        }        
    }
    NSLog(@"%@",aryForCBoxRButton);
    NSLog(@"%@",aryTField);
    
    NSLog(@"%@",aryForCBoxRButton);
    
    if(aryAllQueParticipant != nil)
    {
        [aryAllQueParticipant removeAllObjects];
        aryAllQueParticipant = nil;
    }
    aryAllQueParticipant = [[NSMutableArray alloc]initWithArray:aryQueTitle];
    NSLog(@"%@",aryAllOptionParticipant);
    if(aryAllOptionParticipant != nil)
    {
        [aryAllOptionParticipant removeAllObjects];
        aryAllOptionParticipant = nil;
    }
    aryAllOptionParticipant = [[NSMutableArray alloc]initWithArray:_arrNewOne];
    
    if(aryAllCBoxRButtonParticipant != nil)
    {
        [aryAllCBoxRButtonParticipant removeAllObjects];
        aryAllCBoxRButtonParticipant = nil;
    }
    aryAllCBoxRButtonParticipant = [[NSMutableArray alloc]initWithArray:aryForCBoxRButton];    
    
    if (_tableView!=nil) 
    {
        [_tableView removeFromSuperview];
        _tableView=nil;
    }
    if([ParticipatnsContinue isEqualToString:@"YES"])
    {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,54,768,895) style:UITableViewStylePlain];
    }
    else if([ParticipatnsContinue isEqualToString:@"NO"])
    {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,54,768,895) style:UITableViewStylePlain];
    }
    
    NSLog(@"%@",_allQuestion);
    //if ([_allQuestion count]>0)
    //{
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight=70;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView reloadData];
    //}
    //else
    //{
        //[[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"No data found!!!" cancelButtonTitle:@"OK"];
    //}
}



#pragma mark - *** JBSignatureControllerDelegate ***

/**
 * Example usage of signatureConfirmed:signatureController:
 * @author Jesse Bunch
 **/
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(ParticipantSignView *)sender {
	
	// get image and close signature controller
	
    //	// I replaced the view just to show it works...
    //	UIImageView *imageview = [[UIImageView alloc] initWithImage:signatureImage];
    //	[imageview setContentMode:UIViewContentModeCenter];
    //	[imageview sizeToFit];
    //	[imageview setTransform:sender.view.transform];
    //	sender.view = imageview;
	
	// Example saving the image in the app's application support directory
	NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
	[UIImagePNGRepresentation(signatureImage) writeToFile:[appSupportPath stringByAppendingPathComponent:@"signature.png"] atomically:YES];
	
	
}

/**
 * Example usage of signatureCancelled:
 * @author Jesse Bunch
 **/
-(void)signatureCancelled:(ParticipantSignView *)sender {
	
	// close signature controller
	
	// Clear the sig for now
	[sender clearSignature];
	
}


-(void)createTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,55,768,880) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark -
#pragma mark UITableView Delegaates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return [_arrNewOne count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSMutableArray *ar_1 = [[NSMutableArray alloc]initWithArray:[_arrNewOne objectAtIndex:section]];
    return [ar_1 count]*2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    NSLog(@"%@",[[arySectionName objectAtIndex:section] valueForKey:@"title"]);
    return [[arySectionName objectAtIndex:section] valueForKey:@"title"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row % 2 == 0)
    {
        if([ParticipatnsContinue isEqualToString:@"YES"])
        {
            NSString *strOptionName = @"";
            NSMutableArray *aryQT = [[NSMutableArray alloc]initWithArray:[aryQueTitle objectAtIndex:indexPath.section]];
            NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:[_arrNewOne objectAtIndex:indexPath.section]];
            NSMutableArray *arrTemp_1 = [[NSMutableArray alloc]initWithArray:[arrTemp objectAtIndex:indexPath.row / 2]];
            //--------
            NSMutableArray *ar_03 = [[NSMutableArray alloc]initWithArray:[aryTField objectAtIndex:indexPath.section]];
            //------
            NSMutableArray *arQue_CB = [[NSMutableArray alloc]initWithArray:[aryForCBoxRButton objectAtIndex:indexPath.section]];
            NSMutableArray *aryOpn_CB = [[NSMutableArray alloc]initWithArray:[arQue_CB objectAtIndex:indexPath.row / 2]];
            if ([arrTemp_1 count]>0)
            {
                for(int x=0;x<[arrTemp_1 count];x++)
                {
                    if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"file"])
                    {
                        //strOptionName = [NSString stringWithFormat:@"%@ %@,",strOptionName,@"Video"];
                    }
                    else if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"checkbox"])
                    {
                        strOptionName = [NSString stringWithFormat:@"%@ %d,",strOptionName,[[aryOpn_CB objectAtIndex:x]intValue]];
                    }
                    else if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"radio"])
                    {
                        strOptionName = [NSString stringWithFormat:@"%@ %d,",strOptionName,[[aryOpn_CB objectAtIndex:x]intValue]];
                    }
                    else if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"null"])
                    {
                        strOptionName = [NSString stringWithFormat:@"%@ %@,",strOptionName,[ar_03 objectAtIndex:indexPath.row / 2]];
                    }
                }
            }
            NSLog(@"%@",strOptionName);
            
            NSString* embedHTML;
            
            if([[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setquestiontype"] isEqualToString:@"activity"]){
                
                embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@<br/>%@</body></html>",[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setDescriptionQuestion"],[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setactivitydescription"]];
            }
            else{
           
                embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@</body></html>",[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setDescriptionQuestion"]];
            }
            
            size = [embedHTML sizeWithFont:question_font constrainedToSize:CGSizeMake(768, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            NSLog(@"%@",embedHTML);
            NSLog(@"%f",size.height);
            return size.height + 54;
        }
        else
        {
            NSMutableArray *aryQT = [[NSMutableArray alloc]initWithArray:[aryQueTitle objectAtIndex:indexPath.section]];
            
            NSString* embedHTML;
            
            if([[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setquestiontype"] isEqualToString:@"activity"]){
            
                embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@<br>%@\nNo data entered</body></html>",[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setDescriptionQuestion"],[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setactivitydescription"]];
            }
            else{
                
                embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@\nNo data entered</body></html>",[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setDescriptionQuestion"]];
            }
            NSLog(@"%@",embedHTML);
            size = [embedHTML sizeWithFont:question_font constrainedToSize:CGSizeMake(768, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            return size.height;
        }
    }
    else
    {
        NSLog(@"%@",[[aryKeyPointValues objectAtIndex:indexPath.section]objectAtIndex:((indexPath.row + 1)/2)-1]);
        if([[[aryKeyPointValues objectAtIndex:indexPath.section]objectAtIndex:((indexPath.row + 1)/2)-1] isEqualToString:@"YES"])
            return 226;
        else
            return 126;

    }
    
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell) 
    {
        cell=nil;
        [cell removeFromSuperview];
    }
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if (indexPath.row % 2 == 0)
    {
       
        
        NSLog(@"%d",indexPath.row / 2);
        NSMutableArray *aryQT = [[NSMutableArray alloc]initWithArray:[aryQueTitle objectAtIndex:indexPath.section]];
        
        
        if([ParticipatnsContinue isEqualToString:@"YES"])
        {
            UIImageView *ivBGImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queBG.png"]];
            [cell addSubview:ivBGImg];
            
            NSString *strOptionName = @"";
            //----- Code For Option -------
            NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:[_arrNewOne objectAtIndex:indexPath.section]];
            NSMutableArray *arrTemp_1 = [[NSMutableArray alloc]initWithArray:[arrTemp objectAtIndex:indexPath.row / 2]];
            
            NSLog(@"%@",arrTemp);
            NSLog(@"%@",arrTemp_1);
            //--------
            NSMutableArray *ar_03 = [[NSMutableArray alloc]initWithArray:[aryTField objectAtIndex:indexPath.section]];
            
            //------
            NSMutableArray *arQue_CB = [[NSMutableArray alloc]initWithArray:[aryForCBoxRButton objectAtIndex:indexPath.section]];
            NSMutableArray *aryOpn_CB = [[NSMutableArray alloc]initWithArray:[arQue_CB objectAtIndex:indexPath.row / 2]];
            if ([arrTemp_1 count]>0)
            {
                NSLog(@"%@",arrTemp);
                for(int x=0;x<[arrTemp_1 count];x++)
                {
                    if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"file"])
                    {
                        //strOptionName = [NSString stringWithFormat:@"%@ %@,",strOptionName,@"Video"];
                    }
                    else if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"checkbox"])
                    {
                        NSLog(@"%@",[[arrTemp_1 objectAtIndex:x]valueForKey:@"Column_Value"]);

                        if([[aryOpn_CB objectAtIndex:x]intValue]==1)
                            strOptionName = [NSString stringWithFormat:@"%@ %@,",strOptionName,[[arrTemp_1 objectAtIndex:x]valueForKey:@"Column_Value"]];
                    }
                    else if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"radio"])
                    {
                        NSLog(@"%@",[[arrTemp_1 objectAtIndex:x]valueForKey:@"Column_Value"]);
                        if([[aryOpn_CB objectAtIndex:x]intValue]==1)
                        strOptionName = [NSString stringWithFormat:@"%@ %@,",strOptionName,[[arrTemp_1 objectAtIndex:x]valueForKey:@"Column_Value"]];
                    }
                    else if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"null"])
                    {
                        strOptionName = [NSString stringWithFormat:@"%@ %@,",strOptionName,[ar_03 objectAtIndex:indexPath.row / 2]];
                    }
                }
            }
            
            NSString* embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@</body></html>",[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setDescriptionQuestion"]];
            size = [embedHTML sizeWithFont:question_font constrainedToSize:CGSizeMake(768, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            
            if([[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setquestiontype"] isEqualToString:@"activity"]){
                
                embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@<br>%@<br/><b>Answer:- %@</b></body></html>",[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setDescriptionQuestion"],[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setactivitydescription"],strOptionName];
            }
            else{
                
                embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@<br><b>Answer:- %@</b></body></html>",[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setDescriptionQuestion"],strOptionName];
            }
            
            NSLog(@"%@",embedHTML);
            NSLog(@"%f",size.height);
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, 768, size.height+54)];
            [webView setOpaque:NO];
            [webView setBackgroundColor:[UIColor clearColor]];
            webView.delegate = self;
            [webView loadHTMLString:embedHTML baseURL:nil]; 
            [cell addSubview:webView];
            [ivBGImg setFrame:CGRectMake(0, 0, 768, size.height + 54)];
        }
        else 
        {
            NSString* embedHTML;
            
            if([[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setquestiontype"] isEqualToString:@"activity"]){
                
                embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@<br/>%@\nNo data entered</body></html>",[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setDescriptionQuestion"],[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setquestiontype"]];
            }
            else{
                
                embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@\nNo data entered</body></html>",[[aryQT objectAtIndex:indexPath.row/2]valueForKey:@"setDescriptionQuestion"]];
            }
            size = [embedHTML sizeWithFont:question_font constrainedToSize:CGSizeMake(768, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, 768, size.height)];
            [webView setOpaque:NO];
            [webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"queBG.png"]]];
            webView.delegate = self;
            [webView loadHTMLString:embedHTML baseURL:nil];
            [cell addSubview:webView];
        }
    }
    else
    {
        NSMutableArray *aryForTFValue = [[NSMutableArray alloc]initWithArray:[aryTFAnswer objectAtIndex:indexPath.section]];
        
        UIImageView *iv_bG;
        if([[[aryKeyPointValues objectAtIndex:indexPath.section] objectAtIndex:((indexPath.row + 1)/2)-1] isEqualToString:@"YES"])
            iv_bG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 768, 226)];
        else
            iv_bG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 768, 126)];
        
        [iv_bG setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"COMMENTBG"]]];//
        [cell addSubview:iv_bG];
        
        /*
        UITextField *textField=[[UITextField alloc] initWithFrame:CGRectMake(34, 5 , 440, 111)];
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setBackgroundColor:[UIColor redColor]];
        textField.clearsOnBeginEditing = NO;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.delegate = self;
        textField.placeholder = @"Comments";
        */
        
        UITextView *tfComments = [[UITextView alloc] initWithFrame:CGRectMake(34, 5 , 440, 111)];
        tfComments.textAlignment = NSLineBreakByWordWrapping;
        tfComments.delegate = self;
        [tfComments setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:tfComments];
        
        
        if([ParticipatnsContinue isEqualToString:@"NO"])
        {
            [tfComments setUserInteractionEnabled:FALSE];
            [tfComments setEditable:FALSE];
        }
        else
        {
            [tfComments setUserInteractionEnabled:TRUE];
            [tfComments setEditable:TRUE];
            [tfComments setText:[aryForTFValue objectAtIndex:((indexPath.row + 1)/2)-1]];
        }
        [cell addSubview:tfComments];
        
        
        /*--------------------------- Tick & Cross ------------------------*/
        NSMutableArray *ar_01 = [[NSMutableArray alloc]initWithArray:[aryYNResult objectAtIndex:indexPath.section]];
        
        
        UIButton *btnNo = [UIButton buttonWithType:UIButtonTypeCustom];
        if([ParticipatnsContinue isEqualToString:@"YES"])
        {
            [btnNo addTarget:self action:@selector(btnNoPressed:) forControlEvents:UIControlEventTouchDown];
        }
        btnNo.frame = CGRectMake(629,0,76,50);
        if ([[ar_01 objectAtIndex:((indexPath.row + 1)/2)-1] isEqualToString:@"No"])
        {
            [btnNo setImage:[UIImage imageNamed:@"newcross"] forState:UIControlStateNormal];
        }
        btnNo.tag = ((indexPath.row + 1)/2)-1;
        [cell addSubview:btnNo];
        
        
        UIButton *btnYes = [UIButton buttonWithType:UIButtonTypeCustom];
        if([ParticipatnsContinue isEqualToString:@"YES"])
        {
            [btnYes addTarget:self action:@selector(btnYesPressed:) forControlEvents:UIControlEventTouchDown];
        }
        btnYes.frame = CGRectMake(701,0,71,50);
        if ([[ar_01 objectAtIndex:((indexPath.row + 1)/2)-1] isEqualToString:@"Yes"])
        {
            [btnYes setImage:[UIImage imageNamed:@"newtick"] forState:UIControlStateNormal];
        }
        btnYes.tag = ((indexPath.row + 1)/2)-1;
        [cell addSubview:btnYes];
        
        if([ParticipatnsContinue isEqualToString:@"YES"])
        {
            [btnNo addTarget:self action:@selector(btnNoPressed:) forControlEvents:UIControlEventTouchDown];
            [btnYes addTarget:self action:@selector(btnYesPressed:) forControlEvents:UIControlEventTouchDown];
        }
        
        
        /*---------------------- Keypoint Arrow -------------------------*/
        UIButton *btnKeypointArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnKeypointArrow setFrame:CGRectMake(492, 5, 123, 33)];
        [btnKeypointArrow setTag:((indexPath.row + 1)/2)-1];
        [btnKeypointArrow addTarget:self action:@selector(btnKeyPointTapped:) forControlEvents:UIControlEventTouchDown];
        if([[[aryKeyPointValues objectAtIndex:indexPath.section] objectAtIndex:((indexPath.row + 1)/2)-1] isEqualToString:@"YES"])
        {
            [btnKeypointArrow setImage:[UIImage imageNamed:@"keypointsdefault"] forState:UIControlStateNormal];
            [btnKeypointArrow setImage:[UIImage imageNamed:@"keypointsSelected"] forState:UIControlStateHighlighted];
            NSMutableArray *aryQT = [[NSMutableArray alloc]initWithArray:[aryQueTitle objectAtIndex:indexPath.section]];//_arrNewOne
            
            NSString* embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;font-weight:bold;color:#ffffff;font-size:16px;'>%@<br/>%@</body></html>",[[aryQT objectAtIndex:((indexPath.row + 1)/2)-1]valueForKey:@"setKeyPoint"],[[aryQT objectAtIndex:((indexPath.row + 1)/2)-1]valueForKey:@"setchecklist"]];
            size = [embedHTML sizeWithFont:question_font constrainedToSize:CGSizeMake(768, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,126, 768, 100)];
            [webView setOpaque:NO];//41 81 156
            [webView setBackgroundColor:[UIColor colorWithRed:41/255.f green:81/255.f blue:156/255.f alpha:1.0]];
            webView.delegate = self;
            [webView loadHTMLString:embedHTML baseURL:nil];
            [cell addSubview:webView];
        }
        else
            [btnKeypointArrow setImage:[UIImage imageNamed:@"keypointsdefault"] forState:UIControlStateNormal];
        [cell addSubview:btnKeypointArrow];
            
    

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/******************* Added Code********************/

//- (BOOL)cellIsSelected:(NSIndexPath *)indexPath {
//	// Return whether the cell at the specified index path is selected or not
//	NSNumber *selectedIndex = [selectedIndexes objectForKey:indexPath];
//	return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
//}


#pragma mark - Button Method
-(IBAction)btnNoPressed:(id)sender
{
    UITableViewCell* tempCell =  (UITableViewCell*)[sender superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    [[aryYNResult objectAtIndex:chatindex.section] replaceObjectAtIndex:((chatindex.row + 1)/2)-1 withObject:@"No"];
    [_tableView reloadData];
}
-(IBAction)btnYesPressed:(id)sender
{
    UITableViewCell* tempCell =  (UITableViewCell*)[sender superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    [[aryYNResult objectAtIndex:chatindex.section] replaceObjectAtIndex:((chatindex.row + 1)/2)-1 withObject:@"Yes"];
    [_tableView reloadData];
}

-(IBAction)btnKeyPointTapped:(id)sender
{
    UITableViewCell* tempCell =  (UITableViewCell*)[sender superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    if([[[aryKeyPointValues objectAtIndex:chatindex.section] objectAtIndex:((chatindex.row + 1)/2)-1] isEqualToString:@"NO"])
        [[aryKeyPointValues objectAtIndex:chatindex.section] replaceObjectAtIndex:((chatindex.row + 1)/2)-1 withObject:@"YES"];
    else
        [[aryKeyPointValues objectAtIndex:chatindex.section] replaceObjectAtIndex:((chatindex.row + 1)/2)-1 withObject:@"NO"];
    [_tableView reloadData];
}

-(IBAction)btn_1Pressed:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    NSLog(@"%@",[btn titleLabel].text);    
    NSString *filenamepath = [NSString stringWithFormat:@"%@/%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"FILESPATH"],[btn titleLabel].text];    
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    
    moviePlayer = [[CustomMoviePlayerViewController alloc] initWithPath:filenamepath];
    [moviePlayer readyPlayer];
    moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:moviePlayer animated:NO];
    //[self presentModalViewController:moviePlayer animated:YES];
    moviePlayer=nil;
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}



-(void)btnExpandPressed:(id)sender
{
    /*
    UITableViewCell* tempCell =  (UITableViewCell*)[sender superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    UIImage *image2=[UIImage imageNamed:@"ANSWERBg.png"];
    CGSize size2 =image2.size; 
    CGFloat height = MAX(size2.height, 44.0f);
    
    BOOL isSelected = ![self cellIsSelected:chatindex];
    
    if (isSelected)
    {
        UIView *lblView = [[UIView alloc] init];
        lblView.frame = CGRectMake(0, (size2.height+5), 768, (height*3)-5);
        lblView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ExpandedBG.png"]];
        lblView.tag=99;
        int j=1;
        for (int h=0; h<5; h++)
        {
            UILabel *lbl = [[UILabel alloc] init];
            lbl.frame = CGRectMake(32,(10*j), 300, 20);
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textColor = [UIColor whiteColor];
            lbl.text = [ArrExpand objectAtIndex:h];
            [lblView addSubview:lbl];
            j+=2;
        }
        [tempCell addSubview:lblView];
    }
    else
    {
        UIView *removeView = (UIView*)[tempCell viewWithTag:99]; 
        [removeView removeFromSuperview];
    }
    // Toggle 'selected' state
	
	// Store cell 'selected' state keyed on indexPath
	NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
	[selectedIndexes setObject:selectedIndex forKey:chatindex];	
    
	// This is where magic happens...
	[self._tableView beginUpdates];
	[self._tableView endUpdates];
     */
}
/**************************************************/

-(IBAction)btnNextQuestion:(UIButton *)sender
{
    if([ParticipatnsContinue isEqualToString:@"YES"])
    {
        /*
        if (dt!=nil) {
            dt=nil;
        }
        dt=[DAL getInstance];

        //_allQuestion
        
        for(int s=0;s<[arySectionName count];s++)
        {
            NSMutableArray *arYNResult_1 = [aryYNResult objectAtIndex:s];
            for(int p=0;p<[arYNResult_1 count];p++)
            {
                NSString *str = [NSString stringWithFormat:@"Update tbl_question_answer set result = '%@',AssessorComment = '%@' where AutoID = %@",[[aryYNResult objectAtIndex:s] objectAtIndex:p],[[aryTField objectAtIndex:s] objectAtIndex:p],[[aryAutoID objectAtIndex:s] objectAtIndex:p]];
                [self.dt InsertUpdateDelete:str];
            }
        }*/
    
        NSLog(@"%@",aryTField);
        NSLog(@"%@",aryQueTitle);
        NSLog(@"%@",aryYNResult);
        
        for(int d=0;d<[aryQueTitle count];d++)
        {
            
            NSMutableArray *ar_2 = [[NSMutableArray alloc]initWithArray:[aryQueTitle objectAtIndex:d]];
            NSMutableArray *ar_3 = [[NSMutableArray alloc]initWithArray:[aryTFAnswer objectAtIndex:d]]; // textField
            NSMutableArray *ar_4 = [[NSMutableArray alloc]initWithArray:[aryYNResult objectAtIndex:d]];  // result
            NSMutableArray *ar_5 = [[NSMutableArray alloc]initWithArray:[aryForCBoxRButton objectAtIndex:d]];
            
            for(int f=0;f<[ar_3 count];f++)
            {
                NSLog(@"question_Id:- %@",[[ar_2 objectAtIndex:f] valueForKey:@"setQuestion_Id"]);
                NSLog(@"assessment_task_part_id:- %@",[[ar_2 objectAtIndex:f] valueForKey:@"setAssessment_task_part_id"]);
                NSLog(@"answer:- %@",[ar_3 objectAtIndex:f]);
                NSLog(@"result:- %@",[ar_4 objectAtIndex:f]);
                
                NSMutableArray *ar_7 = [[NSMutableArray alloc]initWithArray:[ar_5 objectAtIndex:f]];
                NSString *strOptionSelected = [ar_7 componentsJoinedByString:@","];
                
                //[self.dt insertQuestionAnswer:[globle_participant_id intValue] assessment_task_id:globle_assessment_task_id question_Id:[[ar_2 objectAtIndex:f] valueForKey:@"setQuestion_Id"] orderID:@"" assessment_task_part_id:[[ar_2 objectAtIndex:f] valueForKey:@"setAssessment_task_part_id"] answer:[ar_3 objectAtIndex:f] result:[ar_4 objectAtIndex:f] OptionSelected:strOptionSelected];
                
                NSString *str = [NSString stringWithFormat:@"Update tbl_question_answer set result = '%@',AssessorComment = '%@',OptionSelected = '%@' where AutoID = %@",[ar_4 objectAtIndex:f],[ar_3 objectAtIndex:f],strOptionSelected,[[aryAutoID objectAtIndex:d] objectAtIndex:f]];
                [DatabaseAccess INSERT_UPDATE_DELETE:str];
            }
        }
    }    
    ParticipatnsContinue = @"NONE";
    ParticipantSignView *controller=[[ParticipantSignView alloc] initWithNibName:@"ParticipantSignView" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)customActionPressed:(id)sender
{
    //Get the superview from this button which will be our cell
	UITableViewCell *owningCell = (UITableViewCell*)[sender superview];
	//From the cell get its index path.
    NSIndexPath *pathToCell = [self._tableView indexPathForCell:owningCell];
	[_downloadStatusDict setValue:@"1" forKey:[NSString stringWithFormat:@"%d",pathToCell.row]];
    
    NSString *tempStr = [_downloadStatusDict2 valueForKey:[NSString stringWithFormat:@"%d",pathToCell.row]];
    if ([tempStr isEqualToString:@"1"]) 
    {
        [_downloadStatusDict setValue:@"0" forKey:[NSString stringWithFormat:@"%d",pathToCell.row]];
    }
    [self._tableView reloadData];
}

-(void)customActionPressed2:(id)sender{
    
    //Get the superview from this button which will be our cell
	UITableViewCell *owningCell = (UITableViewCell*)[sender superview];
	//From the cell get its index path.
    NSIndexPath *pathToCell = [self._tableView indexPathForCell:owningCell];
	[_downloadStatusDict2 setValue:@"1" forKey:[NSString stringWithFormat:@"%d",pathToCell.row]];
    [self._tableView reloadData];
    
    
}

-(IBAction)btnCheckBoxPressed:(id)sender
{
    UITableViewCell* tempCell =  (UITableViewCell*)[sender superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    
    NSLog(@"%d",((chatindex.row + 1)/2)-1);
    
    int value = [[[[aryForCBoxRButton objectAtIndex:chatindex.section] objectAtIndex:((chatindex.row + 1)/2)-1] objectAtIndex:[sender tag]] intValue];

    if(value==0)
        [[[aryForCBoxRButton objectAtIndex:chatindex.section] objectAtIndex:((chatindex.row + 1)/2)-1] replaceObjectAtIndex:[sender tag] withObject:@"1"];
    else
        [[[aryForCBoxRButton objectAtIndex:chatindex.section] objectAtIndex:((chatindex.row + 1)/2)-1] replaceObjectAtIndex:[sender tag] withObject:@"0"];
    
    [_tableView reloadData];
}
-(IBAction)btnRadioButtonPressed:(id)sender
{
    UITableViewCell* tempCell =  (UITableViewCell*)[sender superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    
    NSLog(@"%d",((chatindex.row + 1)/2)-1);
    
    NSMutableArray *aryTmp = [[NSMutableArray alloc]initWithArray:[[aryForCBoxRButton objectAtIndex:chatindex.section] objectAtIndex:((chatindex.row + 1)/2)-1]];

    for(int p=0;p<[aryTmp count];p++)
    {
        if(p==[sender tag])
             [[[aryForCBoxRButton objectAtIndex:chatindex.section] objectAtIndex:((chatindex.row + 1)/2)-1] replaceObjectAtIndex:[sender tag] withObject:@"1"];
        else 
            [[[aryForCBoxRButton objectAtIndex:chatindex.section] objectAtIndex:((chatindex.row + 1)/2)-1] replaceObjectAtIndex:p withObject:@"0"];
    }
    
    [_tableView reloadData];
}



-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    NSLog(@"%d",textView.tag); 
    
    UITableViewCell* tempCell =  (UITableViewCell*)[textView superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    
    //[aryTextField replaceObjectAtIndex:((chatindex.row + 1)/2)-1 withObject:textField_2.text];
        
    [textView setText:[[aryTFAnswer objectAtIndex:chatindex.section] objectAtIndex:((chatindex.row + 1)/2)-1]];
    
    //NSLog(@"textFieldDidBeginEditing %@",textField);
	// Below code is used for scroll up View with navigation baar
	
    CGRect textVWRect = [self.view.window convertRect:textView.bounds fromView:textView];
	CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	CGFloat midline = textVWRect.origin.y + 0.5 * textVWRect.size.height;
	CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	
	if (heightFraction < 0.0) {
		heightFraction = 0.0;
	}else if (heightFraction > 1.0) {
		heightFraction = 1.0;
	}
	
	animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y -= animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
	[self.view setFrame:viewFrame];
	
	[UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    NSUInteger section = ((textView.tag >> 16) & 0xFFFF);
    NSUInteger row     = (textView.tag & 0xFFFF);
    
    NSLog(@"Button in section %i on row %i was pressed.", section, row); 
 
    UITableViewCell* tempCell =  (UITableViewCell*)[textView superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];

    NSLog(@"%d",((chatindex.row + 1)/2)-1);
    NSLog(@"%d",chatindex.section);
    
    [[aryTFAnswer objectAtIndex:chatindex.section] replaceObjectAtIndex:((chatindex.row + 1)/2)-1 withObject:textView.text];
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}

-(IBAction)btnExitPressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_21" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(IBAction)btnParticipantPressed:(id)sender
{
    if([AsParYsNo isEqualToString:@"YES"])
    {
        NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_22" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
}
-(IBAction)btnAssessorPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_23" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
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
