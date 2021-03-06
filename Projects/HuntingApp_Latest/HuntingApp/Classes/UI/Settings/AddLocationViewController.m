//
//  AddLocationViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddLocationViewController.h"
#import "FirstViewController.h"
#import "GlobalFile.h"
@interface AddLocationViewController ()

- (void)editTableView:(id)sender;

@end

@implementation AddLocationViewController
@synthesize isLoggedFirstTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isLoggedFirstTime = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    locationPicker = [[ActionSheetStringPicker alloc]initWithTitle:@"Select Location" targetViewController:self doneAction:@selector(locationPickerDismissed) pickerDidSelectAction:@selector(stateDidSelect)];
    [locationPicker setNumOfComponents:2];
    stateArray = [Utility getAllStatesList];
    if ([Utility getLocationState] && [stateArray containsObject:[Utility getLocationState]])
    {
        countiesArray = [Utility getAllCountiesListOfState:[Utility getLocationState]];
        selectedLocation = [stateArray indexOfObject:[Utility getLocationState]];
    }
    else {
        countiesArray = [Utility getAllCountiesListOfState:[stateArray objectAtIndex:0]];
    }
    [locationPicker setItems:stateArray inComponent:0];
    [locationPicker setItems:countiesArray inComponent:1];
    
    titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 44)] autorelease];
    [lbl setFont:[UIFont fontWithName:@"WOODCUT" size:14]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    [lbl setText:@"Add A Location"];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [titleView addSubview:lbl];
    favLocations =[[NSMutableArray alloc] init];
    [self.navigationItem setHidesBackButton:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [tblView reloadData];
    CustomMapViewController *controller = [[CustomMapViewController alloc] init];
    [controller setDelegate:self];
    
    [tblView reloadData];
    
    [self.navigationController.navigationBar addSubview:titleView];
    self.navigationItem.leftBarButtonItem = [Utility barButtonItemWithImageName:@"left-arrow" Selector:@selector(popViewController) Target:self];
    if (isLoggedFirstTime)
    {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonSelected)] autorelease]; 
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [titleView removeFromSuperview];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)dealloc
{
    if (favLocations)
        RELEASE_SAFELY(favLocations);
    RELEASE_SAFELY(locationPicker);
    RELEASE_SAFELY(titleView);
    RELEASE_SAFELY(locationPicker);
    
    [tblView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [tblView release];
    tblView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonSelected
{
    isLoggedFirstTime = NO;
    FirstViewController *controller = (FirstViewController *)[[self.navigationController viewControllers]objectAtIndex:0];
    [controller dismissMyView:@"2"];
}


#pragma mark
#pragma LocaionPicker fnctions

- (IBAction)showLocationPicker:(id)sender 
{
    strTypeofLocation=@"defined";
    [locationPicker showActionSheetWithSelectedRow:selectedLocation];
}

- (IBAction)PinYourCustomLocation:(id)sender
{
    strTypeofLocation =@"custom";
    
}

- (void)stateDidSelect
{
    selectedLocation = [locationPicker getSelectedIndexInComponent:0];
    countiesArray = [Utility getAllCountiesListOfState:[stateArray objectAtIndex:selectedLocation]];
    [locationPicker setItems:countiesArray inComponent:1];
}

- (void)locationPickerDismissed
{
    selectedLocation = [locationPicker getSelectedIndexInComponent:0];
    [[Utility sharedInstance] addFavouriteLocationToUserProfile:[NSString stringWithFormat:@"%@;%@",[locationPicker getSelectedItemInComponent:1],[locationPicker getSelectedItemInComponent:0]] forViewController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:NOTIFICATION_FAV_LOC_ADDED object:nil];
}

# pragma mark
# pragma TableView Mehods


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Custom";
    }
    if (section == 1)
    {
        return @"Defined";
    }
    
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    [favLocations removeAllObjects];
    [favLocations addObjectsFromArray:[[DAL sharedInstance]getFavLocationsOfCurrentUser]];
    arrcustomLocation = [[NSMutableArray alloc] init];
    arrDefinedLocation = [[NSMutableArray alloc]init];
    
    [favLocations enumerateObjectsUsingBlock:^(Location *loc,NSUInteger i,BOOL *stop){
        
        
        if ([loc.type isEqualToString:@"custom"]) {
            
            [arrcustomLocation addObject:loc];
            
        }else{
            
            [arrDefinedLocation addObject:loc];
            
        }
    }];
    
    if (favLocations.count == 0)
    {
        [tblView setHidden:YES];
        if (!isLoggedFirstTime)
            self.navigationItem.rightBarButtonItem = nil;
        return 0;
    }
    else {
        [tblView setHidden:NO];
        [tblView setEditing:tblView.isEditing];
        DLog(@"%d",favLocations.count);
        if (!isLoggedFirstTime)
        {
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:tblView.isEditing?@"Done":@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTableView:)] autorelease]; 
            
        }
        
        if (section==0) {
            
            return [arrcustomLocation count];
        }else{
            
            return [arrDefinedLocation count];
        }
        return 0;
        
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Configure the cell...
//    Location *loc = [favLocations objectAtIndex:indexPath.row];
    
    Location *loc;
    if (indexPath.section==0) {
        loc = [arrcustomLocation objectAtIndex:indexPath.row];
        cell.textLabel.text = [loc.description stringByReplacingOccurrencesOfString:@";" withString:@","];
        
    }else{
        loc= [arrDefinedLocation objectAtIndex:indexPath.row];
        cell.textLabel.text = [loc.description stringByReplacingOccurrencesOfString:@";" withString:@","];
        
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteLocation:indexPath.row :indexPath.section];
    }
}

- (void)deleteLocation:(NSInteger)row :(NSInteger)section
{
    Location *loc = nil;
    
    if (section==0) {
       loc = [arrcustomLocation objectAtIndex:row];
    }else{
        loc =[arrDefinedLocation objectAtIndex:row];
    }
    
    if (deleteLocationRequest)
    {
        deleteLocationRequest.delegate = nil;
        RELEASE_SAFELY(deleteLocationRequest);
    }
    deleteLocationRequest = [[WebServices alloc] init];
    [deleteLocationRequest setDelegate:self];
    [deleteLocationRequest deleteFavLoc:loc.loc_id];
    [[[DAL sharedInstance] managedObjectContext] deleteObject:loc];
    [[DAL sharedInstance] saveContext];
    [tblView reloadData];

    
}

- (void)reloadTableView
{
    [tblView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:[Utility userID]];
}

# pragma  mark
# pragma  request wrapper delegate
- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    DLog(@"%@",response);
}

- (void)editTableView:(id)sender
{
    BOOL isEditable = tblView.isEditing;
    UIBarButtonItem *btn = (UIBarButtonItem *)sender;
    if (!isEditable)
    {
        [tblView setEditing:YES];
        [btn setTitle:@"Done"];
    }
    else {
        [tblView setEditing:NO];
        [btn setTitle:@"Edit"];
    }
}

- (void)dismissCustomMapController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CustomMap"])
    {
        CustomMapViewController *controller = [segue destinationViewController];
        [controller setDelegate:self];
    }
}

@end
