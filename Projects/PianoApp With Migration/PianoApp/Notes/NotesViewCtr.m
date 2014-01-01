//
//  NotesViewCtr.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotesViewCtr.h"
#import "AddNotesViewCtr.h"
#import "OverlayViewController.h"
#import "AppDelegate.h"

@implementation NotesViewCtr

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
    
    NSString *strQuery_Select_Notes =[NSString stringWithFormat:@"SELECT * FROM tbl_notes"];
    ArryNotes = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_notes:strQuery_Select_Notes]];
    
    //Initialize the copy array.
	copyListOfItems = [[NSMutableArray alloc] init];
		
	//Add the search bar
	tbl_notes.tableHeaderView = searchBar;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
	searching = NO;
	letUserSelectRow = YES;
    
    for (UITextField *tf in searchBar.subviews)
    {
        if ([tf isKindOfClass:[UITextField class]])
        {
            tf.font = [UIFont fontWithName:@"GillSans-Light" size:18.0];
        }
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
    
    // Add iAd
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdShowSetFrame) name:@"iAdShowSetFrame" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdHideSetFrame) name:@"iAdHideSetFrame" object:nil];
    
    if (AppDel.isiAdVisible)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
        if (isiPhone5)
        {
            tbl_notes.frame = CGRectMake(0, 44, 320, 454);
        }
        else
        {
            tbl_notes.frame = CGRectMake(0, 44, 320, 366);
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
        if (isiPhone5)
        {
            tbl_notes.frame = CGRectMake(0, 44, 320, 504);
        }
        else
        {
            tbl_notes.frame = CGRectMake(0, 44, 320, 416);
        }
    }
    
    NSString *strQuery_Select_Notes =[NSString stringWithFormat:@"SELECT * FROM tbl_notes"];
    ArryNotes = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_notes:strQuery_Select_Notes]];
    [tbl_notes reloadData];
}
// Set Frame OF view according to iAd show/hide
-(void)iAdShowSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_notes.frame = CGRectMake(0, 44, 320, 454);
    }
    else
    {
        tbl_notes.frame = CGRectMake(0, 44, 320, 366);
    }
}
-(void)iAdHideSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_notes.frame = CGRectMake(0, 44, 320, 504);
    }
    else
    {
        tbl_notes.frame = CGRectMake(0, 44, 320, 416);
    }
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searching)
		return [copyListOfItems count];
	else 
    {
        return [ArryNotes count];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    UIImageView *imgEditable = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
    imgEditable.contentMode = UIViewContentModeScaleAspectFill;
    imgEditable.image = [UIImage imageNamed:@"Editable_note.png"];
    imgEditable.hidden = YES;
    [cell addSubview:imgEditable];
    
    
    UILabel *lblTitle1=[[UILabel alloc] init];
    lblTitle1.frame=CGRectMake(7,7,200,30);
    lblTitle1.backgroundColor=[UIColor clearColor];
    lblTitle1.textColor = RGBCOLOR(65, 65, 65);
    lblTitle1.textAlignment=UITextAlignmentLeft;
    lblTitle1.font = [UIFont fontWithName:@"GillSans" size:18.0];
    lblTitle1.lineBreakMode = UILineBreakModeTailTruncation;
    if(searching) 
    {
        lblTitle1.text=[NSString stringWithFormat:@"%@",[[copyListOfItems objectAtIndex:indexPath.row]valueForKey:@"notesdesc"]];
    }
	else
    {
        lblTitle1.text=[NSString stringWithFormat:@"%@",[[ArryNotes objectAtIndex:indexPath.row]valueForKey:@"notesdesc"]];
    }
    [cell addSubview:lblTitle1];
    
    UILabel *lblTitle2=[[UILabel alloc] init];
    lblTitle2.frame=CGRectMake(225,7,70,30);
    lblTitle2.backgroundColor=[UIColor clearColor];
    lblTitle2.textColor=[UIColor orangeColor];
    lblTitle2.textAlignment=UITextAlignmentRight;
    lblTitle2.font=[UIFont fontWithName:@"GillSans" size:12.0];;
    lblTitle2.lineBreakMode = UILineBreakModeTailTruncation;
    
    
    NSString *strEditableStatus = [NSString stringWithFormat:@"%@",[[ArryNotes objectAtIndex:indexPath.row]valueForKey:@"editable"]];

    if([[NSUserDefaults standardUserDefaults] boolForKey:@"IhavePurchasedApp"])
    {
        imgEditable.hidden = NO;
        lblTitle1.frame=CGRectMake(42,7,183,30);
    }
    
    if ([strEditableStatus intValue] == 1)
    {
        imgEditable.image = [UIImage imageNamed:@"Editable_note_selected.png"];
        lblTitle2.textColor = RGBCOLOR(65, 65, 65);
    }
    
    
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *strsrch;
    if(searching) 
    {
        strsrch=[NSString stringWithFormat:@"%@",[[copyListOfItems objectAtIndex:indexPath.row]valueForKey:@"ndate"]];
    }
	else
    {
        strsrch=[NSString stringWithFormat:@"%@",[[ArryNotes objectAtIndex:indexPath.row]valueForKey:@"ndate"]];
    }

    NSDate *StartDate=[dateFormatter dateFromString:strsrch];
    
    
    NSDate *Date2 = [NSDate date];
    NSString *str2=[dateFormatter stringFromDate:Date2];
    NSDate *EndDate=[dateFormatter dateFromString:str2];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:EndDate
                                                  toDate:StartDate options:0];
    int days = [components day];
    if (days == 0)
    {
       lblTitle2.text=@"Today"; 
    }
    else if (days == -1)
    {
        lblTitle2.text=@"Yesterday";
    }
    else
    {
        if(searching) 
        {
            lblTitle2.text=[NSString stringWithFormat:@"%@",[[copyListOfItems objectAtIndex:indexPath.row]valueForKey:@"ndate"]];
        }
        else
        {
            lblTitle2.text=[NSString stringWithFormat:@"%@",[[ArryNotes objectAtIndex:indexPath.row]valueForKey:@"ndate"]];
        }
    }
    [cell addSubview:lblTitle2];
    
    // }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell.
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddNotesViewCtr *obj_AddNotesViewCtr=[[AddNotesViewCtr alloc]initWithNibName:@"AddNotesViewCtr" bundle:nil];
    obj_AddNotesViewCtr.strEdit=@"Edit";
    if(searching) 
    {
        obj_AddNotesViewCtr.strPassID = [NSString stringWithFormat:@"%@",[[copyListOfItems objectAtIndex:indexPath.row]valueForKey:@"id"]];
    }
    else
    {
        obj_AddNotesViewCtr.strPassID = [NSString stringWithFormat:@"%@",[[ArryNotes objectAtIndex:indexPath.row]valueForKey:@"id"]];
    }
    [self.navigationController pushViewController:obj_AddNotesViewCtr animated:YES];
    obj_AddNotesViewCtr=nil;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        NSString *strDeleteID,*strLocked;
        if(searching) 
        {
            strDeleteID = [NSString stringWithFormat:@"%@",[[copyListOfItems objectAtIndex:indexPath.row]valueForKey:@"id"]];
            strLocked = [NSString stringWithFormat:@"%@",[[copyListOfItems objectAtIndex:indexPath.row]valueForKey:@"editable"]];
        }
        else
        {
            strDeleteID = [NSString stringWithFormat:@"%@",[[ArryNotes objectAtIndex:indexPath.row]valueForKey:@"id"]];
            strLocked = [NSString stringWithFormat:@"%@",[[ArryNotes objectAtIndex:indexPath.row]valueForKey:@"editable"]];
        }
        
        if ([strLocked intValue] == 1)
        {
            UIAlertView *alert_View = [[UIAlertView alloc]initWithTitle:APP_NAME message:@"This note is locked. You can not delete." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert_View show];
        }
        else
        {
            NSString *strQuery_Delete_Notes = [NSString stringWithFormat:@"DELETE FROM tbl_notes where id=%d",[strDeleteID intValue]];
            [DatabaseAccess InsertUpdateDeleteQuery:strQuery_Delete_Notes];
            
            NSString *strQuery_Select_Notes =[NSString stringWithFormat:@"SELECT * FROM tbl_notes"];
            ArryNotes = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_notes:strQuery_Select_Notes]];
            [self doneSearching_Clicked];
        }
    }
}
#pragma mark -
#pragma mark Search Bar 

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//This method is called again when the user clicks back from teh detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	if(searching)
		return;
	
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;	
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.rvController = self;
	
	[tbl_notes insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	tbl_notes.scrollEnabled = NO;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		tbl_notes.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		[tbl_notes insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		searching = NO;
		letUserSelectRow = NO;
		tbl_notes.scrollEnabled = NO;
	}
	
	[tbl_notes reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchTableView];
}

- (void) searchTableView {
	
	NSString *searchText = searchBar.text;
    NSString *strSearch =[NSString stringWithFormat:@"SELECT * FROM tbl_notes where notesdesc LIKE '%%%@%%'",searchText];
	copyListOfItems = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_notes:strSearch]];
}

- (void) doneSearching_Clicked {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	tbl_notes.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	ovController = nil;
	
	[tbl_notes reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdBannerView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdShowSetFrame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdHideSetFrame" object:nil];
}

#pragma mark - IBAction Methods
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnaddPressed:(id)sender
{
    [self doneSearching_Clicked];  
    AddNotesViewCtr *obj_AddNotesViewCtr=[[AddNotesViewCtr alloc]initWithNibName:@"AddNotesViewCtr" bundle:nil];
    obj_AddNotesViewCtr.strEdit=@"New";
    [self.navigationController pushViewController:obj_AddNotesViewCtr animated:YES];
    obj_AddNotesViewCtr=nil;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
