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
    
    searchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,44)];
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
    arrfbfriendsfullist= [[NSMutableArray alloc]init];
    dictSelectedfriends=[[NSMutableDictionary alloc]init];
    arrfbfriends= [[NSMutableArray alloc]init];
    
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"] objectForKey:@"facebook"] isEqualToString:@"Unauthenticate"])
    {
        btnFBConnect.hidden=NO;
        [self initializefacebook];
        
//        [AppDelegate sharedInstance].facebook = [[Facebook alloc] initWithAppId:kFacebookApp_ID andDelegate:self];
//        NSArray *arrPermissions=[[NSArray alloc]initWithObjects:@"publish_stream",@"offline_access",@"user_checkins",@"read_stream",@"email",@"publish_checkins",@"user_photos",@"user_videos",@"friends_checkins",@"publish_actions", nil];
//        [[AppDelegate sharedInstance].facebook authorize:arrPermissions];
//        if (![[AppDelegate sharedInstance].facebook isSessionValid]) {
//            NSArray *arrPermissions=[[NSArray alloc]initWithObjects:@"publish_stream",@"offline_access",@"user_checkins",@"read_stream",@"email",@"publish_checkins",@"user_photos",@"user_videos",@"friends_checkins",@"publish_actions", nil];
//            [[AppDelegate sharedInstance].facebook authorize:arrPermissions];
//        }
//        else{
//            [self fbDidLogin];
//        }
    }
    else
    {
        btnFBConnect.hidden=YES;
        [self getfacebookfriends];
    }
}

-(IBAction)btnbackclicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - FACEBOOK METHODS
-(IBAction)btnFacebookClicked:(id)sender
{
   [self initializefacebook];
    
//    [AppDelegate sharedInstance].facebook = [[Facebook alloc] initWithAppId:kFacebookApp_ID andDelegate:self];
//    NSArray *arrPermissions=[[NSArray alloc]initWithObjects:@"publish_stream",@"offline_access",@"user_checkins",@"read_stream",@"email",@"publish_checkins",@"user_photos",@"user_videos",@"friends_checkins",@"publish_actions", nil];
//    [[AppDelegate sharedInstance].facebook authorize:arrPermissions];
//    if (![[AppDelegate sharedInstance].facebook isSessionValid])
//    {
//        NSArray *arrPermissions=[[NSArray alloc]initWithObjects:@"publish_stream",@"offline_access",@"user_checkins",@"read_stream",@"email",@"publish_checkins",@"user_photos",@"user_videos",@"friends_checkins",@"publish_actions", nil];
//        [[AppDelegate sharedInstance].facebook authorize:arrPermissions];
//    }
//    else{
//        [self fbDidLogin];
//    }
}
-(void)allocFBIfNeeded
{
    if(!self.fbGraph)
    {
        self.fbGraph = [[FbGraph alloc] initWithFbClientID:kFacebookApp_ID];
        NSString *strToken=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"] objectForKey:@"facebook_token"]];
        if ([strToken length]>2)
        {
            fbGraph.accessToken=[[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"] objectForKey:@"facebook_token"];
        }
    }
}
-(void)getfacebookfriends
{
    [self allocFBIfNeeded];
    [self performSelector:@selector(getdetails) withObject:nil afterDelay:0.000000001];
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
	[self performSelector:@selector(openfacebook) withObject:nil afterDelay:0.3f];
}
-(void)openfacebook
{
    self.fbGraph = [[FbGraph alloc] initWithFbClientID:kFacebookApp_ID];
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
        btnFBConnect.hidden=YES;
        
        NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
        [socialdict setObject:fbGraph.accessToken forKey:@"facebook_token"];
        [socialdict setObject:@"Authenticate" forKey:@"facebook"];
        [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [fbGraph fbcancelcalled]; 
        [tblview reloadData];
        
        [strWebServicePost setString:[NSString stringWithFormat:@"func=auth_unauthFacebook&userID=%@&facebook_token=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],fbGraph.accessToken]];
        [self performSelector:@selector(_startSend) withObject:nil afterDelay:0.4];
	}
}

- (void)fbDidLogin {

    btnFBConnect.hidden=YES;
    
    
    
    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    [socialdict setObject:[[AppDelegate sharedInstance].facebook accessToken] forKey:@"facebook_token"];
    [socialdict setObject:@"Authenticate" forKey:@"facebook"];
    [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [tblview reloadData];
    
    [strWebServicePost setString:[NSString stringWithFormat:@"func=auth_unauthFacebook&userID=%@&facebook_token=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[[AppDelegate sharedInstance].facebook accessToken]]];
    [self performSelector:@selector(_startSend) withObject:nil afterDelay:0.4];
}

-(void)getdetails
{
    [[AppDelegate sharedInstance] showLoadingView];
    [self performSelector:@selector(fbgetmyfriends) withObject:nil afterDelay:0.200000001]; 
}
-(void)fbgetmyfriends
{
    self.fbGraph = [[FbGraph alloc] initWithFbClientID:kFacebookApp_ID];
    NSString *strToken=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"] objectForKey:@"facebook_token"]];
    if ([strToken length]>2)
    {
        fbGraph.accessToken=[[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"] objectForKey:@"facebook_token"];
    }
    
    
    FbGraphResponse *fb_graph_response = [fbGraph doGraphGet:@"me/friends" withGetVars:nil];
    
    NSData *jsonData = [fb_graph_response.htmlResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];

    [arrfbfriendsfullist addObjectsFromArray:[jsonDict objectForKey:@"data"]];
    [[AppDelegate sharedInstance] hideLoadingView];
    
    NSSortDescriptor *sortByfullName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortByfullName];
    NSArray *sorted = [arrfbfriendsfullist sortedArrayUsingDescriptors:descriptors];
    [arrfbfriendsfullist removeAllObjects];
    [arrfbfriendsfullist addObjectsFromArray:sorted];
    [arrfbfriends addObjectsFromArray:sorted];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    tblview.alpha=1;
    
    [UIView commitAnimations];
    [tblview reloadData];
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

#pragma mark - Webservice Called
-(void)_startSend
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading...";
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"%@",strWebServicePost]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:kAuthoriseUnauthoriseSocialNw]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}
#pragma mark - NSUrl Delegate
-(void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [self _stopReceiveWithStatus:@"Connection failed"];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    NSString *strData = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    [self _stopReceiveWithStatus:strData];
}
-(void)_stopReceiveWithStatus:(NSString *)statusString
{
    [self _receiveDidStopWithStatus:statusString];
}
-(void)_receiveDidStopWithStatus:(NSString *)statusString
{
    if( [statusString isEqual:@"Connection failed"] || statusString == nil)
    {
        //DisplayAlertWithTitle(@"Error", @"Failed to connect with the server!");
        return;
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self allocFBIfNeeded];
        [self performSelector:@selector(getdetails) withObject:nil afterDelay:0.300000001];
    }
}
-(void)setData:(NSDictionary*)dictionary
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (dictionary ==(id) [NSNull null])
    {
        //DisplayAlert(@"Failed to connect with the server!");
        return;
    }
    else
    {
        NSString *strMSG =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"MESSAGE"] removeNull]] ;
        if ([strMSG isEqualToString:@""])
        {
           // DisplayAlert(@"Failed to connect with the server!");
            return;
        }
        if ([strMSG isEqualToString:@"SUCCESS"]) 
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1];
            tblview.alpha=1;
            [UIView commitAnimations];
            [tblview reloadData];
        }
        else
        {
            if ([[strMSG removeNull]length]>0)
            {
                DisplayAlertWithTitle(APP_Name, strMSG);
            }
            
            return;
        }
    }
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
//    [cell.btninvite addTarget:self action:@selector(btnInviteClicked:) forControlEvents:UIControlEventTouchUpInside];
//    cell.btninvite.alpha=1;
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
    selectedindex=[sender tag];
    [self performSelector:@selector(invitefacebookfriend) withObject:nil afterDelay:0.3];
}
-(void)invitefacebookfriend
{
    facebook=[[Facebook alloc]initWithAppId:kFacebookApp_ID andDelegate:self];
    //NSArray *arrSelFriendIds=[NSArray arrayWithArray:[dictSelectedfriends allKeys]];
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
        
//        NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                          @"Get Started",@"name",@"http://www.facebook.com/apps/application.php?id=135775646522275/",@"link", nil], nil];
//        UIImage *appImage=[UIImage imageNamed:@"foursquare_unshare@2x.png"];
//        NSString *actionLinksStr = [NSString stringWithFormat:@"%@",actionLinks];
//        
//        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       @"Check out this awesome app I am using.",@"message",
//                                       @"Check this out", @"notification_text",
//                                       @"http://www.facebook.com/apps/application.php?id=135775646522275/",@"link",
//                                       actionLinksStr, @"actions",
//                                       to, @"to",
//                                       nil];
        
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lblheader=[[UILabel alloc]init];
    lblheader.frame=CGRectMake(0, 0, 320,22);
    lblheader.textColor=[UIColor whiteColor];
    lblheader.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"greytransbg.png"]];
    lblheader.text=@"  Invite to Suvi";
    return lblheader;
}

#pragma mark - DEFAULT

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
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate
{
    return NO;
}

@end
