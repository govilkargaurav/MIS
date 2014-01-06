//
//  ContexualizationViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContexualizationViewController.h"
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

@interface ContexualizationViewController ()

@end

@implementation ContexualizationViewController
CGFloat animatedDistance;
@synthesize tableArray,indexPathSelected,detailCellArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //------------------------- assessor information    ------------------------
    aryAssessorInfo = [[NSMutableArray alloc]initWithArray:[DatabaseAccess get_assessor_information:[NSString stringWithFormat:@"select *from tbl_assessor where ass_name = '%@' and ass_pinnumber = '%@'",[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"],[[NSUserDefaults standardUserDefaults] valueForKey:@"asspinnumber"]]]];

    aryContextOption = [[NSMutableArray alloc]initWithArray:[DatabaseAccess getalltblcontextOption:[NSString stringWithFormat:@"Select *from tbl_Contextualisation_Option where cast(ResourceID as int) = %@",globle_resource_id]]];
    
    if([aryContextOption count]>0)
    {
        lblTitle1.text = globle_UnitName;
        [lblTitle2 setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];
        //----Fill webview
        NSString* embedHTML = [NSString stringWithFormat:@"<html><body style='font-family:arial;color:#000000;font-size:16px;'>%@</body></html>",contextualisationDescription];
        [tvWebContent resignFirstResponder];
        [tvWebContent setContentToHTMLString:embedHTML];
        [tvWebContent setEditable:NO];
        [tvWebContent setTag:NO];
        tvWebContent.scrollEnabled = NO;
        tvWebContent.opaque = NO;
        tvWebContent.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0); //UIEdgeInsetsMake(-4,-8,0,0);
        [tvWebContent setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"queBG.png"]]];
        
        CGRect frame = tvWebContent.frame;
        frame.size.height = tvWebContent.contentSize.height;
        tvWebContent.frame = frame;
        NSLog(@"%f",frame.size.height);
        
        //---------------- tableview-------
        if (_tableView!=nil)
        {
            [_tableView removeFromSuperview];
            _tableView=nil;
        }
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,frame.size.height+55,768,1004-frame.size.height-60) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView setTableFooterView:footerView];

        
        self.tableArray = [NSMutableArray arrayWithObjects:@"Reference item 1", @"Reference item 2", @"Reference item 3", @"Reference item 4", @"Reference item 5",nil];
        
        
        selectedIndexes = [[NSMutableArray alloc] init];
        for(int i=0;i<[aryContextOption count]*2;i++)
        {
            [selectedIndexes insertObject:@"0" atIndex:i];
        }
        
        aryContexOptionAnswer = [[NSMutableArray alloc]init];
        aryContexOptionAnswer = [DatabaseAccess getalltblcontextoptionanswer:[NSString stringWithFormat:@"select *from tbl_Contextualisation_Option_Answer where cast(ResourceID as int)=%@ and cast(ContextualisationID as int)=%@ and ParticipantID ='%@' order by cast(COAAutoID as int)",globle_resource_id,[[aryContextOption objectAtIndex:0]valueForKey:@"contexID"],globle_participant_id]];
        
        textFieldValue = [[NSMutableArray alloc]init];
        
        NSLog(@"%@",aryContexOptionAnswer);
        if([aryContexOptionAnswer count]>0)
        {
            
            for(int i=0;i<[aryContexOptionAnswer count];i++)
            {
                NSMutableArray *ar = [[NSMutableArray alloc]init];
                [ar insertObject:[[aryContexOptionAnswer objectAtIndex:i]valueForKey:@"reference"] atIndex:0];
                [ar insertObject:[[aryContexOptionAnswer objectAtIndex:i]valueForKey:@"description"] atIndex:1];
                [ar insertObject:[[aryContexOptionAnswer objectAtIndex:i]valueForKey:@"relationship"] atIndex:2];
                [ar insertObject:[[aryContexOptionAnswer objectAtIndex:i]valueForKey:@"comments"] atIndex:3];
                [textFieldValue addObject:ar];
            }
            NSLog(@"%@",textFieldValue);
        }
        else
        {
            for(int i=0;i<[aryContextOption count];i++)
            {
                NSMutableArray *ar = [[NSMutableArray alloc]init];
                for(int j = 0;j<4;j++)
                {
                    [ar insertObject:@"" atIndex:j];
                }
                [textFieldValue addObject:ar];
            }
            NSLog(@"%@",textFieldValue);
        }
    }
    else
    {
        alertNoContextOption = [[UIAlertView alloc] initWithTitle:@"T&L" message:@"No records found !!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertNoContextOption show];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - UITableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryContextOption count] * 2;
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
            return 273;
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
        [[NSBundle mainBundle]loadNibNamed:@"CellContexualizationViewController" owner:self options:Nil];
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
        [[NSBundle mainBundle]loadNibNamed:@"CellContexualizationViewController" owner:self options:Nil];
        cell=customCell;
        if([[selectedIndexes objectAtIndex:indexPath.row] isEqualToString:@"0"]) 
            [cell setHidden:TRUE];
        else
        {
            [cell setHidden:FALSE];
            NSLog(@"%d",((indexPath.row - 1)/2));
            [tf_1 setText:[[textFieldValue objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:0]];
            [tf_2 setText:[[textFieldValue objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:1]];
            [tf_3 setText:[[textFieldValue objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:2]];
            [tf_4 setText:[[textFieldValue objectAtIndex:((indexPath.row - 1)/2)] objectAtIndex:3]];
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
-(void)textFieldDidBeginEditing:(UITextField *)textField_2
{
    temptf = textField_2;
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField             //Fine
{
	return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField_1
{
    UITableViewCell* tempCell =  (UITableViewCell*)[[textField_1 superview ] superview];
    NSIndexPath *chatindex = [_tableView indexPathForCell:tempCell];
    
    NSLog(@"%d",((chatindex.row + 1)/2));
    NSLog(@"%d",chatindex.section);
    NSLog(@"%d",chatindex.row);
    NSLog(@"%d",((chatindex.row - 1)/2));
    [[textFieldValue objectAtIndex:((chatindex.row - 1)/2)]  replaceObjectAtIndex:textField_1.tag withObject:textField_1.text];
    
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


#pragma mark - UIAlertView Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self exitButtonTapped:nil];
}



#pragma mark - Button Event
-(IBAction)continueButtonTapped:(id)sender
{
    if(temptf !=nil)
        [self textFieldDidEndEditing:temptf];
    NSLog(@"%@",aryContextOption);
    NSLog(@"%@",textFieldValue);
    for(int i=0;i<[aryContextOption count];i++)
    {
        if([aryContexOptionAnswer count]>0)
        {
            NSString *strQuery = [NSString stringWithFormat:@"update tbl_Contextualisation_Option_Answer set reference = '%@',description = '%@',relationship = '%@',comments = '%@' where cast(COAAutoID as int) = %@",[[textFieldValue objectAtIndex:i]objectAtIndex:0],[[textFieldValue objectAtIndex:i]objectAtIndex:1],[[textFieldValue objectAtIndex:i]objectAtIndex:2],[[textFieldValue objectAtIndex:i]objectAtIndex:3],[[aryContexOptionAnswer objectAtIndex:i]valueForKey:@"coaautoid"]];
            NSLog(@"%@",strQuery);
            [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
        }
        else
        {
            NSString *strQuery = [NSString stringWithFormat:@"Insert into tbl_Contextualisation_Option_Answer (Contextualisation_entriesID,reference,description,relationship,comments,ContextualisationID,ResourceID,ParticipantID,AssessorID) values('%@','%@','%@','%@','%@','%@','%@','%@','%@')",[[aryContextOption objectAtIndex:i]valueForKey:@"conentriesID"],[[textFieldValue objectAtIndex:i]objectAtIndex:0],[[textFieldValue objectAtIndex:i]objectAtIndex:1],[[textFieldValue objectAtIndex:i]objectAtIndex:2],[[textFieldValue objectAtIndex:i]objectAtIndex:3],[[aryContextOption objectAtIndex:i]valueForKey:@"contexID"],[[aryContextOption objectAtIndex:i]valueForKey:@"resourceid"],globle_participant_id,[[NSUserDefaults standardUserDefaults] valueForKey:@"assempid"]];
            [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];

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

@end
