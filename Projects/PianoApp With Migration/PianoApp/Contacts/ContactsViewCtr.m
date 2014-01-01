//
//  ContactsViewCtr.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsViewCtr.h"
#import "AddContactViewCtr.h"
#import "ViewContactPressed.h"
#import "OverlayViewController.h"
#import "AppDelegate.h"

@implementation ContactsViewCtr

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
    
    //Initialize the copy array.
	copyListOfItems = [[NSMutableArray alloc] init];
    
	//Add the search bar
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
            tbl_contacts.frame = CGRectMake(0, 88, 320, 410);
        }
        else
        {
            tbl_contacts.frame = CGRectMake(0, 88, 320, 322);
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
        if (isiPhone5)
        {
            tbl_contacts.frame = CGRectMake(0, 88, 320, 460);
        }
        else
        {
            tbl_contacts.frame = CGRectMake(0, 88, 320, 372);
        }
    }
    
    ArryContacts = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_addcontacts:@"SELECT * FROM tbl_addcontacts"]];
    [self ReloadAllTblData];
}

// Set Frame OF view according to iAd show/hide
-(void)iAdShowSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_contacts.frame = CGRectMake(0, 88, 320, 410);
    }
    else
    {
        tbl_contacts.frame = CGRectMake(0, 88, 320, 322);
    }
}
-(void)iAdHideSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_contacts.frame = CGRectMake(0, 88, 320, 460);
    }
    else
    {
        tbl_contacts.frame = CGRectMake(0, 88, 320, 372);
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
                NSString *str = [[copyListOfItems objectAtIndex:j]objectForKey:@"Firstname"];
                if ([[LatterArray objectAtIndex:i] isEqualToString:[[str substringToIndex:1]uppercaseString]]) {
                    [temp addObject:[copyListOfItems objectAtIndex:j]];
                }
            } 
        }
        else
        {
            for (int j = 0; j < [ArryContacts count]; j++){
                NSString *str = [[ArryContacts objectAtIndex:j]objectForKey:@"Firstname"];
                if ([[LatterArray objectAtIndex:i] isEqualToString:[[str substringToIndex:1]uppercaseString]]) {
                    [temp addObject:[ArryContacts objectAtIndex:j]];
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

    [tbl_contacts reloadData];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        
        // Display only a person's phone, email, and birthdate
        NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                                   [NSNumber numberWithInt:kABPersonEmailProperty],
                                   [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
        
        
        picker.displayedProperties = displayedItems;
        // Show the picker
        [self presentModalViewController:picker animated:YES];
    }
    else if (buttonIndex == 1)
    {
        AddContactViewCtr *obj_AddContactViewCtr=[[AddContactViewCtr alloc]initWithNibName:@"AddContactViewCtr" bundle:nil];
        [self.navigationController pushViewController:obj_AddContactViewCtr animated:YES];
        obj_AddContactViewCtr=nil;
    }
    else if (buttonIndex == 2)
    {
        return;
    }
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
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSMutableDictionary *dict = [valueArray objectAtIndex:indexPath.section];
    NSMutableArray *allInfoArray= [dict objectForKey:@"value"];
    NSMutableDictionary *allInfoDict = [allInfoArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font  = [UIFont fontWithName:@"GillSans" size:18.0];;
    if ([[allInfoDict objectForKey:@"LastName"] isEqualToString:@"(null)"]) 
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[allInfoDict objectForKey:@"Firstname"]];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[allInfoDict objectForKey:@"Firstname"],[allInfoDict objectForKey:@"LastName"]];
    }
    cell.textLabel.textAlignment=UITextAlignmentLeft;
    cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    // }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell.
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [valueArray objectAtIndex:indexPath.section];
    NSMutableArray *allInfoArray= [dict objectForKey:@"value"];
    NSMutableDictionary *allInfoDict = [allInfoArray objectAtIndex:indexPath.row];
    
    ViewContactPressed *obj_ViewContactPressed=[[ViewContactPressed alloc]initWithNibName:@"ViewContactPressed" bundle:nil];
    obj_ViewContactPressed.strID=[NSString stringWithFormat:@"%@",[allInfoDict objectForKey:@"id"]];
    [self.navigationController pushViewController:obj_ViewContactPressed animated:YES];
    obj_ViewContactPressed=nil;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(IBAction)btnNameSortPressed:(id)sender
{
    ArryContacts = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_addcontacts:@"SELECT * FROM tbl_addcontacts"]];
    NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"Firstname" ascending:YES];
	[ArryContacts sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    [self ReloadAllTblData];
}
-(IBAction)btnFavSortPressed:(id)sender
{
    NSString *strSearch =[NSString stringWithFormat:@"SELECT * FROM tbl_addcontacts where favstatus=1"];
    ArryContacts = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_addcontacts:strSearch]];
    [self ReloadAllTblData];
}

-(IBAction)btnDateAddedSortPressed:(id)sender
{
    ArryContacts = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_addcontacts:@"SELECT * FROM tbl_addcontacts"]];
    NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
	[ArryContacts sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
    [self ReloadAllTblData];
}
-(IBAction)btnTypeSortPressed:(id)sender
{
    [ArryType removeAllObjects];
    ArryType = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_type:@"SELECT * FROM tbl_typeContact"]];
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
-(IBAction)btnSearchPressed:(id)sender
{
    //tbl_contacts.tableHeaderView=searchBar;
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
	tbl_contacts.scrollEnabled = YES;
    
  //  tbl_contacts.tableHeaderView=toolbarView;
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
	
	ovController.rvController2 = self;
	
	[tbl_contacts insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	tbl_contacts.scrollEnabled = NO;
	
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		tbl_contacts.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		[tbl_contacts insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		searching = NO;
		letUserSelectRow = NO;
		tbl_contacts.scrollEnabled = NO;
	}
	[self ReloadAllTblData];
	//[tbl_passwords reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchTableView];
}

- (void) searchTableView {
	
	NSString *searchText = searchBar.text;
    NSString *strSearch =[NSString stringWithFormat:@"SELECT * FROM tbl_addcontacts where Firstname LIKE '%@%%'",searchText];
	copyListOfItems = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_addcontacts:strSearch]];
    
}

- (void) doneSearching_Clicked
{
    searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	tbl_contacts.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	ovController = nil;
	
   // tbl_contacts.tableHeaderView=toolbarView;
    [searchBar removeFromSuperview];
	[self ReloadAllTblData];
}
-(void)CanclePressed
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
-(void)DonePressed
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
    NSString *strType = [NSString stringWithFormat:@"%@",[[ArryType objectAtIndex:catID] valueForKey:@"type"]];
    NSString *strSearch =[NSString stringWithFormat:@"SELECT * FROM tbl_addcontacts where Category LIKE '%@'",strType];
    ArryContacts = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_addcontacts:strSearch]];
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
        
        NSString *strQuery_Delete_Conatacts = [NSString stringWithFormat:@"DELETE FROM tbl_addcontacts where id=%d",[[allInfoDict objectForKey:@"id"]intValue]];
        [DatabaseAccess InsertUpdateDeleteQuery:strQuery_Delete_Conatacts];
        ArryContacts = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_addcontacts:@"SELECT * FROM tbl_addcontacts"]];
        [self ReloadAllTblData];
    }
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods

// Displays the information of a selected person
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    NSMutableDictionary *dicPhoneno = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicEmail = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dicURL = [[NSMutableDictionary alloc] init];
    
    ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
    ABMultiValueRef multiphone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    BOOL isEmailID = NO;
    BOOL isPhoneNo = NO;
    
    if (ABMultiValueGetCount(multi) > 0) {
        for (CFIndex i = 0; i < ABMultiValueGetCount(multi);i++){
            CFStringRef emailRef = ABMultiValueCopyValueAtIndex(multi, i);
            isEmailID = YES;
            NSString *email;
            NSString *emailLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(multi, i);
            if([emailLabel isEqualToString:@"_$!<Home>!$_"]) {
                email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, i);
                [dicEmail setObject:email forKey:@"Home"];
            }
            else if([emailLabel isEqualToString:@"_$!<Work>!$_"]) {
                email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, i);
                [dicEmail setObject:email forKey:@"Work"];
            }
            else if([emailLabel isEqualToString:@"_$!<Other>!$_"]) {
                email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, i);
                [dicEmail setObject:email forKey:@"Other"];
            }
            CFRelease(emailRef);
        }
    }
    CFRelease(multi);
    
    if (ABMultiValueGetCount(multiphone) > 0) {
        for (CFIndex i = 0; i < ABMultiValueGetCount(multiphone);i++)
        {
                CFStringRef phoneRef = ABMultiValueCopyValueAtIndex(multiphone, i);
                isPhoneNo = YES;
                NSString *mobile;
                NSString *mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(multiphone, i);
                if([mobileLabel isEqualToString:@"_$!<Mobile>!$_"]) {
                    mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiphone, i);
                    NSString *phoneno = [self RemovePhoneExtraChar:(__bridge NSString *)phoneRef];
                    [dicPhoneno setObject:phoneno forKey:@"Mobile"];
                }
                else if([mobileLabel isEqualToString:@"_$!<Home>!$_"]) {
                    mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiphone, i);
                    NSString *phoneno = [self RemovePhoneExtraChar:(__bridge NSString *)phoneRef];
                    [dicPhoneno setObject:phoneno forKey:@"Home"];
                }
                else if([mobileLabel isEqualToString:@"_$!<Work>!$_"]) {
                    mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiphone, i);
                    NSString *phoneno = [self RemovePhoneExtraChar:(__bridge NSString *)phoneRef];
                    [dicPhoneno setObject:phoneno forKey:@"Work"];
                }
                else if([mobileLabel isEqualToString:@"_$!<Other>!$_"]) {
                    mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiphone, i);
                    NSString *phoneno = [self RemovePhoneExtraChar:(__bridge NSString *)phoneRef];
                    [dicPhoneno setObject:phoneno forKey:@"Other"];
                }
                CFRelease(phoneRef);
            }
        }
    CFRelease(multiphone);
    
    if(isEmailID)
    {}
    else
    {}    
    if(isPhoneNo)
    {}
    else
    {}
    
    NSString *firstNameString = (__bridge NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty); // fetch contact first name from address book  
    NSString *lastNameString = (__bridge NSString*)ABRecordCopyValue(person,kABPersonLastNameProperty);
    NSString *companyString = (__bridge NSString*)ABRecordCopyValue(person,kABPersonOrganizationProperty);
    
    ABMultiValueRef multiURL = ABRecordCopyValue(person, kABPersonURLProperty);
    if (ABMultiValueGetCount(multi) > 0) 
    {
        for (CFIndex i = 0; i < ABMultiValueGetCount(multiURL);i++)
        {
            CFStringRef urlRef = ABMultiValueCopyValueAtIndex(multiURL, i);
            
            NSString *homepageString;
            NSString *homepageStringLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(multiURL, i);
            if([homepageStringLabel isEqualToString:@"_$!<HomePage>!$_"]) 
            {
                    homepageString = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiURL, i);
                    [dicURL setObject:homepageString forKey:@"HomePage"];
            }
            CFRelease(urlRef);
        }
    }
    CFRelease(multiURL);
        
    NSString *strFName = [self removeNull:[NSString stringWithFormat:@"%@",firstNameString]];
    NSString *strLName = [self removeNull:[NSString stringWithFormat:@"%@",lastNameString]];
    NSString *strCompany = [self removeNull:[NSString stringWithFormat:@"%@",companyString]]; 
    
    if ([strFName length] > 0)
    {
        NSString *str_Insert_Contacts = [NSString stringWithFormat:@"insert into tbl_addcontacts(Firstname,LastName,Mobile,Home,HomePage,Category,Company,homephone,workphone,otherphone,workemail,otheremail,favstatus) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d)",strFName,strLName,[self removeNull:[NSString stringWithFormat:@"%@",[dicPhoneno valueForKey:@"Mobile"]]],[self removeNull:[NSString stringWithFormat:@"%@",[dicEmail valueForKey:@"Home"]]],[self removeNull:[NSString stringWithFormat:@"%@",[dicURL valueForKey:@"HomePage"]]],@"Family",strCompany,[self removeNull:[NSString stringWithFormat:@"%@",[dicPhoneno valueForKey:@"Home"]]],[self removeNull:[NSString stringWithFormat:@"%@",[dicPhoneno valueForKey:@"Work"]]],[self removeNull:[NSString stringWithFormat:@"%@",[dicPhoneno valueForKey:@"Other"]]],[self removeNull:[NSString stringWithFormat:@"%@",[dicEmail valueForKey:@"Work"]]],[self removeNull:[NSString stringWithFormat:@"%@",[dicEmail valueForKey:@"Other"]]],0];
        [DatabaseAccess InsertUpdateDeleteQuery:str_Insert_Contacts];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}
// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
                               property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel. 
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;{
    [self dismissModalViewControllerAnimated:YES];
}
-(NSString *)RemovePhoneExtraChar:(NSString *)strphoneno
{
    NSMutableString *strippedString = [NSMutableString 
                                       stringWithCapacity:strphoneno.length];
    NSScanner *scanner = [NSScanner scannerWithString:strphoneno];
    NSCharacterSet *numbers = [NSCharacterSet 
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    return strippedString;
}
#pragma mark - Remove NULL

- (NSString *)removeNull:(NSString *)str
{
    str = [NSString stringWithFormat:@"%@",str];    
    if (!str) {
        return @"";
    }
    else if([str isEqualToString:@"<null>"]){
        return @"";
    }
    else if([str isEqualToString:@"(null)"]){
        return @"";
    }
    else{
        return str;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdBannerView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdShowSetFrame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdHideSetFrame" object:nil];
}
#pragma mark - IBaction Methods
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnAddPressed:(id)sender
{
    [self doneSearching_Clicked];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:APP_NAME delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Import contact",@"Compose new contact",@"Cancel", nil];
    sheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    sheet.destructiveButtonIndex = 2;
    [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
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
