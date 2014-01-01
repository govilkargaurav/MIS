//
//  SearchViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "FLImageView.h"


#define ALERT_VIEW_TAG_FOLLOW 98
#define ALERT_VIEW_TAG_INVITE 99999

@interface SearchViewController ()

- (void)searchPhoneNumber:(NSString *)phoneNumber;
- (NSArray *)removeOwnProfileFromArray:(NSArray *)array;

@end

@implementation SearchViewController
@synthesize items;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 44)] autorelease];
    [lbl setFont:[UIFont fontWithName:@"WOODCUT" size:18]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    [lbl setText:@"Find Friends"];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [titleView addSubview:lbl];
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg3.png"]];
    //[bg setFrame:self.view.frame];
    [self.tableView setBackgroundView:bg];
    RELEASE_SAFELY(bg);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar addSubview:titleView];
    self.navigationItem.leftBarButtonItem = [Utility barButtonItemWithImageName:@"left-arrow" Selector:@selector(popViewController) Target:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [titleView removeFromSuperview];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    if (followFriendRequest)
    {
        followFriendRequest.delegate = nil;
        RELEASE_SAFELY(followFriendRequest);
    }
    if (searchFriendRequest)
    {
        searchFriendRequest.delegate = nil;
        RELEASE_SAFELY(searchFriendRequest);
    }
    items = nil;
    RELEASE_SAFELY(titleView);
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    if (items.count!=0 && ![[items objectAtIndex:0]objectForKey:@"data"])
    {
        NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:KWEB_SERVICE_NAME ascending:YES] autorelease];
        NSArray *descriptors = [NSArray arrayWithObject:descriptor];
        NSArray *arr = [NSArray arrayWithArray:items];
        arr = [arr sortedArrayUsingDescriptors:descriptors];
        RELEASE_SAFELY(items);
        items = [arr retain];
    }
    else if (items.count!=0 && [[items objectAtIndex:0]objectForKey:@"data"])
    {
        NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:@"data.name" ascending:YES] autorelease];
        NSArray *descriptors = [NSArray arrayWithObject:descriptor];
        NSArray *arr = [NSArray arrayWithArray:items];
        arr = [arr sortedArrayUsingDescriptors:descriptors];
        RELEASE_SAFELY(items);
        items = [arr retain];


    }
    return [items count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *normalCellIdentifier = @"NormalCell";
    static NSString *searchCellIdentifier = @"SearchCell";
    NSDictionary *dict = [items objectAtIndex:indexPath.row];
    if ([dict objectForKey:@"data"])
    {
        SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
        dict = [dict objectForKey:@"data"];
        [cell.lblName setText:[dict objectForKey:KWEB_SERVICE_NAME]];
        NSString *ID = [dict objectForKey:KWEB_SERVICE_USERID];
        [cell.imgView setImageWithUrl:[Utility getProfilePicURL:ID]];
        return cell;
    }
    else 
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
        cell.textLabel.text = [dict objectForKey:KWEB_SERVICE_NAME];
        cell.detailTextLabel.text = [dict objectForKey:KWEB_SERVICE_PHONE];
        return cell;
    }
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if ([cell isKindOfClass:[SearchCell class]])
    {
        BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Follow Friend" message:@"Do you want to follow that friend?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil] autorelease];
        [alert setTag:indexPath.row];
        [alert show];
    }
    else
    {
        [self searchPhoneNumber:cell.detailTextLabel.text];
    }
    
}


- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark
# pragma UIAlert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        if (alertView.tag !=ALERT_VIEW_TAG_INVITE)
        {
            if (followFriendRequest)
            {
                followFriendRequest.delegate = nil;
                RELEASE_SAFELY(followFriendRequest);
            }
            NSString *ID = [[[items objectAtIndex:alertView.tag] objectForKey:@"data"] objectForKey:KWEB_SERVICE_USERID];
            if (![ID isEqualToString:[Utility userID]])
            {
                followFriendRequest = [[WebServices alloc] init];
                [followFriendRequest setDelegate:self];
                [followFriendRequest followFriend:ID];
                loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Sending..."];
            }
            else 
            {
                DLog(@"User is not allowed to follow their own profile!!!");
            }
        }
        else 
        {
            [self sendMessage:@"I just signed up for OutdoorLoop, a social application for everything outdoors! Come Get In The Loop now and download OutdoorLoop Today! www.TheOutdoorLoop.com" toNumber:[NSArray arrayWithObject:selectedPhoneNumber]];
        }
    }
}

# pragma mark
# pragma Request wraper delegate

- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    if (followFriendRequest)
    {
        followFriendRequest.delegate = nil;
        RELEASE_SAFELY(followFriendRequest);
    }
    if (searchFriendRequest)
    {
        searchFriendRequest.delegate = nil;
        RELEASE_SAFELY(searchFriendRequest);
    }
    [loadingActivityIndicator removeFromSuperview];
    NSDictionary *JSONDict = [WebServices parseJSONString:response];
    if ([JSONDict objectForKey:@"data"] && [[userInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_FOLLOW_FRIEND])
    {
        if ([[JSONDict objectForKey:@"data"] objectForKey:@"success"])
        {
            BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Follow Friend" message:@"Congratulations!!! Now you can follow your friend's hunting expeditions and much more" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
            [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:[Utility userID]];
        }
    }
    else if ([JSONDict objectForKey:@"data"] && [[userInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_SEARCH_FRIEND]) 
    {
        if ([[JSONDict objectForKey:@"data"] count]>0)
        {
            self.items = [NSArray arrayWithArray:[JSONDict objectForKey:@"data"]];
            self.items = [self removeOwnProfileFromArray:self.items];
            if (self.items.count!=0)
                [self.tableView reloadData];
            else 
            {
                BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Search Friend" message:@"You can't search your own profile" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alert show];
            }
        }
        else 
        {
            BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Search Friend" message:@"No friend of this number Found. Do you want to invite this friend to outdoorloop" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil] autorelease];
            alert.tag = ALERT_VIEW_TAG_INVITE;
            [alert show];
        }

    }
    else 
    {
        [Utility showServerError];
    }
}

# pragma mark - Message Composer Functions

- (void)sendMessage:(NSString *)message toNumber:(NSArray *)number
{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {   
        controller.body = message;
        controller.recipients = number;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    switch (result) 
    {
        case MessageComposeResultCancelled:
            DLog(@"Cancelled!!!!");
            break;
        case MessageComposeResultSent:
            DLog(@"Sent!!!!");
            break;
        case MessageComposeResultFailed:
            DLog(@"Failed!!!!");
            break;
        default:
            break;
    }
}

- (void)searchPhoneNumber:(NSString *)phoneNumber
{
    selectedPhoneNumber = phoneNumber;
    loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Searching..."];
    if (searchFriendRequest)
    {
        searchFriendRequest.delegate = nil;
        RELEASE_SAFELY(searchFriendRequest);
    }
    searchFriendRequest = [[WebServices alloc] init];
    [searchFriendRequest setDelegate:self];
    [searchFriendRequest searchProfileBy:KWEB_SERVICE_PHONE andValue:phoneNumber];
}

- (NSArray *)removeOwnProfileFromArray:(NSArray *)array
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
    if(arr.count!=0 && [[arr objectAtIndex:0] objectForKey:@"data"])
    {
        for (NSDictionary *dict in array) 
        {
            if ([[[dict objectForKey:@"data"]objectForKey:KWEB_SERVICE_USERID] isEqualToString:[Utility userID]])
            {
                [arr removeObject:dict];
            }
        }
        DLog(@"%@----%@",[arr description],[array description]);
        return arr;
    }
    else {
        return arr;
    }
}



@end
