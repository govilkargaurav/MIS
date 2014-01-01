//
//  TwitterViewController.m
//  Suvi
//
//  Created by apple on 2/7/13.
//
//

#import "TwitterViewController.h"
#import "ContactCustomCell.h"
#import "TSAlertView.h"
#import "AppDelegate.h"

@implementation TwitterViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];

    searchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchbar.delegate=self;
    searchbar.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"search_bg.png"]];
    searchbar.placeholder=@"Search Contacts on Twitter";
    searchbar.tintColor=[UIColor clearColor];
    searchbar.translucent=YES;
    [searchbar setBackgroundImage:[UIImage imageNamed:@"greytransbg.png"]];
    [searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchbar_txtbg.png"] forState:UIControlStateNormal];
    [searchbar setScopeBarBackgroundImage:[UIImage imageNamed:@"greytransbg.png"]];
    UITextField *searchField = [searchbar valueForKey:@"_searchField"];
    searchField.textColor=[UIColor darkGrayColor];
    searchField.keyboardAppearance=UIKeyboardAppearanceAlert;
    [searchField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    tblview.backgroundColor =[UIColor clearColor];
    tblview.separatorColor=[UIColor grayColor];
    tblview.alpha=0;
    tblview.tableHeaderView=searchbar;
    
    arrtwitterfollowersfulllist= [[NSMutableArray alloc]init];
    arrtwitterfollowerslist= [[NSMutableArray alloc]init];
    photodict=[[NSMutableDictionary alloc]init];
    arrtwitterac=[[NSMutableArray alloc]init];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelectorOnMainThread:@selector(showHUDLoader) withObject:nil waitUntilDone:YES];
    [self accountsExistOrNot];
}

-(IBAction)btnbackclicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)accountsExistOrNot
{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to access their Twitter account
    [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        // Did user allow us access?
       
        if (granted == YES)
        {
            // Populate array with all available Twitter accounts
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
            [arrtwitterac addObjectsFromArray:arrayOfAccounts];
            // Sanity check
            if ([arrayOfAccounts count] > 0)
            {
                if ([arrayOfAccounts count]==1) {
                    selectedtwitteracindex=0;
                    [self fetchTwitterContacts];
                }
                else
                {
                    // Block handler to manage the response
                    UIActionSheet *actsheet=[[UIActionSheet alloc]initWithTitle:@"Please select twitter account" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
                    actsheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
                    
                    for (int i=0; i<[arrayOfAccounts count]; i++)
                    {
                        ACAccount *acct = [arrayOfAccounts objectAtIndex:i];
                        [actsheet addButtonWithTitle:[NSString stringWithFormat:@"%@",acct.username]];
                    }
                    
                    [actsheet showInView:self.view];
                    
                    [self hideHUDLoader];
                }
            }
            else
            {
                 [self performSelectorOnMainThread:@selector(showAddAc) withObject:nil waitUntilDone:YES];
            }
        }
        else{
             [self performSelectorOnMainThread:@selector(showAddAc) withObject:nil waitUntilDone:YES];
        }
    }];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        selectedtwitteracindex=buttonIndex-1;
        [self performSelectorOnMainThread:@selector(showHUDLoader) withObject:nil waitUntilDone:YES];
        [self fetchTwitterContacts];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==301) {
        if (buttonIndex==0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if([alertView tag]==401)
    {
        if (buttonIndex==0)
        {
            //[alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

-(void)fetchTwitterContacts
{
    ACAccount *acct = [arrtwitterac objectAtIndex:selectedtwitteracindex];
    NSString *strTwitterURL=[NSString stringWithFormat:@"http://api.twitter.com/1/statuses/followers.json?screen_name=%@",acct.username];
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:[strTwitterURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] parameters:nil requestMethod:TWRequestMethodGET];
    
    [request setAccount:acct];
    
    // Notice this is a block, it is the handler to process the response
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if ([urlResponse statusCode] == 200)
         {
             // The response from Twitter is in JSON format
             // Move the response into a dictionary and print
             NSError *error;
             NSMutableArray *arrtwdata = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
             for (int i = 0; i<[arrtwdata count]; i++)
             {
                 NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]init];
                 [dictTemp setValue:[[arrtwdata objectAtIndex:i]valueForKey:@"id"] forKey:@"id"];
                 [dictTemp setValue:[[arrtwdata objectAtIndex:i]valueForKey:@"screen_name"] forKey:@"screen_name"];
                 [dictTemp setValue:[[arrtwdata objectAtIndex:i]valueForKey:@"name"] forKey:@"name"];
                 [dictTemp setValue:[[arrtwdata objectAtIndex:i]valueForKey:@"profile_image_url"] forKey:@"profile_image_url"];
                 
                 [arrtwitterfollowersfulllist addObject:dictTemp];
                 [arrtwitterfollowerslist addObject:dictTemp];
             }
             
             if ([arrtwitterfollowersfulllist count]>0)
             {
                 [self performSelectorOnMainThread:@selector(reloadTableData) withObject:nil waitUntilDone:YES];
             }
         }
         
         [self performSelectorOnMainThread:@selector(hideHUDLoader) withObject:nil waitUntilDone:YES];
     }];
}
-(void)invitetwitterfollower:(id)sender
{
    [searchbar resignFirstResponder];
    selectedfollowerindex=[(UIButton *)sender tag];
    [self showHUDLoader];
    [self invitetwfollower];
//    [self performSelectorOnMainThread:@selector(showHUDLoader) withObject:nil waitUntilDone:YES];
//    [self performSelector:@selector(invitetwfollower) withObject:nil afterDelay:0.3];
}

-(void)invitetwfollower
{
    ACAccount *acct = [arrtwitterac objectAtIndex:selectedtwitteracindex];
    NSString *strTwitterID=[NSString stringWithFormat:@"%@",[[arrtwitterfollowerslist objectAtIndex:selectedfollowerindex] objectForKey:@"screen_name"]];
    // Build a twitter request
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/direct_messages/new.json"];
    NSDictionary *p = [NSDictionary dictionaryWithObjectsAndKeys:strTwitterID,@"screen_name",kAppInviteText, @"text",nil];
    
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:url parameters:p requestMethod: TWRequestMethodPOST];
    // Post the request
    [postRequest setAccount:acct];
    
    // Block handler to manage the response
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        if ([urlResponse statusCode]!=200)
        {
            [self showFailureInvite];
        }
        else
        {
            [self showSuccessInvite];
        }
    }];
}

-(void)showAddAc
{
    [[AppDelegate sharedInstance]hideLoader];
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Please add twitter account from Settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertview.tag=301;
    [alertview show];
}

-(void)showSuccessInvite
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TSAlertView* av = [[TSAlertView alloc] init];
        av.title = @"Twitter";
        av.message = @"Friend request sent!";
        
        [av addButtonWithTitle:@"OK"];
        
        av.style = TSAlertViewStyleNormal;
        av.buttonLayout =  TSAlertViewButtonLayoutNormal;
        
        [av show];
        
        [[AppDelegate sharedInstance]hideLoader];
        
        
    });
    
}

-(void)showFailureInvite
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        TSAlertView* av = [[TSAlertView alloc] init];
        av.title = @"Twitter";
        av.message = @"Friend request not sent!";
        
        [av addButtonWithTitle:@"OK"];
        
        av.style = TSAlertViewStyleNormal;
        av.buttonLayout =  TSAlertViewButtonLayoutNormal;
        
        [av show];
        
        [[AppDelegate sharedInstance]hideLoader];
        
    });
}
-(void)showHUDLoader
{
    [[AppDelegate sharedInstance]showLoader];
}
-(void)hideHUDLoader
{
    [[AppDelegate sharedInstance]hideLoader];
}

-(void)reloadTableData
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    tblview.alpha=1.0;
    [tblview reloadData];
    [UIView commitAnimations];
}


#pragma mark - SEARCH BAR METHODS
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [arrtwitterfollowerslist removeAllObjects];
    
    for (int i=0; i<[arrtwitterfollowersfulllist count]; i++) {
        NSRange range = [[[arrtwitterfollowersfulllist objectAtIndex:i] objectForKey:@"name"] rangeOfString:searchbar.text options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound)
        {
            [arrtwitterfollowerslist addObject:[arrtwitterfollowersfulllist objectAtIndex:i]];
        }
    }
    
    [tblview reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [tblview reloadData];
    [searchbar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchbar.text=@"";
    [arrtwitterfollowerslist removeAllObjects];
    [arrtwitterfollowerslist addObjectsFromArray:arrtwitterfollowersfulllist];
    [tblview reloadData];
    [searchbar resignFirstResponder];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchbar setShowsCancelButton:YES animated:YES];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchbar setShowsCancelButton:NO animated:YES];
    [searchbar resignFirstResponder];
}

#pragma mark - TABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrtwitterfollowerslist count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ContactCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ContactCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.btninvite.tag=indexPath.row;
    
    cell.lblcontactname.text=[NSString stringWithFormat:@"%@",[[arrtwitterfollowerslist objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    NSString *strimageurl=[NSString stringWithFormat:@"%@", [[arrtwitterfollowerslist objectAtIndex:indexPath.row] objectForKey:@"profile_image_url"]];
    [cell.imgview setImageWithURL:[NSURL URLWithString:[strimageurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
    
    [cell.btninvite addTarget:self action:@selector(invitetwitterfollower:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)btnInviteClicked:(id)sender
{
    [searchbar resignFirstResponder];
    selectedindex=[(UIButton *)sender tag];
    [self performSelector:@selector(invitetwitterfollowers) withObject:nil afterDelay:0.3];
}


@end
