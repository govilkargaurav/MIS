//
//  SignUpController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpController.h"
#import "SettingsViewController.h"
#import "SHKFacebook.h"
//#import "FirstScreen.h"
#import <Twitter/Twitter.h>
#import <Accounts/ACAccount.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccountType.h>
#import "UIImage+Scale.h"

#define AlertTagAvatar 999

@interface SignUpController (Private)

- (BOOL)isAllTheInfoCompletelyFilled;

- (void)cancelSignUpRequest;

- (void)fillFormForTwitter:(NSDictionary *)userInfo;

- (void)fillFormForFacebook;

@end

@implementation SignUpController

@synthesize controller;
@synthesize imagePicker;
@synthesize txtEmail;
@synthesize txtUsername;
@synthesize txtPassword;
@synthesize txtPhone;
@synthesize scrollView;


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
    [self.scrollView setContentSize:CGSizeMake(320, 415)];
    isSigningUp = NO;

    titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 44)] autorelease];
    [lbl setFont:[UIFont fontWithName:@"WOODCUT" size:18]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    [lbl setText:@"OutdoorLoop"];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [titleView addSubview:lbl];
    [self.navigationItem setHidesBackButton:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar addSubview:titleView];
    self.navigationItem.leftBarButtonItem = [Utility barButtonItemWithImageName:@"left-arrow" Selector:@selector(popViewController) Target:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.leftBarButtonItem = nil;
    [titleView removeFromSuperview];
}

- (void)viewDidUnload
{
    [self setTxtEmail:nil];
    [self setTxtUsername:nil];
    [self setTxtPassword:nil];
    [self setTxtPhone:nil];
    [self setScrollView:nil];
    [self setImagePicker:nil];
    [avatarView release];
    avatarView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)signUp:(id)type
{
    [self resignResponders:nil];
    BOOL isCompletelyFilled = [self isAllTheInfoCompletelyFilled];
    if (isCompletelyFilled && !isSigningUp)
    {
        isSigningUp = YES;
        webServices = [[WebServices alloc] init];
        [webServices setDelegate:self];
        if (userInfo)
            RELEASE_SAFELY(userInfo);
        userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:txtEmail.text forKey:KWEB_SERVICE_EMAIL];
        [userInfo setObject:txtPassword.text forKey:KWEB_SERVICE_PASSKEY];
        if (![txtPhone.text isEmptyString])
            [userInfo setObject:txtPhone.text forKey:KWEB_SERVICE_PHONE];
        [userInfo setObject:txtUsername.text forKey:KWEB_SERVICE_NAME];
        if ([type isKindOfClass:[NSString class]])
        {
            NSString *accType = (NSString *)type;
            [userInfo setObject:accType forKey:KWEB_SERVICE_TYPE];
            if ([accType isEqualToString:@"2"])
                [userInfo setObject:txtEmail.text forKey:KWEB_SERVICE_TWITTER_ID];
            else {
                [userInfo setObject:txtEmail.text forKey:KWEB_SERVICE_FACEBOOK_ID];
            }
        }
        else {
            loggedWithAccountType = [NSNumber numberWithInt:0];
            [userInfo setObject:@"0" forKey:KWEB_SERVICE_TYPE];
        }
        [userInfo setObject:@"0" forKey:KWEB_SERVICE_PRIVACY];
        UIImage *image = [avatar scaleDownToSize:CGSizeMake(81, 81)];
        [userInfo setObject:[NSString base64StringFromData:UIImagePNGRepresentation(image)] forKey:KWEB_SERVICE_AVATAR];
        loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Signing Up..."];
        [webServices createUserProfile:userInfo];
    }
}

- (void)dealloc {
    RELEASE_SAFELY(titleView);
    [txtEmail release];
    [txtUsername release];
    [txtPassword release];
    [txtPhone release];
    [scrollView release];
    RELEASE_SAFELY(userInfo);
    RELEASE_SAFELY(avatar);
    [imagePicker release];
    [avatarView release];
    [super dealloc];
}

- (BOOL)isAllTheInfoCompletelyFilled
{
    BOOL isCompletelyFilled = YES;
    NSString *message = nil;
    if ([txtEmail.text isEqualToString:@""] || (![Utility validateEmail:txtEmail.text] && [loggedWithAccountType intValue]==0))
    {
        isCompletelyFilled = NO;
        message = @"Please enter valid email address";
    }
    else if ([txtUsername.text isEqualToString:@""])
    {
        isCompletelyFilled = NO;
        message = @"User Name not entered";
    }    
    else if ([txtPassword.text isEqualToString:@""])
    {
        isCompletelyFilled = NO;
        message = @"Password not entered";
    }
//    else if ([txtPhone.text isEqualToString:@""])
//    {
//        isCompletelyFilled = NO;
//        message = @"Phone  number not entered";
//    }
    else if (!avatar) 
    {
        isCompletelyFilled = NO;
        message = @"Select your picture";
    }
    if (loggedWithAccountType && [loggedWithAccountType intValue]>0)
    {
        message = @"Unable to get user credentials";
    }
    if (!isCompletelyFilled)
    {
        BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"Sign Up" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        RELEASE_SAFELY(alert);
    }
    return isCompletelyFilled;
}

#pragma mark
#pragma WebServices Delegate
- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)auserInfo
{
    [self cancelSignUpRequest];
    NSDictionary *jsonDict = [WebServices parseJSONString:response];
    if ([jsonDict objectForKey:@"data"] && [[jsonDict objectForKey:@"data"] count]>0)
    {
        if ([[jsonDict objectForKey:@"data"] count]>0 && [[auserInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_LOGIN] && [[[[jsonDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"data"]objectForKey:LOGIN_TOKEN])
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
        else if ([[jsonDict objectForKey:@"data"]objectForKey:@"success"])
        {
            [self.navigationController.tabBarController.tabBar setUserInteractionEnabled:YES];
            NSString *token = [[jsonDict objectForKey:@"data"] objectForKey:LOGIN_TOKEN];
            NSString *userid = [[jsonDict objectForKey:@"data"] objectForKey:KWEB_SERVICE_USERID];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"1" forKey:LOGIN_STATE];
            [defaults setObject:token forKey:LOGIN_TOKEN];
            [defaults setObject:userid forKey:PROFILE_USER_ID_KEY];
            [defaults synchronize];
            [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:userid];
            BlackAlertView *alert = [[BlackAlertView alloc]initWithTitle:@"Sign Up" message:[[jsonDict objectForKey:@"data"]objectForKey:@"success"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            RELEASE_SAFELY(alert);
            [self.navigationController popToRootViewControllerAnimated:NO];
            [controller dismissMyView:@"1"];
        }
        else if([[jsonDict objectForKey:@"data"]objectForKey:@"error"])
        {
            if (loggedWithAccountType && [loggedWithAccountType intValue]>0)
            {
                webServices = [[WebServices alloc] init];
                [webServices setDelegate:self];
                if (userInfo)
                    RELEASE_SAFELY(userInfo);
                userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setObject:txtEmail.text forKey:KWEB_SERVICE_EMAIL];
                [userInfo setObject:@"******" forKey:KWEB_SERVICE_PASSKEY];
                loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Signing in..."];
                [webServices logIn:userInfo];
            }
            else {
                BlackAlertView *alert = [[BlackAlertView alloc]initWithTitle:@"Sign Up" message:[[jsonDict objectForKey:@"data"]objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                RELEASE_SAFELY(alert);
            }
        }
    }
    else {
        [Utility showServerError];
    }
}


# pragma mark
# pragma TextField Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentSize:CGSizeMake(320, 520)];
    [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-100)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.scrollView setContentSize:CGSizeMake(320, 367)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)resignResponders:(id)sender 
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtUsername resignFirstResponder];
}

- (IBAction)selectAvatar:(id)sender 
{
    [self resignResponders:nil];
    BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"Select Avatar" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take Photo",@"Library", nil];
    [alert setTag:AlertTagAvatar];
    [alert show];
    RELEASE_SAFELY(alert);
}

- (IBAction)signUpWithFB:(id)sender 
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sharerFinishedSending:) name:@"SHKSendDidFinish" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sharerFinishedSending:) name:@"SHKSendDidCancel" object:nil];
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self.navigationController.tabBarController];

    SHKItem *item = [SHKItem text:@"I just signed up for OutdoorLoop, a social application for everything outdoors! Come Get In The Loop now and download OutdoorLoop Today! www.TheOutdoorLoop.com"];
    [SHKFacebook shareItem:item];
    
}

- (IBAction)signUpWithTwitter:(id)sender 
{
    TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];
    [tweetController setInitialText:@"I just signed up for OutdoorLoop, a social application for everything outdoors! Come Get In The Loop now"];
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
                                                  [self signUp:@"2"];
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
                                              [self signUp:@"2"];
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

- (void)cancelSignUpRequest
{
    [loadingActivityIndicator removeFromSuperview];
    [webServices setDelegate:nil];
    RELEASE_SAFELY(webServices);
    isSigningUp = NO;
    
}

#pragma mark
#pragma alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertTagAvatar)
    {
        if (buttonIndex == 1)
        {
            if([UIImagePickerController isSourceTypeAvailable:
                UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker= [[UIImagePickerController alloc]init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [picker setShowsCameraControls:YES];
                [picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
                [self presentModalViewController:picker animated:YES];
                [picker release];
            }
        }
        else if (buttonIndex == 2)
        {
            if([UIImagePickerController isSourceTypeAvailable:
                UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *picker= [[UIImagePickerController alloc]init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentModalViewController:picker animated:YES];
                [picker release];
            }
        }
    }
}


# pragma mark
#pragma uiImage Picker Delegate

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    if (avatar)
        RELEASE_SAFELY(avatar);
	avatar = [[image fixOrientation]retain];
    [avatarView setImage:avatar];
   	[picker dismissModalViewControllerAnimated:YES];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)popViewController;
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [txtUsername setText:username];
    [txtPhone setText:@"N/A"];
    RELEASE_SAFELY(avatar);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[auserInfo objectForKey:@"profile_image_url"]]];
    avatar = [[UIImage imageWithData:data] retain];
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
    [self signUp:@"1"];
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
    [txtUsername setText:username];
    [txtPhone setText:@"N/A"];
    RELEASE_SAFELY(avatar);
    NSString *fbUrl = [[email componentsSeparatedByString:@"/"] lastObject];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",fbUrl]]];
    avatar = [[UIImage imageWithData:data] retain];
}


@end