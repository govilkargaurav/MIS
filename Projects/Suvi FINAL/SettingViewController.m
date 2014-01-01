//
//  SettingViewController.m
//  Suvi
//
//  Created by Dhaval Vaishnani on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "TermsOfUseViewController.h"
#import "IIViewDeckController.h"
#import "MyAppManager.h"
#import "OAuthTwitter.h"
#import "OAuthConsumerCredentials.h"
#import "OAuth.h"
#import "CustomLoginPopup.h"
#import "TwitterLoginPopup.h"
#import "FoursquareLoginPopup.h"
#import "NSString+URLEncoding.h"
#import "AutocompletionTableView.h"
#import "Constants.h"

@interface SettingViewController (PrivateMethods)
-(void)resetUi;
-(void)presentLoginWithFlowType:(TwitterLoginFlowType)flowType;
@end

@interface SettingViewController ()<FBSessionDelegate,FBDialogDelegate,FBRequestDelegate>
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@end

@implementation SettingViewController
@synthesize fbGraph;
@synthesize oAuthTwitter;
@synthesize oAuth4sq,imgTempStore;
@synthesize autoCompleter = _autoCompleter;
@synthesize facebook;
#pragma mark - SendEmail
-(IBAction)SendEmail:(id)sender
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        controller.navigationBar.tintColor=[UIColor lightGrayColor];
        [controller setToRecipients:[NSArray arrayWithObject:@"info@suviapp.com"]];
        [controller setSubject:@"Suvi Feedback"];
        [controller setMessageBody:@"" isHTML:YES];
        if (controller) 
            [self presentModalViewController:controller animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
    switch (result)
    {
        case MFMailComposeResultSent:
            [self dismissModalViewControllerAnimated:YES];
            break;
            
        case MFMailComposeResultSaved:
            break;
            
        case MFMailComposeResultCancelled:
            [self dismissModalViewControllerAnimated:YES];
            break;
            
        case MFMailComposeResultFailed:
            break;
            
        default:
            break;
    }
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oauth_verifier_received:) name:NOTIFY_OAUTH_VERIFY_RECEIVED object:nil];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
    
    scrollViewobj.contentSize=CGSizeMake(viewsettings.frame.size.width, viewsettings.frame.size.height);
    viewsettings.frame=CGRectMake(0,0, 320, viewsettings.frame.size.height);
    [scrollViewobj addSubview:viewsettings];
//    CGRect theRect=scrollViewobj.frame;
//    theRect.origin.y+=(([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?20.0:0.0);
//    theRect.size.height+=(([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?20.0:0.0);
//    theRect.size.height-=((IS_DEVICE_iPHONE_5)?0.0:iPhone5ExHeight);
//    
//    scrollViewobj.frame=theRect;
    
    
    
    btnDropDownMask=[[UIButton alloc]initWithFrame:CGRectMake(0, 0.0-iOS7ExHeight, 320, 480+iPhone5ExHeight)];
    [self.view addSubview:btnDropDownMask];
    btnDropDownMask.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.1];
    btnDropDownMask.hidden=YES;
    
    imgTempStore=[[UIImageView alloc]init];
    action=[[NSMutableString alloc]init];
    actionurl=[[NSMutableString alloc]init];
    actionparameters=[[NSMutableString alloc]init];
    webData=[[NSMutableData alloc]init];
    
    NSString *strfname=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"admin_fname"]];
    NSString *strlname=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"admin_lname"]];
    NSString *strpassword=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"admin_pwd"]];
    NSString *strmobilenotemp=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"admin_mobile"]];
   
    NSString *strmobileno=[NSString stringWithFormat:@"%@",([strmobilenotemp integerValue]==0)?@"":strmobilenotemp];
    
    NSString *strschool=[[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"school"]] removeNull];
    NSString *strlocationname1=[[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"vLocationName"]] removeNull];
    NSString *strlocationname2=[[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"vCustomLocation"]] removeNull];
    NSString *strlocationname=[[NSString stringWithFormat:@"%@",([strlocationname1 length]>0)?strlocationname1:strlocationname2] removeNull];
    
    txtfirstname.text=[strfname removeNull];
    txtlastname.text=[strlname removeNull];
    txtpassword.text=[strpassword removeNull];
    txtphonenumber.text=[strmobileno removeNull];
    txtschool.text=[strschool removeNull];
    txtlocationname.text=[strlocationname removeNull];
    
    if ([strlocationname length]!=0) {
        [[NSUserDefaults standardUserDefaults] setObject:strlocationname forKey:@"prelocation"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    imgprofileimg.tag=1001;
    imgcoverimage.tag=1002;
    
    NSURL *imgURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"image_path"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [imgprofileimg setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
    NSURL *imgURL2 = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"COVERPIC_URL"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [imgcoverimage setImageWithURL:imgURL2 placeholderImage:[UIImage imageNamed:@""]];
    
    [self performSelector:@selector(updatesocialbuttons) withObject:nil afterDelay:1.0];
    [self loadlocations];
}


#pragma mark - AutoCompleteTableViewDelegate
-(AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:txtlocationname inViewController:self withOptions:options];
        _autoCompleter.tag=200;
        _autoCompleter.suggestionsDictionary = [AppDelegate sharedInstance].arrlocations;
    }
    return _autoCompleter;
}
- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return [AppDelegate sharedInstance].arrlocations;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index{
    // invoked when an available suggestion is selected
    
    NSString *strLocationName=[NSString stringWithFormat:@"%@",[[self.autoCompleter.suggestionsListed objectAtIndex:index] objectForKey:@"locationname"]];
    NSString *strLocationId=[NSString stringWithFormat:@"%@",[[self.autoCompleter.suggestionsListed objectAtIndex:index] objectForKey:@"locid"]];
    
    NSMutableDictionary *userdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    [userdict setObject:strLocationId forKey:@"iLocationID"];
    [userdict setObject:strLocationName forKey:@"vLocationName"];
    [userdict setObject:@"" forKey:@"vCustomLocation"];
    [[NSUserDefaults standardUserDefaults]setObject:userdict forKey:@"USER_DETAIL"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [txtlocationname resignFirstResponder];
    
    [self performSelector:@selector(updateProfile) withObject:nil afterDelay:1.0];
}

-(IBAction)btnbackclicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updatesocialbuttons];   
}

#pragma mark - PROFILE UPDATE
-(void)updateProfile
{
    if([[txtfirstname.text removeNull]length]==0)
    {
        DisplayAlert(@"Please enter firstname.");
    }
    else if([[txtlastname.text removeNull]length]==0)
    {
        DisplayAlert(@"Please enter lastname.");
    } 
    else if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [action setString:@"profile_update"];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSString *strEmail=[NSString stringWithFormat:@"%@",[[defaults valueForKey:@"USER_DETAIL"] valueForKey:@"admin_email"]];
        NSString *struserid=[NSString stringWithFormat:@"%@",[[defaults valueForKey:@"USER_DETAIL"] valueForKey:@"admin_id"]];
        NSString *strDOB=[NSString stringWithFormat:@"%@",[[defaults valueForKey:@"USER_DETAIL"] valueForKey:@"dDOB"]];
        NSString *strGender=[NSString stringWithFormat:@"%@",[[defaults valueForKey:@"USER_DETAIL"] valueForKey:@"eGender"]];
        NSString *stradmin_pwd=[NSString stringWithFormat:@"%@",[[defaults valueForKey:@"USER_DETAIL"] valueForKey:@"admin_pwd"]];
       
        NSString *strlocationname1=[NSString stringWithFormat:@"%@",[[defaults valueForKey:@"USER_DETAIL"] valueForKey:@"iLocationID"]];
        NSString *strlocationname2=[NSString stringWithFormat:@"%@",[[defaults valueForKey:@"USER_DETAIL"] valueForKey:@"vCustomLocation"]];

        if ([strlocationname2 length]!=0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:strlocationname2 forKey:@"prelocation"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        NSString *strlocation;
        
        if ([[strlocationname1 removeNull] length]>0)
        {
            strlocation=[NSString stringWithFormat:@"&iLocationID=%@",strlocationname1];
        }
        else
        {
            strlocation=[NSString stringWithFormat:@"&vCustomLocation=%@",strlocationname2];
        }
        
        NSString  *urlstring = [NSString stringWithFormat:@"%@&admin_fname=%@&admin_lname=%@&admin_email=%@&admin_mobile=%@&school=%@&admin_pwd=%@&eGender=%@&dDOB=%@%@",strEditProfile,[txtfirstname.text removeNull],[txtlastname.text removeNull],strEmail,[txtphonenumber.text removeNull],[txtschool.text removeNull],stradmin_pwd,strGender,strDOB,strlocation];
        
        NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"userID=%@",struserid] stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}

#pragma mark - TEXTFIELD DELEGATE
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ((textField==txtfirstname) || (textField==txtlastname))
    {
        [scrollViewobj setContentOffset:CGPointMake(0,(IS_DEVICE_iPHONE_5)?0:64) animated:YES];
    }
    else if(textField==txtschool)
    {
        [scrollViewobj setContentOffset:CGPointMake(0,(IS_DEVICE_iPHONE_5)?30:110) animated:YES];
    }
    else if(textField==txtlocationname)
    {
        btnDropDownMask.hidden=NO;
        [scrollViewobj setContentOffset:CGPointMake(0,237.0-iOS7ExHeight-10.0) animated:YES];
        [self.autoCompleter showSuggestionsForString:[txtlocationname.text removeNull]];
    }
    else if(textField==txtphonenumber)
    {
        [scrollViewobj setContentOffset:CGPointMake(0,(IS_DEVICE_iPHONE_5)?50:110) animated:YES];
    }
    
    scrollViewobj.scrollEnabled=NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==txtlocationname)
    {
        btnDropDownMask.hidden=YES;
    }

    scrollViewobj.scrollEnabled=YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*) textField 
{
    if (textField==txtlocationname)
    {
        NSMutableDictionary *userdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
        [userdict setObject:@"" forKey:@"iLocationID"];
        [userdict setObject:@"" forKey:@"vLocationName"];
        [userdict setObject:[txtlocationname.text removeNull] forKey:@"vCustomLocation"];
        [[NSUserDefaults standardUserDefaults]setObject:userdict forKey:@"USER_DETAIL"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        self.autoCompleter.hidden=YES;
        
        [self performSelector:@selector(updateProfile) withObject:nil afterDelay:1.0];
    }
    else
    {
        if (!((textField==txtOldPassword) || (textField==txtNewPassword) || (textField==txtConfirmPassword))) {
            if (textField!=txtpassword) {
                [self updateProfile];
            }
        }
    }
    
    [textField resignFirstResponder];
	return TRUE;
}

#pragma mark - FACEBOOK
-(IBAction)btnAuthoriseFacebookClicked:(id)sender
{
    [AppDelegate sharedInstance].facebook = [[Facebook alloc] initWithAppId:kFacebookApp_ID andDelegate:self];

    if (![[AppDelegate sharedInstance].facebook isSessionValid]) {
        NSArray *arrPermissions=[[NSArray alloc]initWithObjects:@"publish_stream",@"offline_access",@"user_checkins",@"read_stream",@"email",@"publish_checkins",@"user_photos",@"user_videos",@"friends_checkins",@"publish_actions", nil];
        [[AppDelegate sharedInstance].facebook authorize:arrPermissions];
    }
    else{
        [self fbDidLogin];
    }
//    self.fbGraph = [[FbGraph alloc] initWithFbClientID:kFacebookApp_ID];
//    
//    if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) )  
//    {
//        [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback) 
//                             andExtendedPermissions:kFacebookPermissions];
//    }
//    else
//    {
//        [self performSelector:@selector(fbGraphCallback) withObject:nil afterDelay:0.000000000001];
//    }   
}

- (void)fbDidLogin {
    
    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    [socialdict setObject:[[AppDelegate sharedInstance].facebook accessToken] forKey:@"facebook_token"];
    [socialdict setObject:@"Authenticate" forKey:@"facebook"];
    [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
//    [[NSUserDefaults standardUserDefaults] setObject:[[AppDelegate sharedInstance].facebook accessToken] forKey:@"FBAccessTokenKey"];
//    [[NSUserDefaults standardUserDefaults] setObject:[[AppDelegate sharedInstance].facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updatesocialbuttons];
}

-(IBAction)btnUnAuthoriseFacebookClicked:(id)sender
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
    
    [action setString:@"facebook_unauth"];
    [actionurl setString:kAuthoriseUnauthoriseSocialNw];
    [actionparameters setString:[NSString stringWithFormat:@"func=auth_unauthFacebook&userID=%@&facebook_token=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],@""]];
    [self performSelector:@selector(_startSend)];
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
        
        NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
        [socialdict setObject:fbGraph.accessToken forKey:@"facebook_token"];
        [socialdict setObject:@"Authenticate" forKey:@"facebook"];
        [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self updatesocialbuttons];
        
        [action setString:@"facebook_auth"];
        [actionurl setString:kAuthoriseUnauthoriseSocialNw];
        [actionparameters setString:[NSString stringWithFormat:@"func=auth_unauthFacebook&userID=%@&facebook_token=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],fbGraph.accessToken]];
        [self performSelector:@selector(_startSend)];
	}
}


#pragma mark - OAUTH
-(void) tokenRequestDidStart:(TwitterLoginPopup *)twitterLogin 
{
    [loginPopup startanimator];
}
-(void) tokenRequestDidSucceed:(TwitterLoginPopup *)twitterLogin {
    [loginPopup stopanimator];
}
-(void) tokenRequestDidFail:(TwitterLoginPopup *)twitterLogin {
    [loginPopup stopanimator];
}
-(void) authorizationRequestDidStart:(TwitterLoginPopup *)twitterLogin {
    [loginPopup startanimator];
}
-(void) authorizationRequestDidSucceed:(TwitterLoginPopup *)twitterLogin {
    [loginPopup stopanimator];
}
-(void) authorizationRequestDidFail:(TwitterLoginPopup *)twitterLogin {
    [loginPopup stopanimator];
}
-(void) presentLoginWithFlowType:(TwitterLoginFlowType)flowType {
    
    if (loginPopup) {
        loginPopup = nil;
    }
    
    if (!loginPopup) 
    {
        loginPopup = [[CustomLoginPopup alloc] initWithNibName:@"TwitterLoginCallbackFlow" bundle:nil];
        loginPopup.oAuthCallbackUrl = OAUTH_CALLBACK_URL;
        loginPopup.flowType = flowType;
        loginPopup.socialnetworkType=SocialNetworkTwitter;
        loginPopup.oAuth = oAuthTwitter;
        loginPopup.delegate = self;
        loginPopup.uiDelegate = self;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginPopup];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bgnavbar%@",([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?@"soc":@""]] forBarMetrics:UIBarMetricsDefault];
    [self presentModalViewController:nav animated:YES];        
}
-(void)handleOAuthVerifier:(NSString *)oauth_verifier 
{
    [loginPopup authorizeOAuthVerifier:oauth_verifier];
}
-(void)oAuthLoginPopupDidCancel:(UIViewController *)popup 
{
    [self dismissModalViewControllerAnimated:YES];  
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (socialnwtype==1) 
    {
        loginPopup = nil; // was retained as ivar in "login"
    }
    else if(socialnwtype==3)
    {
        loginPopupFSQ = nil;
    }
}
-(void)oAuthLoginPopupDidAuthorize:(UIViewController *)popup 
{
    [self dismissModalViewControllerAnimated:YES]; 
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (socialnwtype==1) 
    {
        loginPopup = nil;
        [oAuthTwitter save];
        [self resetUi];
    }
    else if(socialnwtype==3)
    {
        loginPopupFSQ = nil;
        [oAuth4sq save];
        [self resetUi];
    }
}
-(void)oauth_verifier_received:(NSNotification *)notification
{
    NSString *stroauth_verifier;
    if ([[notification userInfo] objectForKey:@"oauth_verifier"]) 
    {
        stroauth_verifier=[NSString stringWithFormat:@"%@",[[notification userInfo] objectForKey:@"oauth_verifier"]];
    }
    
    [self handleOAuthVerifier:stroauth_verifier];
}

#pragma mark - TWITTER
-(IBAction)btnAuthoriseTwitterClicked:(id)sender
{
    if (!oAuthTwitter) 
    {
        oAuthTwitter = [[OAuthTwitter alloc] initWithConsumerKey:OAUTH_TWITTER_CONSUMER_KEY andConsumerSecret:OAUTH_TWITTER_CONSUMER_SECRET];
        oAuthTwitter.socialnwtype=1;
        [oAuthTwitter load];
    }
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"twitter"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    socialnwtype=1;
    [self presentLoginWithFlowType:TwitterLoginCallbackFlow];
}
-(IBAction)btnUnAuthoriseTwitterClicked:(id)sender
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"twitter"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    [socialdict setObject:@"0" forKey:@"twitter_secrete"];
    [socialdict setObject:@"0" forKey:@"twitter_token"];
    [socialdict setObject:@"Unauthenticate" forKey:@"twitter"];
    [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self updatesocialbuttons]
    ;
    [action setString:@"twitter_unauth"];
    [actionurl setString:kAuthoriseUnauthoriseSocialNw];
    [actionparameters setString:[NSString stringWithFormat:@"func=auth_unauthTwitter&userID=%@&twitter_token=%@&twitter_secrete=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],@"",@""]];
    [self performSelector:@selector(_startSend)];
}

#pragma mark - FOURSQUARE
-(IBAction)btnAuthoriseFoursquareClicked:(id)sender
{
    if (!oAuth4sq) {
        oAuth4sq = [[OAuth alloc] initWithConsumerKey:OAUTH_FOURSQUARE_CONSUMER_KEY andConsumerSecret:OAUTH_FOURSQUARE_CONSUMER_SECRET];
        oAuth4sq.save_prefix = @"PlainOAuth4sq";
        [oAuth4sq load];
    }
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"foursquare"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    socialnwtype=3;
    if (loginPopupFSQ) {
        loginPopupFSQ = nil;
    }
    
    loginPopupFSQ = [[FoursquareLoginPopup alloc] init];
    loginPopupFSQ.oAuth = oAuth4sq;
    loginPopupFSQ.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginPopupFSQ];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bgnavbar%@",([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?@"soc":@""]] forBarMetrics:UIBarMetricsDefault];
    [self presentModalViewController:nav animated:YES];
}

-(IBAction)btnUnAuthoriseFoursquareClicked:(id)sender
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"foursquare"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    [actionurl setString:kAuthoriseUnauthoriseSocialNw];
    [actionparameters setString:[NSString stringWithFormat:@"func=auth_unauthFoursquare&userID=%@&foursquare_token=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],@""]];
    [action setString:@"foursquare_unauth"];
    [self performSelector:@selector(_startSend)];
}

#pragma mark - WS METHODS
-(void)_startSend
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
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

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}
-(void)loadlocations
{
    [[AppDelegate sharedInstance]showLoader];

    [action setString:@"load_locations"];
    [actionurl setString:strLocationFetchURL];
    [actionparameters setString:[NSString stringWithFormat:@"param=%d",[[NSString stringWithFormat:@"%@",[[AppDelegate sharedInstance] getmaxtimestampoflocations]] integerValue]]];
    [self performSelector:@selector(_startSend)];
}
-(void)_updateImage
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
       [[AppDelegate sharedInstance]showLoader];
        
        NSData *imgData;
        NSString  *urlstring;
        
        if (isselectedimagecover) {
            [action setString:@"image_update"];
            imgData = UIImagePNGRepresentation(imgTempStore.image);
            imgcoverimage.image=[imgcoverimage.image cropCenterToSize:imgcoverimage.frame.size];
            urlstring= [NSString stringWithFormat:@"%@&userID=%@",kCoverImageUpdateURL,[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
        }
        else
        {
            [action setString:@"image_update"];
            imgData = UIImagePNGRepresentation(imgTempStore.image);
            urlstring= [NSString stringWithFormat:@"%@&userID=%@",kProfileImageUpdateURL,[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
        }

        NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
        [postRequest setURL:url];
        [postRequest setHTTPMethod:@"POST"];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        NSMutableData  *body = [[NSMutableData alloc] init];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"somepic.png\"\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imgData]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postRequest setHTTPBody:body];
        [postRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
    }
}
#pragma mark - NSUrl Delegate
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
    if ([action isEqualToString:@"image_update"] || [action isEqualToString:@"load_locations"])
    {
        [[AppDelegate sharedInstance]hideLoader];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
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
        return;
    }
    
    NSString *strMSG =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"MESSAGE"] removeNull]] ;
    if ([strMSG isEqualToString:@""])
    {
        return;
    }
    if ([action isEqualToString:@"password_update"]) {
        if ([strMSG isEqualToString:@"SUCCESS"])
        {
            DisplayAlert(@"Password successfully changed!");
        }
        else
        {
            DisplayAlertWithTitle(@"Note", strMSG);
            return;
        }
    }
    if ([action isEqualToString:@"SignOut"])
    {
//        if ([strMSG isEqualToString:@"SUCCESS"] || [strMSG isEqualToString:@"DATA NOT FOUND."])
        {
            @try {
                
                NSHTTPCookie *cookie;
                NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                for (cookie in [storage cookies])
                {
                    NSString *domainName = [cookie domain];
                    NSRange domainRange = [domainName rangeOfString:@"facebook"];
                    if(domainRange.length > 0)
                    {
                        [storage deleteCookie:cookie];
                    }
                }
                
                [[[MyAppManager sharedManager] arrAllFeeds] removeAllObjects];
                isUserLoggedIn=YES;
                
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                NSMutableDictionary *userDefaults=[[NSMutableDictionary alloc]initWithDictionary:[defaults valueForKey:@"USER_DETAIL"]];
                NSString *strFileName=[NSString stringWithFormat:@"user_timeline_%@_1p2.json",[userDefaults valueForKey:@"admin_id"]];
                NSString *strFileName2=[NSString stringWithFormat:@"user_home_%@_1p2.json",[userDefaults valueForKey:@"admin_id"]];
                
                [strFileName removeFile];
                [strFileName2 removeFile];
                
                [defaults removeObjectForKey:@"USER_DETAIL"];
                [defaults synchronize];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
            
            [[AppDelegate sharedInstance]hideLoader];
            
            NSArray *vList = [[self navigationController] viewControllers];
            UIViewController *view;
            for (int i=[vList count]-1; i>=0; --i) {
                view = [vList objectAtIndex:i];
                if ([view.nibName isEqualToString: @"LoginViewController"])
                    break;
            }
            [[self navigationController] popToViewController:view animated:YES];
            
            
        }
    }
    if ([action isEqualToString:@"load_locations"])
    {
        [[AppDelegate sharedInstance]hideLoader];
        
        NSMutableArray *templocarray=[[NSMutableArray alloc]initWithArray:[dictionary objectForKey:@"LOCATION_DIARY"]];
        
        for (int i=0; i<[templocarray count]; i++)
        {
            NSInteger locid=[[[templocarray objectAtIndex:i] objectForKey:@"iLocationID"] integerValue];
            NSString *strLocName=[[templocarray objectAtIndex:i] objectForKey:@"vLocationName"];
            NSString *strLocTimeStamp=[[templocarray objectAtIndex:i] objectForKey:@"unixTimeStampLoc"];
            
            [[AppDelegate sharedInstance] addlocationwithlocationid:locid locationname:strLocName locationtimestamp:strLocTimeStamp];
        }
        
        [[AppDelegate sharedInstance] getalllocations];
        
        [txtlocationname addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }

    if ([action isEqualToString:@"facebook_unauth"])
    {
        if ([strMSG isEqualToString:@"SUCCESS"]) 
        {
            NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
            [socialdict setObject:@"0" forKey:@"facebook_token"];
            [socialdict setObject:@"Unauthenticate" forKey:@"facebook"];
            [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else
        {
            DisplayAlertWithTitle(@"Note", strMSG);
            return;
        }
    }
    if ([action isEqualToString:@"twitter_unauth"])
    {
        if ([strMSG isEqualToString:@"SUCCESS"]) 
        {
            NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
            [socialdict setObject:@"0" forKey:@"twitter_secrete"];
            [socialdict setObject:@"0" forKey:@"twitter_token"];
            [socialdict setObject:@"Unauthenticate" forKey:@"twitter"];
            [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else
        {
            DisplayAlertWithTitle(@"Note", strMSG);
            return;
        }
    }

    if ([action isEqualToString:@"foursquare_unauth"])
    {
        [action setString:@""];
        
        if ([strMSG isEqualToString:@"SUCCESS"]) 
        {
            NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
            [socialdict setObject:@"0" forKey:@"foursquare_token"];
            [socialdict setObject:@"Unauthenticate" forKey:@"foursquare"];
            [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else
        {
            DisplayAlertWithTitle(@"Note", strMSG);
            return;
        }
    }
   
    if ([action isEqualToString:@"profile_update"] || [action isEqualToString:@"image_update"]) 
    {
        if ([dictionary objectForKey:@"USER_DETAIL"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[dictionary objectForKey:@"USER_DETAIL"] forKey:@"USER_DETAIL"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        if ([action isEqualToString:@"image_update"])
        {
            UIImageView *imgTemp = [[UIImageView alloc]init];
            NSURL *imgURLTemp = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"COVERPIC_URL"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [imgTemp setImageWithURL:imgURLTemp placeholderImage:[UIImage imageNamed:@""]];
            
            UIImageView *imgTemp2 = [[UIImageView alloc]init];
            NSURL *imgURLTemp2 = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"image_path"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [imgTemp2 setImageWithURL:imgURLTemp2 placeholderImage:[UIImage imageNamed:@"profileUser"]];
        }
        
        NSNotification *notif = [NSNotification notificationWithName:@"updateProfilePic" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
        [action setString:@""];
      }
    
    [self updatesocialbuttons];
}


#pragma mark - PROFILE VIEW
-(IBAction)btnChangeProfilePic:(id)sender
{
    if ([txtfirstname isFirstResponder] || [txtlastname isFirstResponder] || [txtphonenumber isFirstResponder] || [txtlocationname isFirstResponder] || [txtschool isFirstResponder]) {
        [txtfirstname resignFirstResponder];
        [txtlastname resignFirstResponder];
        [txtphonenumber resignFirstResponder];
        [txtlocationname resignFirstResponder];
        [txtschool resignFirstResponder];
        [self updateProfile];
    }
    
    if ([txtpassword isFirstResponder]) {
        [txtpassword resignFirstResponder];
    }
    
    isselectedimagecover=NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallery", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	actionSheet.tag = 1;
	[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(IBAction)btnChangeCoverPic:(id)sender
{
    if ([txtfirstname isFirstResponder] || [txtlastname isFirstResponder] || [txtphonenumber isFirstResponder] || [txtlocationname isFirstResponder] || [txtschool isFirstResponder]) {
        [txtfirstname resignFirstResponder];
        [txtlastname resignFirstResponder];
        [txtphonenumber resignFirstResponder];
        [txtlocationname resignFirstResponder];
        [txtschool resignFirstResponder];
        [self updateProfile];
    }
    
    if ([txtpassword isFirstResponder]) {
        [txtpassword resignFirstResponder];
    }
    
    isselectedimagecover=YES;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallery", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	actionSheet.tag = 1;
	[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch (actionSheet.tag) {
		case 1:
			switch (buttonIndex){
                case 0:
                {
                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    {
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:APP_Name message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                    else
                    {
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        picker.delegate = self;
                        picker.allowsEditing =YES;
                        [self presentModalViewController:picker animated:YES];
                    }
                }
                    break;
                    
                case 1:
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  
                    picker.delegate = self; 
                    picker.allowsEditing =YES;
                    [self presentModalViewController:picker animated:YES];
                }
                    break;
            }
            break;
		default:
			break;
	}	
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==201 && buttonIndex==1)
    {
        NSString *strOldPwd= [[alertView textFieldAtIndex:0].text removeNull];
        NSString *strNewPwd= [[alertView textFieldAtIndex:1].text removeNull];

        if ([strOldPwd length]>0 && [strNewPwd length]>0)
        {
            if ([strOldPwd isEqualToString:strNewPwd])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change Password" message:@"Please enter different password!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Change", nil];
                alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
                [alert textFieldAtIndex:0].secureTextEntry=YES;
                [alert textFieldAtIndex:0].placeholder=@"Old Password";
                [alert textFieldAtIndex:1].placeholder=@"New Password";
                alert.tag=201;
                [alert show];
            }
            else
            {
                if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
                {
                    DisplayNoInternate;
                    return;
                }
                else
                {
                    [action setString:@"password_update"];
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    
                    NSURL *urlPost=[NSURL URLWithString:kChangePasswordURL];
                    NSMutableDictionary *dictPostParameters=[[NSMutableDictionary alloc]init];
                    [dictPostParameters setObject:[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"] forKey:@"userID"];
                    [dictPostParameters setObject:strOldPwd forKey:@"oldpwd"];
                    [dictPostParameters setObject:strNewPwd forKey:@"newpwd"];
                    
                    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
                    [postRequest setURL:urlPost];
                    [postRequest setHTTPMethod:@"POST"];
                    
                    NSString *boundary = @"---------------------------14737809831466499882746641449";
                    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                    NSMutableData  *body = [[NSMutableData alloc] init];
                    
                    [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
                    
                    for (NSString *theKey in [dictPostParameters allKeys])
                    {
                        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",theKey] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[dictPostParameters objectForKey:theKey]] dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
//                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                    [postRequest setHTTPBody:body];
                    [postRequest setTimeoutInterval:kTimeOutInterval];

                    connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
                }
            }
        }
        else
        {
            DisplayAlert(@"Please enter all fields!");
        }
    }
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    if (isselectedimagecover)
    {
        UIImage *resultingImage = [info objectForKey:UIImagePickerControllerEditedImage];
        imgcoverimage.image = resultingImage;
        imgTempStore.image=resultingImage;
    }
    else
    {
        UIImage *resultingImage = [info objectForKey:UIImagePickerControllerEditedImage];
        imgprofileimg.image=[resultingImage squareImage];
        imgTempStore.image=resultingImage;
    }
    
    [self performSelector:@selector(_updateImage)];
	[picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self.navigationController dismissModalViewControllerAnimated:YES];	
}

-(IBAction)btnUpdatePassword:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change Password" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Change", nil];
    alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
    [alert textFieldAtIndex:0].secureTextEntry=YES;
    [alert textFieldAtIndex:0].placeholder=@"Old Password";
    [alert textFieldAtIndex:1].placeholder=@"New Password";
    alert.tag=201;
    [alert show];
}

#pragma mark - SOCIAL NETWORK ITEGRATION
- (void)resetUi 
{
    [self updatesocialbuttons];
}
-(void)updatesocialbuttons
{
    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    
    if ([[socialdict objectForKey:@"facebook"] isEqualToString:@"Unauthenticate"]) {
        btnfacebookshare.hidden=NO;
        btnfacebookshare2.hidden=YES;
    }
    else
    {
        btnfacebookshare.hidden=YES;
        btnfacebookshare2.hidden=NO;
    }
    
    if ([[socialdict objectForKey:@"twitter"] isEqualToString:@"Unauthenticate"]) {
        btntwittershare.hidden=NO;
        btntwittershare2.hidden=YES;
    }
    else
    {
        btntwittershare.hidden=YES;
        btntwittershare2.hidden=NO;
    }
    
    if ([[socialdict objectForKey:@"foursquare"] isEqualToString:@"Unauthenticate"]) {
        btnfoursquareshare.hidden=NO;
        btnfoursquareshare2.hidden=YES;
    }
    else
    {
        btnfoursquareshare.hidden=YES;
        btnfoursquareshare2.hidden=NO;
    }
    
    [switchSearchable setOn:(![[socialdict objectForKey:@"eAccountStatus"] isEqualToString:@"Private"])];
        
    if ([[socialdict objectForKey:@"eFrndReq_MailNoty"] isEqualToString:@"ON"])
    {
        [btnmailnot_frireq setImage:[UIImage imageNamed:@"btnMail_sel.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnmailnot_frireq setImage:[UIImage imageNamed:@"btnMail_unsel.png"] forState:UIControlStateNormal];
    }
    
    if ([[socialdict objectForKey:@"ePost_MailNoty"] isEqualToString:@"ON"])
    {
        [btnmailnot_postfri setImage:[UIImage imageNamed:@"btnMail_sel.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnmailnot_postfri setImage:[UIImage imageNamed:@"btnMail_unsel.png"] forState:UIControlStateNormal];
    }
    
    if ([[socialdict objectForKey:@"eComment_MailNoty"] isEqualToString:@"ON"])
    {
        [btnmailnot_comment setImage:[UIImage imageNamed:@"btnMail_sel.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnmailnot_comment setImage:[UIImage imageNamed:@"btnMail_unsel.png"] forState:UIControlStateNormal];
    }
    
    if ([[socialdict objectForKey:@"ePostOfMe_mail"] isEqualToString:@"ON"])
    {
        [btnmailnot_postofme setImage:[UIImage imageNamed:@"btnMail_sel.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnmailnot_postofme setImage:[UIImage imageNamed:@"btnMail_unsel.png"] forState:UIControlStateNormal];
    }
    
    if ([[socialdict objectForKey:@"eFrndReq_MobileNoty"] isEqualToString:@"ON"])
    {
        [btnmobilenot_frireq setImage:[UIImage imageNamed:@"btnMobile_sel.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnmobilenot_frireq setImage:[UIImage imageNamed:@"btnMobile_unsel.png"] forState:UIControlStateNormal];
    }
    
    if ([[socialdict objectForKey:@"ePost_MobileNoty"] isEqualToString:@"ON"])
    {
        [btnmobilenot_postfri setImage:[UIImage imageNamed:@"btnMobile_sel.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnmobilenot_postfri setImage:[UIImage imageNamed:@"btnMobile_unsel.png"] forState:UIControlStateNormal];
    }
    
    if ([[socialdict objectForKey:@"eComment_MobileNoty"] isEqualToString:@"ON"])
    {
        [btnmobilenot_comment setImage:[UIImage imageNamed:@"btnMobile_sel.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnmobilenot_comment setImage:[UIImage imageNamed:@"btnMobile_unsel.png"] forState:UIControlStateNormal];
    }
    
    if ([[socialdict objectForKey:@"ePostOfMe_mobile"] isEqualToString:@"ON"])
    {
        [btnmobilenot_postofme setImage:[UIImage imageNamed:@"btnMobile_sel.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnmobilenot_postofme setImage:[UIImage imageNamed:@"btnMobile_unsel.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - NOTIFICATION
-(IBAction)btnMailNotificationClicked:(id)sender
{
    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    
    switch ([sender tag]) {
        case 0:
        {
            if ([[socialdict objectForKey:@"eFrndReq_MailNoty"] isEqualToString:@"ON"])
            {
                [socialdict setObject:@"OFF" forKey:@"eFrndReq_MailNoty"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changeFrndReqNotiOnMail&state=%@",WebURL,@"OFF"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
            else
            {
                [socialdict setObject:@"ON" forKey:@"eFrndReq_MailNoty"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changeFrndReqNotiOnMail&state=%@",WebURL,@"ON"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }            
        }
            break;
        case 1:
        {
            if ([[socialdict objectForKey:@"ePost_MailNoty"] isEqualToString:@"ON"])
            {
                [socialdict setObject:@"OFF" forKey:@"ePost_MailNoty"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changePostMailNoty&state=%@",WebURL,@"OFF"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
            else
            {
                [socialdict setObject:@"ON" forKey:@"ePost_MailNoty"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changePostMailNoty&state=%@",WebURL,@"ON"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
        }
            break;
        case 2:
        {
            if ([[socialdict objectForKey:@"eComment_MailNoty"] isEqualToString:@"ON"])
            {
                [socialdict setObject:@"OFF" forKey:@"eComment_MailNoty"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changeCommentMailNoty&state=%@",WebURL,@"OFF"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
            else
            {
                [socialdict setObject:@"ON" forKey:@"eComment_MailNoty"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changeCommentMailNoty&state=%@",WebURL,@"ON"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
        }
            break;
        case 3:
        {
            if ([[socialdict objectForKey:@"ePostOfMe_mail"] isEqualToString:@"ON"])
            {
                [socialdict setObject:@"OFF" forKey:@"ePostOfMe_mail"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changePostOFmeMailNoty&state=%@",WebURL,@"OFF"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
            else
            {
                [socialdict setObject:@"ON" forKey:@"ePostOfMe_mail"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changePostOFmeMailNoty&state=%@",WebURL,@"ON"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
        }
            break;
            
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self updatesocialbuttons];
}
-(IBAction)btnMobileNotificationClicked:(id)sender
{
    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    
    switch ([sender tag]) {
        case 0:
        {
            if ([[socialdict objectForKey:@"eFrndReq_MobileNoty"] isEqualToString:@"ON"])
            {
                [socialdict setObject:@"OFF" forKey:@"eFrndReq_MobileNoty"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changeFrndReqNotiOnMobile&state=%@",WebURL,@"OFF"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
            else
            {
                [socialdict setObject:@"ON" forKey:@"eFrndReq_MobileNoty"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changeFrndReqNotiOnMobile&state=%@",WebURL,@"ON"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }            
        }
            break;
        case 1:
        {
            if ([[socialdict objectForKey:@"ePost_MobileNoty"] isEqualToString:@"ON"])
            {
                [socialdict setObject:@"OFF" forKey:@"ePost_MobileNoty"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changePostMobileNoty&state=%@",WebURL,@"OFF"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
            else
            {
                [socialdict setObject:@"ON" forKey:@"ePost_MobileNoty"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changePostMobileNoty&state=%@",WebURL,@"ON"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
        }
            break;
        case 2:
        {
            if ([[socialdict objectForKey:@"eComment_MobileNoty"] isEqualToString:@"ON"])
            {
                [socialdict setObject:@"OFF" forKey:@"eComment_MobileNoty"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changeCommentMobileNoty&state=%@",WebURL,@"OFF"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
            else
            {
                [socialdict setObject:@"ON" forKey:@"eComment_MobileNoty"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changeCommentMobileNoty&state=%@",WebURL,@"ON"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
        }
            break;
        case 3:
        {
            if ([[socialdict objectForKey:@"ePostOfMe_mobile"] isEqualToString:@"ON"])
            {
                [socialdict setObject:@"OFF" forKey:@"ePostOfMe_mobile"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changePostOFmeMobileNoty&state=%@",WebURL,@"OFF"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
            else
            {
                [socialdict setObject:@"ON" forKey:@"ePostOfMe_mobile"];
                [action setString:@"set_notification"];
                [actionurl setString:[NSString stringWithFormat:@"%@index.php?c=admin&func=changePostOFmeMobileNoty&state=%@",WebURL,@"ON"]];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@",[socialdict valueForKey:@"admin_id"]]];
                [self performSelector:@selector(_startSend)];
            }
        }
            break;
            
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self updatesocialbuttons];
}

#pragma mark - Privacy VIEW

-(IBAction)switchSearchableValueChanged:(id)sender
{
    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    
    if (![[socialdict objectForKey:@"eAccountStatus"] isEqualToString:(switchSearchable.isOn)?@"Public":@"Private"])
    {
        [socialdict setObject:(switchSearchable.isOn)?@"Public":@"Private" forKey:@"eAccountStatus"];
        [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self updatesocialbuttons];
        
        [action setString:@"set_privacy"];
        [actionurl setString:strSetPrivacy];
        [actionparameters setString:[NSString stringWithFormat:@"userID=%@&privacy=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],(switchSearchable.isOn)?@"Public":@"Private"]];
        [self performSelector:@selector(_startSend)];
    }
}

#pragma mark - Terms VIEW
-(IBAction)btnTermsOfUseClicked:(id)sender
{
    TermsOfUseViewController *objTermsOfUseViewController=[[TermsOfUseViewController alloc]initWithNibName:@"TermsOfUseViewController" bundle:nil];
    objTermsOfUseViewController.strTitle = @"About";
    objTermsOfUseViewController.strWebURL = kPrivacyPolicyCombined;
    [self.navigationController pushViewController:objTermsOfUseViewController animated:YES];
}
#pragma mark - Sign Out
-(IBAction)btnSignOutClicked:(id)sender
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [action setString:@"SignOut"];
        [[AppDelegate sharedInstance]showLoader];
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"admin_id=%@&device=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[[NSUserDefaults standardUserDefaults] valueForKey:@"Device_Token"]]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:strSignOut]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}

#pragma mark - 
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_OAUTH_VERIFY_RECEIVED object:nil];
}
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
