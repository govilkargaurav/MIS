//
//  FollowersListViewCltr.m
//  FitTagApp
//
//  Created by Apple1 on 2/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FacebookFriendList.h"

@implementation FacebookFriendList

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    self.title=@"Friends";
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Facebook";
    
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Select All",@"UnSelect All",@"Invite",nil]];
    control.segmentedControlStyle = UISegmentedControlStyleBar;
    //control.tintColor = [UIColor colorWithRed:0.851 green:0.660 blue:0.648 alpha:1.0];
    control.momentary = YES;
    [control addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];            
    UIBarButtonItem *controlItem = [[UIBarButtonItem alloc] initWithCustomView:control];
    self.navigationItem.rightBarButtonItem = controlItem;
        
    //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Invite" style:UIBarButtonItemStyleDone target:self action:@selector(onClick_Done)];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [friendUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIButton *btnInvite = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [btnInvite setFrame:CGRectMake(270, 5, 32 , 35)];
        [btnInvite setTitle:@"" forState:UIControlStateNormal];
        [btnInvite setBackgroundColor:[UIColor clearColor]];
        [btnInvite setTag:indexPath.row+1];
        [btnInvite setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btnInvite addTarget:self action:@selector(inviteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnInvite setImage:[UIImage imageNamed:@"chk_unchecked"] forState:UIControlStateNormal];
        [cell addSubview:btnInvite];
    }
    btnInvite = (UIButton *)[cell viewWithTag:indexPath.row+1];
    
    if ([self isArray:arrInviteFriends ContainsObject:[friendUsers objectAtIndex:indexPath.row] WithKey:@"id"]) {
        [btnInvite setImage:[UIImage imageNamed:@"chk_checked"] forState:UIControlStateNormal];
    }
    else{
        [btnInvite setImage:[UIImage imageNamed:@"chk_unchecked"] forState:UIControlStateNormal];
    }
    
    NSDictionary *dict = [friendUsers objectAtIndex:indexPath.row];
    
    cell.textLabel.text=[dict objectForKey:@"first_name"] ;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}


#pragma mark - 
#pragma mark Button Actions


- (IBAction)inviteButtonPressed:(UIButton *)sender {
    
    // create a dictionary for our dialog's parameters
    
    UIButton *btn = (UIButton *)sender;
    //[btn setHidden:TRUE];
    
    //[AppUtilityClass Array:arrInviteFriends containsObject:[friendUsers objectAtIndex:[btn tag]]]
    if ([arrInviteFriends containsObject:[friendUsers objectAtIndex:[btn tag]-1]]) 
    {
        [arrInviteFriends removeObject:[friendUsers objectAtIndex:[btn tag]-1]];
    }
    else
    {
        [arrInviteFriends addObject:[friendUsers objectAtIndex:[btn tag]-1]];
    }
    [self.tableView reloadData];
    
    
}

-(void)segmentValueChanged:(id)sender
{
   }

-(IBAction)onClick_Done
{
   }

#pragma mark - 
#pragma mark - Class Functionality
-(BOOL)CompareArray:(NSMutableArray *)arrayToCompare WithArray:(NSMutableArray *)byArray withKeyValue:(NSString *)Key{
    
    for (int i =0; i< arrayToCompare.count; i++) {
        for (int j =0; j<byArray.count; j++) {
            if ([[[byArray objectAtIndex:j]valueForKey:Key] isEqualToString:[[arrayToCompare objectAtIndex:i]valueForKey:Key]]) {
               
                return TRUE;
            }
        }
    }
    return FALSE;
}

-(BOOL)isArray:(NSMutableArray *)array ContainsObject:(id)object WithKey:(NSString *)key{
    
    for (int i = 0; i< array.count; i++) {
        if ([[object valueForKey:key]isEqual:[[array objectAtIndex:i]valueForKey:key]]) {
            return TRUE;
        }
    }
    
    return FALSE;
    
}


@end
