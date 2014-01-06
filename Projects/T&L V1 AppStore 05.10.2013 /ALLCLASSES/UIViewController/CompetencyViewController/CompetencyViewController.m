//
//  CompetencyViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/9/12.
//
//

#import "CompetencyViewController.h"
#import "GlobleClass.h"
@interface CompetencyViewController ()

@end

@implementation CompetencyViewController
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
    
    //----------------------------------    Fill Values  -------------------------------
    lblTitle1.text = globle_UnitName;
    [lblTitle2 setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];
    
    
    //-------------------------     Assessor Information    ------------------------
    aryAssessorInfo = [[NSMutableArray alloc]initWithArray:[DatabaseAccess get_assessor_information:[NSString stringWithFormat:@"select *from tbl_assessor where ass_name = '%@' and ass_pinnumber = '%@'",[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"],[[NSUserDefaults standardUserDefaults] valueForKey:@"asspinnumber"]]]];
    
    
    //-------------------------     Title Array     ------------------------------
    arytasktitle = [[NSMutableArray alloc]init];
    arytasktitle = [DatabaseAccess get_assessmentTasktitle:[NSString stringWithFormat:@"SELECT title from tbl_assessment_task_part where assessment_task_id in(select assessment_task_id from tbl_assessment_Task where cast(resource_id as int) = %@ order by  cast(assessment_task_id as int) asc) order by assessment_task_id asc",globle_resource_id]];
    NSLog(@"%@",arytasktitle);
    NSLog(@"%d",[arytasktitle count]);
    NSLog(@"%d",350 + ([arytasktitle count]*70));
    tWidht = 350 + ([arytasktitle count]*70);
    //--------------------------------  Fill webview    ------------------------------
    /*
    [webView setOpaque:NO];
    //[thirdpartyinfo setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"queBG.png"]]];
    webView.delegate = self;
    
    [webView loadHTMLString:embedHTML baseURL:nil];
    */
    NSString* embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@</body></html>",[[aryCompetency objectAtIndex:0] valueForKey:@"Description"]];
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
    //------------------------------- Tableview     -------------------------------------
    if (_tableView!=nil)
    {
        [_tableView removeFromSuperview];
        _tableView=nil;
    }
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,tWidht,824) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [scrView addSubview:_tableView];
    [footImage setFrame:CGRectMake(0, 0, tWidht, 51)];
    [_tableView setTableFooterView:footerView];
    
    [scrView setContentSize:CGSizeMake(tWidht, 824)];
    
    
    
    //---------------------------------     Array Declaration   -----------------------
    selectedIndexes = [[NSMutableArray alloc]init];
    aryButtons = [[NSMutableArray alloc]init];
    aryCompetencyQuestions = [[NSMutableArray alloc]init];
    
    //---------------------------------     Update  -----------------------------------
    if([aryCompetencyAnswer count]>0)
    {
        [aryCompetencyAnswer removeAllObjects];
        aryCompetencyAnswer = [[NSMutableArray alloc]init];
        
        for(int act=0;act<[aryCompetencyTask count];act++)
        {
            [aryCompetencyQuestions addObject:[DatabaseAccess get_tbl_CompetencyTaskQuestions:[NSString stringWithFormat:@"select *from tbl_CompetencyTaskQuestions where cast(competencytaskid as int) = %@",[[aryCompetencyTask objectAtIndex:act] valueForKey:@"CompetencyTaskID"]]]];
            
            [aryCompetencyAnswer addObject:[DatabaseAccess get_tbl_CompetencyTaskAnswer:[NSString stringWithFormat:@"select *from tbl_CompetencyTaskAnswer where cast(ResourceID as int) = %@ and cast(competencytaskid as int) = %@ and ParticipantID = '%@'",globle_resource_id,[[aryCompetencyTask objectAtIndex:act] valueForKey:@"CompetencyTaskID"],globle_participant_id]]];
            NSLog(@"%@",aryCompetencyAnswer);
            
            tempArray1 = [[NSMutableArray alloc]init];
            for(int x=0;x<[[aryCompetencyAnswer objectAtIndex:act] count];x++)
            {
                NSLog(@"%@",[[[aryCompetencyAnswer objectAtIndex:act] objectAtIndex:x] valueForKey:@"Answer"]);
                NSArray *aryNT = [[NSMutableArray alloc]init];
                aryNT = [[[[aryCompetencyAnswer objectAtIndex:act] objectAtIndex:x] valueForKey:@"Answer"] componentsSeparatedByString:@","];
                NSLog(@"%@",aryNT);
                [tempArray1 addObject:aryNT];

                //[tempArray1 addObject:[[[aryCompetencyAnswer objectAtIndex:act] objectAtIndex:x] valueForKey:@"Answer"]];
                //NSLog(@"%@",[[[aryCompetencyAnswer objectAtIndex:act] objectAtIndex:x] valueForKey:@"Answer"]);
            }
            [aryButtons addObject:tempArray1];
            NSLog(@"%@",aryButtons);
        }
        NSLog(@"%@",aryButtons);
    }
    else
    {
        for(int act=0;act<[aryCompetencyTask count];act++)
        {
            [aryCompetencyQuestions addObject:[DatabaseAccess get_tbl_CompetencyTaskQuestions:[NSString stringWithFormat:@"select *from tbl_CompetencyTaskQuestions where cast(competencytaskid as int) = %@",[[aryCompetencyTask objectAtIndex:act] valueForKey:@"CompetencyTaskID"]]]];
            
            tempArray1 = [[NSMutableArray alloc]init];
            for(int x=0;x<[[aryCompetencyQuestions objectAtIndex:act] count];x++)
            {
                NSMutableArray *aryNT = [[NSMutableArray alloc]init];
                for(int l=0;l<[arytasktitle count];l++)
                {
                    [aryNT addObject:@"999"];
                }
                [tempArray1 addObject:aryNT];
            }
            [aryButtons addObject:tempArray1];
            NSLog(@"%@",aryButtons);
        }
    }
    for(int y=0;y<[aryCompetencyTask count]*2;y++)
    {
        [selectedIndexes insertObject:@"0" atIndex:y];
    }
}

#pragma mark - UITableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowcount = ([aryCompetencyTask count]*2);
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
            NSLog(@"%@",[aryCompetencyQuestions objectAtIndex:((indexPath.row + 1)/2)-1]);
            int recordcount = [[aryCompetencyQuestions objectAtIndex:((indexPath.row + 1)/2)-1] count];
            NSLog(@"%d",[[aryCompetencyQuestions objectAtIndex:((indexPath.row + 1)/2)-1] count]);
            if(recordcount >0)
            {
                int s = recordcount * 46;
                return s;
            }
            else
            {
                return 0;
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
        [cellBg setFrame:CGRectMake(0,0,tWidht,44)];
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
        [lblTitle setText:[[aryCompetencyTask objectAtIndex:indexPath.row/2] valueForKey:@"Description"]];
        [cell addSubview:lblTitle];
    }
    else
    {
        if([[selectedIndexes objectAtIndex:indexPath.row] isEqualToString:@"0"])
            [cell setHidden:TRUE];
        else
        {
            tempArray2 = [[NSMutableArray alloc]initWithArray:[aryCompetencyQuestions objectAtIndex:((indexPath.row - 1)/2)]];
            int top=0;
            
            //----------    If ther is Record  ------------
            for(int y=0;y<[tempArray2 count];y++)
            {
                if([[[tempArray2 objectAtIndex:y]valueForKey:@"parentquestionid"] isEqualToString:@"null"])
                {
                    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, top, tWidht, 46)];
                    [iv setBackgroundColor:[UIColor colorWithRed:0.047f green:0.172f blue:0.321f alpha:1]];
                    [iv setOpaque:NO];
                    [cell addSubview:iv];
                    
                    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(25, top, 300, 46)];
                    [lblTitle setText:[[tempArray2 objectAtIndex:y] valueForKey:@"Description"]];
                    [lblTitle setTextColor:[UIColor whiteColor]];
                    [lblTitle setLineBreakMode:NSLineBreakByTruncatingTail];
                    [lblTitle setBackgroundColor:[UIColor clearColor]];
                    [cell addSubview:lblTitle];
                    
                    int left = 350;
                    for(int k=0;k<[arytasktitle count];k++)
                    {
                        UILabel *lblTitle_2 = [[UILabel alloc]initWithFrame:CGRectMake(left, top, 70, 46)];
                        [lblTitle_2 setText:[[arytasktitle objectAtIndex:k] valueForKey:@"title"]];
                        [lblTitle_2 setTextAlignment:NSTextAlignmentCenter];
                        [lblTitle_2 setTextColor:[UIColor whiteColor]];
                        [lblTitle_2 setBackgroundColor:[UIColor clearColor]];
                        [cell addSubview:lblTitle_2];
                        left = left + 70;
                    }
                    top = top + 46;
                }
                else
                {
                    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, top, tWidht, 46)];
                    [iv setImage:[UIImage imageNamed:@"queBG.png"]];
                    [iv setOpaque:NO];
                    [cell addSubview:iv];
                    
                    UILabel *lblTitle_3 = [[UILabel alloc]initWithFrame:CGRectMake(25, top, 300, 46)];
                    [lblTitle_3 setText:[[tempArray2 objectAtIndex:y] valueForKey:@"Description"]];
                    [lblTitle_3 setLineBreakMode:NSLineBreakByWordWrapping];
                    [lblTitle_3 setNumberOfLines:3];
                    [lblTitle_3 setTextColor:[UIColor darkGrayColor]];
                    [lblTitle_3 setBackgroundColor:[UIColor clearColor]];
                    [cell addSubview:lblTitle_3];
                    
                    int left = 350;
                    //int selectedTick = [[[aryButtons objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:y] intValue];
                    NSLog(@"%@",aryButtons);
                    NSLog(@"%@",[aryButtons objectAtIndex:(indexPath.row - 1)/2]);
                    NSLog(@"%@",[[aryButtons objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:y]);
                    NSMutableArray *arSel = [[NSMutableArray alloc]initWithArray:[[aryButtons objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:y]];
                    for(int k=0;k<[arytasktitle count];k++)
                    {
                        NSLog(@"%@",[arSel objectAtIndex:k]);
                        TickButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        [TickButton setTag:y];
                        [TickButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                        [TickButton setTitle:[NSString stringWithFormat:@"%d",k] forState:UIControlStateNormal];
                        if([[arSel objectAtIndex:k] intValue]==k)
                        {
                            NSLog(@"%@",[arSel objectAtIndex:k]);
                            NSLog(@"%d",k);
                            [TickButton setImage:[UIImage imageNamed:@"tick_enable.png"] forState:UIControlStateNormal];
                            [TickButton setSelected:TRUE];
                        }
                        else
                        {
                            [TickButton setImage:[UIImage imageNamed:@"tick_disable.png"] forState:UIControlStateNormal];
                            [TickButton setSelected:FALSE];
                        }
                        
                        [TickButton setFrame:CGRectMake(left, top, 70, 46)];
                        [TickButton addTarget:self action:@selector(btnDeleteTickTapped:)
                            forControlEvents:UIControlEventTouchDown];
                        [cell addSubview:TickButton];
                        
                        left = left + 70;
                    }
                    top = top + 46;
                }
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Button Event

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
    
    //NSLog(@"%d",[sender tag]);
    UIButton *btn = (UIButton*)sender;
    //NSLog(@"%@",btn.currentImage.description);
    //NSLog(@"%@",btn.currentTitle);
    //NSLog(@"%c",btn.selected);
    if(btn.selected==TRUE)
    {
        [[[aryButtons objectAtIndex:((chatindex.row + 1)/2)-1] objectAtIndex:[sender tag]] replaceObjectAtIndex:[[btn currentTitle] intValue] withObject:@"9"];
    }
    else
    {
        [[[aryButtons objectAtIndex:((chatindex.row + 1)/2)-1] objectAtIndex:[sender tag]] replaceObjectAtIndex:[[btn currentTitle] intValue] withObject:[btn currentTitle]];
    }
    //NSLog(@"%@",aryButtons);
    //NSLog(@"%@",[aryButtons objectAtIndex:((chatindex.row + 1)/2)-1]);
    
    [_tableView reloadData];
}

-(IBAction)continueButtonTapped:(id)sender
{
    if([aryCompetencyAnswer count]>0)
    {
        for(int a=0;a<[aryCompetencyTask count];a++)
        {
            NSMutableArray *tempArray4 = [[NSMutableArray alloc]initWithArray:[aryCompetencyAnswer objectAtIndex:a]];
            for(int b=0;b<[tempArray4 count];b++)
            {
                NSString *CAnsID = [[[aryCompetencyAnswer objectAtIndex:a] objectAtIndex:b] valueForKey:@"CAnsID"];
                NSString *strAnswer = [[[aryButtons objectAtIndex:a]objectAtIndex:b] componentsJoinedByString:@","];
                NSLog(@"%@",strAnswer);
                [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"update tbl_CompetencyTaskAnswer set Answer = '%@' where cast(CAnsID as int) = %@",strAnswer,CAnsID]];
            }
        }
    }
    else
    {
        for(int a=0;a<[aryCompetencyTask count];a++)
        {
            NSMutableArray *tempArray4 = [[NSMutableArray alloc]initWithArray:[aryCompetencyQuestions objectAtIndex:a]];
            for(int b=0;b<[tempArray4 count];b++)
            {
                NSString *strOutlineID = [[aryCompetencyTask objectAtIndex:a] valueForKey:@"CompetencyOutlineID"];
                NSString *strCTaskID = [[tempArray4 objectAtIndex:b] valueForKey:@"competencytaskid"];
                NSString *strQueID = [[tempArray4 objectAtIndex:b] valueForKey:@"competencyquestionid"];
                NSString *strAnswer = [[[aryButtons objectAtIndex:a]objectAtIndex:b] componentsJoinedByString:@","];
                NSLog(@"%@",strAnswer);
                [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"insert into tbl_CompetencyTaskAnswer(ResourceID,CompetencyOutlineID,CompetencyTaskID,CompetencyQuestionID,ParticipantID,AssessorID,Answer) values('%@','%@','%@','%@','%@','%@','%@')",globle_resource_id,strOutlineID,strCTaskID,strQueID,globle_participant_id,[[aryAssessorInfo objectAtIndex:0] valueForKey:@"ass_empid"],strAnswer]];
            }
        }
    }
    
    NSArray *vList = [[self navigationController] viewControllers];
    UIViewController *view;
    for (int i=[vList count]-1; i>=0; --i) {
        view = [vList objectAtIndex:i];
        if ([view.nibName isEqualToString:@"AssessmentsVIewController"])
            break;
    }
    [[self navigationController] popToViewController:view animated:YES];
}

-(IBAction)exitButtonTapped:(id)sender
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
