//
//  LoginViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "SHKFacebook.h"
//#import "FirstScreen.h"
#import <Twitter/Twitter.h>
#import <Accounts/ACAccount.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccountType.h>


@interface LoginViewController ()

- (void)fillFormForTwitter:(NSDictionary *)auserInfo;
- (void)fillFormForFacebook;

@end

@implementation LoginViewController
@synthesize txtEmail;
@synthesize txtPassword;
@synthesize controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 44)] autorelease];
    [lbl setFont:[UIFont fontWithName:@"WOODCUT" size:18]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    [lbl setText:@"OutdoorLoop"];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [titleView addSubview:lbl];
    loggedWithAccountType = [NSNumber numberWithInt:0];
    [self.navigationItem setHidesBackButton:YES];

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
    [self setTxtEmail:nil];
    [self setTxtPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - Request Wrapper Delegate

- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)auserInfo
{
    [loadingActivityIndicator removeFromSuperview];
    NSDictionary *jsonDict = [WebServices parseJSONString:response];
    RELEASE_SAFELY(webServices);
    DLog(@"%@",[auserInfo description]);
    if ([[auserInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_FORGET])
    {
        BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Forgot Password" message:@"Password has been sent to you on you email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
    }
    else if ([[jsonDict objectForKey:@"data"] count]>0&& [[[[jsonDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"data"]objectForKey:LOGIN_TOKEN])
    {
        [self.navigationController.tabBarController.tabBar setUserInteractionEnabled:YES];
        NSString *token = [[[[jsonDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"data"]objectForKey:LOGIN_TOKEN];
        NSString *userid = [[[[jsonDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"data"]objectForKey:@"userid"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:LOGIN_STATE];
        [defaults setObject:token forKey:LOGIN_TOKEN];
        [defaults setObject:userid forKey:PROFILE_USER_ID_KEY];
        [defaults synchronize];
        [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:userid];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [controller dismissMyView:@"2"];
    }
    else if([jsonDict objectForKey:@"data"])
    {
        
        BlackAlertView *alert = [[BlackAlertView alloc]initWithTitle:@"Log In Error" message:@"Please check your user id or password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        RELEASE_SAFELY(alert);
    }
    else {
        [Utility showServerError];
    }
    
}

# pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)isAllTheInfoCompletelyFilled
{
    BOOL isCompletelyFilled = YES;
    NSString *message = nil;
    if ([txtEmail.text isEqualToString:@""])
    {
        isCompletelyFilled = NO;
        message = @"Email not entered";
    }
    else if ([txtPassword.text isEqualToString:@""])
    {
        isCompletelyFilled = NO;
        message = @"Password not entered";
    }
    if (!isCompletelyFilled)
    {
        BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"Log In" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        RELEASE_SAFELY(alert);
    }
    return isCompletelyFilled;
}


- (void)dealloc 
{
    if(webServices)
    {
        webServices.delegate = nil;
        RELEASE_SAFELY(webServices);
    }
    if (forgotRequest)
    {
        forgotRequest.delegate = nil;
        RELEASE_SAFELY(forgotRequest);
    }
    RELEASE_SAFELY(userInfo);
    RELEASE_SAFELY(titleView);
    [txtEmail release];
    [txtPassword release];
    [super dealloc];
}
- (IBAction)logIn:(id)sender 
{
    [self resignResponders:nil];
    if ([self isAllTheInfoCompletelyFilled])
    {
        webServices = [[WebServices alloc] init];
        [webServices setDelegate:self];
        if (userInfo)
            RELEASE_SAFELY(userInfo);
        userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:txtEmail.text forKey:KWEB_SERVICE_EMAIL];
        [userInfo setObject:txtPassword.text forKey:KWEB_SERVICE_PASSKEY];
        loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Signing in..."];
        [webServices logIn:userInfo];
    }

}

- (IBAction)resignResponders:(id)sender 
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
}

- (void)popViewController;
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signInWithFB:(id)sender 
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sharerFinishedSending:) name:@"SHKSendDidFinish" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sharerFinishedSending:) name:@"SHKSendDidCancel" object:nil];
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self.navigationController.tabBarController];
    
    SHKItem *item = [SHKItem text:@"having fun using OutdoorLoop. Come Get In The Loop now and download OutdoorLoop Today! www.TheOutdoorLoop.com"];
    [SHKFacebook shareItem:item];
    
}

- (IBAction)signInWithTwitter:(id)sender 
{
    TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];
    [tweetController setInitialText:@"having fun using OutdoorLoop. Come Get In The Loop now"];
    [tweetController addURL:[NSURL URLWithString:@"http://www.TheOutdoorLoop.com"]];
    TWTweetComposeViewControllerCompletionHandler 
    completionHandler =
    ^(TWTweetComposeViewControllerResult result) {
        switch (result)
        {
            case TWTweetComposeViewControllerResultCancelled:
            {
                DLog(@"Twitter Result: canceled");
                ACAccountStore *store = [[ACAccountStore alloc] init];
                
                ACAccountType *twitterType = [store
                                              accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                
                [store requestAccessToAccountsWithType:twitterType
                                 withCompletionHandler:^(BOOL granted, NSError *error) {
                                     if (granted) {
                                         DLog(@"Granted");
                                         NSArray *twitterAccounts = [store accountsWithAccountType:twitterType];
                                         if (twitterAccounts.count!=0)
                                         {
                                             ACAccount *account = [twitterAccounts objectAtIndex:0];
                                             __block TWRequest *request2 = [[TWRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/users/lookup.json?screen_name=%@",account.username]] parameters:nil requestMethod:TWRequestMethodGET];
                                             [request2 performRequestWithHandler:^(NSData *responseData2, NSHTTPURLResponse *urlResponse2, NSError *error2) 
                                              {
                                                  NSString *res = [[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding];
                                                  NSArray *arr = (NSArray *)[WebServices parseJSONString:res];
                                                  RELEASE_SAFELY(res);
                                                  [self fillFormForTwitter:[arr objectAtIndex:0]];
                                                  loggedWithAccountType = [NSNumber numberWithInt:1];
                                                  [self logIn:nil];
                                                  RELEASE_SAFELY(request2);
                                              }];
                                         }
                                         
                                     }
                                     else {
                                         BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Signup" message:@"You have to grant permission in order to use the app" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                                         [alert show];
                                     }
                                 }];
                [store release];
                
            }
                break;
            case TWTweetComposeViewControllerResultDone:
            {
                DLog(@"Twitter Result: sent");
                ACAccountStore *store = [[ACAccountStore alloc] init];
                
                ACAccountType *twitterType = [store
                                              accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                
                [store requestAccessToAccountsWithType:twitterType
                                 withCompletionHandler:^(BOOL granted, NSError *error) {
                                     if (granted) {
                                         DLog(@"Granted");
                                         NSArray *twitterAccounts = [store accountsWithAccountType:twitterType];
                                         ACAccount *account = [twitterAccounts objectAtIndex:0];
                                         __block TWRequest *request2 = [[TWRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/users/lookup.json?screen_name=%@",account.username]] parameters:nil requestMethod:TWRequestMethodGET];
                                         [request2 performRequestWithHandler:^(NSData *responseData2, NSHTTPURLResponse *urlResponse2, NSError *error2) 
                                          {
                                              RELEASE_SAFELY(request2);
                                              NSString *res = [[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding];
                                              NSArray *arr = (NSArray *)[WebServices parseJSONString:res];
                                              RELEASE_SAFELY(res);
                                              [self fillFormForTwitter:[arr objectAtIndex:0]];
                                              loggedWithAccountType = [NSNumber numberWithInt:1];
                                              [self logIn:@"2"];
                                          }];
                                         
                                     }
                                     else {
                                         BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Signup" message:@"You have to grant permission in order to use the app" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                                         [alert show];
                                     }
                                 }];
                [store release];
                
            }
                break;
            default:
                DLog(@"Twitter Result: default");
                break;
        }
        [self.navigationController dismissModalViewControllerAnimated:YES];
    };
    [tweetController setCompletionHandler:completionHandler];
    [self.navigationController presentModalViewController:tweetController animated:YES];
    RELEASE_SAFELY(tweetController);
}

- (IBAction)forgotMyPassword:(id)sender 
{
    BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Forgot Password" message:@"Please enter your registered email address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] autorelease];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)fillFormForTwitter:(NSDictionary *)auserInfo
{
    DLog(@"%@",[auserInfo description]);
    NSString *email = [auserInfo objectForKey:@"screen_name"];
    NSString *username = [auserInfo objectForKey:@"name"];
    DLog(@"email %@",[email description]);
    DLog(@"username %@",[username description]); 
    [txtEmail setText:email];
    [txtPassword setText:@"******"];
    
}

- (void)sharerFinishedSending:(id)sender
{
    DLog(@"Finished or cancelled sending!!!!");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SHKSendDidFinish" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SHKSendDidCancel" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(facebookUserInfoRceived:) name:@"FacebookUserInfoRceived" object:nil];
    [SHKFacebook getUserCredentials];
}

- (void)facebookUserInfoRceived:(NSNotification *)notification
{
    DLog(@"%@",[notification object]);
    [[NSUserDefaults standardUserDefaults]setObject:[notification object] forKey:USER_FACEBOOK_INFO];
    [self fillFormForFacebook];
    loggedWithAccountType = [NSNumber numberWithInt:1];
    [self logIn:nil];
}

- (void)fillFormForFacebook
{
    NSDictionary *accountDescription = [[NSUserDefaults standardUserDefaults]objectForKey:USER_FACEBOOK_INFO];
    NSString *email = [accountDescription objectForKey:@"link"];
    NSString *username = [NSString stringWithFormat:@"%@ %@",[accountDescription objectForKey:@"first_name"],[accountDescription objectForKey:@"last_name"]];
    DLog(@"email %@",[email description]);
    DLog(@"username %@",[username description]); 
    [txtEmail setText:email];
    [txtPassword setText:@"******"];
    
}

# pragma  mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (forgotRequest)
        {
            forgotRequest.delegate = nil;
            RELEASE_SAFELY(forgotRequest);
        }
        NSString *email = [alertView textFieldAtIndex:0].text;
        if ([Utility validateEmail:email])
        {
            forgotRequest = [[WebServices alloc] init];
            forgotRequest.delegate = self;
            [forgotRequest forgetPassword:email];
        }
        else {
            BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Invalid Email Address" message:@"Please enter valid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        }

    }
}

@end
