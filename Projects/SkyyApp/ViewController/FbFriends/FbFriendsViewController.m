//
//  FbFriendsViewController.m
//  SkyyApp
//
//  Created by Vishal Jani on 9/5/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import "FbFriendsViewController.h"
#import "FacebookFriendCustomCell.h"
@interface FbFriendsViewController ()

@end

@implementation FbFriendsViewController
@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    arrSelectedFriends=[[NSMutableArray alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [self getFbFriends];
}
-(void)getFbFriends{
    
    // Issue a Facebook Graph API request to get your user's friend list
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbId" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            NSArray *friendUsers = [friendQuery findObjects];
            arrfriends=friendUsers;
            [tblFriends reloadData];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
        }
        else{
            DisplayLocalizedAlert(@"You need to login to send a Note");
             [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrfriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellReuseIdentifier = @"cellReuseIdentifier";
    FacebookFriendCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (cell == nil) {
        cell = [[FacebookFriendCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    cell.lblUserName.text=[[arrfriends objectAtIndex:indexPath.row] objectForKey:@"name"];
      NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", [[arrfriends objectAtIndex:indexPath.row] objectForKey:@"fbId"]]];
    [cell.userProfileImage setImageURL:pictureURL];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    PFUser *selectedUser=[arrfriends objectAtIndex:indexPath.row];
    [arrSelectedFriends addObject:selectedUser];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [arrSelectedFriends removeObjectAtIndex:indexPath.row];
}
-(IBAction)sendNote:(id)sender{
    [self.delegate sendNote:arrSelectedFriends];
}

-(IBAction)cencelNote:(id)sender{
    
    [self.delegate cancelSendNote];
    
}

@end
