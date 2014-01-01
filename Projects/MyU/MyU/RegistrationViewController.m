//
//  RegistrationViewController.m
//  MyU
//
//  Created by Vijay on 7/5/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "RegistrationViewController.h"
#import "LeftSideViewController.h"
#import "RightSideViewController.h"
#import "TermsAndPolicyViewController.h"
#import "HomeViewController.h"
#import "GRAlertView.h"
#import "NSString+Utilities.h"
#import "DBManager.h"
#import "MyAppManager.h"
#import "WSManager.h"
#import "FbGraph.h"
#import "OAuthTwitter.h"
#import "OAuthConsumerCredentials.h"
#import "CustomLoginPopup.h"
#import "TwitterLoginPopup.h"
#import "SBJson.h"
#import "NSString+URLEncoding.h"
#import "XMPPFramework.h"
#import "AppDelegate.h"
#import "GlobalVariables.h"
#import "DDLog.h"



@interface RegistrationViewController ()
{
    FbGraph *fbGraph;
}

-(void)presentLoginWithFlowType:(TwitterLoginFlowType)flowType;
-(void)fbGraphCallback;

@end

@implementation RegistrationViewController
@synthesize oAuthTwitter;

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dictSocial=[[NSMutableDictionary alloc]init];
    
    isUserProffesor=NO;
    selecteduni=-1;
    arrUniversityNames=[[NSMutableArray alloc]init];
    
    pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0, 548.0+iOS7, 320.0, 216.0)];
     [self.view addSubview:pickerView];
     pickerView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
     pickerView.delegate=self;
     [pickerView reloadAllComponents];
    
    isManuallyUniEntry=NO;
    
    [self syncuniversities];
    [self logoutTwitter];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oauth_verifier_received:) name:NOTIFY_OAUTH_VERIFY_RECEIVED object:nil];
}
-(void)syncuniversities
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObject:@"" forKey:@"lastsyncedtimestamp"];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kLoadUniversityURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(universitysynced:) withfailureHandler:nil withCallBackObject:self];
    [obj startRequest];
}
-(void)universitysynced:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        if ([dictResponse objectForKey:@"university_list"])
        {
            [arrUniversityNames removeAllObjects];
            [arrUniversityNames addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"universityid",@"Not Listed",@"universityname",nil]];
            [arrUniversityNames addObjectsFromArray:[dictResponse objectForKey:@"university_list"]];
            [pickerView reloadAllComponents];
        }
    }
}

#pragma mark - TWITTER INTEGRATION

-(IBAction)btnTwitterClicked:(id)sender
{
    [self.view endEditing:YES];
    [self hidePicker];
    
    if (!oAuthTwitter)
    {
        oAuthTwitter = [[OAuthTwitter alloc] initWithConsumerKey:OAUTH_TWITTER_CONSUMER_KEY andConsumerSecret:OAUTH_TWITTER_CONSUMER_SECRET];
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
    
    [self presentLoginWithFlowType:TwitterLoginCallbackFlow];
}

-(void)initialiseTwitter
{
    oAuthTwitter = [[OAuthTwitter alloc] initWithConsumerKey:OAUTH_TWITTER_CONSUMER_KEY andConsumerSecret:OAUTH_TWITTER_CONSUMER_SECRET];
    [oAuthTwitter load];
}
-(void)logoutTwitter
{
    [oAuthTwitter forget];
    [oAuthTwitter save];
}

-(void)getmytwitterdetails
{
    NSString *getUrl = @"https://api.twitter.com/1.1/users/show.json";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:oAuthTwitter.user_id,@"user_id", nil];
    
    NSLog(@"thee %@",params);
    // Note how the URL is without parameters here...
    // (this is how OAuth works, you always give it a "normalized" URL without parameters
    // since you give parameters separately to it, even for GET)
    NSString *oAuthValue = [oAuthTwitter oAuthHeaderForMethod:@"GET" andUrl:getUrl andParams:params];
    
    // ... but the actual request URL contains normal GET parameters.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString
                                                                                             stringWithFormat:@"%@?user_id=%@",
                                                                                             getUrl,oAuthTwitter.user_id]]];
    
    [request addValue:oAuthValue forHTTPHeaderField:@"Authorization"];
    
    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSString *responseString = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Got statuses. HTTP result code: %d", [response statusCode]);
    NSDictionary *profiledata=[responseString JSONValue];
    //NSDictionary *profiledata = [responseString JSONValue];
    NSLog(@"The Profile:%@",profiledata);
    
    txtName.text=([profiledata objectForKey:@"name"])?[profiledata objectForKey:@"name"]:txtName.text;
    txtUserName.text=([profiledata objectForKey:@"screen_name"])?[profiledata objectForKey:@"screen_name"]:txtName.text;
       
    if ([profiledata objectForKey:@"profile_image_url"])
    {
        NSString *strProfileURL=[NSString stringWithFormat:@"%@",[profiledata objectForKey:@"profile_image_url"]];
        
        if ([[strProfileURL removeNull] length]>0)
        {
            UIImage *imgprofile=[[UIImage alloc]initWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[strProfileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
            
            if (imgprofile!=nil) {
                [dictSocial setObject:imgprofile forKey:@"profile_pic"];
            }
        }
    }
    
    [dictSocial setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"tw_token"]] forKey:@"tw_token"];
    
    [dictSocial setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"tw_secret"]] forKey:@"tw_secret"];
    
    [[MyAppManager sharedManager] hideLoaderInMainThread];
    
}
#pragma mark - oAuthLoginPopupDelegate
- (void)oAuthLoginPopupDidCancel:(UIViewController *)popup
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{}];

}
- (void)oAuthLoginPopupDidAuthorize:(UIViewController *)popup
{
    [self dismissViewControllerAnimated:NO completion:^{}];
    [oAuthTwitter save];
}

#pragma mark - TwitterLoginUiFeedback
-(void) tokenRequestDidStart:(TwitterLoginPopup *)twitterLogin
{
    [loginPopup startanimator];
}
-(void) tokenRequestDidSucceed:(TwitterLoginPopup *)twitterLogin
{
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
    [[MyAppManager sharedManager] showLoaderInMainThread];
    [self getmytwitterdetails];
}
-(void) authorizationRequestDidFail:(TwitterLoginPopup *)twitterLogin {
    [loginPopup stopanimator];
}

#pragma mark - UIActionSheetDelegate
-(void)presentLoginWithFlowType:(TwitterLoginFlowType)flowType
{
    if (loginPopup) {
        loginPopup = nil;
    }
    
    if (!loginPopup)
    {
        loginPopup = [[CustomLoginPopup alloc] initWithNibName:@"TwitterLoginCallbackFlow" bundle:nil];
        loginPopup.oAuthCallbackUrl = OAUTH_CALLBACK_URL;
        loginPopup.flowType = flowType;
        loginPopup.oAuth = oAuthTwitter;
        loginPopup.delegate = self;
        loginPopup.uiDelegate = self;
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginPopup];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navbar.png"] forBarMetrics:UIBarMetricsDefault];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:nav animated:NO completion:^{}];
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

-(void)handleOAuthVerifier:(NSString *)oauth_verifier
{
    [loginPopup authorizeOAuthVerifier:oauth_verifier];
}

#pragma mark - FACEBOOK INTEGRATION
-(IBAction)btnFacebookClicked:(id)sender
{
    [self.view endEditing:YES];
    [self hidePicker];
    
    [self logoutfacebook];
    fbGraph = [[FbGraph alloc] initWithFbClientID:kFacebookAppID];
    [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback)
                         andExtendedPermissions:kFacebookPermissions];
    
    /*
    fbGraph.accessToken=[[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"] objectForKey:@"facebook_token"];
    
    if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0))
    {
        [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback)
                             andExtendedPermissions:kFacebookPermissions];
    }
    else
    {
        [self performSelector:@selector(fbGraphCallback) withObject:nil afterDelay:0.000000000001];
    }
     */
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
        [[MyAppManager sharedManager] showLoaderInMainThread];
        [self performSelector:@selector(getmyfbdetails) withObject:nil afterDelay:0.4];
	}
}
-(void)getmyfbdetails
{
    NSDictionary *fbgetpara=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"fb_token"],@"access_token",@"id,username,email,name,first_name,middle_name,last_name,birthday,gender,locale,location,hometown,cover,bio,picture.type(large),relationship_status,religion,verified,link",@"fields",nil];
    FbGraphResponse *fb_graph_response = [fbGraph doGraphGet:@"me" withGetVars:fbgetpara];
    
    NSData *jsonData = [fb_graph_response.htmlResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *profiledata = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"Hii jsondict:%@",profiledata);
    
    
    txtName.text=([profiledata objectForKey:@"name"])?[profiledata objectForKey:@"name"]:txtName.text;
    txtUserName.text=([profiledata objectForKey:@"username"])?[profiledata objectForKey:@"username"]:txtName.text;
    if ([profiledata objectForKey:@"email"])
    {
        NSString *strFBMail=[NSString stringWithFormat:@"%@",[profiledata objectForKey:@"email"]];
        NSString *strProxy = @"proxymail.facebook.com";
        if ([strFBMail rangeOfString:strProxy].location == NSNotFound)
        {
            //Actual Email
            txtEmail.text=[strFBMail removeNull];
        }
        else
        {
            //ProxyMail
        }
    }
    
    if ([profiledata objectForKey:@"picture"])
    {
        if ([[profiledata objectForKey:@"picture"] objectForKey:@"data"])
        {
            if ([[[profiledata objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"])
            {
                NSString *strProfileURL=[NSString stringWithFormat:@"%@",[[[profiledata objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                
                if ([[strProfileURL removeNull] length]>0)
                {
                    UIImage *imgprofile=[[UIImage alloc]initWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[strProfileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
                    
                    if (imgprofile!=nil) {
                        [dictSocial setObject:imgprofile forKey:@"profile_pic"];
                    }
                }
            }
        }
    }
    
    if ([profiledata objectForKey:@"gender"])
    {
        [dictSocial setObject:[profiledata objectForKey:@"gender"] forKey:@"gender"];
    }
    
    if ([profiledata objectForKey:@"bio"])
    {
        [dictSocial setObject:[profiledata objectForKey:@"bio"] forKey:@"bio"];
    }

    if ([profiledata objectForKey:@"birthday"])
    {
        NSString *strBirthday=[NSString stringWithFormat:@"%@",[profiledata objectForKey:@"birthday"]];
        
        if ([[strBirthday removeNull] length]==10)
        {
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            NSDate *dateBirth=[dateFormatter dateFromString:[strBirthday removeNull]];
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];
            [dictSocial setObject:[dateFormatter stringFromDate:dateBirth] forKey:@"birthday"];
        }
    }
    
    [dictSocial setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"fb_token"]] forKey:@"fb_token"];
    
    /*
     email = "vijay@openxcell.info";
     "first_name" = Vijay;
     gender = male;
     id = 100004909328124;
     "last_name" = Openxcell;
     link = "https://www.facebook.com/vijay.openxcell";
     locale = "en_US";
     location =     {
     id = 115440481803904;
     name = "Ahmedabad, India";
     };
     name = "Vijay Openxcell";
     picture =     {
     data =         {
     "is_silhouette" = 0;
     url = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/371914_100004909328124_448895503_q.jpg";
     };
     };
     username = "vijay.openxcell";
     verified = 1;
     */
    
    [[MyAppManager sharedManager] hideLoaderInMainThread];
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


-(IBAction)btnRegisterClicked:(id)sender
{
    if ([[txtName.text removeNull]length]==0)
    {
        kGRAlert(@"Please enter name");
    }
    else if ([[txtUserName.text removeNull]length]==0)
    {
        kGRAlert(@"Please enter user-name");
    }
    else if ([[txtPassword.text removeNull]length]==0)
    {
        kGRAlert(@"Please enter password");
    }
    else if ([[txtEmail.text removeNull]length]==0)
    {
        kGRAlert(@"Please enter email");
    }
    else if (![[txtEmail.text removeNull] isValidEmail])
    {
        kGRAlert(@"Please enter valid email");
    }
    else if ([[txtUniversity.text removeNull]length]==0)
    {
        kGRAlert(@"Please enter university");
    }
    else
    {
        //NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[strUserName removeNull],@"username",[strPassword removeNull],@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"],@"device_token", nil];
        //username=bharat&password=123456&name=jim&email=bharat@openxcell.info&isfacultymember=1&university=9&device_token=8789798654654654654
        NSMutableDictionary *dictPara=[[NSMutableDictionary alloc]init];
        
//#if TARGET_IPHONE_SIMULATOR
        //[dictPara setObject:@"IOS_SIMULATOR" forKey:@"device_token"];
//#elif TARGET_OS_IPHONE
//        [dictPara setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"] forKey:@"device_token"];
//#endif
        
        [dictPara setObject:[txtName.text removeNull] forKey:@"name"];
        [dictPara setObject:[txtUserName.text removeNull] forKey:@"username"];
        [dictPara setObject:[txtPassword.text removeNull] forKey:@"password"];
        [dictPara setObject:[txtEmail.text removeNull] forKey:@"email"];
        [dictPara setObject:[NSString stringWithFormat:@"%d",(isUserProffesor)?1:0] forKey:@"isfacultymember"];
        [dictPara setObject:[NSString stringWithFormat:@"%@",(isManuallyUniEntry)?@"":[[arrUniversityNames objectAtIndex:selecteduni] objectForKey:@"universityid"]] forKey:@"university"];
        [dictPara setObject:[NSString stringWithFormat:@"%@",(isManuallyUniEntry)?[txtUniversity.text removeNull]:@""] forKey:@"university_name"];
        
        if ([dictSocial objectForKey:@"bio"])
        {
            [dictPara setObject:[dictSocial objectForKey:@"bio"] forKey:@"bio"];
        }
        
        if ([dictSocial objectForKey:@"gender"])
        {
            [dictPara setObject:[dictSocial objectForKey:@"gender"] forKey:@"gender"];
        }
        
        if ([dictSocial objectForKey:@"birthday"])
        {
            [dictPara setObject:[dictSocial objectForKey:@"birthday"] forKey:@"birthday"];
        }
        
        if ([dictSocial objectForKey:@"fb_token"])
        {
            [dictPara setObject:[dictSocial objectForKey:@"fb_token"] forKey:@"fb_token"];
        }
        
        if ([dictSocial objectForKey:@"tw_token"])
        {
            [dictPara setObject:[dictSocial objectForKey:@"tw_token"] forKey:@"twitter_token"];
        }
        
        if ([dictSocial objectForKey:@"tw_secret"])
        {
            [dictPara setObject:[dictSocial objectForKey:@"tw_secret"] forKey:@"twitter_secret"];
        }
        
        NSMutableDictionary *dictPostData=[[NSMutableDictionary alloc]init];
        if ([dictSocial objectForKey:@"profile_pic"])
        {
            UIImage *imgProfile=[dictSocial objectForKey:@"profile_pic"];
            [dictPostData setObject:UIImagePNGRepresentation(imgProfile) forKey:@"profile_picture"];
        }
               
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kSignUpURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:dictPostData withsucessHandler:@selector(registrationdone:) withfailureHandler:@selector(registrationfailed:) withCallBackObject:self];
        [[MyAppManager sharedManager]showLoader];
        [obj startRequest];
        

    }
}
/* SET USERNAME AND PASSWORD IN USER DEFAULT TO GET IN */

- (void)setField:(NSString *)field forKey:(NSString *)key
{
    if (field != nil)
    {
        if ([key isEqualToString:@"kXMPPmyJID"]) {
            field = [NSString stringWithFormat:@"%@%@",field,DOMAIN_NAME];
        }
        [[NSUserDefaults standardUserDefaults] setObject:field forKey:key];        
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

-(void)registrationdone:(id)sender
{
    [[MyAppManager sharedManager]hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        IsRegestration = @"YES";
        [self setField:[dictResponse valueForKey:@"user_id"] forKey:@"kXMPPmyJID"];
        [self setField:[dictResponse valueForKey:@"user_id"] forKey:@"kXMPPmyPassword"];
        [[self appDelegate] disconnect];
        [[self appDelegate] connect];
        
        kGRAlert(@"You have been successfully registered. An activation email has been sent to you. Within the email you will find a link, which you must click in order to activate your account.\nIf the email doesn’t appear shortly, please make sure to check your spam or junk boxes. Make sure to move the email to your inbox before clicking the link");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)registrationfailed:(id)sender
{
    [[MyAppManager sharedManager]hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    
    if ([[strErrorMessage removeNull] length]>0) {
        kGRAlert([strErrorMessage removeNull])
    }
}
-(IBAction)btnTermsClicked:(id)sender
{
    TermsAndPolicyViewController *obj=[[TermsAndPolicyViewController alloc]init];
    obj.pagetype=TermsPage;
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnPrivacyPolicyClicked:(id)sender
{
    TermsAndPolicyViewController *obj=[[TermsAndPolicyViewController alloc]init];
    obj.pagetype=PrivacyPage;
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnUniversityClicked:(id)sender
{
    if ([arrUniversityNames count]>0)
    {
        [self.view endEditing:YES];
        
        if (IS_DEVICE_iPHONE_5)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];
            [viewsignup setFrame:CGRectMake(0,-57.0,320,460+iPhone5ExHeight)];
            [pickerView setFrame:CGRectMake(0,460+iPhone5ExHeight-216.0+iOS7,320,216.0)];
            [UIView commitAnimations];
        }
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];
            [viewsignup setFrame:CGRectMake(0,-145.0,320,460+iPhone5ExHeight)];
            [pickerView setFrame:CGRectMake(0,460+iPhone5ExHeight-216.0+iOS7,320,216.0)];
            [UIView commitAnimations];
        }
    }
    else
    {
        kGRAlert(kUniversityNotLoadedAlert);
    }
}
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)navigatetohomescreen
{
    UIViewController * leftSideDrawerViewController = [[LeftSideViewController alloc] init];
    UIViewController * centerViewController = [[HomeViewController alloc] init];
    UIViewController * rightSideDrawerViewController = [[RightSideViewController alloc] init];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    navigationController.navigationBarHidden = YES;
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:navigationController
                                             leftDrawerViewController:leftSideDrawerViewController
                                             rightDrawerViewController:rightSideDrawerViewController];
    drawerController.navigationController.navigationBarHidden = YES;
    [drawerController setMaximumLeftDrawerWidth:250.0];
    [drawerController setMaximumRightDrawerWidth:250.0];
    
    //MMDrawerAnimationTypeSlide,
    //MMDrawerAnimationTypeSlideAndScale,
    //MMDrawerAnimationTypeSwingingDoor,
    //MMDrawerAnimationTypeParallax,
    
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
    [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:MMDrawerAnimationTypeParallax];
    
    drawerController.centerHiddenInteractionMode =MMDrawerAnimationTypeSwingingDoor;
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible)
     {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    [self.navigationController pushViewController:drawerController animated:YES];
    
}

-(IBAction)btnCheckMarkClicked:(id)sender
{
    isUserProffesor=!isUserProffesor;
    [btnCheckMark setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btncheck_%@.png",(isUserProffesor)?@"sel":@"unsel"]] forState:UIControlStateNormal];
    txtEmail.placeholder=(isUserProffesor)?@"Please enter your university email":@"";
}

#pragma mark - PICKERVIEW

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView
{
	return [arrUniversityNames count];
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row
{
	return [[arrUniversityNames objectAtIndex:row] objectForKey:@"universityname"];
}
- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row
{
	return ((row==selecteduni)?YES:NO);
	//return [[selectionStates objectForKey:[entries objectAtIndex:row]] boolValue];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==200)
    {
        if (buttonIndex==1)
        {
            [[alertView textFieldAtIndex:0] resignFirstResponder];
            
            if ([[[alertView textFieldAtIndex:0].text removeNull]length]>0)
            {
                txtUniversity.text=[[alertView textFieldAtIndex:0].text removeNull];
                isManuallyUniEntry=YES;
            }
            else
            {
                GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"Provide us with your university name so we can add it to the app soon!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                alert.tag=200;
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert textFieldAtIndex:0].placeholder = @"Enter University Name:";
                [alert textFieldAtIndex:0].delegate=self;
                [alert textFieldAtIndex:0].font=[UIFont systemFontOfSize:14.0f];
                [[alert textFieldAtIndex:0] becomeFirstResponder];
                [alert show];
            }
        }
    }
}

- (void)pickerView:(ALPickerView *)pickerViews didCheckRow:(NSInteger)row
{
    NSLog(@"the sel row:%d",row);
    selecteduni=row;
    
    if (row==0)
    {
        txtUniversity.text=@"";
        isManuallyUniEntry=YES;
        GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"Provide us with your university name so we can add it to the app soon!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alert.tag=200;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert textFieldAtIndex:0].placeholder = @"Enter University Name:";
        [alert textFieldAtIndex:0].delegate=self;
        [alert textFieldAtIndex:0].font=[UIFont systemFontOfSize:14.0f];
        [[alert textFieldAtIndex:0] becomeFirstResponder];
        [alert show];
    }
    else
    {
        txtUniversity.text=[[arrUniversityNames objectAtIndex:selecteduni] objectForKey:@"universityname"];
        isManuallyUniEntry=NO;
    }
    
    [self hidePicker];
    
    
    //[self performSelector:@selector(openhomeview) withObject:nil afterDelay:0.5];
    /*
     // Check whether all rows are checked or only one
     if (row == -1)
     for (id key in [selectionStates allKeys])
     [selectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
     else
     [selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[entries objectAtIndex:row]];
     */
}
- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row
{
    
    NSLog(@"the selgg row:%d",row);
    
    /*
     // Check whether all rows are unchecked or only one
     if (row == -1)
     for (id key in [selectionStates allKeys])
     [selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
     else
     [selectionStates setObject:[NSNumber numberWithBool:NO] forKey:[entries objectAtIndex:row]];
     */
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *theTouch=[touches anyObject];
    if (theTouch.view==viewsignup)
    {
        [self hidePicker];
        [self.view endEditing:YES];
    }
}

-(void)hidePicker
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [viewsignup setFrame:CGRectMake(0,0,320,460+iPhone5ExHeight)];
    [pickerView setFrame:CGRectMake(0,self.view.frame.size.height,320,216.0)];
    [UIView commitAnimations];    
}


#pragma mark -TEXTFIELD METHODS
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(textField==txtUserName)
    {
        NSCharacterSet *cs;
        
        if (newLength==1)
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        }
        else
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_."] invertedSet];
        }
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        NSLog(@"The filtered...:%@",filtered);
        return [string isEqualToString:filtered];
    }
    
    return (newLength>60)?NO:YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==txtName)
    {
        [txtUserName becomeFirstResponder];
    }
    else if (textField==txtUserName)
    {
        [txtPassword becomeFirstResponder];
    }
    else if (textField==txtPassword)
    {
        [txtEmail becomeFirstResponder];
    }
    else if (textField==txtEmail)
    {
        [self btnUniversityClicked:nil];
    }

    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePicker];
    
    if (IS_DEVICE_iPHONE_5)
    {
        if (textField==txtPassword)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];
            [viewsignup setFrame:CGRectMake(0,-21.0,320,460+iPhone5ExHeight)];
            [UIView commitAnimations];
        }
        else if(textField==txtEmail)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];
            [viewsignup setFrame:CGRectMake(0,-57.0,320,460+iPhone5ExHeight)];
            [UIView commitAnimations];
        }
    }
    else
    {
        if (textField==txtName)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];
            [viewsignup setFrame:CGRectMake(0,-10.0,320,460+iPhone5ExHeight)];
            [UIView commitAnimations];
        }
        else if(textField==txtUserName)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];
            [viewsignup setFrame:CGRectMake(0,-41.0,320,460+iPhone5ExHeight)];
            [UIView commitAnimations];
        }
        else if (textField==txtPassword)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];
            [viewsignup setFrame:CGRectMake(0,-105.0,320,460+iPhone5ExHeight)];
            [UIView commitAnimations];
        }
        else if(textField==txtEmail)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];
            [viewsignup setFrame:CGRectMake(0,-145.0,320,460+iPhone5ExHeight)];
            [UIView commitAnimations];
        }

    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    [viewsignup setFrame:CGRectMake(0,0,320.0,460.0+iPhone5ExHeight)];
    [UIView commitAnimations];
}

#pragma mark - DEFAULT
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
@end

