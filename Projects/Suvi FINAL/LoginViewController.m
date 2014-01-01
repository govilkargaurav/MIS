//
//  LoginViewController.m
//  Suvi
//
//  Created by apple on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "Constants.h"
#import "FbGraph.h"

@interface LoginViewController ()
{
    FbGraph *fbGraph;
    BOOL isSignUpFromFacebook;
    
    IBOutlet UIView *viewtutorial;
    IBOutlet UIView *viewBirtdayConfirm;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIPageControl *pagecntrl;
    IBOutlet UILabel *lblBDate;
    IBOutlet UIDatePicker *datePickerBD;
    NSMutableDictionary *dictFacebook;
    NSInteger selectedpage;
    
    NSDateFormatter *dateFormatterBD;
}
-(void)fbGraphCallback;

@end

@implementation LoginViewController
@synthesize centerController = _viewController;
@synthesize leftController = _leftController;
@synthesize HomeController=_HomeController;
@synthesize facebook;

#pragma mark - View Did Load

-(void)viewDidLoad{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    dictFacebook=[[NSMutableDictionary alloc]init];
    scrollview.contentSize=CGSizeMake(320*5.0,548.0);
    scrollview.pagingEnabled=YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.scrollsToTop = NO;
    pagecntrl.currentPage=0;
    selectedpage=0;
    dateFormatterBD=[[NSDateFormatter alloc]init];
    [dateFormatterBD setDateFormat:@"LLL dd, yyyy"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
    viewtutorial.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
    scrollview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
    
    viewtutorial.alpha=1.0;
    [self.view addSubview:viewtutorial];
    
    viewBirtdayConfirm.alpha=0.0;
    [self.view addSubview:viewBirtdayConfirm];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-13];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-22];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [datePickerBD setMaximumDate:maxDate];
    [datePickerBD setMinimumDate:minDate];
    [datePickerBD setDate:minDate];
    
    scrollview.contentOffset=CGPointMake(0, 0);
    
    if (!IS_DEVICE_iPHONE_5)
    {
        pagecntrl.frame=CGRectMake(0,426.0, 320, 36);
    }

    isSignUpClicked=NO;
    viewAllBtn.hidden = NO;
    activity.hidden=YES;
    passwordField.returnKeyType = UIReturnKeyDone;
    lblSignIN.hidden=YES;
    
    webData = [[NSMutableData alloc]init];
    action = @"";
}
-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollview.frame.size.width;
    int page = floor((scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pagecntrl.currentPage = page;
    selectedpage=page;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"]!=nil)
    {
        if (AddViewFlag==50)
        {
            AddViewFlag=50000;
        }
        FlagView1=1;
        
        isUserLoggedIn=YES;
        self.navigationController.navigationBar.hidden=TRUE;
        self.leftController = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
        self.HomeController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        self.centerController = [[UINavigationController alloc] initWithRootViewController:self.HomeController];
        
        IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.centerController                           leftViewController:self.leftController                                                                                           rightViewController:nil];
        deckController.rightLedge = 50;
        deckController.leftLedge = 50;
        [self.navigationController pushViewController:deckController animated:YES];
    }
    else
    {
        isUserLoggedIn=NO;
        viewAllBtn.hidden = NO;
    }
}


#pragma mark - BUTTON CLICK METHODS
-(IBAction)btnTloginClicked:(id)sender
{
    viewtutorial.alpha=0.0;
    [logintextField becomeFirstResponder];
}
-(IBAction)btnTsignupClicked:(id)sender
{
    viewtutorial.alpha=0.0;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome! You're almost there. Just enter your email & password to get started." message:nil delegate:self cancelButtonTitle:@"Join" otherButtonTitles:nil];
    alert.tag=102;
    [alert show];
}
-(IBAction)btnTFacebookClicked:(id)sender
{
    viewtutorial.alpha=0.0;

    [AppDelegate sharedInstance].facebook = [[Facebook alloc] initWithAppId:kFacebookApp_ID andDelegate:self];
    if (![[AppDelegate sharedInstance].facebook isSessionValid]) {
        NSArray *arrPermissions=[[NSArray alloc]initWithObjects:@"publish_stream",@"offline_access",@"user_checkins",@"read_stream",@"email",@"publish_checkins",@"user_photos",@"user_videos",@"friends_checkins",@"publish_actions", nil];
        [[AppDelegate sharedInstance].facebook authorize:arrPermissions];
    }
    else{
        [self fbDidLogin];
    }
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[AppDelegate sharedInstance].facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[AppDelegate sharedInstance].facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    //.type(large)
    NSString *strParam = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@&fields=id,username,email,name,first_name,last_name,birthday,gender,location,cover,picture,education",[[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessTokenKey"]];
    
    action = @"FBLogin";
    
    [[AppDelegate sharedInstance]showLoader];
    
    NSMutableData *postData = [NSMutableData data];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *urlRequest;
    urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:[strParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    [urlRequest setTimeoutInterval:kTimeOutInterval];
    
    connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark - FBRequestDelegate implementation

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}
/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    // here, you can show an alert and send cancellation notice to delegate
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"There was a problem retrieving list of your friends.", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
//    [alertView show];
}
/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"---> %@", result);
//        result = [(NSDictionary*)result objectForKey:@"data"];
    }
}

-(IBAction)LoginCliked:(id)sender
{
    [self login];
}
-(void)login
{
    [logintextField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    if (!IS_DEVICE_iPHONE_5)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.2];
        [self.view setFrame:CGRectMake(0, 0, 320, 460)];
        [UIView commitAnimations];
    }
    
    NSString *strLoginT =[logintextField.text removeNull];
    NSString *strPass = [passwordField.text removeNull];
    
    if ([strLoginT isEqualToString:@""] || [strPass isEqualToString:@""])
    {
        DisplayAlert(@"Please enter credentials");
        return;
    }
    else if(![self validEmail:strLoginT])
    {
        DisplayAlert(@"Please enter valid email");
        return;
    }
    else if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        action = @"login";
        self.view.userInteractionEnabled = NO;
        viewAllBtn.hidden = YES;
        
        activity.hidden=NO;
        [activity startAnimating];
        lblSignIN.hidden=NO;
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[[NSString stringWithFormat:@"email=%@&pass=%@&device=%@",logintextField.text,passwordField.text,[[NSUserDefaults standardUserDefaults] valueForKey:@"Device_Token"]]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:strLogin]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}

-(IBAction)btnForgetPasswordClicked:(id)sender
{
    NSString *strLoginT =[logintextField.text removeNull];
    
    if ([strLoginT isEqualToString:@""])
    {
        DisplayAlert(@"Please enter email");
        return;
    }
    else if(![self validEmail:strLoginT])
    {
        DisplayAlert(@"Please enter valid email");
        return;
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
            action = @"ForgetPassword";
            
            [[AppDelegate sharedInstance]showLoader];
            
            NSMutableData *postData = [NSMutableData data];
            [postData appendData: [[[[NSString stringWithFormat:@"admin_email=%@",strLoginT]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            NSMutableURLRequest *urlRequest;
            urlRequest = [[NSMutableURLRequest alloc] init];
            [urlRequest setURL:[NSURL URLWithString:strForgetPassword]];
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [urlRequest setHTTPBody:postData];
            [urlRequest setTimeoutInterval:kTimeOutInterval];

            connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==101)
    {
        if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
        {
            DisplayNoInternate;
            return;
        }
        else
        {
            if(buttonIndex==1)
            {
                if ([[tfForgotPass.text removeNull] isEqualToString:@""])
                {
                    DisplayAlert(@"Please enter email");
                    return;
                }
                else
                {
                    action = @"ForgetPassword";
                    
                    [[AppDelegate sharedInstance]showLoader];
                    
                    NSMutableData *postData = [NSMutableData data];
                    [postData appendData: [[[[NSString stringWithFormat:@"admin_email=%@",tfForgotPass.text]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
                    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
                    NSMutableURLRequest *urlRequest;
                    urlRequest = [[NSMutableURLRequest alloc] init];
                    [urlRequest setURL:[NSURL URLWithString:strForgetPassword]];
                    [urlRequest setHTTPMethod:@"POST"];
                    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
                    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                    [urlRequest setHTTPBody:postData];
                    [urlRequest setTimeoutInterval:kTimeOutInterval];

                    connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
                    tfForgotPass.text=@"";
                }
            }
        }
    }
    else if(alertView.tag==102)
    {
        isSignUpClicked=YES;
        isSignUpFromFacebook=NO;
        [logintextField becomeFirstResponder];
    }
    else if(alertView.tag==103)
    {
        isSignUpClicked=YES;
        isSignUpFromFacebook=YES;
        [logintextField becomeFirstResponder];
    }
}

-(BOOL)validEmail:(NSString*) emailString
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];

    return (regExMatches == 0)?NO:YES;
}

-(IBAction)signUpController:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome! You're almost there. Just enter your email & password to get started." message:nil delegate:self cancelButtonTitle:@"Join" otherButtonTitles:nil];
    alert.tag=102;
    [alert show];
}

#pragma mark - WS METHODS
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
    NSLog(@"hhhh %@",strData);
    [self _stopReceiveWithStatus:strData];
}
-(void)_stopReceiveWithStatus:(NSString *)statusString{    
    [self _receiveDidStopWithStatus:statusString];
}
-(void)_receiveDidStopWithStatus:(NSString *)statusString
{
    self.view.userInteractionEnabled = YES;
    [activity stopAnimating];
    viewAllBtn.hidden=NO;
    activity.hidden=YES;
    lblSignIN.hidden=YES;
    
    [[AppDelegate sharedInstance]hideLoader];
    
    if( [statusString isEqual:@"Connection failed"] || statusString == nil)
    {
        viewAllBtn.hidden=NO;
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
- (IBAction)btnSignInWithFacebookClicked:(id)sender
{
    viewtutorial.alpha=0.0;
    
    [AppDelegate sharedInstance].facebook = [[Facebook alloc] initWithAppId:kFacebookApp_ID andDelegate:self];
    if (![[AppDelegate sharedInstance].facebook isSessionValid]) {
        [[AppDelegate sharedInstance].facebook authorize:nil];
    }
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
-(void)setData:(NSMutableDictionary*)dictionary
{
    if (dictionary ==(id) [NSNull null])
    {
        return;
    }
    
    if ([action isEqualToString:@"ForgetPassword"])
    {
        action = @"";
        NSString *strMSG =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"MESSAGE"] removeNull]] ;
        if ([strMSG isEqualToString:@""])
        {
            return;
        }
        if ([strMSG isEqualToString:@"MAIL HAS BEEN SENT"]) 
        {
            DisplayAlertWithTitle(@"Note", @"Password has been sent to your email ID.");
            return;
        }
        else
        {
            DisplayAlertWithTitle(@"Note",strMSG);
            return;
        }
    }
    if ([action isEqualToString:@"FBLogin"])
    {
        action = @"FBSignUp";
        [dictFacebook removeAllObjects];
        [dictFacebook addEntriesFromDictionary:dictionary];
    if ([dictionary objectForKey:@"SignUP"])
        {
            [dictFacebook setObject:[dictionary objectForKey:@"SignUP"] forKey:@"SignUP"];
        }

            //birthday = "06/17/1989";

        NSString *strBDate=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"birthday"]];
        
        if ([[strBDate removeNull] length]==10)
        {
            NSDateFormatter *dateFormatterTemp=[[NSDateFormatter alloc]init];
            [dateFormatterTemp setDateFormat:@"MM/dd/yyyy"];
            
            lblBDate.text=[dateFormatterBD stringFromDate:[dateFormatterTemp dateFromString:[strBDate removeNull]]];
        }
        else
        {
            lblBDate.text=[dateFormatterBD stringFromDate:datePickerBD.date];
        }
        
        viewBirtdayConfirm.alpha=1.0;
        
        
        /*
         {
         birthday = "06/17/1989";
         email = "vijay@openxcell.info";
         "first_name" = Vijay;
         gender = male;
         id = 100004909328124;
         "last_name" = OpenXcell;
         location =     {
         id = 115440481803904;
         name = "Ahmedabad, India";
         };
         name = "Vijay OpenXcell";
         picture =     {
         data =         {
         "is_silhouette" = 0;
         url = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash1/371914_100004909328124_448895503_q.jpg";
         };
         };
         username = "vijay.openxcell";
         }
         */
        /*
         55) Facebook Login
         
         URL :
         
         http://www.suvi.me/suvi/ws/index.php?c=admin&func=facebookLogin&iFBID=111000111000&admin_email=patel1011@gmail.cod&dDOB=2000-11-10&school=DP%20High&admin_fname=krupal1234&admin_lname=Patel1234&eGender=Male&facebook_token=12321323213131313131212321313131313&vCustomLocation=ahmedabad,gujarat
         
         Request : c(admin) ,func (facebookLogin), iFBID , admin_email,dDOB , school , admin_fname , admin_lname ,  eGender,  facebook_token ,  vCustomLocation
         */
        
            }
    else if ([action isEqualToString:@"FBSignUp"])
    {
        viewBirtdayConfirm.alpha=0.0;

        action = @"";
        NSString *strMSG =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"MESSAGE"] removeNull]] ;
        
        if ([strMSG isEqualToString:@""])
        {
            return;
        }
        if ([strMSG isEqualToString:@"FACEBOOK_LOGIN_SUCCESS"])
        {
            FlagView1=1;
            if (AddViewFlag==50)
            {
                AddViewFlag=50000;
            }
            
            if ([dictionary objectForKey:@"SignUP"])
            {
                if ([[dictionary objectForKey:@"SignUP"] isEqualToString:@"SignUPFirstTime"])
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"SignUPFirstTime" forKey:@"SignUP"];
                }
            }

            [[NSUserDefaults standardUserDefaults]setObject:[dictionary valueForKey:@"USER_DETAIL"] forKey:@"USER_DETAIL"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            isUserLoggedIn=YES;
            self.navigationController.navigationBar.hidden=TRUE;
            self.leftController = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
            
            HomeViewController *centerControllerT = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            
            self.centerController = [[UINavigationController alloc] initWithRootViewController:centerControllerT];
            
            IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.centerController                           leftViewController:self.leftController                                                                                           rightViewController:nil];
            deckController.rightLedge = 50;
            deckController.leftLedge = 50;
            
            [self.navigationController pushViewController:deckController animated:YES];
        }
        else
        {
            DisplayAlertWithTitle(APP_Name,@"Please Enter Valid Username And Password");
            return;
        }
    }
    else if ([action isEqualToString:@"login"])
    {
        action = @"";
        NSString *strMSG =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"MESSAGE"] removeNull]] ;

        if ([strMSG isEqualToString:@""])
        {
            return;
        }
        if ([strMSG isEqualToString:@"Login successfully"]) 
        {
            FlagView1=1;
            if (AddViewFlag==50)
            {
                AddViewFlag=50000;
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",passwordField.text] forKey:@"admin_pwd"];
            [[NSUserDefaults standardUserDefaults]setObject:[dictionary valueForKey:@"USER_DETAIL"] forKey:@"USER_DETAIL"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
//            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",passwordField.text] forKey:@"admin_pwd"];
//            NSMutableDictionary *dictUserData=[[NSMutableDictionary alloc]initWithDictionary:[dictionary valueForKey:@"USER_DETAIL"]];
//            [dictUserData setObject:@"901" forKey:@"admin_id"];
//            [[NSUserDefaults standardUserDefaults]setObject:dictUserData forKey:@"USER_DETAIL"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            
            isUserLoggedIn=YES;
            self.navigationController.navigationBar.hidden=TRUE;
            self.leftController = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];

            HomeViewController *centerControllerT = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            
            self.centerController = [[UINavigationController alloc] initWithRootViewController:centerControllerT];
            
            IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.centerController                           leftViewController:self.leftController                                                                                           rightViewController:nil];
            deckController.rightLedge = 50;
            deckController.leftLedge = 50;
            
            [self.navigationController pushViewController:deckController animated:YES];
        }
        else
        {
            DisplayAlertWithTitle(APP_Name,@"Please Enter Valid Username And Password");
            return;
        }
    }
}

-(IBAction)btnConfirmFBBirthdayClicked:(id)sender
{
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-13];
        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [comps setYear:-22];
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        NSDate *myBD=[dateFormatterBD dateFromString:lblBDate.text];
        NSTimeInterval maxti=[maxDate timeIntervalSince1970]+(60.0*60.0*24.0);
        NSTimeInterval minti=[minDate timeIntervalSince1970]-(60.0*60.0*24.0);
        NSTimeInterval curti=[myBD timeIntervalSince1970];
    
        NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    
        NSString *strDOB=[NSString stringWithFormat:@"%@",[dateFormatter2 stringFromDate:myBD]];
   
        if (curti<minti || curti>maxti)
        {
            DisplayAlert(@"Please confirm valid birthdate between age 13-22.");
            return;
        }
        else
            {
            NSString *strFBId=[NSString stringWithFormat:@"%@",[dictFacebook objectForKey:@"id"]];
            NSString *strFBToken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"]];
            NSString *strFirstName=[NSString stringWithFormat:@"%@",[dictFacebook objectForKey:@"first_name"]];
            NSString *strLastName=[NSString stringWithFormat:@"%@",[dictFacebook objectForKey:@"last_name"]];
            NSString *strEmail=[NSString stringWithFormat:@"%@",[dictFacebook objectForKey:@"email"]];
            
            //            NSString *strDOB=[NSString stringWithFormat:@"%@",[dateFormatter2 stringFromDate:myBD]];
            NSString *strGender=[NSString stringWithFormat:@"%@",([[dictFacebook objectForKey:@"gender"] isEqualToString:@"male"])?@"Male":@"Female"];
            NSString *strLocation;
            NSString *strSchool;
            NSString *strPP;
            NSString *strCP;
            
            if ([dictFacebook objectForKey:@"SignUP"])
                {
                if ([[dictFacebook objectForKey:@"SignUP"] isEqualToString:@"SignUPFirstTime"])
                    {
                    [[NSUserDefaults standardUserDefaults] setObject:@"SignUPFirstTime" forKey:@"SignUP"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    }
            }
            
            
            if ([dictFacebook objectForKey:@"location"])
                {
                if ([[dictFacebook objectForKey:@"location"] objectForKey:@"name"])
                    {
                    strLocation=[NSString stringWithFormat:@"%@",[[dictFacebook objectForKey:@"location"] objectForKey:@"name"]];
                    }
                }
            
            
            if ([dictFacebook objectForKey:@"education"])
                {
                @try {
                    if ([[dictFacebook objectForKey:@"education"] count]>0)
                        {
                        strSchool=[NSString stringWithFormat:@"%@",[[[[dictFacebook objectForKey:@"education"] lastObject] objectForKey:@"school"] objectForKey:@"name"]];
                        }
                }
                @catch (NSException *exception)
                    {
                    
                    }
                @finally {
                    
                }
                }
            
            if ([dictFacebook objectForKey:@"picture"])
                {
                @try {
                    if ([[dictFacebook objectForKey:@"picture"] objectForKey:@"data"])
                        {
                        if ([[[[dictFacebook objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"is_silhouette"] integerValue]==0)
                            {
                            strPP=[NSString stringWithFormat:@"%@",[[[[dictFacebook objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"_q.jpg" withString:@"_b.jpg"]];
                            }
                        }
                }
                @catch (NSException *exception)
                    {
                    
                    }
                @finally {
                    
                }
                }
            
            if ([dictFacebook objectForKey:@"cover"])
                {
                @try {
                    if ([[dictFacebook objectForKey:@"cover"] objectForKey:@"source"])
                        {
                        strCP=[NSString stringWithFormat:@"%@",[[dictFacebook objectForKey:@"cover"] objectForKey:@"source"]];
                        }
                }
                @catch (NSException *exception)
                    {
                    
                    }
                @finally {
                    
                }
                }
            
            /*
             {
             birthday = "06/17/1989";
             email = "vijay@openxcell.info";
             "first_name" = Vijay;
             gender = male;
             id = 100004909328124;
             "last_name" = OpenXcell;
             location =     {
             id = 115440481803904;
             name = "Ahmedabad, India";
             };
             name = "Vijay OpenXcell";
             picture =     {
             data =         {
             "is_silhouette" = 0;
             url = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash1/371914_100004909328124_448895503_q.jpg";
             };
             };
             username = "vijay.openxcell";
             }
             */
            /*
             55) Facebook Login
             
             URL :
             
             http://www.suvi.me/suvi/ws/index.php?c=admin&func=facebookLogin&iFBID=111000111000&admin_email=patel1011@gmail.cod&dDOB=2000-11-10&school=DP%20High&admin_fname=krupal1234&admin_lname=Patel1234&eGender=Male&facebook_token=12321323213131313131212321313131313&vCustomLocation=ahmedabad,gujarat
             
             Request : c(admin) ,func (facebookLogin), iFBID , admin_email,dDOB , school , admin_fname , admin_lname ,  eGender,  facebook_token ,  vCustomLocation
             */
            
            
            [[AppDelegate sharedInstance]showLoader];
            
//            NSMutableDictionary *dictPostParameters=[[NSMutableDictionary alloc]init];
//            [dictPostParameters setObject:[strFBId removeNull] forKey:@"iFBID"];
//            [dictPostParameters setObject:[strEmail removeNull] forKey:@"admin_email"];
//            [dictPostParameters setObject:strDOB forKey:@"dDOB"];
//            [dictPostParameters setObject:[strFirstName  removeNull] forKey:@"admin_fname"];
//            [dictPostParameters setObject:[strLastName  removeNull] forKey:@"admin_lname"];
//            [dictPostParameters setObject:[strGender removeNull] forKey:@"eGender"];
//            [dictPostParameters setObject:[strFBToken removeNull] forKey:@"facebook_token"];
//            [dictPostParameters setObject:[strLocation removeNull] forKey:@"vCustomLocation"];
                
                
                 NSMutableDictionary *dictPostParameters=[[NSMutableDictionary alloc]init];
                 [dictPostParameters setObject:[strFBId removeNull] forKey:@"iFBID"];
                 [dictPostParameters setObject:([[strEmail removeNull] length]>0)?[strEmail removeNull]:@" " forKey:@"admin_email"];
                 [dictPostParameters setObject:([[strDOB removeNull] length]>0)?[strDOB removeNull]:@" " forKey:@"dDOB"];
                 [dictPostParameters setObject:([[strFirstName removeNull] length]>0)?[strFirstName removeNull]:@" " forKey:@"admin_fname"];
                 [dictPostParameters setObject:([[strLastName removeNull] length]>0)?[strLastName removeNull]:@" " forKey:@"admin_lname"];
                 [dictPostParameters setObject:([[strGender removeNull] length]>0)?[strGender removeNull]:@" " forKey:@"eGender"];
                 [dictPostParameters setObject:[strFBToken removeNull] forKey:@"facebook_token"];
                 [dictPostParameters setObject:([[strLocation removeNull] length]>0)?[strLocation removeNull]:@" " forKey:@"vCustomLocation"];
            
            if ([[strSchool removeNull] length]!=0)
                {
                [dictPostParameters setObject:[strSchool removeNull] forKey:@"school"];
                }
            
            if ([[strPP removeNull] length]!=0)
                {
                [dictPostParameters setObject:[strPP removeNull] forKey:@"vProfilePicName"];
                }
            
            if ([[strCP removeNull] length]!=0)
                {
                [dictPostParameters setObject:[strCP removeNull] forKey:@"coverPic"];
                }
            
            NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
            
            [postRequest setURL:[NSURL URLWithString:[NSString stringWithString:[@"http://www.suvi.me/suvi/ws/index.php?c=admin&func=facebookLogin" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
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
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [postRequest setHTTPBody:body];
            [postRequest setTimeoutInterval:kTimeOutInterval];
            
            
            connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
    }
}

-(IBAction)dateChanged:(id)sender
{
    lblBDate.text=[dateFormatterBD stringFromDate:datePickerBD.date];
}

#pragma mark - TEXT-FIELD DELEGATES
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!IS_DEVICE_iPHONE_5) {
        if ((textField == logintextField) || (textField == passwordField))
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.2];
            [self.view setFrame:CGRectMake(0,(isSignUpClicked)?-20:-60, 320, 460)];
            [UIView commitAnimations];
        }
    }
    else
    {
        if (isSignUpClicked) {
            if ((textField == logintextField) || (textField == passwordField))
            {
                btnLogin.alpha=0.0;
            }
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!IS_DEVICE_iPHONE_5)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.2];
        [self.view setFrame:CGRectMake(0, 0, 320, 460)];
        [UIView commitAnimations];
    }
    else
    {
        if (isSignUpClicked) {
            if ((textField == logintextField) || (textField == passwordField))
            {
                btnLogin.alpha=1.0;
            }
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    
        if (isSignUpClicked)
        {
            if ([[logintextField.text removeNull] isEqualToString:@""])
            {
                DisplayAlert(@"Please enter email.");
            }
            else if (![self validEmail:[logintextField.text removeNull]])
            {
                DisplayAlert(@"Enter valid email.");
            }
            else if ([[passwordField.text removeNull] isEqualToString:@""])
            {
                DisplayAlert(@"Please enter password.");
            }
            else
            {
                if (isSignUpFromFacebook)
                {
                    fbGraph = [[FbGraph alloc] initWithFbClientID:kFacebookApp_ID];
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
                else
                {
                    SignUpViewController *controller=[[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
                    isSignUpClicked=NO;
                    controller.strsEmail=[NSString stringWithFormat:@"%@",[logintextField.text removeNull]];
                    controller.strsPassword=[NSString stringWithFormat:@"%@",[passwordField.text removeNull]];
                    [self.navigationController pushViewController:controller animated:YES];
                    controller=nil;
                }
            }
        }
        else
        {
            if(textField == passwordField)
            {
                [self login];
            }
        }
    
	return TRUE;
}

#pragma mark - Extra Methods
-(void)viewDidUnload
{
    logintextField = nil;
    passwordField = nil;
    [super viewDidUnload];
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
-(void)didReceiveMemoryWarning{
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
