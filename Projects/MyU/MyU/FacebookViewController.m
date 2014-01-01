//
//  FacebookViewController.m
//  Suvi
//
//  Created by Dhaval Vaishnani on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookViewController.h"
#import "ContactCustomCell.h"
#import "AppDelegate.h"

@implementation FacebookViewController
@synthesize fbGraph;
@synthesize facebook;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
    
    searchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchbar.delegate=self;
    searchbar.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"search_bg.png"]];
    searchbar.placeholder=@"Search Contacts on Facebook";
    searchbar.tintColor=[UIColor clearColor];
    searchbar.translucent=YES;
    [searchbar setBackgroundImage:[UIImage imageNamed:@"greytransbg.png"]];
    [searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchbar_txtbg.png"] forState:UIControlStateNormal];
    [searchbar setScopeBarBackgroundImage:[UIImage imageNamed:@"greytransbg.png"]];
    UITextField *searchField = [searchbar valueForKey:@"_searchField"];
    searchField.textColor=[UIColor darkGrayColor];
    [searchField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    tblview.backgroundColor =[UIColor clearColor];
    tblview.separatorColor=[UIColor grayColor];
    tblview.alpha=0;
    tblview.tableHeaderView=searchbar;
    
    strWebServicePost=[[NSMutableString alloc]init];
}

#pragma mark - FACEBOOK METHODS
-(IBAction)btnFacebookClicked:(id)sender
{
   [self initializefacebook];
}
#pragma mark - SEARCH BAR METHODS
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{   
    [arrfbfriends removeAllObjects];
        
    for (int j=0; j<[arrfbfriendsfullist count]; j++) {
        NSRange range = [[[arrfbfriendsfullist objectAtIndex:j] objectForKey:@"name"] rangeOfString:searchbar.text options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound)
        {
            [arrfbfriends addObject:[arrfbfriendsfullist objectAtIndex:j]];
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
    [arrfbfriends removeAllObjects];
    [arrfbfriends addObjectsFromArray:arrfbfriendsfullist];
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
    return [arrfbfriends count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ContactCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ContactCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.btninvite.tag=indexPath.row;
    
    if ([dictSelectedfriends objectForKey:[[arrfbfriends objectAtIndex:indexPath.row] objectForKey:@"id"]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.lblcontactname.text=[NSString stringWithFormat:@"%@",[[arrfbfriends objectAtIndex:indexPath.row] objectForKey:@"name"]];
    NSString *strimageurl=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [[arrfbfriends objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [cell.imgview setImageWithURL:[NSURL URLWithString:strimageurl] placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
    cell.btninvite.hidden=YES;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([dictSelectedfriends objectForKey:[[arrfbfriends objectAtIndex:indexPath.row] objectForKey:@"id"]])
    {
        [dictSelectedfriends removeObjectForKey:[[arrfbfriends objectAtIndex:indexPath.row] objectForKey:@"id"]];
    }
    else
    {
        [dictSelectedfriends setObject:@"YES" forKey:[[arrfbfriends objectAtIndex:indexPath.row] objectForKey:@"id"]];
    }
    
    [tblview reloadData];
}

-(IBAction)btnInviteClicked:(id)sender
{
    [searchbar resignFirstResponder];
    selectedindex=[(UIButton *)sender tag];
    [self performSelector:@selector(invitefacebookfriend) withObject:nil afterDelay:0.3];
}
-(void)invitefacebookfriend
{
    facebook=[[Facebook alloc]initWithAppId:kFacebookApp_ID andDelegate:self];
    NSMutableArray *arrSelFriendIds=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[arrfbfriends count]; i++)
    {
        if ([dictSelectedfriends objectForKey:[[arrfbfriends objectAtIndex:i] objectForKey:@"id"]])
        {
            [arrSelFriendIds addObject:[[arrfbfriends objectAtIndex:i] objectForKey:@"id"]];
        }
    }
    
    if ([arrSelFriendIds count]>0)
    {
        NSString *to=[arrSelFriendIds componentsJoinedByString:@","];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:kAppInviteText,  @"message",to, @"to",nil];
        [self.facebook dialog:@"apprequests" andParams:params andDelegate:self];
    }
    else{
        DisplayAlert(@"Please select atleast one friend!");
    }
}
-(void)dialogDidComplete:(FBDialog *)dialog
{
    DisplayAlertWithTitle(@"Facebook",@"Friend request sent!");
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


@end
