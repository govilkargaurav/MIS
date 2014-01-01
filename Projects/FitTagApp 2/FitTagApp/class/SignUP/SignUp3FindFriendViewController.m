//
//  SignUp3FindFriendViewController.m
//  FitTagApp
//
//  Created by apple on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SignUp3FindFriendViewController.h"
#import "FrndSugestCustomCell.h"
#import "TimeLineViewController.h"
#import "TwitterFollowerList.h"
#import "FacebookFriendList.h"
#import "InviteContactForChallenge.h"
#import <FacebookSDK/FacebookSDK.h>

@class FindChallengesViewConroller;


@implementation SignUp3FindFriendViewController
@synthesize arrAllUser;
@synthesize arrSugestedFriends;
@synthesize intInviteTag;
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
    
    appDelegateRefrence = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    [lbl1 setFont:[UIFont fontWithName:@"DynoBold" size:15]];
    [lbl2 setFont:[UIFont fontWithName:@"DynoBold" size:15]];
    [lbl3 setFont:[UIFont fontWithName:@"DynoBold" size:15]];
        [lbl4 setFont:[UIFont fontWithName:@"DynoBold" size:12]];
    // Do any additional setup after loading the view from its nib.
    toggle=TRUE;
    //navigation back Button- Arrow
    UIButton *btnback=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnHeaderbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
    UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
    [view123 addSubview:btnback];
    
    UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn123.width=-16;
    UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
    self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
    
    if(intInviteTag!=1){
    //Done Button
    
    UIButton *btnBarDone=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBarDone addTarget:self action:@selector(btnDonePressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnBarDone setFrame:CGRectMake(0, 0, 52, 30)];
    [btnBarDone setImage:[UIImage imageNamed:@"btnSmallDone"] forState:UIControlStateNormal];
    [btnBarDone setImage: [UIImage imageNamed:@"btnSmallDoneSel"] forState:UIControlStateHighlighted];
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 52,30)];
        [view addSubview:btnBarDone];
        UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
        btn.width=-11;
        UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.rightBarButtonItems=[[NSArray alloc]initWithObjects:btn,btn1,nil];
    }
}

- (void)viewDidUnload
{
    tblAllUser = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- TableView Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrSugestedFriends count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FrndSugestCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.btnFollow.tag=indexPath.row;
    
    if ([[[self.arrSugestedFriends objectAtIndex:indexPath.row ] objectForKey:@"isFollow"]isEqualToString:@"Yes"]) {
        [cell.btnFollow setImage:[UIImage imageNamed:@"btnUnfollow"] forState:UIControlStateNormal];
        [cell.btnFollow setImage:[UIImage imageNamed:@"btnUnfollow"] forState:UIControlStateHighlighted];
        
    }else{
        
        [cell.btnFollow setImage:[UIImage imageNamed:@"btnFollow"] forState:UIControlStateNormal];
        [cell.btnFollow setImage:[UIImage imageNamed:@"btnFollowSel"] forState:UIControlStateHighlighted];
    }
    cell.lblUserName.text = [[self.arrSugestedFriends objectAtIndex:indexPath.row ] objectForKey:@"name"];
     [cell.lblUserName setFont:[UIFont fontWithName:@"DynoRegular" size:17]];
    [cell.imgProfileView setImageURL:[NSURL URLWithString:[[self.arrSugestedFriends objectAtIndex:indexPath.row] objectForKey:@"ImageURL"]]];
    [cell.btnFollow addTarget:self action:@selector(btnFollowPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark Button actions
-(IBAction)btnDonePressed:(id)sender{
    TimeLineViewController *timelineViewConroller=[[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
    [self.navigationController pushViewController:timelineViewConroller animated:YES];
    
}
- (IBAction)btnFollowPressed:(id)sender{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIButton *btnSender = (UIButton *)sender;
    PFUser *objUser = [[self.arrSugestedFriends objectAtIndex:[sender tag]] objectForKey:@"followUser"];
    PFObject *follower = [PFObject objectWithClassName:@"Tbl_follower"];
    
    if ([[[self.arrSugestedFriends objectAtIndex:[sender tag]] objectForKey:@"isFollow"]isEqualToString:@"No"]) {
        [btnSender setTitle:@"Unfollow" forState:UIControlStateNormal];
        [follower setObject:[[self.arrSugestedFriends objectAtIndex:[sender tag]] objectForKey:@"objectIdForUser"] forKey:@"follower_id"];
        [follower setObject:objUser forKey:@"followerUser"];
        //[follower setObject:[[PFUser currentUser]objectId] forKey:@"userId"];
        [follower setObject:[[PFUser currentUser]objectId] forKey:@"CurrentUserId"];
        [follower setObject:[PFUser currentUser] forKey:@"userId"];
        [follower setObject:[[PFUser currentUser]username] forKey:@"username"];
        [follower setObject:[[PFUser currentUser]email] forKey:@"email"];
        [follower setObject:[[self.arrSugestedFriends objectAtIndex:[sender tag]] objectForKey:@"name"] forKey:@"following_username"];
        [[self.arrSugestedFriends objectAtIndex:[sender tag]] removeObjectForKey:@"isFollow"];
        
        [[self.arrSugestedFriends objectAtIndex:[sender tag]] setObject:@"Yes" forKey:@"isFollow"];
        //[follower setObject:[objUser objectForKey:@"email" ] forKey:@"following_email"];
        [follower save];
        
        PFQuery *queryMyfolloewr = [PFQuery queryWithClassName:@"Tbl_follower"];
        [queryMyfolloewr whereKey:@"follower_id" equalTo:[[self.arrSugestedFriends objectAtIndex:[sender tag]] objectForKey:@"objectIdForUser"]];
        [queryMyfolloewr findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                PFQuery *userQuery = [PFUser query];
                [userQuery whereKey:@"objectId" equalTo:objUser.objectId];
                
                // Find devices associated with these users
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"owner" equalTo:objUser];
                
                // Send push notification to query
                
                if(![[objUser objectId] isEqualToString:[[PFUser currentUser] objectId]]){
                    
                    if([[objUser objectForKey:@"followNotification"] isEqualToString:@"YES"]){
                        PFPush *push = [[PFPush alloc] init];
                        //[push setQuery:pushQuery]; // Set our Installation query
                        [push setChannel:[NSString stringWithFormat:@"user_%@",[objUser objectId]]];
                        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSString stringWithFormat:@"%@ Started following you",[PFUser currentUser].username], @"alert",
                                              @"Increment", @"badge",
                                              @"default",@"sound",
                                              [[self.arrSugestedFriends objectAtIndex:[sender tag]] objectForKey:@"objectIdForUser"],@"followingUserId",
                                              @"follow",@"action",
                                              nil];
                        [push setData:data];
                        [push sendPushInBackgroundWithBlock:^(BOOL done,NSError *errror){
                            if (!errror) {
                            }else{
                            }
                        }];
                    }
                }
                
                arrayTemp = [[NSMutableArray alloc]init];
                arrayTemp = [objects mutableCopy];
                [[self.arrSugestedFriends objectAtIndex:[sender tag]] setObject:[arrayTemp objectAtIndex:0]  forKey: @"index"];
                [sender setTag:1];
                [btnSender setImage:[UIImage imageNamed:@"btnUnfollow"] forState:UIControlStateNormal];
                [btnSender setImage:[UIImage imageNamed:@"btnUnfollow"] forState:UIControlStateHighlighted];
            } else {
                // Log details of the failure
                DisplayAlertWithTitle(@"FitTag",[[error userInfo] objectForKey:@"error"])
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:TRUE];
            toggle=FALSE;
        }];
    }
    else{
        PFObject *obj = [[self.arrSugestedFriends objectAtIndex:[sender tag]] objectForKey:@"index"];
        [obj deleteInBackground];
        [btnSender setTitle:@"Follow" forState:UIControlStateNormal];
        [[self.arrSugestedFriends objectAtIndex:[sender tag]] removeObjectForKey:@"isFollow"];
        
        [[self.arrSugestedFriends objectAtIndex:[sender tag]] setObject:@"No" forKey:@"isFollow"];
        [btnSender setImage:[UIImage imageNamed:@"btnFollow"] forState:UIControlStateNormal];
        [btnSender setImage:[UIImage imageNamed:@"btnFollowSel"] forState:UIControlStateHighlighted];
        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
        [sender setTag:0];
    }
}

- (IBAction)btnFBFriendPressed:(id)sender {
    if([PFFacebookUtils session].state == FBSessionStateOpen){
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity: 4];
        
        // set the frictionless requests parameter to "1"
        [params setObject: @"1" forKey:@"frictionless"];//frictionlessRequests
        [params setObject: [NSString stringWithFormat:@"%@ just challenged you on FitTag (www.fittagapp.com). Do you accept the challenge?",[PFUser currentUser].username] forKey:@"message"];
        [params setObject:FACEBOOKCLIENTID forKey:@"app_id"];
        
        [FBWebDialogs presentRequestsDialogModallyWithSession:[PFFacebookUtils session]
                message:[NSString stringWithFormat:@"%@ just challenged you on FitTag",[PFUser currentUser].username] title:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error){
              if (error) {
                  // Case A: Error launching the dialog or sending request.
              } else {
                  if (result == FBWebDialogResultDialogNotCompleted) {
                      //Case B: User clicked the "x" icon
                  } else {
                      //Case C: Dialog shown and the user clicks Cancel or Send
                  }
              }
        }];
        
    }else{
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:FB_PERMISSIONS block:^(BOOL Success,NSError *error){
            
            if(!error){
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity: 4];
                
                // set the frictionless requests parameter to "1"
                [params setObject: @"1" forKey:@"frictionless"];//frictionlessRequests
                [params setObject: [NSString stringWithFormat:@"%@ just challenged you on FitTag (www.fittagapp.com). Do you accept the challenge?",[PFUser currentUser].username] forKey:@"message"];
                [params setObject:FACEBOOKCLIENTID forKey:@"app_id"];
                
                [FBWebDialogs presentRequestsDialogModallyWithSession:[PFFacebookUtils session] message:[NSString stringWithFormat:@"%@ just challenged you on FitTag",[PFUser currentUser].username] title:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                          if (error) {
                              // Case A: Error launching the dialog or sending request.
                          } else {
                              if (result == FBWebDialogResultDialogNotCompleted) {
                                  //Case B: User clicked the "x" icon
                              } else {
                                  //Case C: Dialog shown and the user clicks Cancel or Send
                              }
                          }
                }];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FitTag" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (IBAction)btnTwitterFriendPressed:(id)sender {
    
 /*   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FitTag" message:@"OOPS ! Sorry for inconvenience. We are having some problems with twitter for now. We are working hard to solve the issue. We will get back to you soon." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];*/
    
    // Twitter Temporary block
    
    
    TwitterFollowerList *objTwitterFollowerList = [[TwitterFollowerList alloc]initWithNibName:@"TwitterFollowerList" bundle:nil];
    [self.navigationController pushViewController:objTwitterFollowerList animated:YES]; 
}

-(IBAction)btnContectFriendPressed:(id)sender {
    
    InviteContactForChallenge *inviteContactFriendsVC = [[InviteContactForChallenge alloc]initWithNibName:@"InviteContactForChallenge" bundle:nil];
    [self.navigationController pushViewController:inviteContactFriendsVC animated:YES];
}

-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
