//
//  FacebookShareViewController.m
//  MyU
//
//  Created by Vijay on 9/9/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "FacebookShareViewController.h"
#import "SocialSharingCell.h"
#import "MBProgressHUD.h"
#import "FbGraph.h"
#import "FBConnect.h"

@interface FacebookShareViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,FBSessionDelegate,FBDialogDelegate>
{
    IBOutlet UITextField *txtSearch;
    IBOutlet UITableView *tblView;
    IBOutlet UIImageView *bgTable;
    NSMutableArray *arrFriends;
    FbGraph *fbGraph;
    Facebook *facebook;
    NSMutableArray *arrfbfriendsfullist;
    NSMutableDictionary *dictSelectedfriends;
}

-(void)fbGraphCallback;
-(void)getfacebookfriends;
-(void)initializefacebook;
-(void)invitefacebookfriend;

@end

@implementation FacebookShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    bgTable.image=[[UIImage imageNamed:@"bg_tellafriendtbl"] resizableImageWithCapInsets:UIEdgeInsetsMake(100.0, 0.0, 100.0, 0.0) resizingMode:UIImageResizingModeTile];
    arrfbfriendsfullist= [[NSMutableArray alloc]init];
    dictSelectedfriends=[[NSMutableDictionary alloc]init];
    arrFriends=[[NSMutableArray alloc]init];
    tblView.frame=CGRectMake(11.0,113.0+iOS7,298.0,tblView.frame.size.height);

    if (1)
    {
        [self initializefacebook];
    }
    else
    {
        [self getfacebookfriends];
    }
}
-(void)allocFBIfNeeded
{
    if(!fbGraph)
    {
        fbGraph = [[FbGraph alloc] initWithFbClientID:kFacebookAppID];
//        NSString *strToken=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"] objectForKey:@"facebook_token"]];
//        if ([strToken length]>2)
//        {
//            fbGraph.accessToken=[[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"] objectForKey:@"facebook_token"];
//        }
    }
}
-(void)getfacebookfriends
{
    [self allocFBIfNeeded];
    [[MyAppManager sharedManager] showLoader];
    [self performSelector:@selector(fbgetmyfriends) withObject:nil afterDelay:0.000000001];
}

-(void)logoutfacebook
{
    //Remove Cookies only for facebook...
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
}
-(void)initializefacebook
{
    [self logoutfacebook];
    [self openfacebook];
	//[self performSelector:@selector(openfacebook) withObject:nil afterDelay:0.3f];
}
-(void)openfacebook
{
    fbGraph = [[FbGraph alloc] initWithFbClientID:kFacebookAppID];
    if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0))
    {
        [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback)
                             andExtendedPermissions:kFacebookPermissions];
    }
    else
    {
        [self performSelector:@selector(fbGraphCallback) withObject:nil afterDelay:0.000000000001];
    }
}
-(void)fbGraphCallback
{
	if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) )
    {
        [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback)
							 andExtendedPermissions:kFacebookPermissions];
	}
    else
    {
        [fbGraph fbcancelcalled];
        
//        NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
//        [socialdict setObject:fbGraph.accessToken forKey:@"facebook_token"];
//        [socialdict setObject:@"Authenticate" forKey:@"facebook"];
//        [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
        
        //[strWebServicePost setString:[NSString stringWithFormat:@"func=auth_unauthFacebook&userID=%@&facebook_token=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],fbGraph.accessToken]];
        [[MyAppManager sharedManager] showLoaderInMainThread];
        [self performSelector:@selector(fbgetmyfriends) withObject:nil afterDelay:0.200000001];

	}
}

-(void)fbgetmyfriends
{
    FbGraphResponse *fb_graph_response = [fbGraph doGraphGet:@"me/friends" withGetVars:nil];
    
    NSData *jsonData = [fb_graph_response.htmlResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    [arrfbfriendsfullist addObjectsFromArray:[jsonDict objectForKey:@"data"]];
    
    
    NSSortDescriptor *sortByfullName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortByfullName];
    NSArray *sorted = [arrfbfriendsfullist sortedArrayUsingDescriptors:descriptors];
    [arrfbfriendsfullist removeAllObjects];
    [arrfbfriendsfullist addObjectsFromArray:sorted];
    [arrFriends addObjectsFromArray:sorted];
    [tblView reloadData];
    
    [[MyAppManager sharedManager] hideLoaderInMainThread];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *theTouch=[touches anyObject];
    if (theTouch.view==self.view)
    {
        [self.view endEditing:YES];
    }
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
    
    cell.isFacebookCell=YES;
    cell.btnInvite.tag=indexPath.row;
    cell.bgimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"bgcell_tf-%d",(indexPath.row%2)]];

    
    if ([dictSelectedfriends objectForKey:[[arrFriends objectAtIndex:indexPath.row] objectForKey:@"id"]])
    {
        [cell.btnInvite setImage:[UIImage imageNamed:@"ffchecked"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnInvite setImage:[UIImage imageNamed:@"ffunchecked"] forState:UIControlStateNormal];
    }
    
    [cell.btnInvite addTarget:self action:@selector(btnCheckMarkClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lblFriendName.text=[NSString stringWithFormat:@"%@",[[arrFriends objectAtIndex:indexPath.row] objectForKey:@"name"]];
    NSString *strimageurl=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [[arrFriends objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [cell.imgView setImageWithURL:[NSURL URLWithString:strimageurl] placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SocialSharingCell *cell=(SocialSharingCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([dictSelectedfriends objectForKey:[[arrFriends objectAtIndex:indexPath.row] objectForKey:@"id"]])
    {
        [dictSelectedfriends removeObjectForKey:[[arrFriends objectAtIndex:indexPath.row] objectForKey:@"id"]];
        [cell.btnInvite setImage:[UIImage imageNamed:@"ffunchecked"] forState:UIControlStateNormal];
    }
    else
    {
        [dictSelectedfriends setObject:@"YES" forKey:[[arrFriends objectAtIndex:indexPath.row] objectForKey:@"id"]];
        [cell.btnInvite setImage:[UIImage imageNamed:@"ffchecked"] forState:UIControlStateNormal];
    }
    
}

-(void)btnCheckMarkClicked:(id)sender
{
    SocialSharingCell *cell=(SocialSharingCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[(UIButton *)sender tag] inSection:0]];
    if ([dictSelectedfriends objectForKey:[[arrFriends objectAtIndex:[(UIButton *)sender tag]] objectForKey:@"id"]])
    {
        [dictSelectedfriends removeObjectForKey:[[arrFriends objectAtIndex:[(UIButton *)sender tag]] objectForKey:@"id"]];
        [cell.btnInvite setImage:[UIImage imageNamed:@"ffunchecked"] forState:UIControlStateNormal];
    }
    else
    {
        [dictSelectedfriends setObject:@"YES" forKey:[[arrFriends objectAtIndex:[(UIButton *)sender tag]] objectForKey:@"id"]];
        [cell.btnInvite setImage:[UIImage imageNamed:@"ffchecked"] forState:UIControlStateNormal];
    }
}

-(IBAction)btnInviteClicked:(id)sender
{
    [self.view endEditing:YES];
    [self performSelector:@selector(invitefacebookfriend) withObject:nil afterDelay:0.3];
}
-(void)invitefacebookfriend
{
    facebook=[[Facebook alloc]initWithAppId:kFacebookAppID andDelegate:self];
    NSMutableArray *arrSelFriendIds=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[arrFriends count]; i++)
    {
        if ([dictSelectedfriends objectForKey:[[arrFriends objectAtIndex:i] objectForKey:@"id"]])
        {
            [arrSelFriendIds addObject:[[arrFriends objectAtIndex:i] objectForKey:@"id"]];
        }
    }
    
    if ([arrSelFriendIds count]>0)
    {
        NSString *to=[arrSelFriendIds componentsJoinedByString:@","];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Please Join the myu",@"message",to,@"to",nil];
        [facebook dialog:@"apprequests" andParams:params andDelegate:self];
    }
    else
    {
        DisplayAlert(@"Please select atleast one friend!");
    }
}
-(void)dialogDidComplete:(FBDialog *)dialog
{
    DisplayAlert(@"Invitation sent!");
    [dictSelectedfriends removeAllObjects];
    [self logoutfacebook];
}
-(void)dialog:(FBDialog *)dialog didFailWithError:(NSError *)error
{
    
}
-(void)dialogDidNotCompleteWithUrl:(NSURL *)url
{
    
}
-(void)dialogDidNotComplete:(FBDialog *)dialog
{
    [self logoutfacebook];
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
        [arrFriends addObjectsFromArray:arrfbfriendsfullist];
        [tblView reloadData];
        return;
    }
    
    for (int i=0; i<[arrfbfriendsfullist count]; i++)
    {
        NSRange range =[[NSString stringWithFormat:@"%@",[[arrfbfriendsfullist objectAtIndex:i] objectForKey:@"name"]] rangeOfString:[txtSearch.text removeNull] options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound)
        {
            [arrFriends addObject:[arrfbfriendsfullist objectAtIndex:i]];
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
    tblView.frame=CGRectMake(11.0,113.0+iOS7,298.0,334.0+iPhone5ExHeight);
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
