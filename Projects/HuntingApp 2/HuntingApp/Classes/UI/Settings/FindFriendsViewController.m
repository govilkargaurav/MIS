//
//  FindFriendsViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FindFriendsViewController.h"
#import "SettingsViewController.h"
#import "AddLocationViewController.h"
#import "SearchViewController.h"
#import "SHKFacebook.h"
#import <Twitter/Twitter.h>
#import <Accounts/ACAccount.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccountType.h>
#import "AddressBook/AddressBook.h"

#define KALERT_TAG_CONTACT  100
#define KALERT_TAG_EMAIL    101


@interface FindFriendsViewController (Private)

- (void)gotoAddLocation;
- (void)gotoFriendsTableViewController:(NSArray *)friendsInfo;
- (void)findFriendFromFacebook;
- (void)findFriendFromTwitter;
- (void)sendMessage:(NSString *)message toNumber:(NSArray *)numbers;
- (NSArray *)getContactsList;
- (NSArray *)removeOwnProfileFromArray:(NSArray *)array;
@end

@implementation FindFriendsViewController
@synthesize isLoggedFirstTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isLoggedFirstTime = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isSearching = NO;
    facebookButtonPressed = NO;
	// Do any additional setup after loading the view.
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar addSubview:titleView];
    if (!isLoggedFirstTime)
        self.navigationItem.leftBarButtonItem = [Utility barButtonItemWithImageName:@"left-arrow" Selector:@selector(popViewController) Target:self];
}

- (void)applicationDidBecomeActive:(id)sender
{
    if (facebookButtonPressed)
        [self findFriendFromFacebook];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [titleView removeFromSuperview];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)dealloc
{
    if (searchFriendRequest)
    {
        searchFriendRequest.delegate = nil;
        RELEASE_SAFELY(searchFriendRequest);
    }
    RELEASE_SAFELY(titleView);
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"AddLocation"])
    {
        AddLocationViewController *controller = (AddLocationViewController *)[segue destinationViewController];
        [controller setIsLoggedFirstTime:YES];
    }
    else if ([[segue identifier]isEqualToString:@"SearchView"]) 
    {
        SearchViewController *controller = (SearchViewController *)[segue destinationViewController];
        NSArray *friendsInfo = [NSArray arrayWithArray:(NSArray *)sender];
        [controller setItems:friendsInfo];
    }
}

- (IBAction)search:(UIButton *)sender 
{
    
    switch (sender.tag) {
        case 0:
        {
            NSArray *contacts = [self getContactsList];
            if (contacts.count!=0)
            {
                [self gotoFriendsTableViewController:contacts];
            }
            else {
                BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Search Friend" message:@"There are no contacts in your phone book" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alert show];
            }
            
        }
            break;
        case 1:
        {
            BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Search Friend" message:@"" delegate:self cancelButtonTitle:@"Search" otherButtonTitles:@"Cancel",nil] autorelease];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [alert setTag:KALERT_TAG_EMAIL];
            [alert show];
        }
            break;
        case 2:
        {
            [self findFriendFromTwitter];
            
        }
            break;
        case 3:
        {
            [self findFriendFromFacebook];
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark
#pragma UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        NSString *searchValue = [alertView textFieldAtIndex:0].text;
        if (searchFriendRequest)
        {
            searchFriendRequest.delegate = nil;
            RELEASE_SAFELY(searchFriendRequest);
        }
        searchFriendRequest = [[WebServices alloc] init];
        [searchFriendRequest setDelegate:self];
        switch (alertView.tag) {
            case KALERT_TAG_CONTACT:
            {
                [searchFriendRequest searchProfileBy:KWEB_SERVICE_PHONE andValue:searchValue];
            }
                break;
            case KALERT_TAG_EMAIL:
            {
                [searchFriendRequest searchProfileBy:KWEB_SERVICE_EMAIL andValue:searchValue];
            }
                break;
            default:
                break;
        }
        loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Searching..."];
    }
}

# pragma mark
# pragma Request Wrapper Delegate
- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    isSearching = NO;
    if (searchFriendRequest)
    {
        searchFriendRequest.delegate = nil;
        RELEASE_SAFELY(searchFriendRequest);
    }
    [loadingActivityIndicator removeFromSuperview];
    NSDictionary *JSONDict = [WebServices parseJSONString:response];
    if (JSONDict && [JSONDict objectForKey:@"data"])
    {
        if ([[JSONDict objectForKey:@"data"] count]>0)
        {
            NSArray *results = [self removeOwnProfileFromArray:[JSONDict objectForKey:@"data"]];
            if (results.count!=0)
                [self gotoFriendsTableViewController:results];
            else 
            {
                BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Search Friend" message:@"You can't search your own profile" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alert show];
            }
        }
        else 
        {
            BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Search Friend" message:@"No friend Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    else {
        [Utility showServerError];
    }
}

- (void)gotoFriendsTableViewController:(NSArray *)friendsInfo
{
    [self performSegueWithIdentifier:@"SearchView" sender:friendsInfo];
}

- (void)findFriendFromFacebook
{
    facebookButtonPressed = YES;
    if (!isSearching)
    {
        if ([[[[SHKFacebook alloc] init] autorelease] authorize])
        {
            facebookButtonPressed = NO;
            loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Searching..."];
            NSString * name = @"";
            Profile *profile = nil;
            if ([Utility userID])
                profile = [[DAL sharedInstance] getProfileByID:[Utility userID]];
            if (profile )
            {
                NSMutableArray *resultArray = [NSMutableArray array];
                NSDictionary *dict = [SHKFacebook getUserFriends];
                NSArray *array = [dict objectForKey:@"data"];
                for (NSDictionary *dict2 in array) 
                {
                    if ([dict2 objectForKey:@"installed"])
                    {
                        [resultArray addObject:dict2];
                    }
                }
                for (NSDictionary *dict3 in resultArray) 
                {
                    name =  [name stringByAppendingFormat:@",%@",[dict3 objectForKey:@"name"]];
                }
                if (name && ![name isEmptyString])
                {
                    if ([name hasPrefix:@","])
                    {
                        name = [name substringFromIndex:1];
                        if (searchFriendRequest)
                        {
                            searchFriendRequest.delegate = nil;
                            RELEASE_SAFELY(searchFriendRequest);
                        }
                        searchFriendRequest = [[WebServices alloc] init];
                        [searchFriendRequest setDelegate:self];
                        [searchFriendRequest searchProfileBy:KWEB_SERVICE_NAME andValue:name];
                        isSearching = YES;
                    }
                }
                else {
                    BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Search Friend" message:@"No friend Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                    [alert show];
                    [loadingActivityIndicator removeFromSuperview];
                }
                
            }
            else {
                BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Search Friend" message:@"You have not logged in from your facebook account!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alert show];
                [loadingActivityIndicator removeFromSuperview];
            }
            
        }
    }
}

- (void)findFriendFromTwitter
{
    if (!isSearching)
    {
        
        loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Searching..."];
        ACAccountStore *store = [[ACAccountStore alloc] init];
        
        ACAccountType *twitterType = [store
                                      accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [store requestAccessToAccountsWithType:twitterType
                         withCompletionHandler:^(BOOL granted, NSError *error) 
         {
             if (granted) 
             {
                 NSArray *twitterAccounts = [store accountsWithAccountType:twitterType];
                 ACAccount *account = [twitterAccounts objectAtIndex:0];
                 __block TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/friends/ids/%@.json",account.username]] parameters:nil requestMethod:TWRequestMethodGET];
                 [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     RELEASE_SAFELY(request);
                     NSString *followersString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                     NSDictionary *dict = [WebServices parseJSONString:followersString];
                     RELEASE_SAFELY(followersString);
                     NSArray *arr = [dict objectForKey:@"ids"];
                     NSString *ids = @"";
                     for (NSString *str in arr) {
                         ids = [ids stringByAppendingFormat:@",%@",str];
                     }
                     if (![ids isEqualToString:@""])
                     {
                         ids = [ids substringFromIndex:1];
                         __block TWRequest *request2 = [[TWRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/users/lookup.json?user_id=%@",ids]] parameters:nil requestMethod:TWRequestMethodGET];
                         [request2 performRequestWithHandler:^(NSData *responseData2, NSHTTPURLResponse *urlResponse2, NSError *error2) 
                          {
                              RELEASE_SAFELY(request2);
                              NSString *name =@"";
                              NSString *followerProfileInfo = [[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding];
                              NSArray *arr2 = (NSArray *)[WebServices parseJSONString:followerProfileInfo];
                              RELEASE_SAFELY(followerProfileInfo);
                              for (NSDictionary *dict3 in arr2) {
                                  name =  [name stringByAppendingFormat:@",%@",[dict3 objectForKey:@"screen_name"]];
                              }
                              if (name && ![name isEmptyString])
                              {
                                  if ([name hasPrefix:@","])
                                  {
                                      name = [name substringFromIndex:1];
                                      if (searchFriendRequest)
                                      {
                                          searchFriendRequest.delegate = nil;
                                          RELEASE_SAFELY(searchFriendRequest);
                                      }
                                      searchFriendRequest = [[WebServices alloc] init];
                                      [searchFriendRequest setDelegate:self];
                                      [searchFriendRequest searchProfileBy:KWEB_SERVICE_NAME andValue:name];
                                      isSearching = YES;
                                  }
                              }
                              else {
                                  BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Search Friend" message:@"No friend Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                                  [alert show];
                                  [loadingActivityIndicator removeFromSuperview];
                              }
                              
                          }];
                     }
                 }];
                 
             } 
         }];
    }
}

- (NSArray *)getContactsList
{
    ABAddressBookRef ab=ABAddressBookCreate();
    NSArray *arrTemp=(NSArray *)ABAddressBookCopyArrayOfAllPeople(ab);
    NSMutableArray *arrContact=[[NSMutableArray alloc] init];
    for (int i=0;i<[arrTemp count];i++) 
    {
        NSMutableDictionary *dicContact=[[NSMutableDictionary alloc] init];
        NSString *name=(NSString *)ABRecordCopyValue([arrTemp objectAtIndex:i],kABPersonFirstNameProperty);
        if (!name)
            continue;
        ABMultiValueRef phones =(NSString*)ABRecordCopyValue([arrTemp objectAtIndex:i], kABPersonPhoneProperty);
        NSString* mobile=nil;
        NSString* mobileLabel;
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) 
        {
            mobileLabel = (NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                mobile = (NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                break ;
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                mobile = (NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                break ;
            }
        }
        if(!mobile)
            continue;
        
        
        if (name && mobile)
        {
            mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
            [dicContact setObject:name forKey:KWEB_SERVICE_NAME];
            [dicContact setObject:mobile forKey:KWEB_SERVICE_PHONE];
            [arrContact addObject:dicContact];
            RELEASE_SAFELY(dicContact);
            
        }
        else
            RELEASE_SAFELY(dicContact);
    }
    DLog(@"%@",[arrContact description]);
    return arrContact;
}

- (NSArray *)removeOwnProfileFromArray:(NSArray *)array
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
    arr = [arr valueForKeyPath:@"@distinctUnionOfObjects.userid"];
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
