//
//  AddFriendsViewController.m
//  Suvi
//
//  Created by Dhaval Vaishnani on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "ContactsViewController.h"
#import "TwitterViewController.h"
#import "FacebookViewController.h"
#import "SuggestedFriendsCustomCell.h"
#import "AppDelegate.h"
#import "MyFriendListingViewCtr.h"
#import "CustomBadge.h"
#import "RandomUserViewCtr.h"

@implementation AddFriendsViewController
@synthesize facebook;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
    
    searchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0+iOS7ExHeight, 320, 44)];
    searchbar.delegate=self;
    searchbar.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"search_bg.png"]];
    searchbar.placeholder=@"Search Suvi";
    searchbar.tintColor=[UIColor clearColor];
    searchbar.translucent=YES;
    [searchbar setBackgroundImage:[UIImage imageNamed:@"greytransbg.png"]];
    [searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchbar_txtbg.png"] forState:UIControlStateNormal];
    [searchbar setScopeBarBackgroundImage:[UIImage imageNamed:@"greytransbg.png"]];
    UITextField *searchField = [searchbar valueForKey:@"_searchField"];
    searchField.textColor=[UIColor darkGrayColor];
    [searchField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    searchField.keyboardAppearance=UIKeyboardAppearanceAlert;
    
   // txtSearch=[[UITextField alloc]init];
   // [txtSearch setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
   // [txtSearch setValue:[UIFont fontWithName:@"Arial-Bold" size:20.0] forKeyPath:@"_placeholderLabel.font"];

    tblview.separatorColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"greytransbg.png"]];
   
    friendData=[[NSMutableDictionary alloc]init];
    webData=[[NSMutableData alloc]init];
    arrsuvifriendsfulllist=[[NSMutableArray alloc]init];
    arrsuvifriends=[[NSMutableArray alloc]init];
    arrpeopleknowfulllist=[[NSMutableArray alloc]init];
    arrpeopleknow=[[NSMutableArray alloc]init];
   // arrrandomfulllist=[[NSMutableArray alloc]init];
    arrrandom=[[NSMutableArray alloc]init];
    arrpendingreuestfulllist=[[NSMutableArray alloc]init];
    arrpendingreuest=[[NSMutableArray alloc]init];
    arrsuvifriendssearchfulllist=[[NSMutableArray alloc]init];
    arrsuvifriendssearch= [[NSMutableArray alloc]init];
    action=[[NSMutableString alloc]init];
    actionurl=[[NSMutableString alloc]init];
    actionparameters=[[NSMutableString alloc]init];
    
    strRefreshForFriendsView = @"RefreshFriendsView";
    
    // Set Border to ScrollView
    [self SetBorderToScrollView:scl_MyFriends];
    [self SetBorderToScrollView:scl_PeopleMayKnow];
    [self SetBorderToScrollView:scl_Random];
    
    scl_Main.contentSize = CGSizeMake(scl_Main.frame.size.width,444);
}
-(void)SetBorderToScrollView:(UIScrollView*)scl
{
    [[scl layer] setMasksToBounds:YES];
    [[scl layer] setBorderColor:[RGBCOLOR(215.0, 215.0, 215.0) CGColor]];
    [[scl layer] setBorderWidth:1.0f];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [action setString:@"friends"];
    [actionurl setString:strAllFriends];
    [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]]];
    
    if ([strRefreshForFriendsView isEqualToString:@""])
    {
        strRefreshForFriendsView = @"RefreshFriendsView";
    }
    if ([strRefreshForFriendsView isEqualToString:@"RefreshFriendsView"] )
    {
        [self _startSend];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [txtSearch resignFirstResponder];
}

#pragma mark - SEARCH BAR METHODS
-(void)_searchFriend
{
    [action setString:@"searchfriends"];
    [actionurl setString:kSearchUsersURL];
    [actionparameters setString:[NSString stringWithFormat:@"userID=%@&textField=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],searchbar.text]];
    [self _startSend];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{   

}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text length]<2) {
        DisplayAlert(@"Please enter atleast two characters to search!");
        return;
    }
    
    [self _searchFriend];
    [searchbar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchbar.text=@"";
    [arrsuvifriendssearch removeAllObjects];
    [arrsuvifriendssearchfulllist removeAllObjects];
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
        [[AppDelegate sharedInstance]showLoader];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[actionparameters stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",actionurl]]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection=[NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}
-(void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
}
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error{
    [self _stopReceiveWithStatus:@"Connection failed"];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection{
    NSString *strData = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    [self _stopReceiveWithStatus:strData];
}
-(void)_stopReceiveWithStatus:(NSString *)statusString{    
    [self _receiveDidStopWithStatus:statusString];
}
-(void)_receiveDidStopWithStatus:(NSString *)statusString
{
    [[AppDelegate sharedInstance]hideLoader];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
    if( [statusString isEqual:@"Connection failed"] || statusString == nil)
    {
        return;
    }
    else
    {
        NSError *error;
        NSData *storesData = [statusString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:storesData options:NSJSONReadingMutableLeaves error:&error];
        [self setData:dict];
    }
}
-(void)setData:(NSDictionary*)dictionary
{
    if (dictionary ==(id) [NSNull null])
    {
        //DisplayAlert(@"Failed to connect with the server!");
        return;
    }
    
    NSString *strMSG =[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"MESSAGE"]] ;
    if ([strMSG isEqualToString:@"SUCCESS"]) 
    {
        if ([action isEqualToString:@"friends"]) {
            [friendData removeAllObjects];
            [friendData addEntriesFromDictionary:dictionary];
            
            // Friends Array
            [arrsuvifriendsfulllist removeAllObjects];
            [arrsuvifriendsfulllist addObjectsFromArray:[dictionary objectForKey:@"FRIENDS_DETAILS"]];

            NSSortDescriptor *sortByfullName = [[NSSortDescriptor alloc] initWithKey:@"admin_fullname" ascending:YES];
            NSArray *descriptors = [NSArray arrayWithObject:sortByfullName];
            NSArray *sorted = [arrsuvifriendsfulllist sortedArrayUsingDescriptors:descriptors];
            [arrsuvifriendsfulllist removeAllObjects];
            [arrsuvifriendsfulllist addObjectsFromArray:sorted];
            [arrsuvifriends removeAllObjects];
            [arrsuvifriends addObjectsFromArray:sorted];
            
            // People May You Know Array
            if ([arrpeopleknowfulllist count] > 0)
                [arrpeopleknowfulllist removeAllObjects];
            
            [arrpeopleknowfulllist addObjectsFromArray:[dictionary objectForKey:@"CAN_BE_COMMON_FRIEND"]];
            
            NSArray *sortedPeopleKnow = [arrpeopleknowfulllist sortedArrayUsingDescriptors:descriptors];
            
            if ([arrpeopleknow count] > 0)
                [arrpeopleknow removeAllObjects];

            [arrpeopleknow addObjectsFromArray:sortedPeopleKnow];
            
            
             PeopleUKnowTotalCount = [[dictionary objectForKey:@"CAN_BE_COMMON_FRIEND_COUNTS"] intValue];
             // Random Users Array
            //if ([arrrandomfulllist count] > 0)
             //   [arrrandomfulllist removeAllObjects];
            
            RandomUserTotalCount = [[dictionary objectForKey:@"RANDOM_USERS_COUNTS"] intValue];
            
            if ([arrrandom count] > 0)
                [arrrandom removeAllObjects];
            
            [arrrandom addObjectsFromArray:[dictionary objectForKey:@"RANDOM_USERS"]];
            
           // NSArray *sortedRandom = [arrrandomfulllist sortedArrayUsingDescriptors:descriptors];
            
           // [arrrandom addObjectsFromArray:sortedRandom];
            
            // Pending Request Array
            if ([arrpendingreuestfulllist count] > 0)
                [arrpendingreuestfulllist removeAllObjects];
            
            [arrpendingreuestfulllist addObjectsFromArray:[dictionary objectForKey:@"RECEIEVED_REQ_DETAILS"]];
            
            NSArray *sortedPendingRequst = [arrpendingreuestfulllist sortedArrayUsingDescriptors:descriptors];
            
            if ([arrpendingreuest count] > 0)
                [arrpendingreuest removeAllObjects];
            
            [arrpendingreuest addObjectsFromArray:sortedPendingRequst];
            
            
            NSString *strBadgeCount = [NSString stringWithFormat:@"%d",[arrpendingreuest count]];
            if ([strBadgeCount intValue] > 0)
            {
                CustomBadge *PendingRequestCountBadge = [CustomBadge customBadgeWithString:strBadgeCount withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor]  withBadgeFrame:NO withBadgeFrameColor:[UIColor whiteColor]  withScale:0.80 withShining:YES];
                [PendingRequestCountBadge setFrame:CGRectMake(95,4, PendingRequestCountBadge.frame.size.width, PendingRequestCountBadge.frame.size.height)];
                [scl_Main addSubview:PendingRequestCountBadge];
            }
            else
            {
                for (UIView *subview in scl_Main.subviews)
                {
                    if ([subview isKindOfClass:[CustomBadge class]])
                    {
                        [subview removeFromSuperview];  
                    }
                }
            }
           

            // If Count > then Load ScrollView
            if (arrsuvifriends.count > 0)
            {
                [self SetMyFriendsInScrollView];
                lblMsgMyFriends.hidden = YES;
            }
            else
            {
                lblMsgMyFriends.hidden = NO;
            }
            
            if (arrpeopleknow.count > 0)
                [self SetPeopleMayYouKnowInScrollView];

            if (arrrandom.count > 0)
                [self SetRandomInScrollView];
            
            // Set Alpha Of scrollView With Animations
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1];
            scl_MyFriends.alpha=1;
            scl_PeopleMayKnow.alpha = 1;
            scl_Random.alpha = 1;
            btn_MyFriends.alpha=1;
            btn_PeopleMayKnow.alpha = 1;
            btn_Random.alpha = 1;
            [UIView commitAnimations];
        }
        else if([action isEqualToString:@"searchfriends"])
        {
            [arrsuvifriendssearchfulllist removeAllObjects];
            [arrsuvifriendssearchfulllist addObjectsFromArray:[dictionary objectForKey:@"USER_DETAIL"]];
            
            NSSortDescriptor *sortByfullName = [[NSSortDescriptor alloc] initWithKey:@"admin_fname" ascending:YES];
            NSArray *descriptors = [NSArray arrayWithObject:sortByfullName];
            NSArray *sorted = [arrsuvifriendssearchfulllist sortedArrayUsingDescriptors:descriptors];
            [arrsuvifriendssearchfulllist removeAllObjects];
            [arrsuvifriendssearchfulllist addObjectsFromArray:sorted];
            [arrsuvifriendssearch removeAllObjects];
            [arrsuvifriendssearch addObjectsFromArray:sorted];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1];
            tblview.alpha=1;
            
            [UIView commitAnimations];
            [tblview reloadData];
        }
        else if([action isEqualToString:@"addfriends"] || [action isEqualToString:@"SendFriendRequest"])
        {
            DisplayAlert(@"Friend request sent!");
        }
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchFriendsAndNavigate:textField.text];
    return YES;
}
-(void)searchFriendsAndNavigate:(NSString*)strSearch
{
    if ([[strSearch removeNull] length]<=1)
    {
        DisplayAlert(@"Please enter two or more characters to search!");
    }
    else
    {
        strRefreshForFriendsView = @"NoRefreshFriendsView";
        FriendsSearchViewController *obj=[[FriendsSearchViewController alloc]init];
        obj.strsearchtext=[NSString stringWithFormat:@"%@",[strSearch removeNull]];
        txtSearch.text=@"";
        [self.navigationController pushViewController:obj animated:YES];
    }
}

-(IBAction)btnbackclicked:(id)sender
{
    AddViewFlag=50;
    [[NSUserDefaults standardUserDefaults]setValue:@"SignUPDone" forKey:@"SignUP"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self dismissModalViewControllerAnimated:YES];
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
#pragma mark - IBActions Methods
-(IBAction)btnFBInvitePressed:(id)sender
{
    strRefreshForFriendsView = @"NoRefreshFriendsView";
    FacebookViewController *obj=[[FacebookViewController alloc]init];
    [self.navigationController pushViewController:obj animated:YES];
    
    /*
    facebook = [[Facebook alloc] initWithAppId:kFacebookApp_ID andDelegate:self];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kAppInviteText,@"message",nil];
    [self.facebook dialog:@"apprequests" andParams:params andDelegate:nil];
     */
}

-(IBAction)btnTwitterInvitePressed:(id)sender
{
    strRefreshForFriendsView = @"NoRefreshFriendsView";
    TwitterViewController *obj=[[TwitterViewController alloc]init];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnContactInvitePressed:(id)sender
{
    strRefreshForFriendsView = @"NoRefreshFriendsView";
    ContactsViewController *obj=[[ContactsViewController alloc]init];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnRandomPressed:(id)sender
{
    if ([arrrandom count] > 0)
    {
        strRefreshForFriendsView = @"NoRefreshFriendsView";
        RandomUserViewCtr *obj_RandomUserViewCtr = [[RandomUserViewCtr alloc]initWithNibName:@"RandomUserViewCtr" bundle:nil];
        obj_RandomUserViewCtr.strFromView = @"Random";
        obj_RandomUserViewCtr.ArrayUsersList = arrrandom;
        obj_RandomUserViewCtr.pageCount = 0;
        obj_RandomUserViewCtr.TotalCount = RandomUserTotalCount;
        [self.navigationController pushViewController:obj_RandomUserViewCtr animated:YES];
        obj_RandomUserViewCtr = nil;
    }
}
-(IBAction)btnSuggestedFriendPressed:(id)sender
{
    if ([arrpeopleknow count] > 0)
    {
        strRefreshForFriendsView = @"NoRefreshFriendsView";
        RandomUserViewCtr *obj_RandomUserViewCtr = [[RandomUserViewCtr alloc]initWithNibName:@"RandomUserViewCtr" bundle:nil];
        obj_RandomUserViewCtr.strFromView = @"Suggested Friends";
        obj_RandomUserViewCtr.ArrayUsersList = arrpeopleknow;
        obj_RandomUserViewCtr.pageCount = 0;
        obj_RandomUserViewCtr.TotalCount = PeopleUKnowTotalCount;
        [self.navigationController pushViewController:obj_RandomUserViewCtr animated:YES];
        obj_RandomUserViewCtr = nil;
    }
}
-(IBAction)btnMyFriendsPressed:(id)sender
{
    if ([arrsuvifriends count] > 0 || [arrpendingreuest count] > 0)
    {
        strRefreshForFriendsView = @"NoRefreshFriendsView";
        MyFriendListingViewCtr *obj_MyFriendListingViewCtr = [[MyFriendListingViewCtr alloc]initWithNibName:@"MyFriendListingViewCtr" bundle:nil];
        obj_MyFriendListingViewCtr.ArryFriends = arrsuvifriends;
        obj_MyFriendListingViewCtr.ArryPendingRequest = arrpendingreuest;
        [self.navigationController pushViewController:obj_MyFriendListingViewCtr animated:YES];
        obj_MyFriendListingViewCtr = nil;
    }
}
-(IBAction)btnSearchPressed:(id)sender
{
    [txtSearch resignFirstResponder];
    [self searchFriendsAndNavigate:txtSearch.text];
}
-(void)btnUserProfileClicked:(id)sender
{
    [self FriendsProfileViewPush:[sender tag] showonefeed:YES viewFrom:@"RandomView"];
}
-(void)btnMyFriendsUserProfileClicked:(id)sender
{
    [self FriendsProfileViewPush:[sender tag] showonefeed:NO viewFrom:@"FriendView"];
}
-(void)FriendsProfileViewPush:(int)adminid showonefeed:(BOOL)showfeed viewFrom:(NSString*)strFromView
{
    strRefreshForFriendsView = @"NoRefreshFriendsView";
    FriendsProfileVC *objFriendsProfileVC = [[FriendsProfileVC alloc]initWithNibName:@"FriendsProfileVC" bundle:nil];
    objFriendsProfileVC.admin_id = [NSString stringWithFormat:@"%d",adminid];
    objFriendsProfileVC.shouldShowOnlyOneFeed = showfeed;
    objFriendsProfileVC.strFrom = strFromView;
    [self.navigationController pushViewController:objFriendsProfileVC animated:YES];
    objFriendsProfileVC = nil;
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

#pragma mark - ScrollView Set UP
-(void)SetMyFriendsInScrollView
{
    while ([scl_MyFriends.subviews count] > 0)
    {
        [[[scl_MyFriends subviews] objectAtIndex:0] removeFromSuperview];
    }
    int Yaxis = 7;
    int Xaxis = 14;
    
    for (int i = 1; i <= [arrsuvifriends count]; i++)
    {
        NSDictionary *DicfriendsDetail = [[NSDictionary alloc] initWithDictionary:[arrsuvifriends objectAtIndex:i-1]];
        
        NSString *strGender=[NSString stringWithFormat:@"%@",([DicfriendsDetail objectForKey:@"eGender"])?[DicfriendsDetail objectForKey:@"eGender"]:@""];
        BOOL isUserMale=([strGender isEqualToString:@"Male"])?YES:NO;
        
        UIButton *btnUserProfile = [UIButton buttonWithType:UIButtonTypeCustom];
        btnUserProfile.frame = CGRectMake(Xaxis, Yaxis, 84, 84);
        //[btnUserProfile setImageWithURL: placeholderImage:];
         [btnUserProfile setImageWithURL:[NSURL URLWithString:[[DicfriendsDetail valueForKey:@"image_path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:(isUserMale)?@"suvimale.png":@"suvifemale.png"]];
        btnUserProfile.tag= [[DicfriendsDetail objectForKey:@"admin_id"] intValue];
        [btnUserProfile addTarget:self action:@selector(btnMyFriendsUserProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnUserProfile.backgroundColor = [UIColor clearColor];
        btnUserProfile.userInteractionEnabled = YES;
        [scl_MyFriends addSubview:btnUserProfile];
        
        UILabel *lblUser = [[UILabel alloc]initWithFrame:CGRectMake(Xaxis,Yaxis+87,84,15)];
        lblUser.text = [[NSString stringWithFormat:@"%@",[DicfriendsDetail valueForKey:@"admin_fullname"]] removeNull];
        lblUser.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblUser.textAlignment = UITextAlignmentLeft;
        lblUser.backgroundColor = [UIColor clearColor];
        lblUser.textColor = RGBCOLOR(73.0, 72.0, 72.0);
        [scl_MyFriends addSubview:lblUser];
                
        if (i % 3 == 0)
            Xaxis = Xaxis + 114;
        else
            Xaxis = Xaxis + 98;
    }
    if (arrsuvifriends.count % 3 == 0)
    {
        scl_MyFriends.contentSize = CGSizeMake(Xaxis, scl_MyFriends.frame.size.height);
    }
    else if (arrsuvifriends.count % 3 == 1)
    {
        scl_MyFriends.contentSize = CGSizeMake(Xaxis + (2 * 114), scl_MyFriends.frame.size.height);
    }
    else if (arrsuvifriends.count % 3 == 2)
    {
        scl_MyFriends.contentSize = CGSizeMake(Xaxis + (1 * 114), scl_MyFriends.frame.size.height);
    }
}
-(void)SetPeopleMayYouKnowInScrollView
{
    while ([scl_PeopleMayKnow.subviews count] > 0)
    {
        [[[scl_PeopleMayKnow subviews] objectAtIndex:0] removeFromSuperview];
    }
    int Yaxis = 5;
    int Xaxis = 14;
    
    for (int i = 1; i <= [arrpeopleknow count]; i++)
    {
        NSDictionary *DicfriendsDetail = [[NSDictionary alloc] initWithDictionary:[arrpeopleknow objectAtIndex:i-1]];
        
        NSString *strGender=[NSString stringWithFormat:@"%@",([DicfriendsDetail objectForKey:@"eGender"])?[DicfriendsDetail objectForKey:@"eGender"]:@""];
        BOOL isUserMale=([strGender isEqualToString:@"Male"])?YES:NO;
        
        UIButton *btnUserProfile = [UIButton buttonWithType:UIButtonTypeCustom];
        btnUserProfile.frame = CGRectMake(Xaxis, Yaxis + 4, 84, 84);
        //[btnUserProfile setImageWithURL:[NSURL URLWithString:[[DicfriendsDetail valueForKey:@"image_path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]  placeholderImage:[UIImage imageNamed:(isUserMale)?@"suvimale.png":@"suvifemale.png"]];
         [btnUserProfile setImageWithURL:[NSURL URLWithString:[[DicfriendsDetail valueForKey:@"image_path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:(isUserMale)?@"suvimale.png":@"suvifemale.png"]];
        btnUserProfile.tag= [[DicfriendsDetail objectForKey:@"admin_id"] intValue];
        [btnUserProfile addTarget:self action:@selector(btnUserProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnUserProfile.backgroundColor = [UIColor clearColor];
        btnUserProfile.userInteractionEnabled = YES;
        [scl_PeopleMayKnow addSubview:btnUserProfile];
        
        UILabel *lblUser=[[UILabel alloc]initWithFrame:CGRectMake(Xaxis,Yaxis+87,84,15)];
        lblUser.text=[[NSString stringWithFormat:@"%@",[DicfriendsDetail valueForKey:@"admin_fullname"]] removeNull];
        lblUser.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        lblUser.textAlignment=UITextAlignmentLeft;
        lblUser.backgroundColor=[UIColor clearColor];
        lblUser.textColor = RGBCOLOR(73.0, 72.0, 72.0);
        [scl_PeopleMayKnow addSubview:lblUser];
        
        UILabel *lblSharedFrndr=[[UILabel alloc]initWithFrame:CGRectMake(Xaxis,Yaxis+102,84,12)];
        NSString *strAppend;
        if ([[DicfriendsDetail valueForKey:@"No_of_mutualFriends"] intValue] == 1)
        {
            strAppend = @"mutual friend";
        }
        else
        {
            strAppend = @"mutual friends";
        }
        lblSharedFrndr.text=[[NSString stringWithFormat:@"%@ %@",[DicfriendsDetail valueForKey:@"No_of_mutualFriends"],strAppend] removeNull];
        lblSharedFrndr.font=[UIFont fontWithName:@"Helvetica" size:10.0];
        lblSharedFrndr.textAlignment=UITextAlignmentLeft;
        lblSharedFrndr.backgroundColor=[UIColor clearColor];
        lblSharedFrndr.textColor= RGBCOLOR(49.0f, 126.0f, 103.0f);
        [scl_PeopleMayKnow addSubview:lblSharedFrndr];
        
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAdd.frame = CGRectMake(Xaxis+66, Yaxis - 2, 29, 29);
        btnAdd.tag = [[DicfriendsDetail valueForKey:@"admin_id"] intValue];
        [btnAdd addTarget:self action:@selector(btnSendFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        [btnAdd setImage:[UIImage imageNamed:@"btnPlus.png"] forState:UIControlStateNormal];
        
        if ([[DicfriendsDetail objectForKey:@"canSendFrndReq"] isEqualToString:@"YES"] &&
            [[DicfriendsDetail objectForKey:@"isAlreadyFrnd"] isEqualToString:@"NO"])
        {
            btnAdd.hidden=NO;
        }
        else
        {
            btnAdd.hidden=YES;
        }
        
        [scl_PeopleMayKnow addSubview:btnAdd];
        
        
        if (i % 3 == 0)
            Xaxis = Xaxis + 114;
        else
            Xaxis = Xaxis + 98;
    }
    if (arrpeopleknow.count % 3 == 0)
    {
        scl_PeopleMayKnow.contentSize = CGSizeMake(Xaxis, scl_PeopleMayKnow.frame.size.height);
    }
    else if (arrpeopleknow.count % 3 == 1)
    {
        scl_PeopleMayKnow.contentSize = CGSizeMake(Xaxis + (2 * 114), scl_PeopleMayKnow.frame.size.height);
    }
    else if (arrpeopleknow.count % 3 == 2)
    {
        scl_PeopleMayKnow.contentSize = CGSizeMake(Xaxis + (1 * 98), scl_PeopleMayKnow.frame.size.height);
    }
}
-(void)SetRandomInScrollView
{
    while ([scl_Random.subviews count] > 0)
    {
        [[[scl_Random subviews] objectAtIndex:0] removeFromSuperview];
    }
    int Yaxis = 5;
    int Xaxis = 14;
    
    for (int i = 1; i <= [arrrandom count]; i++)
    {
        NSDictionary *DicfriendsDetail = [[NSDictionary alloc] initWithDictionary:[arrrandom objectAtIndex:i-1]];
        
        NSString *strGender=[NSString stringWithFormat:@"%@",([DicfriendsDetail objectForKey:@"eGender"])?[DicfriendsDetail objectForKey:@"eGender"]:@""];
        BOOL isUserMale=([strGender isEqualToString:@"Male"])?YES:NO;
        
        UIButton *btnUserProfile = [UIButton buttonWithType:UIButtonTypeCustom];
        btnUserProfile.frame = CGRectMake(Xaxis, Yaxis + 4, 84, 84);
        //[btnUserProfile setImageWithURL:[NSURL URLWithString:[[DicfriendsDetail valueForKey:@"vProfilePicName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:(isUserMale)?@"suvimale.png":@"suvifemale.png"]];
        [btnUserProfile setImageWithURL:[NSURL URLWithString:[[DicfriendsDetail valueForKey:@"vProfilePicName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:(isUserMale)?@"suvimale.png":@"suvifemale.png"]];
        btnUserProfile.tag= [[DicfriendsDetail objectForKey:@"admin_id"] intValue];
        [btnUserProfile addTarget:self action:@selector(btnUserProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnUserProfile.backgroundColor = [UIColor clearColor];
        btnUserProfile.userInteractionEnabled = YES;
        [scl_Random addSubview:btnUserProfile];
        
        UILabel *lblUser=[[UILabel alloc]initWithFrame:CGRectMake(Xaxis,Yaxis+87,84,15)];
        lblUser.text=[[NSString stringWithFormat:@"%@",[DicfriendsDetail valueForKey:@"admin_fullname"]] removeNull];
        lblUser.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        lblUser.textAlignment=UITextAlignmentLeft;
        lblUser.backgroundColor=[UIColor clearColor];
        lblUser.textColor = RGBCOLOR(73.0, 72.0, 72.0);
        [scl_Random addSubview:lblUser];
        
        UILabel *lblSchool=[[UILabel alloc]initWithFrame:CGRectMake(Xaxis,Yaxis+102,84,12)];
        lblSchool.text=[[NSString stringWithFormat:@"%@",[DicfriendsDetail valueForKey:@"school"]] removeNull];
        lblSchool.font=[UIFont fontWithName:@"Helvetica" size:10.0];
        lblSchool.textAlignment=UITextAlignmentLeft;
        lblSchool.backgroundColor=[UIColor clearColor];
        lblSchool.textColor= RGBCOLOR(49.0f, 126.0f, 103.0f);
        [scl_Random addSubview:lblSchool];
        
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAdd.frame = CGRectMake(Xaxis+66, Yaxis - 2, 29, 29);
        btnAdd.tag = [[DicfriendsDetail valueForKey:@"admin_id"] intValue];
        [btnAdd addTarget:self action:@selector(btnSendFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        [btnAdd setImage:[UIImage imageNamed:@"btnPlus.png"] forState:UIControlStateNormal];
        
        if ([[DicfriendsDetail objectForKey:@"canSendFrndReq"] isEqualToString:@"YES"] &&
            [[DicfriendsDetail objectForKey:@"isAlreadyFrnd"] isEqualToString:@"NO"])
        {
            btnAdd.hidden=NO;
        }
        else
        {
            btnAdd.hidden=YES;
        }
        
        [scl_Random addSubview:btnAdd];
        
        if (i % 3 == 0)
            Xaxis = Xaxis + 114;
        else
            Xaxis = Xaxis + 98;
    }
    if (arrrandom.count % 3 == 0)
    {
        scl_Random.contentSize = CGSizeMake(Xaxis, scl_Random.frame.size.height);
    }
    else if (arrrandom.count % 3 == 1)
    {
        scl_Random.contentSize = CGSizeMake(Xaxis + (2 * 114), scl_Random.frame.size.height);
    }
    else if (arrrandom.count % 3 == 2)
    {
        scl_Random.contentSize = CGSizeMake(Xaxis + (1 * 114), scl_Random.frame.size.height);
    }
}

-(void)btnSendFriendRequest:(id)sender
{
    UIButton *btnRequest=(UIButton *)sender;
    btnRequest.hidden=YES;
    
    for (int i=0; i<[arrrandom count];i++)
    {
        if ([sender tag] == [[[arrrandom objectAtIndex:i]  valueForKey:@"admin_id"] intValue])
        {
            NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc]initWithDictionary:[arrrandom objectAtIndex:i]];
            [dictTemp setObject:@"NO" forKey:@"canSendFrndReq"];
            [arrrandom replaceObjectAtIndex:i withObject:dictTemp];
        }
    }
    
    for (int i=0; i<[arrpeopleknow count];i++)
    {
        if ([sender tag] == [[[arrpeopleknow objectAtIndex:i]  valueForKey:@"admin_id"] intValue])
        {
            NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc]initWithDictionary:[arrpeopleknow objectAtIndex:i]];
            [dictTemp setObject:@"NO" forKey:@"canSendFrndReq"];
            [arrpeopleknow replaceObjectAtIndex:i withObject:dictTemp];
        }
    }
    
    strFriendID = [NSString stringWithFormat:@"%d",[sender tag]];
    [action setString:@"SendFriendRequest"];
    [actionurl setString:kSendFriendRequestURL];
    [actionparameters setString:[NSString stringWithFormat:@"userID=%@&frndIDs=%@&sometext=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],strFriendID,@""]];
    [self _startSend];
}

@end
