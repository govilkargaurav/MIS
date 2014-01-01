//
//  Login.m
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Login.h"
#import "AppConstat.h"
#import "BusyAgent.h"

@implementation Login
@synthesize strSetHideCancelbtn,strMessageTitle;
@synthesize fbGraph;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    if ([strSetHideCancelbtn isEqualToString:@"No"])
//    {
//        btnCancel.hidden=NO;
//    }
    lblMessage.text = [NSString stringWithFormat:@"%@",strMessageTitle];
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Dealloc
#pragma mark - IBAction Method
-(IBAction)CancelCliked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    if ([strSetHideCancelbtn isEqualToString:@"Yes"])
    {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushIt0" object:self];
    }
}

-(IBAction)LoginCliked:(id)sender
{
    [tfUsername resignFirstResponder];
    [tfPassword resignFirstResponder];
    
    if ([tfUsername.text length] == 0 || [tfPassword.text length] == 0 ) 
	{
        DisplayAlertWithTitle(APP_Name, @"Enter username and password");
	} 
	else 
    {
        [self CallURL:@"Normal"];
    }
}
-(void)CallURL:(NSString *)loginstr
{
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    responseData = [[NSMutableData alloc] init];
    results = [[NSMutableDictionary alloc] init];
    NSString *strLogin;
    if ([loginstr isEqualToString:@"Normal"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Normal" forKey:@"Type"];
        strLogin=[NSString stringWithFormat:@"%@webservices/login.php?vEmail=%@&vPassword=%@",APP_URL,tfUsername.text,tfPassword.text];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"FB" forKey:@"Type"];
        strLogin=[NSString stringWithFormat:@"%@webservices/fblogin.php?vEmail=%@&vFirst=%@&vLast=%@",APP_URL,[resultfb valueForKey:@"email"],[resultfb valueForKey:@"first_name"],[resultfb valueForKey:@"last_name"]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strLogin]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request delegate:self];
}
#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    DisplayNoInternate;

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    results = [responseString JSONValue];
    if ([[results valueForKey:@"msg"] isEqualToString:@"login successfull"])
    {
        NSUserDefaults *Info = [NSUserDefaults standardUserDefaults];
        [Info setValue:@"LoginValue" forKey:@"Login"];
        [Info setValue:[results valueForKey:@"iUserID"] forKey:@"iUserID"];
        [Info setValue:[results valueForKey:@"vEmail"] forKey:@"vEmail"];

        NSString *str=[results valueForKey:@"vFirst"];
        str=[str stringByAppendingFormat:@" %@",[results valueForKey:@"vLast"]];
        [Info setValue:str forKey:@"vFullName"]; 

        
        [self dismissModalViewControllerAnimated:YES];
	}
	else 
	{
        DisplayAlertWithTitle(APP_Name, @"Your Username or Password seems to be incorrectly entered, please check and re-enter.");
    }
}
-(IBAction)ForgotPasswordClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter your email address registered with myM8te, your password will be emailed to that address." message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    alert.tag=1;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"Email";
    [alert textFieldAtIndex:0].delegate=self;
    [alert textFieldAtIndex:0].font=[UIFont systemFontOfSize:14.0f];
    [[alert textFieldAtIndex:0] becomeFirstResponder];
   
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
        }
        else
        {
            FsenetAppDelegate *appdel = (FsenetAppDelegate *)[[UIApplication sharedApplication]delegate];
            if( ![appdel checkConnection] ) 
            {
                [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
                DisplayNoInternate;
            }
            else
            {
                [[alertView textFieldAtIndex:0] resignFirstResponder];
                NSString *strurl=[NSString stringWithFormat:@"%@webservices/forgotpassword.php?vEmail=%@",APP_URL,[alertView textFieldAtIndex:0].text];
                NSURL *myurl= [NSURL URLWithString:strurl];
                NSString *strres = [[NSString alloc] initWithContentsOfURL:myurl encoding:NSUTF8StringEncoding error:nil];
                NSDictionary *dic = [[NSDictionary alloc]init];
                dic = [strres JSONValue];
                DisplayAlertWithTitle(APP_Name, @"Your Password has been emailed to the registered email address.");
            }
        }   
    }
}
-(IBAction)FBLoginPressed:(id)sender
{
    NSString *client_id = @"126689434176418";
	
	//alloc and initalize our FbGraph instance
	fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
	
	//begin the authentication process.....
	[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins,email,user_about_me"];
}
#pragma mark -
#pragma mark FbGraph Callback Function
/**
 * This function is called by FbGraph after it's finished the authentication process
 **/
- (void)fbGraphCallback {
	
	if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) )
    {
		//restart the authentication process.....
		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins,email,user_about_me"];
	} 
    else
    {
        [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
        [self performSelectorInBackground:@selector(GetFBUserDetail) withObject:nil];
    }
}

-(void)GetFBUserDetail
{
    @autoreleasepool
    {
        NSString  *urlstring1 = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@",fbGraph.accessToken];
        NSURL *myurl= [NSURL URLWithString:urlstring1];
        NSString *str = [[NSString alloc] initWithContentsOfURL:myurl encoding:NSUTF8StringEncoding error:nil];
        resultfb=[str JSONValue];
        [fbGraph fbcancelcalled];
        [self performSelectorOnMainThread:@selector(GetFBUserDetailRedult) withObject:nil waitUntilDone:YES];
    }
}
-(void)GetFBUserDetailRedult
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    [self CallURL:@"FB"];
}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Extra Methods
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
