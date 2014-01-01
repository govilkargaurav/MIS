//
//  TwitterShareViewController.m
//  MyU
//
//  Created by Vijay on 9/9/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "TwitterShareViewController.h"
#import "SocialSharingCell.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface TwitterShareViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextField *txtSearch;
    IBOutlet UITableView *tblView;
    IBOutlet UIImageView *bgTable;
    NSMutableArray *arrFriends;
    NSMutableArray *arrtwitterfollowersfulllist;
    NSInteger selectedindex;
    NSInteger selectedtwitteracindex;
    NSMutableArray *arrtwitterac;
    NSInteger selectedfollowerindex;
}
-(void)accountsExistOrNot;
-(void)fetchTwitterContacts;
-(void)invitetwitterfollower:(id)sender;

@end

@implementation TwitterShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    bgTable.image=[[UIImage imageNamed:@"bg_tellafriendtbl"] resizableImageWithCapInsets:UIEdgeInsetsMake(100.0, 0.0, 100.0, 0.0) resizingMode:UIImageResizingModeTile];
    arrtwitterfollowersfulllist= [[NSMutableArray alloc]init];
    arrtwitterac=[[NSMutableArray alloc]init];
    arrFriends=[[NSMutableArray alloc]init];
    tblView.frame=CGRectMake(11.0,113.0+iOS7,298.0,tblView.frame.size.height);
    
    [[MyAppManager sharedManager] showLoader];
    [self accountsExistOrNot];
    //[self performSelector:@selector(accountsExistOrNot) withObject:nil afterDelay:1.0];
}
-(IBAction)btnBackClicked:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{}];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - TABLEVIEW METHODS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrFriends count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SocialSharingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[SocialSharingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.isFacebookCell=NO;
    cell.btnInvite.tag=indexPath.row;
    
    cell.bgimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"bgcell_tf-%d",(indexPath.row%2)]];
    
    [cell.btnInvite addTarget:self action:@selector(invitetwitterfollower:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lblFriendName.text=[NSString stringWithFormat:@"%@",[[arrFriends objectAtIndex:indexPath.row] objectForKey:@"name"]];
    NSString *strimageurl=[NSString stringWithFormat:@"%@",[[arrFriends objectAtIndex:indexPath.row] objectForKey:@"profile_image_url"]];
    [cell.imgView setImageWithURL:[NSURL URLWithString:strimageurl] placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - TWITTER METHODS
-(void)accountsExistOrNot
{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to access their Twitter account
    [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
    {
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
                    [[MyAppManager sharedManager] hideLoaderInMainThread];
                    [self performSelectorOnMainThread:@selector(showActionSheet) withObject:nil waitUntilDone:YES];

//                    [self performSelector:@selector(showActionSheet) withObject:nil afterDelay:1.0];
//                    UIActionSheet *actsheet=[[UIActionSheet alloc]initWithTitle:@"Please select twitter account" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
//                    actsheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
////                    
////                    for (int i=0; i<[arrtwitterac count]; i++)
////                    {
////                        ACAccount *acct = [arrtwitterac objectAtIndex:i];
////                        [actsheet addButtonWithTitle:[NSString stringWithFormat:@"%@",acct.username]];
////                    }
//                    
//                    [actsheet showInView:self.view];
                    
                    
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

-(void)showActionSheet
{
    UIActionSheet *actsheet=[[UIActionSheet alloc]initWithTitle:@"Please select twitter account" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
    actsheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;

    for (int i=0; i<[arrtwitterac count]; i++)
    {
        ACAccount *acct = [arrtwitterac objectAtIndex:i];
        [actsheet addButtonWithTitle:[NSString stringWithFormat:@"%@",acct.username]];
    }
    
    [actsheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    else
    {
        selectedtwitteracindex=buttonIndex-1;
        [[MyAppManager sharedManager] showLoaderInMainThread];
        [self fetchTwitterContacts];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==301) {
        if (buttonIndex==0)
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self dismissViewControllerAnimated:NO completion:^{}];

        }
    }
}
-(void)fetchTwitterContacts
{
    ACAccount *acct = [arrtwitterac objectAtIndex:selectedtwitteracindex];
    NSString *userID = [[acct valueForKey:@"properties"] valueForKey:@"user_id"];

    NSString *strTwitterURL=[NSString stringWithFormat:@"http://api.twitter.com/1/statuses/followers.json?user_id=%@",userID];
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
             NSMutableDictionary *response_data = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
             NSMutableArray *arrtwdata=[[NSMutableArray alloc]initWithArray:[response_data objectForKey:@"users"]];
             for (int i = 0; i<[arrtwdata count]; i++)
             {
                 NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]init];
                 [dictTemp setValue:[[arrtwdata objectAtIndex:i]valueForKey:@"id"] forKey:@"id"];
                 [dictTemp setValue:[[arrtwdata objectAtIndex:i]valueForKey:@"screen_name"] forKey:@"screen_name"];
                 [dictTemp setValue:[[arrtwdata objectAtIndex:i]valueForKey:@"name"] forKey:@"name"];
                 [dictTemp setValue:[[arrtwdata objectAtIndex:i]valueForKey:@"profile_image_url"] forKey:@"profile_image_url"];
                 
                 [arrtwitterfollowersfulllist addObject:dictTemp];
                 [arrFriends addObject:dictTemp];
             }
             
             if ([arrtwitterfollowersfulllist count]>0)
             {
                 [self performSelectorOnMainThread:@selector(reloadTableData) withObject:nil waitUntilDone:YES];
             }
         }
         else{
             NSLog(@"the data code:%d and error:%@",[urlResponse statusCode],[error localizedDescription]);
         }
         
         [self performSelectorOnMainThread:@selector(hideHUDLoader) withObject:nil waitUntilDone:YES];
     }];
}
-(void)reloadTableData
{
    [[MyAppManager sharedManager] hideLoader];
    [tblView reloadData];
}
-(void)invitetwitterfollower:(id)sender
{
    [self.view endEditing:YES];
    selectedfollowerindex=[(UIButton *)sender tag];
    [[MyAppManager sharedManager] showLoader];
    [self invitetwfollower];
}

-(void)invitetwfollower
{
    ACAccount *acct = [arrtwitterac objectAtIndex:selectedtwitteracindex];
    NSString *strTwitterID=[NSString stringWithFormat:@"%@",[[arrFriends objectAtIndex:selectedfollowerindex] objectForKey:@"screen_name"]];
    // Build a twitter request
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/direct_messages/new.json"];
    NSDictionary *p = [NSDictionary dictionaryWithObjectsAndKeys:strTwitterID,@"screen_name",@"Please Join the MyU", @"text",nil];
    
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
    [[MyAppManager sharedManager]hideLoader];
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Please add twitter account from Settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertview.tag=301;
    [alertview show];
}

-(void)showSuccessInvite
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        TSAlertView* av = [[TSAlertView alloc] init];
//        av.title = @"Twitter";
//        av.message = @"Friend request sent!";
//        
//        [av addButtonWithTitle:@"OK"];
//        
//        av.style = TSAlertViewStyleNormal;
//        av.buttonLayout =  TSAlertViewButtonLayoutNormal;
//        
//        [av show];
        
        kGRAlert(@"Invitation sent")
        
        [[MyAppManager sharedManager]hideLoader];
        
        
    });
    
}

-(void)showFailureInvite
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        TSAlertView* av = [[TSAlertView alloc] init];
//        av.title = @"Twitter";
//        av.message = @"Friend request not sent!";
//        
//        [av addButtonWithTitle:@"OK"];
//        
//        av.style = TSAlertViewStyleNormal;
//        av.buttonLayout =  TSAlertViewButtonLayoutNormal;
//        
//        [av show];
        
        kGRAlert(@"Invitation not sent")

        
        [[MyAppManager sharedManager]hideLoader];
        
    });
}

-(void)hideHUDLoader
{
    [[MyAppManager sharedManager] hideLoader];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *theTouch=[touches anyObject];
    if (theTouch.view==self.view)
    {
        [self.view endEditing:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)searchUsersLocally
{
    [arrFriends removeAllObjects];
    
    if ([[txtSearch.text removeNull] length]==0)
    {
        [arrFriends addObjectsFromArray:arrtwitterfollowersfulllist];
        [tblView reloadData];
        return;
    }
    
    for (int i=0; i<[arrtwitterfollowersfulllist count]; i++)
    {
        NSRange range =[[NSString stringWithFormat:@"%@",[[arrtwitterfollowersfulllist objectAtIndex:i] objectForKey:@"name"]] rangeOfString:[txtSearch.text removeNull] options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound)
        {
            [arrFriends addObject:[arrtwitterfollowersfulllist objectAtIndex:i]];
        }
    }
    
    [tblView reloadData];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(searchUsersLocally) withObject:nil afterDelay:0.0];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    tblView.frame=CGRectMake(11.0,113.0+iOS7,298.0,347.0-216.0+iPhone5ExHeight);
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self searchUsersLocally];
    tblView.frame=CGRectMake(11.0,113.0+iOS7,298.0,331.0+iPhone5ExHeight);
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self performSelector:@selector(searchUsersLocally) withObject:nil afterDelay:0.0];
    return YES;
}
#pragma mark - DEFAULT METHODS
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
    [super didReceiveMemoryWarning];
}


@end
