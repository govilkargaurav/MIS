//
//  PasswordsViewctr.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PasswordsViewctr.h"
#import "NewPassWordsViewCtr.h"
#import "ViewNewPassViewCtr.h"
#import "OverlayViewController.h"
#import "TypeViewCtr.h"
#import "AppDelegate.h"

@implementation PasswordsViewctr

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
    
    /*self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddPressed)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor orangeColor];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(62,0,196,44)];
    iv.contentMode = UIViewContentModeCenter;
    [iv setImage:[UIImage imageNamed:@"PasswordsHeader.png"]];
    self.navigationItem.titleView = iv;*/
   // tbl_passwords.tableHeaderView=toolbarView;
    
    //Searchbar----------------------------------
	copyListOfItems = [[NSMutableArray alloc] init];
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
    //PickerView Create ----------------------------------------------------
    ArryType =[[NSMutableArray alloc]init];
    
    toolBar=[[UIToolbar alloc] init];
    if (isiPhone5)
    {
        toolBar.frame=CGRectMake(0,568, 320, 44);
    }
    else
    {
        toolBar.frame=CGRectMake(0,480, 320, 44);
    }
    toolBar.barStyle=UIBarStyleBlackTranslucent;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
	[self.view addSubview:toolBar];  
	
	UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CanclePressed)];
    
	UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressed)];
    
	NSArray *buttons = [NSArray arrayWithObjects: item1, item2, nil];
    [toolBar setItems: buttons animated:NO];
    
    [UIView commitAnimations];
    
    pickerView = [[UIPickerView alloc] init];
    if (isiPhone5)
    {
        pickerView.frame=CGRectMake(0, 568, 320, 216);
    }
    else
    {
        pickerView.frame=CGRectMake(0, 480, 320, 216);
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView commitAnimations];
    pickerView.backgroundColor=[UIColor grayColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    [self.view addSubview:pickerView];
    [pickerView selectRow:0 inComponent:0 animated:NO];
    //-----------------------------------------------------------------
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
            tbl_passwords.frame = CGRectMake(0, 88, 320, 410);
        }
        else
        {
            tbl_passwords.frame = CGRectMake(0, 88, 320, 322);
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
        if (isiPhone5)
        {
            tbl_passwords.frame = CGRectMake(0, 88, 320, 460);
        }
        else
        {
            tbl_passwords.frame = CGRectMake(0, 88, 320, 372);
        }
    }
    NSString *strQuery_Select_password =[NSString stringWithFormat:@"SELECT * FROM tbl_newpasswords"];
    ArryPasswords = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_newpasswords:strQuery_Select_password]];
    [self ReloadAllTblData];
}

// Set Frame OF view according to iAd show/hide
-(void)iAdShowSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_passwords.frame = CGRectMake(0, 88, 320, 410);
    }
    else
    {
        tbl_passwords.frame = CGRectMake(0, 88, 320, 322);
    }
}
-(void)iAdHideSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_passwords.frame = CGRectMake(0, 88, 320, 460);
    }
    else
    {
        tbl_passwords.frame = CGRectMake(0, 88, 320, 372);
    }
}

-(void)ReloadAllTblData
{
    NSMutableArray *LatterArray = [[NSMutableArray alloc] init];
    [LatterArray addObject:@"A"];
    [LatterArray addObject:@"B"];
    [LatterArray addObject:@"C"];
    [LatterArray addObject:@"D"];
    [LatterArray addObject:@"E"];
    [LatterArray addObject:@"F"];
    [LatterArray addObject:@"G"];
    [LatterArray addObject:@"H"];
    [LatterArray addObject:@"I"];
    [LatterArray addObject:@"J"];
    [LatterArray addObject:@"K"];
    [LatterArray addObject:@"L"];
    [LatterArray addObject:@"M"];
    [LatterArray addObject:@"N"];
    [LatterArray addObject:@"O"];
    [LatterArray addObject:@"P"];
    [LatterArray addObject:@"Q"];
    [LatterArray addObject:@"R"];
    [LatterArray addObject:@"S"];
    [LatterArray addObject:@"T"];
    [LatterArray addObject:@"U"];
    [LatterArray addObject:@"V"];
    [LatterArray addObject:@"W"];
    [LatterArray addObject:@"X"];
    [LatterArray addObject:@"Y"];
    [LatterArray addObject:@"Z"];
       
    valueArray = [[NSMutableArray alloc]init];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [LatterArray count]; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            
            NSMutableArray *temp = [[NSMutableArray alloc]init];
            if (searching)
            {
                for (int j = 0; j < [copyListOfItems count]; j++){
                    NSString *str = [[copyListOfItems objectAtIndex:j]objectForKey:@"title"];
                    if ([[LatterArray objectAtIndex:i] isEqualToString:[[str substringToIndex:1]uppercaseString]]) {
                        [temp addObject:[copyListOfItems objectAtIndex:j]];
                    }
                } 
            }
            else
            {
                for (int j = 0; j < [ArryPasswords count]; j++){
                    NSString *str = [[ArryPasswords objectAtIndex:j]objectForKey:@"title"];
                    if ([[LatterArray objectAtIndex:i] isEqualToString:[[str substringToIndex:1]uppercaseString]]) {
                        [temp addObject:[ArryPasswords objectAtIndex:j]];
                    }
                }
            }
            
            if ([temp count]) {
                [dict setObject:[LatterArray objectAtIndex:i] forKey:@"key"];
                [dict setObject:temp forKey:@"value"];
                [array addObject:dict];
            }
        }
        
        [valueArray removeAllObjects];
        
        valueArray = array;
    [tbl_passwords reloadData];
    
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [valueArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[valueArray objectAtIndex:section]objectForKey:@"value"] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    
    return [[valueArray objectAtIndex:section]objectForKey:@"key"];
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
    return [valueArray valueForKey:@"key"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[valueArray valueForKey:@"key"] indexOfObject:title];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  //  if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
   // }
    NSMutableDictionary *dict = [valueArray objectAtIndex:indexPath.section];
    NSMutableArray *allInfoArray= [dict objectForKey:@"value"];
    NSMutableDictionary *allInfoDict = [allInfoArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:18.0];//[UIFont boldSystemFontOfSize:18.0f];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[allInfoDict objectForKey:@"title"]];
    cell.textLabel.textAlignment=UITextAlignmentLeft;
    cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
   
    cell.detailTextLabel.textColor = [UIColor orangeColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"GillSans" size:12.0];//[UIFont boldSystemFontOfSize:14.0f];
    if ([[allInfoDict objectForKey:@"url"] isEqualToString:@"(null)"]) 
    {
        cell.detailTextLabel.text = @"";
    }
    else
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[allInfoDict objectForKey:@"url"]];
    }
    cell.detailTextLabel.textAlignment=UITextAlignmentLeft;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell.
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [valueArray objectAtIndex:indexPath.section];
    NSMutableArray *allInfoArray= [dict objectForKey:@"value"];
    NSMutableDictionary *allInfoDict = [allInfoArray objectAtIndex:indexPath.row];
    
    ViewNewPassViewCtr *obj_ViewNewPassViewCtr=[[ViewNewPassViewCtr alloc]initWithNibName:@"ViewNewPassViewCtr" bundle:nil];
    obj_ViewNewPassViewCtr.strID=[NSString stringWithFormat:@"%@",[allInfoDict objectForKey:@"id"]];
    [self.navigationController pushViewController:obj_ViewNewPassViewCtr animated:YES];
    obj_ViewNewPassViewCtr=nil;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(IBAction)btnNameSortPressed:(id)sender
{
    NSString *strQuery_Select_password =[NSString stringWithFormat:@"SELECT * FROM tbl_newpasswords"];
    ArryPasswords = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_newpasswords:strQuery_Select_password]];
    NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
	[ArryPasswords sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    [self ReloadAllTblData];
}
-(IBAction)btnDateAddedSortPressed:(id)sender
{
    NSString *strQuery_Select_password =[NSString stringWithFormat:@"SELECT * FROM tbl_newpasswords"];
    ArryPasswords = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_newpasswords:strQuery_Select_password]];
    NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
	[ArryPasswords sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    [self ReloadAllTblData];
}
-(IBAction)btnFavSortPressed:(id)sender
{
    NSString *strQuery_Select_Fav =[NSString stringWithFormat:@"SELECT * FROM tbl_newpasswords where favstatus=1"];
    ArryPasswords = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_newpasswords:strQuery_Select_Fav]];
    [self ReloadAllTblData];
}
-(IBAction)btnTypeSortPressed:(id)sender
{
    [ArryType removeAllObjects];
    ArryType = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_type:@"SELECT * FROM tbl_typePass"]];
    [self PickerShow];
}
-(IBAction)btnSearchPressed:(id)sender
{
   // tbl_passwords.tableHeaderView=searchBar;
    searchBar.frame = CGRectMake(0, 44, 320, 44);
    [self.view addSubview:searchBar];
    [searchBar becomeFirstResponder];
    
}
-(IBAction)CancelSearchPressed:(id)sender
{
    searchBar.text = @"";
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	tbl_passwords.scrollEnabled = YES;
		
  //  tbl_passwords.tableHeaderView=toolbarView;
    [searchBar removeFromSuperview];
	[self ReloadAllTblData]; 
}
- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
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
	CGRect frame = CGRectMake(0, yaxis - 44, width, height);
	ovController.view.frame = frame;	
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.rvController1 = self;
	
	[tbl_passwords insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	tbl_passwords.scrollEnabled = NO;

}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		tbl_passwords.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		[tbl_passwords insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		searching = NO;
		letUserSelectRow = NO;
		tbl_passwords.scrollEnabled = NO;
	}
	[self ReloadAllTblData];
	//[tbl_passwords reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchTableView];
}

- (void) searchTableView {
	
	NSString *searchText = searchBar.text;
    NSString *strQuery_Select_Search =[NSString stringWithFormat:@"SELECT * FROM tbl_newpasswords where title LIKE '%@%%'",searchText];
	copyListOfItems = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_newpasswords:strQuery_Select_Search]];
    
}

- (void) doneSearching_Clicked{
	

	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	tbl_passwords.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	ovController = nil;
    [searchBar removeFromSuperview];
//	[self ReloadAllTblData];
}
-(void)CanclePressed
{
    [self PickerHide];
}
-(void)PickerHide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    if (isiPhone5)
    {
        toolBar.frame=CGRectMake(0,568, 320, 44);
        pickerView.frame=CGRectMake(0,568, 320, 216);
    }
    else
    {
        toolBar.frame=CGRectMake(0,480, 320, 44);
        pickerView.frame=CGRectMake(0,480, 320, 216);
    }
    [UIView commitAnimations];
}
-(void)PickerShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    int toolbarH,pickerH;
    if (isiPhone5)
    {
        if (AppDel.isiAdVisible)
        {
            toolbarH = 238;
            pickerH = 282;
        }
        else
        {
            toolbarH = 288;
            pickerH = 332;
        }
        toolBar.frame=CGRectMake(0,toolbarH, 320, 44);
        pickerView.frame=CGRectMake(0,pickerH, 320, 216);
    }
    else
    {
        if (AppDel.isiAdVisible)
        {
            toolbarH = 150;
            pickerH = 194;
        }
        else
        {
            toolbarH = 200;
            pickerH = 244;
        }
        toolBar.frame=CGRectMake(0,toolbarH, 320, 44);
        pickerView.frame=CGRectMake(0,pickerH, 320, 216);
    }
    [UIView commitAnimations];
    [pickerView reloadAllComponents];
}
-(void)DonePressed
{
    [self PickerHide];
    NSString *strType = [NSString stringWithFormat:@"%@",[[ArryType objectAtIndex:catID] valueForKey:@"type"]];
    NSString *strQuery_Select_Type =[NSString stringWithFormat:@"SELECT * FROM tbl_newpasswords where type LIKE '%@'",strType];
    ArryPasswords = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_newpasswords:strQuery_Select_Type]];
    [self ReloadAllTblData];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [ArryType count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[ArryType objectAtIndex:row] valueForKey:@"type"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
    catID=row;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        NSMutableDictionary *dict = [valueArray objectAtIndex:indexPath.section];
        NSMutableArray *allInfoArray= [dict objectForKey:@"value"];
        NSMutableDictionary *allInfoDict = [allInfoArray objectAtIndex:indexPath.row];
        
        NSString *strQuery_Delete_Password = [NSString stringWithFormat:@"DELETE FROM tbl_newpasswords where id=%d",[[allInfoDict objectForKey:@"id"]intValue]];
        [DatabaseAccess InsertUpdateDeleteQuery:strQuery_Delete_Password];
        
        NSString *strQuery_Select_password =[NSString stringWithFormat:@"SELECT * FROM tbl_newpasswords"];
        ArryPasswords = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_newpasswords:strQuery_Select_password]];
        [self ReloadAllTblData];
    }
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
-(IBAction)btnAddPasswordsPressed:(id)sender
{
    [self doneSearching_Clicked];
    NewPassWordsViewCtr *obj_NewPassWordsViewCtr=[[NewPassWordsViewCtr alloc]initWithNibName:@"NewPassWordsViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_NewPassWordsViewCtr animated:YES];
    obj_NewPassWordsViewCtr=nil;
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
