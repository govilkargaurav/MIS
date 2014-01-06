//
//  ParticipantsQueViewController.m
//  T&L
//
//  Created by openxcell tech.. on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParticipantsQueViewController.h"
#import "NavigationController.h"
#import "NSFileManager+DirectoryLocations.h"
#import "TabbarController.h"
#import "GlobleClass.h"
#import "KeypadVC.h"

#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH 768.0f
#define CELL_CONTENT_MARGIN 0.0f
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
@implementation ParticipantsQueViewController

CGFloat animatedDistance;

@synthesize _tableView,imageNmArr;
@synthesize _scrollView;
@synthesize finalArr,ArrData,ImgArrData,arySelectStatus,aryTextField,aryForCBoxRButton;

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
    strPushView = @"NO";
    lbl_1.text = globle_UnitName;
    [lbl_2 setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //--------------------Database Bean--------------------------------------------------
    
    if([strPushView isEqualToString:@"YES"])
    {
        strPushView = NO;
        ParticipatnsContinue = @"YES";
        QuestionAssessorViewController *QAview=[[QuestionAssessorViewController alloc] initWithNibName:@"QuestionAssessorViewController" bundle:nil];
        [self.navigationController pushViewController:QAview animated:YES];
    }
    else
    {
        question_font = [UIFont fontWithName:@"Helvetica" size:14];
        //self._scrollView.contentSize=CGSizeMake(self.view.frame.size.width, 1300);
        if (imageNmArr!=nil) {
            imageNmArr=nil;
            [imageNmArr removeAllObjects];
        }
        
        
        self.imageNmArr=[NSArray arrayWithObjects:@"",@"",@"",@"",@"Player.png",@"",@"train-tracks.png",@"",@"Video.png",@"123.png", nil];
        self.ImgArrData = [NSArray arrayWithObjects:@"",@"",@"", nil];
        
        self.finalArr = [NSArray arrayWithObjects:@"Question 1: What is T&L?",@"", @"Question 1: What is T&L?",@"", @"Question 1: What is T&L?",@"",@"Question 1: What is T&L?",@"",@"Question 1: What is T&L?",@"",nil];
        self.ArrData = [NSArray arrayWithObjects:@"Question 1: What is T&L Next Question?", @"Question 1: What is T&L Next Question?", @"Question 1: What is T&L Next Question?", nil];
        
        if (aryParticpants!=nil) 
        {
            [aryParticpants removeAllObjects];
            aryParticpants=nil;
        }
        
        
        if(aryQueTitle!=nil)
        {
            [aryQueTitle removeAllObjects];
            aryQueTitle = nil;
        }
        aryQueTitle = [[NSMutableArray alloc]init];
        NSLog(@"%@",aryAllQueParticipant);
        aryQueTitle = [[NSMutableArray alloc]initWithArray:aryAllQueParticipant];  // take from questionAssessor
        
        
        if (arySelectStatus!=nil) {
            [arySelectStatus removeAllObjects];
            arySelectStatus=nil;
        }  
        
        if (_arrNewOne!=nil) {
            [_arrNewOne removeAllObjects];
            _arrNewOne=nil;
        }
        _arrNewOne = [[NSMutableArray alloc]initWithArray:aryAllOptionParticipant];  // take from questionAssessor
        NSLog(@"%@",aryAllOptionParticipant);
        NSLog(@"%@",_arrNewOne);
        arySelectStatus = [[NSMutableArray alloc]init];
        
        
        if(aryForCBoxRButton != nil)
        {
            [aryForCBoxRButton removeAllObjects];
            aryForCBoxRButton = nil;
        }
        aryForCBoxRButton = [[NSMutableArray alloc]initWithArray:aryAllCBoxRButtonParticipant]; // take from questionAssessor
        

        if(aryTextField!=nil)
        {
            [aryTextField removeAllObjects];
            aryTextField = nil;
        }
        aryTextField = [[NSMutableArray alloc]init];
        
        if(arySectionName!=nil)
        {
            [arySectionName removeAllObjects];
            arySectionName = nil;
        }
        NSString *sqlStatement =[NSString stringWithFormat:@"SELECT *from tbl_assessment_task_part where assessment_task_id = %@",globle_assessment_task_id];
        
        arySectionName = [[NSMutableArray alloc]initWithArray:[DatabaseAccess getallRecord_assessment_task_part_id:sqlStatement]];
        NSLog(@"%@",arySectionName);
        
        NSLog(@"%@",aryTField);
        NSLog(@"%@",aryYNResult);
        NSLog(@"%@",aryTextField);

        //----Fill webview
        //[taskinfo setOpaque:NO];
        //[thirdpartyinfo setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"queBG.png"]]];
        //taskinfo.delegate = self;
        NSString* embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@</body></html>",[[NSUserDefaults standardUserDefaults] valueForKey:@"assTaskOutline"]];
        NSLog(@"%@",embedHTML);
        
        [tvWebData resignFirstResponder];
        [tvWebData setContentToHTMLString:embedHTML];
        [tvWebData setEditable:NO];
        [tvWebData setTag:NO];
        tvWebData.scrollEnabled = NO;
        tvWebData.backgroundColor = [UIColor clearColor];
        tvWebData.opaque = NO;
        
        CGRect frame = tvWebData.frame;
        frame.size.height = tvWebData.contentSize.height + 5;
        tvWebData.frame = frame;
        
        [_tableView setFrame:CGRectMake(0, frame.size.height+60, 768, 1004-60-frame.size.height)];
        //[taskinfo loadHTMLString:embedHTML baseURL:nil];
        
    }
}




//-(void)createTableView{
//    
//    int tblRowHeight = [aryParticpants count] * 218;
//    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,300,769,tblRowHeight) style:UITableViewStylePlain];
//    [_tableView setScrollEnabled:NO];
//    _tableView.delegate=self;
//    _tableView.dataSource=self;
//    _tableView.backgroundColor=[UIColor clearColor];
//    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
//    [self._scrollView addSubview:_tableView];
//    self._scrollView.contentSize=CGSizeMake(self.view.frame.size.width, tblRowHeight + 300);
//    
//}


#pragma mark -
#pragma mark UITableView Delegaates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    NSLog(@"%d",[_arrNewOne count]);
	return [_arrNewOne count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSMutableArray *ar_1 = [[NSMutableArray alloc]initWithArray:[_arrNewOne objectAtIndex:section]];
    NSLog(@"%d",[ar_1 count]);
    return [ar_1 count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    NSLog(@"%@",arySectionName);
    NSLog(@"%d",section);
    NSLog(@"%@",[[arySectionName objectAtIndex:section] valueForKey:@"title"]);
    return [[arySectionName objectAtIndex:section] valueForKey:@"title"];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.section);
    NSLog(@"%d",indexPath.row);
    int rHeight = 0;
    NSLog(@"%@",aryQueTitle);
    
    NSMutableArray *aryQT = [[NSMutableArray alloc]initWithArray:[aryQueTitle objectAtIndex:indexPath.section]];
    NSLog(@"%@",aryQT);
    NSLog(@"%@",[aryQueTitle objectAtIndex:indexPath.section]);
    if([aryQT count]>0)
    {
        NSString* embedHTML;
        if([[[aryQT objectAtIndex:indexPath.row]valueForKey:@"setquestiontype"] isEqualToString:@"activity"]){
        
            embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@<br>%@</body></html>",[[aryQT objectAtIndex:indexPath.row]valueForKey:@"setDescriptionQuestion"],[[aryQT objectAtIndex:indexPath.row]valueForKey:@"setactivitydescription"]];
        }
        else{
            
            embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@</body></html>",[[aryQT objectAtIndex:indexPath.row]valueForKey:@"setDescriptionQuestion"]];
        }
        size = [embedHTML sizeWithFont:question_font constrainedToSize:CGSizeMake(768, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        rHeight = rHeight + size.height;

        NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:[_arrNewOne objectAtIndex:indexPath.section]];
        NSMutableArray *arrTemp_1 = [[NSMutableArray alloc]initWithArray:[arrTemp objectAtIndex:indexPath.row]];
        if ([arrTemp_1 count]>0)
        {
            
            for(int x=0;x<[arrTemp_1 count];x++)
            {
                if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"file"])
                {
                    rHeight = rHeight + 110;
                }
                else if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"checkbox"])
                {
                    rHeight = rHeight + 35;
                }
                else if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"radio"])
                {
                    rHeight = rHeight + 35;
                }
                else if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"null"])
                {
                    rHeight = rHeight + 126;
                }
            }
        }
    }
//    if(indexPath.section==0)
//    if(indexPath.row==3)
//    {
//        return 54;
//    }
    NSLog(@"%d",rHeight);
    return rHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.section);
    NSLog(@"%d",indexPath.row);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
//    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell) {
//        cell=nil;
//        [cell removeFromSuperview];
//        
//    }
   if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    int y = 0;
    UIImageView *ivBGImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queBG.png"]];
    [cell addSubview:ivBGImg];
    
    NSMutableArray *aryQT = [[NSMutableArray alloc]initWithArray:[aryQueTitle objectAtIndex:indexPath.section]];

    NSLog(@"%@",[[aryQT objectAtIndex:indexPath.row]valueForKey:@"setDescriptionQuestion"]);
    NSString* embedHTML;
    
    if([[[aryQT objectAtIndex:indexPath.row]valueForKey:@"setquestiontype"] isEqualToString:@"activity"]){
        
        embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@<br/>%@</body></html>",[[aryQT objectAtIndex:indexPath.row]valueForKey:@"setDescriptionQuestion"],[[aryQT objectAtIndex:indexPath.row]valueForKey:@"setactivitydescription"]];
    }
    else{
        
        embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@</body></html>",[[aryQT objectAtIndex:indexPath.row]valueForKey:@"setDescriptionQuestion"]];
    }
    size = [embedHTML sizeWithFont:question_font constrainedToSize:CGSizeMake(768, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%d",y);
    NSLog(@"%f",size.height);
    /*
    tvDynamic = [[UITextView alloc]initWithFrame:CGRectMake(0, 5, 768, 10)];
    [tvDynamic resignFirstResponder];
    [tvDynamic setContentToHTMLString:embedHTML];
    [tvDynamic setEditable:NO];
    [tvDynamic setBackgroundColor:[UIColor redColor]];
    [tvDynamic setTag:NO];
    tvDynamic.scrollEnabled = NO;
    tvDynamic.opaque = NO;
    [tvDynamic sizeToFit];
    
    CGRect frame = tvDynamic.frame;
    frame.size.height = tvDynamic.contentSize.height + 5;
    tvDynamic.frame = frame;
    //[tvDynamic setFrame:CGRectMake(0, y, 768, frame.size.height)];
    NSLog(@"%f",tvDynamic.frame.size.height+5);
    [cell addSubview:tvDynamic];
    */
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,y, 768, size.height)];
    [webView setOpaque:NO];
    [webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"queBG.png"]]];
    webView.delegate = self;
    [webView loadHTMLString:embedHTML baseURL:nil];
    [cell addSubview:webView];
   

    y = y + size.height;
     NSLog(@"%d",y);
    NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:[_arrNewOne objectAtIndex:indexPath.section]];
    NSMutableArray *arrTemp_1 = [[NSMutableArray alloc]initWithArray:[arrTemp objectAtIndex:indexPath.row]];
    NSLog(@"%@",arrTemp_1);
    //------
    NSMutableArray *arQue_CB = [[NSMutableArray alloc]initWithArray:[aryForCBoxRButton objectAtIndex:indexPath.section]];
    NSMutableArray *aryOpn_CB = [[NSMutableArray alloc]initWithArray:[arQue_CB objectAtIndex:indexPath.row]];
    
    if ([arrTemp_1 count]>0)
    {
        
        for(int x=0;x<[arrTemp_1 count];x++)
        {
            NSString *filenamepath = [NSString stringWithFormat:@"%@/%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"FILESPATH"],[[arrTemp_1 objectAtIndex:x]valueForKey:@"src"]];
            NSURL* urlFileVideo = [NSURL fileURLWithPath:filenamepath];
            
            if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"file"])
            {
                MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:urlFileVideo];
                UIImage  *thumbnail = [player thumbnailImageAtTime:8.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
                [player stop];
                player = nil;
                
                UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn_1 setImage:thumbnail forState:UIControlStateNormal];
                [btn_1 setFrame:CGRectMake(90, y, 500, 100)];
                [btn_1 setTitle:[[arrTemp_1 objectAtIndex:x]valueForKey:@"src"] forState:UIControlStateNormal];
                [btn_1 addTarget:self action:@selector(btn_1Pressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn_1];
                
                UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(90, y, 500, 100)];
                [iv setImage:[UIImage imageNamed:@"videoPlayIcon.png"]];
                [iv setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Shaddow.png"]]];                        
                [iv setContentMode:UIViewContentModeCenter];
                [cell addSubview:iv];
                
                y = y + 110;
            }
            if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"checkbox"])
            {
                UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
                if([[aryOpn_CB objectAtIndex:x]intValue] == 0)
                    [button0 setBackgroundImage:[UIImage imageNamed:@"checkboxEmpty.png"] forState:UIControlStateNormal];
                else
                    [button0 setBackgroundImage:[UIImage imageNamed:@"checkboxFull.png"] forState:UIControlStateNormal];
                
                [button0 addTarget:self action:@selector(btnCheckBoxPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                button0.frame = CGRectMake(50, y, 32,32);
                [button0 setTag:x+100];
                [cell addSubview:button0];
                
                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(100, y, 500, 32)];
                [lbl setBackgroundColor:[UIColor clearColor]];
                [lbl setText:[[arrTemp_1 objectAtIndex:x] valueForKey:@"Column_Value"]];
                [cell addSubview:lbl];
                
                y = y + 35;
            }
            if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"radio"])
            {
                UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
                if([[aryOpn_CB objectAtIndex:x]intValue] == 0)
                    [button0 setBackgroundImage:[UIImage imageNamed:@"RadioSingle.png"] forState:UIControlStateNormal];
                else
                    [button0 setBackgroundImage:[UIImage imageNamed:@"RadioSingleselected.png"] forState:UIControlStateNormal];
                
                [button0 addTarget:self action:@selector(btnRadioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                button0.frame = CGRectMake(50, y, 21,21);
                [button0 setTag:x+200];
                [cell addSubview:button0];
                
                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(100, y, 500, 32)];
                [lbl setBackgroundColor:[UIColor clearColor]];
                [lbl setText:[[arrTemp_1 objectAtIndex:x] valueForKey:@"Column_Value"]];
                [cell addSubview:lbl];
                
                
                y = y + 35;
                
            }
            if([[[arrTemp_1 objectAtIndex:x]valueForKey:@"type"]isEqualToString:@"null"])
            {
                UIImageView *ivCOMMENTBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, y, 768, 126)];
                [ivCOMMENTBG setImage:[UIImage imageNamed:@"COMMENTBG"]];
                [cell addSubview:ivCOMMENTBG];

                UITextView *tfComments = [[UITextView alloc] initWithFrame:CGRectMake(34, y , 440, 111)];
                tfComments.textAlignment = NSLineBreakByWordWrapping;
                tfComments.delegate = self;
                [tfComments setBackgroundColor:[UIColor clearColor]];
                [tfComments setText:[[aryTField objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
                [cell addSubview:tfComments];
                y = y + 35;
            }
        }
    }
    NSLog(@"%d",y);
//    if(indexPath.row==3)
//    {
//        [ivBGImg setFrame:CGRectMake(0, 0, 768, 55)];
//    }
//    else
//    {
//        [ivBGImg setFrame:CGRectMake(0, 0, 768, y)];
//    }
    [ivBGImg setFrame:CGRectMake(0, 0, 768, y)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SignatureViewController *signatureController = [[SignatureViewController alloc] initWithNibName:@"SignatureViewController" bundle:nil];
//	signatureController.delegate = self;
//    signatureController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//    [self presentModalViewController:signatureController animated:YES];    
//    [signatureController release];
}
-(IBAction)btnNoPressed:(id)sender
{
    UITableViewCell* tempCell =  (UITableViewCell*)[sender superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    [[aryYNResult objectAtIndex:chatindex.section] replaceObjectAtIndex:chatindex.row withObject:@"No"];
    [_tableView reloadData];
}
-(IBAction)btnYesPressed:(id)sender
{
    UITableViewCell* tempCell =  (UITableViewCell*)[sender superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    [[aryYNResult objectAtIndex:chatindex.section] replaceObjectAtIndex:chatindex.row withObject:@"Yes"];
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

-(IBAction)btnCheckBoxPressed:(id)sender
{

    UITableViewCell* tempCell =  (UITableViewCell*)[sender superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    
    NSLog(@"%d",chatindex.row);
    
    int value = [[[[aryForCBoxRButton objectAtIndex:chatindex.section] objectAtIndex:chatindex.row] objectAtIndex:[sender tag]-100] intValue];
    
    if(value==0)
    {
        [[[aryForCBoxRButton objectAtIndex:chatindex.section] objectAtIndex:chatindex.row] replaceObjectAtIndex:[sender tag]-100 withObject:@"1"];
        UIButton *Btn=(UIButton *) [self.view viewWithTag:[sender tag]];
        [Btn setBackgroundImage:[UIImage imageNamed:@"checkboxFull.png"] forState:UIControlStateNormal];
    }
    else
    {
        UIButton *Btn=(UIButton *) [self.view viewWithTag:[sender tag]];
        [Btn setBackgroundImage:[UIImage imageNamed:@"checkboxEmpty.png"] forState:UIControlStateNormal];
        [[[aryForCBoxRButton objectAtIndex:chatindex.section] objectAtIndex:chatindex.row] replaceObjectAtIndex:[sender tag]-100 withObject:@"0"];
    }
}
-(IBAction)btnRadioButtonPressed:(id)sender
{
    UITableViewCell* tempCell =  (UITableViewCell*)[sender superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    NSMutableArray *aryTmp = [[NSMutableArray alloc]initWithArray:[[aryForCBoxRButton objectAtIndex:chatindex.section] objectAtIndex:chatindex.row]];
    
    NSLog(@"%d",chatindex.row);
    for(int p=0;p<[aryTmp count];p++)
    {
        UIButton *Btn=(UIButton *) [self.view viewWithTag:p+200];
        [Btn setBackgroundImage:[UIImage imageNamed:@"RadioSingle.png"] forState:UIControlStateNormal];
         [[[aryForCBoxRButton objectAtIndex:chatindex.section] objectAtIndex:chatindex.row] replaceObjectAtIndex:p withObject:@"0"];
    }
    UIButton *Btn1=(UIButton *)sender;
    
    NSLog(@"%d",Btn1.tag-200);
    [Btn1 setBackgroundImage:[UIImage imageNamed:@"RadioSingleselected.png"] forState:UIControlStateNormal];
    [[[aryForCBoxRButton objectAtIndex:chatindex.section] objectAtIndex:chatindex.row] replaceObjectAtIndex:Btn1.tag-200 withObject:@"1"];
}

-(void)complete
{
   
   
    NSLog(@"%@",aryTField);
    NSLog(@"%@",aryQueTitle);
    NSLog(@"%@",aryYNResult);
    
    for(int d=0;d<[aryQueTitle count];d++)
    {
        
        NSMutableArray *ar_2 = [[NSMutableArray alloc]initWithArray:[aryQueTitle objectAtIndex:d]];
        NSMutableArray *ar_3 = [[NSMutableArray alloc]initWithArray:[aryTField objectAtIndex:d]]; // textField
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
            
            NSString *strQuery = [NSString stringWithFormat:@"insert into tbl_question_answer (UserID,assessment_task_id,question_Id,'order',assessment_task_part_id,answer,result,OptionSelected,AssessorID,ResourceID) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",globle_participant_id,globle_assessment_task_id,[[ar_2 objectAtIndex:f] valueForKey:@"setQuestion_Id"],@"",[[ar_2 objectAtIndex:f] valueForKey:@"setAssessment_task_part_id"],[ar_3 objectAtIndex:f],[ar_4 objectAtIndex:f],strOptionSelected,[[NSUserDefaults standardUserDefaults] valueForKey:@"assempid"],globle_resource_id];
            [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
        }
    }
    
    
    //----Clear Array Set On QuestionAssessorView--
    [aryAllQueParticipant removeAllObjects];
    aryAllQueParticipant = nil;
    
    [aryAllOptionParticipant removeAllObjects];
    aryAllQueParticipant = nil;
        
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




-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    UITableViewCell* tempCell =  (UITableViewCell*)[textView superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    
    //[aryTextField replaceObjectAtIndex:((chatindex.row + 1)/2)-1 withObject:textField_2.text];
    NSLog(@"%d",chatindex.section);
    [textView setText:[[aryTField objectAtIndex:chatindex.section] objectAtIndex:chatindex.row]];
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
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    //NSUInteger section = ((textView.tag >> 16) & 0xFFFF);
    //NSUInteger row     = (textView.tag & 0xFFFF);
    
    //NSLog(@"Button in section %i on row %i was pressed.", section, row);
    
    UITableViewCell* tempCell =  (UITableViewCell*)[textView superview];
    NSIndexPath *chatindex = [self._tableView indexPathForCell:tempCell];
    
    NSLog(@"%d",chatindex.row);
    NSLog(@"%d",chatindex.section);
    
    [[aryTField objectAtIndex:chatindex.section] replaceObjectAtIndex:chatindex.row withObject:textView.text];
    //[aryTextField replaceObjectAtIndex:((chatindex.row + 1)/2)-1 withObject:textField_1.text];

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    //[_tableView reloadData];
}

-(IBAction)btnExitPressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_21" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(IBAction)btnParticipantPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
        NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_22" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(IBAction)btnAssessorPressed:(id)sender
{
    AsParYsNo = @"NO";
    [self complete];
    strPushView = @"YES";
    KeypadVC *controller=[[KeypadVC alloc] initWithNibName:@"KeypadVC" bundle:nil];
    [self.navigationController pushViewController:controller animated:NO];
    
    //NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_23" object:self];
    //[[NSNotificationCenter defaultCenter] postNotification:notif];
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
