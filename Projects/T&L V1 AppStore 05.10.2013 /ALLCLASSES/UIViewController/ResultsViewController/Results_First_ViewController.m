//
//  Results_First_ViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/2/12.
//
//

#import "Results_First_ViewController.h"
#import "GlobleClass.h"
#import "ResultAssSignViewController.h"

#define HARDCODED_REAPPEAR_DELAY 0.25
#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH 768.0f
#define CELL_CONTENT_MARGIN 0.0f
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH 768.0f
#define CELL_CONTENT_MARGIN 0.0f

@interface Results_First_ViewController ()

@end

@implementation Results_First_ViewController
CGFloat animatedDistance;
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
    
    
    
        
    //------------------------- assessor information    ------------------------
    aryAssessorInfo = [[NSMutableArray alloc]initWithArray:[DatabaseAccess get_assessor_information:[NSString stringWithFormat:@"select *from tbl_assessor where ass_name = '%@' and ass_pinnumber = '%@'",[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"],[[NSUserDefaults standardUserDefaults] valueForKey:@"asspinnumber"]]]];
    
    
    //---------------- tableview-------
    aryResults = [[NSMutableArray alloc]init];
    aryResultsOptions = [[NSMutableArray alloc]init];
    aryResultsOptionAnswer = [[NSMutableArray alloc]init];
    aryAssTaskPart = [[NSMutableArray alloc]init];
    selectedIndexes = [[NSMutableArray alloc]init];
    aryButtons = [[NSMutableArray alloc]init];
    aryNewAssTaskPart = [[NSMutableArray alloc]init];
    
    //BOOL isSelected = NO;
    //NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];

    aryResults = [DatabaseAccess get_tbl_Results:[NSString stringWithFormat:@"select *from tbl_Results where cast(ResourceID as int) = %@",globle_resource_id]];
    NSLog(@"%@",aryResults);
    if([aryResults count]>0)
    {
        lblTitle1.text = globle_UnitName;
        [lblTitle2 setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];
        
        aryResultsOptions = [DatabaseAccess get_tbl_ResultsOptions:[NSString stringWithFormat:@"select ROAutoID,ResultTaskTextID,AssessmentTaskID,Description,ResourceID,(select title from tbl_assessment_task where cast(assessment_task_id as int) = cast(AssessmentTaskID  as int)) from tbl_ResultsOptions where cast(ResourceID as int) = %@",globle_resource_id]];
        
        if([aryResultOpn count]>0)
        {
            for(int x=0;x<[aryResultsOptions count];x++)
            {
                NSMutableArray *ars = [[NSMutableArray alloc]init];
                
                NSString *sqlStatement =[NSString stringWithFormat:@"SELECT *from tbl_assessment_task_part where assessment_task_id = %@",[[aryResultsOptions objectAtIndex:x] valueForKey:@"AssessmentTaskID"]];
                ars = [DatabaseAccess getallRecord_assessment_task_part_id:sqlStatement];
                
                if([ars count]>0)
                    [aryAssTaskPart addObject:ars];
                else
                {
                    ars = [[NSMutableArray alloc]init];
                    [aryAssTaskPart addObject:ars];
                }
                
                
                [aryNewAssTaskPart addObject:[DatabaseAccess get_tbl_ResultsOptionsAnswer:[NSString stringWithFormat:@"select *from tbl_ResultsOptionsAnswer where cast(ResourceID as int) = %@ and ParticipantID  = '%@' and cast(AssessmentTaskID as int) = %@",globle_resource_id,globle_participant_id,[[aryResultsOptions objectAtIndex:x] valueForKey:@"AssessmentTaskID"]]]];
                
                
                
                tempArray2 = [[NSMutableArray alloc]initWithArray:[aryNewAssTaskPart lastObject]];

                
                NSMutableArray *ar = [[NSMutableArray alloc]init];
                NSLog(@"%@",ars);
                
                for(int k=0;k<[ars count];k++)
                {
                    NSLog(@"%d",k);
                    
                    if(k<[tempArray2 count])
                    {
                        NSLog(@"%@",tempArray2);
                        NSLog(@"%@",[tempArray2 objectAtIndex:k]);
                        //BOOL bl = [[[tempArray2 objectAtIndex:k] valueForKey:@"Status"] boolValue];
                        //NSNumber *SI = [NSNumber numberWithBool:bl];
                        [ar insertObject:[[tempArray2 objectAtIndex:k] valueForKey:@"Status"] atIndex:k];
                    }
                    else
                    {
                        [ar insertObject:@"786" atIndex:k];
                    }
                    
                }
                [aryButtons addObject:ar];
            }
            
            tempArray3 = [[NSMutableArray alloc]initWithArray:[DatabaseAccess get_tbl_ResultsOptionsAnswer:[NSString stringWithFormat:@"select *from tbl_ResultsOptionsAnswer where ResultTaskTextID = 'Unit Competency'"]]];
            [aryNewAssTaskPart addObject:tempArray3];
            // --------------------------------------- Unit Competency Values ------------------------------
            NSMutableArray *arT = [[NSMutableArray alloc]init];
            //BOOL bl = [[[tempArray3 objectAtIndex:0] valueForKey:@"Status"] boolValue];
            //NSNumber *SI = [NSNumber numberWithBool:bl];
            [arT insertObject:[[tempArray3 objectAtIndex:0] valueForKey:@"Status"] atIndex:0];
            [aryButtons addObject:arT];
            
            
            tempArray4 = [[NSMutableArray alloc]initWithArray:[DatabaseAccess get_tbl_ResultsOptionsAnswer:[NSString stringWithFormat:@"select *from tbl_ResultsOptionsAnswer where ResultTaskTextID = 'Comments'"]]];
            [aryNewAssTaskPart addObject:tempArray4];
                        
            arT = [[NSMutableArray alloc]init];
            //bl = [[[tempArray4 objectAtIndex:0] valueForKey:@"Status"] boolValue];
            //SI = [NSNumber numberWithBool:bl];
            [arT insertObject:[[tempArray4 objectAtIndex:0] valueForKey:@"Status"] atIndex:0];
            [aryButtons addObject:arT];
            
            NSLog(@"%@",aryNewAssTaskPart);
        }
        else
        {
            NSLog(@"%d",[aryResultsOptions count]);
            for(int x=0;x<[aryResultsOptions count];x++)
            {
                NSMutableArray *ars = [[NSMutableArray alloc]init];
                
                NSString *sqlStatement =[NSString stringWithFormat:@"SELECT *from tbl_assessment_task_part where assessment_task_id = %@",[[aryResultsOptions objectAtIndex:x] valueForKey:@"AssessmentTaskID"]];
                ars = [DatabaseAccess getallRecord_assessment_task_part_id:sqlStatement];
                NSLog(@"%d",[ars count]);
                
                if([ars count]>0)
                    [aryAssTaskPart addObject:ars];
                else
                {
                    ars = [[NSMutableArray alloc]init];
                    [aryAssTaskPart addObject:ars];
                }
                
                NSMutableArray *ar = [[NSMutableArray alloc]init];
                for(int k=0;k<[ars count];k++)
                {
                    [ar insertObject:@"786" atIndex:k];
                }
                [aryButtons addObject:ar];
            }
            //----- this 2 add object for comment & other
            NSMutableArray *arT = [[NSMutableArray alloc]init];
            [arT insertObject:@"786" atIndex:0];
            [aryButtons addObject:arT];
            arT = [[NSMutableArray alloc]init];
            [arT insertObject:@"786" atIndex:0];
            [aryButtons addObject:arT];
            NSLog(@"%@",aryButtons);
        }
         NSLog(@"%@",aryNewAssTaskPart);
    }
    else
    {
        UIAlertView *noRecordFound = [[UIAlertView alloc] initWithTitle:@"T&L" message:@"Data not founds !!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [noRecordFound setTag:1];
        [noRecordFound show];
        return;
    }
    NSLog(@"%@",aryAssTaskPart);
    
    for(int y=0;y<[aryAssTaskPart count]*2 + 4;y++)
    {
        [selectedIndexes insertObject:@"0" atIndex:y];
    }
    
       
    //----Fill webview
    
    NSString* embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@</body></html>",[[aryResults valueForKey:@"Description"] objectAtIndex:0]];
    [tvWebContent resignFirstResponder];
    [tvWebContent setContentToHTMLString:embedHTML];
    [tvWebContent setEditable:NO];
    [tvWebContent setTag:NO];
    tvWebContent.scrollEnabled = NO;
    tvWebContent.opaque = NO;
    tvWebContent.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0); //UIEdgeInsetsMake(-4,-8,0,0);
    
    
    CGRect frame = tvWebContent.frame;
    frame.size.height = tvWebContent.contentSize.height;
    [ivBG setFrame:CGRectMake(0, 55, 768, frame.size.height+5)];
    tvWebContent.frame = frame;
    NSLog(@"%f",frame.size.height);
    
    
  
    if (_tableView!=nil)
    {
        [_tableView removeFromSuperview];
        _tableView=nil;
    }
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,frame.size.height+60,768,1004-frame.size.height-60) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView setTableFooterView:footerView];
}

#pragma mark - UITableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowcount = ([aryAssTaskPart count]*2)+4;
    NSLog(@"%d",rowcount);
    return rowcount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row % 2 == 0)
    {
        return 44;
    }
    else
    {
        if([[selectedIndexes objectAtIndex:indexPath.row]isEqualToString:@"1"])
        {
            if(indexPath.row < [aryAssTaskPart count]*2)
            {
                int recordcount = [[aryAssTaskPart objectAtIndex:((indexPath.row + 1)/2)-1] count];
                if(recordcount >0)
                {
                    int s = 46 + recordcount * 46;
                    return s;
                }
                else
                {
                    return 46;
                }
            }
            else
            {
                return 46;
            }
        }
        else
        {
            return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //}
    
    if(indexPath.row % 2 == 0)
    {
        UIImageView *cellBg=[[UIImageView alloc] initWithFrame:CGRectZero];
        [cellBg setImage:[UIImage imageNamed:@"queBG.png"]];
        [cellBg setFrame:CGRectMake(0,0,768,44)];
        [cell addSubview:cellBg];
        
        btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        if([[selectedIndexes objectAtIndex:indexPath.row+1] isEqualToString:@"0"])
            [btnArrow setImage:[UIImage imageNamed:@"ARROW_Up.png"] forState:UIControlStateNormal];
        else
            [btnArrow setImage:[UIImage imageNamed:@"ARROW_Down.png"] forState:UIControlStateNormal];
        
        [btnArrow addTarget:self action:@selector(btnExpandPressed:)
           forControlEvents:UIControlEventTouchDown];
        btnArrow.frame = CGRectMake(10,0,44,44);
        [cell addSubview:btnArrow];
        
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 500, 44)];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        
        
        if(indexPath.row < [aryAssTaskPart count]*2)
        {
            [lblTitle setText:[[aryResultsOptions valueForKey:@"AssTaskName"] objectAtIndex:indexPath.row/2]];
            [cell addSubview:lblTitle];
        }
        else if(indexPath.row == [aryAssTaskPart count]*2)
        {
            [lblTitle setText:@"Unit Competency"];
            [cell addSubview:lblTitle];
        }
        else if(indexPath.row == [aryAssTaskPart count]*2 + 2)
        {
            [lblTitle setText:@"Comments"];
            [cell addSubview:lblTitle];
        }
    }
    else
    {
        if([[selectedIndexes objectAtIndex:indexPath.row] isEqualToString:@"0"])
            [cell setHidden:TRUE];
        else
        {
            if(indexPath.row < [aryAssTaskPart count]*2)
            {
                UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 786, 46)];
                [iv setBackgroundColor:[UIColor colorWithRed:0.047f green:0.172f blue:0.321f alpha:1]];
                [iv setOpaque:NO];
                [cell addSubview:iv];
                
                UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 500, 44)];
                [lblTitle setText:@"Title and assessment method"];
                [lblTitle setTextColor:[UIColor whiteColor]];
                [lblTitle setBackgroundColor:[UIColor clearColor]];
                [lblTitle setTextAlignment:NSTextAlignmentLeft];
                [cell addSubview:lblTitle];
                
                UILabel *lblTitle_2 = [[UILabel alloc]initWithFrame:CGRectMake(490, 0, 250, 44)];
                [lblTitle_2 setText:@"Successfully Completed"];
                [lblTitle_2 setTextColor:[UIColor whiteColor]];
                [lblTitle_2 setTextAlignment:NSTextAlignmentRight];
                [lblTitle_2 setBackgroundColor:[UIColor clearColor]];
                [cell addSubview:lblTitle_2];

                int ct = [[aryAssTaskPart objectAtIndex:((indexPath.row - 1)/2)] count];
                int y = 47;
                
                
                UIImageView *iv1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 46, 786, ct*46 + 3)];
                [iv1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"queBG.png"]]];
                [cell addSubview:iv1];
                
                
                if(ct > 0)
                {
                    UIWebView *wv = [[UIWebView alloc]initWithFrame:CGRectMake(0, 46,600, ct*46)];
                    [wv setOpaque:NO];
                    wv.delegate = self;
                    [wv setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"queBG.png"]]];
                    NSString* embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#00000000;font-size:16px;'>%@</body></html>",[[aryResultsOptions valueForKey:@"Description"] objectAtIndex:((indexPath.row - 1)/2)]];
                    [wv loadHTMLString:embedHTML baseURL:nil];
                    [cell addSubview:wv];
                }
                
                NSLog(@"%@",aryButtons);
                NSLog(@"%@",[aryButtons objectAtIndex:((indexPath.row - 1)/2)]);
                
                for(int s=0;s<ct;s++)
                {
                    NSString *sValue = [[aryButtons objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:s];
                    //BOOL sValue = [ boolValue];
                    
                    btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btnDelete setTag:s];
                    [btnDelete setTitle:@"0" forState:UIControlStateNormal];
                    [btnDelete setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    if([sValue isEqualToString:@"0"])
                        [btnDelete setImage:[UIImage imageNamed:@"delete_enable.png"] forState:UIControlStateNormal];
                    else if([sValue isEqualToString:@"1"] || [sValue isEqualToString:@"786"])
                        [btnDelete setImage:[UIImage imageNamed:@"delete_disable.png"] forState:UIControlStateNormal];
                    
                    [btnDelete setFrame:CGRectMake(624, y, 72, 46)];
                    [btnDelete addTarget:self action:@selector(btnDeleteTickTapped:)
                       forControlEvents:UIControlEventTouchDown];
                    [cell addSubview:btnDelete];
                    
                    btnTick = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btnTick setTag:s];
                    [btnTick setTitle:@"1" forState:UIControlStateNormal];
                    [btnTick setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    if([sValue isEqualToString:@"0"] || [sValue isEqualToString:@"786"])
                        [btnTick setImage:[UIImage imageNamed:@"tick_disable.png"] forState:UIControlStateNormal];
                    else if([sValue isEqualToString:@"1"])
                        [btnTick setImage:[UIImage imageNamed:@"tick_enable.png"] forState:UIControlStateNormal];
                    [btnTick setFrame:CGRectMake(696, y, 72, 46)];
                    [btnTick addTarget:self action:@selector(btnDeleteTickTapped:)
                        forControlEvents:UIControlEventTouchDown];
                    [cell addSubview:btnTick];
                    
                    y = y + 46;
                }
            }
            else if(indexPath.row == [aryAssTaskPart count]*2 + 1)
            {
                UIImageView *iv1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 786, 46 + 3)];
                [iv1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"queBG.png"]]];
                [cell addSubview:iv1];
                
                NSString *sValue = [[aryButtons objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:0];
                //BOOL sValue = [[[aryButtons objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:0] boolValue];
                
                btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnDelete setTag:0];
                [btnDelete setTitle:@"0" forState:UIControlStateNormal];
                [btnDelete setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                if([sValue isEqualToString:@"0"])
                    [btnDelete setImage:[UIImage imageNamed:@"delete_enable.png"] forState:UIControlStateNormal];
                else if([sValue isEqualToString:@"1"] || [sValue isEqualToString:@"786"])
                    [btnDelete setImage:[UIImage imageNamed:@"delete_disable.png"] forState:UIControlStateNormal];
                [btnDelete setFrame:CGRectMake(624, 0, 72, 46)];
                [btnDelete addTarget:self action:@selector(btnDeleteTickTapped:)
                    forControlEvents:UIControlEventTouchDown];
                [cell addSubview:btnDelete];
                
                btnTick = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnTick setTag:0];
                [btnTick setTitle:@"1" forState:UIControlStateNormal];
                [btnTick setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                if([sValue isEqualToString:@"0"] || [sValue isEqualToString:@"786"])
                    [btnTick setImage:[UIImage imageNamed:@"tick_disable.png"] forState:UIControlStateNormal];
                else if([sValue isEqualToString:@"1"])
                    [btnTick setImage:[UIImage imageNamed:@"tick_enable.png"] forState:UIControlStateNormal];
                [btnTick setFrame:CGRectMake(696, 0, 72, 46)];
                [btnTick addTarget:self action:@selector(btnDeleteTickTapped:)
                  forControlEvents:UIControlEventTouchDown];
                [cell addSubview:btnTick];
                
            }
            else if(indexPath.row == [aryAssTaskPart count]*2 + 3)
            {
                UIImageView *iv1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 786, 46)];
                [iv1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"queBG.png"]]];
                [cell addSubview:iv1];
                
                tfComment = [[UITextField alloc]initWithFrame:CGRectMake(30, 5, 600, 36)];
                [tfComment setBorderStyle:UITextBorderStyleRoundedRect];
                [tfComment setPlaceholder:@"Comments"];
                [tfComment setText:[[tempArray4 objectAtIndex:0] valueForKey:@"Status"]];
                [cell addSubview:tfComment];
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/******************* Added Code********************/
- (BOOL)cellIsSelected:(NSIndexPath *)indexPath {
	// Return whether the cell at the specified index path is selected or not
	NSNumber *selectedIndex = [selectedIndexes objectAtIndex:indexPath.row+1];
	return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
}

#pragma mark - Button Tapped Event


-(IBAction)continueButtonTapped:(id)sender
{
    NSLog(@"%@",tempArray3);
    NSLog(@"%@",tempArray4);
    if([aryResultOpn count]>0)
    {
        for(int i=0;i<[aryAssTaskPart count];i++)
        {
            NSMutableArray *arS2 = [[NSMutableArray alloc]initWithArray:[aryButtons objectAtIndex:i]];
            for(int j=0;j<[[aryAssTaskPart objectAtIndex:i] count];j++)
            {
                NSLog(@"%@",[arS2 objectAtIndex:j]);
                //NSNumber *selectedIndex2 = [arS2 objectAtIndex:j];
                //NSString *st =  [NSString stringWithFormat:@"%s",[selectedIndex2 boolValue] ? "YES" : "NO"];
                [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"update tbl_ResultsOptionsAnswer set Status = '%@' where cast(ROAAutoID as int) = %@",[arS2 objectAtIndex:j],[[[aryNewAssTaskPart objectAtIndex:i]objectAtIndex:j] valueForKey:@"ROAAutoID"]]];
            }
        }
        
        
        // ------------------------------------- Insert Comment & Unit Competency ---------------------------------------------
        NSMutableArray *arS_1 = [[NSMutableArray alloc]initWithArray:[aryButtons objectAtIndex:[aryButtons count]-2]];
        //NSNumber *selectedIndex = [arS_1 objectAtIndex:0];
        //NSString *st = [NSString stringWithFormat:@"%s",[selectedIndex boolValue] ? "YES" : "NO"];
        [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"update tbl_ResultsOptionsAnswer set Status = '%@' where cast(ROAAutoID as int) = %@",[arS_1 objectAtIndex:0],[tempArray3 valueForKey:@"ROAAutoID"]]];
        
        
        [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"update tbl_ResultsOptionsAnswer set Status = '%@' where cast(ROAAutoID as int) = %@",tfComment.text,[tempArray4 valueForKey:@"ROAAutoID"]]];
    }
    else
    {
        for(int i=0;i<[aryAssTaskPart count];i++)
        {
            NSMutableArray *arS = [[NSMutableArray alloc]initWithArray:[aryAssTaskPart objectAtIndex:i]];
            NSMutableArray *arS2 = [[NSMutableArray alloc]initWithArray:[aryButtons objectAtIndex:i]];
            
            for(int j=0;j<[[aryAssTaskPart objectAtIndex:i] count];j++)
            {
                NSLog(@"%@",[arS2 objectAtIndex:j]);
                NSLog(@"%@",[[aryAssessorInfo objectAtIndex:0] valueForKey:@"assessorsID"]);
                [DatabaseAccess insert_tbl_ResultOptionsAnswer:[[aryResultsOptions objectAtIndex:i] valueForKey:@"ResultTaskTextID"] AssessmentTaskID:[[aryResultsOptions objectAtIndex:i] valueForKey:@"AssessmentTaskID"] Description:[[aryResultsOptions objectAtIndex:i] valueForKey:@"Description"] ResourceID:[[aryResultsOptions objectAtIndex:i] valueForKey:@"ResourceID"] AssTaskPartName:[[arS objectAtIndex:j] valueForKey:@"title"] ParticipantID:globle_participant_id Status:[arS2 objectAtIndex:j] AssessorID:[[NSUserDefaults standardUserDefaults] valueForKey:@"assempid"] Assessment_Task_Part_ID:[[arS objectAtIndex:j] valueForKey:@"setassessment_tak_part_id"]];
            }
        }
        
        
        // ------------------------------------- Insert Comment & Unit Competency ---------------------------------------------
        NSMutableArray *arS_1 = [[NSMutableArray alloc]initWithArray:[aryButtons objectAtIndex:[aryButtons count]-2]];
        //NSNumber *selectedIndex = [arS_1 objectAtIndex:0];
        //NSString *st = [NSString stringWithFormat:@"%s",[selectedIndex boolValue] ? "YES" : "NO"];
        
        
        [DatabaseAccess insert_tbl_ResultOptionsAnswer:@"Unit Competency" AssessmentTaskID:@"Unit Competency" Description:@"Competency has been achieved in this unit" ResourceID:globle_resource_id AssTaskPartName:@"Unit Competency" ParticipantID:globle_participant_id Status:[arS_1 objectAtIndex:0] AssessorID:[[NSUserDefaults standardUserDefaults] valueForKey:@"assempid"] Assessment_Task_Part_ID:@"Task Part ID"];
        
        [DatabaseAccess insert_tbl_ResultOptionsAnswer:@"Comments" AssessmentTaskID:@"Comments" Description:tfComment.text ResourceID:globle_resource_id AssTaskPartName:@"Comments" ParticipantID:globle_participant_id Status:tfComment.text AssessorID:[[NSUserDefaults standardUserDefaults] valueForKey:@"assempid"] Assessment_Task_Part_ID:@"Task Part ID"];
    }
    
    
    ResultAssSignViewController *objResultAssSignViewController = [[ResultAssSignViewController alloc]initWithNibName:@"ResultAssSignViewController" bundle:nil];
    [self.navigationController pushViewController:objResultAssSignViewController animated:YES];
}

-(void)btnExpandPressed:(id)sender
{
    UITableViewCell* tempCell =  (UITableViewCell*)[sender superview];
    NSIndexPath *chatindex = [_tableView indexPathForCell:tempCell];
    
    
    if([[selectedIndexes objectAtIndex:chatindex.row+1] isEqualToString:@"0"])
    {
        for(int i=0;i<[selectedIndexes count];i++)
        {
            [selectedIndexes replaceObjectAtIndex:i withObject:@"0"];
        }
        [selectedIndexes replaceObjectAtIndex:chatindex.row+1 withObject:@"1"];
    }
    else if([[selectedIndexes objectAtIndex:chatindex.row+1] isEqualToString:@"1"])
    {
        for(int i=0;i<[selectedIndexes count];i++)
        {
            [selectedIndexes replaceObjectAtIndex:i withObject:@"0"];
        }
        //[selectedIndexes replaceObjectAtIndex:chatindex.row+1 withObject:@"0"];
    }
    
    
    [_tableView reloadData];
}

-(IBAction)btnDeleteTickTapped:(id)sender
{
    UITableViewCell* tempCell =  (UITableViewCell*)[sender superview];
    NSIndexPath *chatindex = [_tableView indexPathForCell:tempCell];
    
    NSLog(@"%d",[sender tag]);
    UIButton *btn = (UIButton*)sender;
    NSLog(@"%@",btn.currentTitle);
    
    NSLog(@"%d",((chatindex.row + 1)/2)-1);
    //NSString *sValue = [[aryButtons objectAtIndex:((chatindex.row - 1)/2)] objectAtIndex:[sender tag]];
    //BOOL sValue = [[[aryButtons objectAtIndex:((chatindex.row - 1)/2)] objectAtIndex:[sender tag]] boolValue];
    //NSNumber *selectedIndex = [NSNumber numberWithBool:!sValue];
    [[aryButtons objectAtIndex:((chatindex.row + 1)/2)-1] replaceObjectAtIndex:[sender tag] withObject:btn.currentTitle];
    NSLog(@"%@",aryButtons);
    NSLog(@"%@",[aryButtons objectAtIndex:((chatindex.row + 1)/2)-1]);
    
    [_tableView reloadData];
}

-(IBAction)exitButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIAlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        NSArray *vList = [[self navigationController] viewControllers];
        UIViewController *view;
        for (int i=[vList count]-1; i>=0; --i) {
            view = [vList objectAtIndex:i];
            if ([view.nibName isEqualToString:@"AssessmentsVIewController"])
                break;
        }
        [[self navigationController] popToViewController:view animated:YES];
    }
}


@end
