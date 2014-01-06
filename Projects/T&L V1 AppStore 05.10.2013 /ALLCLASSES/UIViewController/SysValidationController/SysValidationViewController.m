//
//  SysValidationViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/4/12.
//
//

#import "SysValidationViewController.h"
#import "GlobleClass.h"

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



@interface SysValidationViewController ()

@end

@implementation SysValidationViewController
CGFloat animatedDistance;
@synthesize tableArray;
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
    NSLog(@"%@",arySysValidationOption);
    lblTitle1.text = globle_UnitName;
    [lblTitle2 setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];
    
   
    
    //------------------------- assessor information    ------------------------
    //----Fill webview
    aryAssessorInfo = [[NSMutableArray alloc]initWithArray:[DatabaseAccess get_assessor_information:[NSString stringWithFormat:@"select *from tbl_assessor where ass_name = '%@' and ass_pinnumber = '%@'",[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"],[[NSUserDefaults standardUserDefaults] valueForKey:@"asspinnumber"]]]];
    //----------- webview -----------------------
    NSString* embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@</body></html>",strDescription];
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
    
    
    //---------------- tableview-------
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
    
    
    NSLog(@"%@",arySysValidationOption);
    
    self.tableArray = [[NSMutableArray alloc] init];
    for(int x=0;x<[arySysValidationOption count];x++)
    {
        [self.tableArray addObject:[[arySysValidationOption objectAtIndex:x]valueForKey:@"TypeofValidation"]];
    }
    
    textFieldValue = [[NSMutableArray alloc]init];
    selectedIndexes = [[NSMutableArray alloc] init];
    for(int i=0;i<[arySysValidationOption count]*2;i++)
    {
        [selectedIndexes insertObject:@"0" atIndex:i];
    }
    
    if([arySysValidationAnswer count]>0)
    {
        
        for(int i=0;i<[arySysValidationAnswer count];i++)
        {
            NSLog(@"%@",[arySysValidationAnswer objectAtIndex:i]);
            NSMutableArray *ar = [[NSMutableArray alloc]init];
            [ar insertObject:[[arySysValidationAnswer objectAtIndex:i]valueForKey:@"ScheduleDate"] atIndex:0];
            [ar insertObject:[[arySysValidationAnswer objectAtIndex:i]valueForKey:@"Process"] atIndex:1];
            [ar insertObject:[[arySysValidationAnswer objectAtIndex:i]valueForKey:@"Participants_1"] atIndex:2];
            [ar insertObject:[[arySysValidationAnswer objectAtIndex:i]valueForKey:@"Participants_2"] atIndex:3];
            [ar insertObject:[[arySysValidationAnswer objectAtIndex:i]valueForKey:@"Participants_3"] atIndex:4];
            [ar insertObject:[[arySysValidationAnswer objectAtIndex:i]valueForKey:@"Participants_4"] atIndex:5];
            [ar insertObject:[[arySysValidationAnswer objectAtIndex:i]valueForKey:@"Participants_5"] atIndex:6];
            [ar insertObject:[[arySysValidationAnswer objectAtIndex:i]valueForKey:@"OutCome"] atIndex:7];
            
            [textFieldValue addObject:ar];
        }
        NSLog(@"%@",textFieldValue);
    }
    else
    {
        for(int i=0;i<[self.tableArray count];i++)
        {
            NSMutableArray *ar = [[NSMutableArray alloc]init];
            for(int j = 0;j<8;j++)
            {
                [ar insertObject:@"" atIndex:j];
            }
            [textFieldValue addObject:ar];
        }
        NSLog(@"%@",textFieldValue);
    }
    NSLog(@"%@",arySysValidationOption);
    NSLog(@"%@",arySysValidationAnswer);
    [_tableView reloadData];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - UITableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arySysValidationOption count] * 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"%d",indexPath.row);
    if (indexPath.row % 2 == 0)
    {
        return 44;
    }
    else
    {
        if([[selectedIndexes objectAtIndex:indexPath.row]isEqualToString:@"1"])
        {
            return 422;
        }
        else
        {
            return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == Nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [[NSBundle mainBundle]loadNibNamed:@"CCellSysValidationViewController" owner:self options:Nil];
    }
    
    
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
        [lblTitle setText:[tableArray objectAtIndex:indexPath.row / 2]];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:lblTitle];
    }
    else
    {
        [[NSBundle mainBundle]loadNibNamed:@"CCellSysValidationViewController" owner:self options:Nil];
        cell=customCell;
        if([[selectedIndexes objectAtIndex:indexPath.row] isEqualToString:@"0"])
            [cell setHidden:TRUE];
        else
        {
            [cell setHidden:FALSE];
            NSLog(@"%d",((indexPath.row - 1)/2));
            [tfSDate setText:[[textFieldValue objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:0]];
            [tfProcess setText:[[textFieldValue objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:1]];
            [tfP1 setText:[[textFieldValue objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:2]];
            [tfP2 setText:[[textFieldValue objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:3]];
            [tfP3 setText:[[textFieldValue objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:4]];
            [tfP4 setText:[[textFieldValue objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:5]];
            [tfP5 setText:[[textFieldValue objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:6]];
            [tfOutcome setText:[[textFieldValue objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:7]];
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


#pragma mark - textfield delegate method
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField             //Fine
{
	return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField_2
{
    temptf = textField_2;
    //UITableViewCell* tempCell =  (UITableViewCell*)[textField_2 superview];
    //NSIndexPath *chatindex = [_tableView indexPathForCell:tempCell];
    
    CGRect textVWRect = [self.view.window convertRect:textField_2.bounds fromView:textField_2];
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


-(void)textFieldDidEndEditing:(UITextField *)textField_1
{
    UITableViewCell* tempCell =  (UITableViewCell*)[[textField_1 superview ] superview];
    NSIndexPath *chatindex = [_tableView indexPathForCell:tempCell];
    
    NSLog(@"%d",((chatindex.row + 1)/2));
    NSLog(@"%d",chatindex.section);
    NSLog(@"%d",chatindex.row);
    NSLog(@"%d",((chatindex.row - 1)/2));
    NSLog(@"%d",textField_1.tag);
    [[textFieldValue objectAtIndex:((chatindex.row - 1)/2)]  replaceObjectAtIndex:textField_1.tag withObject:textField_1.text];
    NSLog(@"%@",textFieldValue);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField              //Fine
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField                  //Fine
{
	[textField resignFirstResponder];
	return YES;
}


#pragma mark - Button Event
-(IBAction)continueButtonTapped:(id)sender
{
    if (temptf != nil)
    {
        [self textFieldDidEndEditing:temptf];
    }
    
    NSLog(@"%@",textFieldValue);
    for(int i=0;i<[arySysValidationOption count];i++)
    {
        NSLog(@"%@",[textFieldValue objectAtIndex:i]);
        if([arySysValidationAnswer count]>0)
        {
            NSString *strQuery = [NSString stringWithFormat:@"update tbl_SysValidationOptionsAnswer set ScheduleDate = '%@',Process = '%@',Participants_1 = '%@',Participants_2 = '%@',Participants_3 = '%@',Participants_4 = '%@',Participants_5 = '%@',OutCome = '%@' where cast(VOAAutoID as int) = %@",[[textFieldValue objectAtIndex:i]objectAtIndex:0],[[textFieldValue objectAtIndex:i]objectAtIndex:1],[[textFieldValue objectAtIndex:i]objectAtIndex:2],[[textFieldValue objectAtIndex:i]objectAtIndex:3],[[textFieldValue objectAtIndex:i]objectAtIndex:4],[[textFieldValue objectAtIndex:i]objectAtIndex:5],[[textFieldValue objectAtIndex:i]objectAtIndex:6],[[textFieldValue objectAtIndex:i]objectAtIndex:7],[[arySysValidationAnswer objectAtIndex:i]valueForKey:@"VOAAutoID"]];
            NSLog(@"%@",strQuery);
            [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
        }
        else
        {
            NSString *strQuery = [NSString stringWithFormat:@"Insert into tbl_SysValidationOptionsAnswer (ValidationID,ResourceID,EntryID,ScheduleDate,Process,Participants_1,Participants_2,Participants_3,Participants_4,Participants_5,OutCome,ParticipantID,AssessorID) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[[arySysValidationOption objectAtIndex:i]valueForKey:@"ValidationID"],globle_resource_id,[[arySysValidationOption objectAtIndex:i]valueForKey:@"EntryID"],[[textFieldValue objectAtIndex:i]objectAtIndex:0],[[textFieldValue objectAtIndex:i]objectAtIndex:1],[[textFieldValue objectAtIndex:i]objectAtIndex:2],[[textFieldValue objectAtIndex:i]objectAtIndex:3],[[textFieldValue objectAtIndex:i]objectAtIndex:4],[[textFieldValue objectAtIndex:i]objectAtIndex:5],[[textFieldValue objectAtIndex:i]objectAtIndex:6],[[textFieldValue objectAtIndex:i]objectAtIndex:7],globle_participant_id,[[NSUserDefaults standardUserDefaults] valueForKey:@"assempid"]];
            [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
        }
    }
       
    
    /*
    NSArray *vList = [[self navigationController] viewControllers];
    UIViewController *view;
    for (int i=[vList count]-1; i>=0; --i) {
        view = [vList objectAtIndex:i];
        if ([view.nibName isEqualToString:@"AssessmentsVIewController"])
            break;
    }
    [[self navigationController] popToViewController:view animated:YES];
    */
    [self performSelector:@selector(exitButtonTapped)];
}

-(IBAction)exitButtonTapped
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
