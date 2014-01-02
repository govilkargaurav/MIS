//
//  UserInfoViewController.m
//  NewsStand
//
//  Created by openxcell technolabs on 4/23/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AppDelegate.h"
#import "SignInViewController.h"


@implementation UserInfoViewController
@synthesize btnConnect;
@synthesize btnSubscribe;
@synthesize btnCancel;
@synthesize popSignIn;

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveSubscribe) name:@"removeSubscribe" object:nil];

}

-(NSString *)StringNotNullValidation:(NSString *)stringIp
{
    if(stringIp == nil)
    {
        return @"";
    }
    else if(stringIp == (id)[NSNull null] || [stringIp caseInsensitiveCompare:@"(null)"] == NSOrderedSame || [stringIp caseInsensitiveCompare:@"<null>"] == NSOrderedSame || [stringIp caseInsensitiveCompare:@""] == NSOrderedSame || [stringIp caseInsensitiveCompare:@"<nil>"] == NSOrderedSame || [stringIp length]==0)
    {
        return @"";
    }
    else
    {
        return [stringIp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]);
    
    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"isSubscribed"] isEqualToString:@"true"] || [[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"eTrialFlag"] isEqualToString:@"true"])
    {
        btnSubscribe.hidden = YES;

        if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]valueForKey:@"iUserID"]isEqualToString:@"0"] )
        {
            [btnConnect setTitle:@"Sign Out" forState:UIControlStateNormal];
            btnChangePassword.hidden = NO;

            if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"vType"] isEqualToString:@"Print"])
            {
                btnChangePassword.hidden = YES;
                btnCancel.frame = CGRectMake(8, 127, 251, 45);
            }
            else
            {
                //btnSubscribe.frame = CGRectMake(8, 127, 251, 45);
                btnChangePassword.frame = CGRectMake(8, 127, 251, 45);
                btnCancel.frame = CGRectMake(8, 180, 251, 45);
            }
        }
        else
        {
            [btnConnect setTitle:@"Sign In" forState:UIControlStateNormal];
            btnChangePassword.hidden = YES;
            //btnSubscribe.frame = CGRectMake(8, 127, 251, 45);
            btnCancel.frame = CGRectMake(8, 127, 251, 45);
        }
    }
    else
    {
            if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]valueForKey:@"iUserID"]isEqualToString:@"0"] )
            {
                [btnConnect setTitle:@"Sign Out" forState:UIControlStateNormal];
                btnChangePassword.hidden = NO;
                if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"vType"] isEqualToString:@"Print"])
                {
                    btnSubscribe.hidden = YES;
                    btnChangePassword.hidden = YES;
                    btnCancel.frame = CGRectMake(8, 127, 251, 45);
                }
                else
                {
                    btnSubscribe.hidden = NO;
                    btnSubscribe.frame = CGRectMake(8, 127, 251, 45);
                    btnChangePassword.frame = CGRectMake(8, 180, 251, 45);
                    btnCancel.frame = CGRectMake(8, 233, 251, 45);
                }
            }
            else
            {
                btnSubscribe.hidden = YES;
                [btnConnect setTitle:@"Sign In" forState:UIControlStateNormal];
                btnChangePassword.hidden = YES;
                //btnSubscribe.frame = CGRectMake(8, 127, 251, 45);
                btnCancel.frame = CGRectMake(8, 127, 251, 45);
            }
    }
    
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateSelected = [dateForm dateFromString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]valueForKey:@"dEndDate"]];
    [dateForm setDateFormat:@"LLLL-dd-yyyy"];
    NSString* strYourName = @"Your";
    
    NSString* stringDateValidity = [self StringNotNullValidation:[dateForm stringFromDate:dateSelected]];
    
    
    if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]valueForKey:@"iUserID"]isEqualToString:@"0"] )
    {
        strYourName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]valueForKey:@"vFirstName"];
        
        if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"isSubscribed"] isEqualToString:@"true"])
        {
            lblUntilValid.text = [NSString stringWithFormat:@"%@, your subscription is valid until\n%@",strYourName,[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"dEndDate"]];
        }
        else if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"eTrialFlag"] isEqualToString:@"true"])//
        {
            lblUntilValid.text = [NSString stringWithFormat:@"%@, your free trail is valid until\n%@",strYourName,stringDateValidity];
        }
        else if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"eTrialFlag"] isEqualToString:@"false"] && [[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"isSubscribed"] isEqualToString:@"false"])//
        {
            NSString *strMessage;
            if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"vType"] isEqualToString:@"Print"])
            {
                strMessage = @"your print subscription is inactive\n";
            }
            else
            {
                strMessage = @"your trial has expired, Please subscribe\n";
            }
            lblUntilValid.text = [NSString stringWithFormat:@"%@, %@",strYourName,strMessage];
        }
        else
        {
            lblUntilValid.text = [NSString stringWithFormat:@"%@, your trial has expired, Please subscribe\n",strYourName];
        }
    }
    else
    {
        if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"isSubscribed"] isEqualToString:@"true"])
        {
            lblUntilValid.text = [NSString stringWithFormat:@"Your subscription is valid until\n%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"dEndDate"]];
        }
        else if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"eTrialFlag"] isEqualToString:@"true"])//
        {
            lblUntilValid.text = [NSString stringWithFormat:@"Your free trail is valid until\n%@",stringDateValidity];
        }
        else if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"eTrialFlag"] isEqualToString:@"false"] && [[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"isSubscribed"] isEqualToString:@"false"])//
        {
            NSString *strMessage;
            if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"vType"] isEqualToString:@"Print"])
            {
                strMessage = @"Your print subscription is inactive\n";
            }
            else
            {
                strMessage = @"Your trial has expired, Please subscribe\n";
            }
            lblUntilValid.text = [NSString stringWithFormat:@"%@",strMessage];
        }
        else
        {
            lblUntilValid.text = @"Your trial has expired, Please subscribe\n";
        }
    }
    
    //Login Alert
    alertLogin = [[UIAlertView alloc] initWithTitle:App_Name message:@"\n\n\n"delegate:self cancelButtonTitle:@"Cancel"otherButtonTitles:@"Ok",nil];
    alertLogin.tag = 2;
    txtUserName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)];  
    [txtUserName setBackgroundColor:[UIColor whiteColor]]; 
    [txtUserName setPlaceholder:@"username"]; 
    [alertLogin addSubview:txtUserName];

    txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)];
    [txtPassword setBackgroundColor:[UIColor whiteColor]]; 
    [txtPassword setPlaceholder:@"password"]; 
    [txtPassword setSecureTextEntry:YES]; 
    [alertLogin addSubview:txtPassword];
    
    //Subscription Alert
    alertSubscription=[[UIAlertView alloc]initWithTitle:App_Name message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"2 months",@"6 months", nil];
    
    if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"]isEqualToString:@"0"])
    {
        [btnConnect setImage:[UIImage imageNamed:@"SignOut.png"] forState:UIControlStateNormal];
    }
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Button Action Methods

-(IBAction)btnChangePasswordPressed:(id)sender
{
    if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"]isEqualToString:@"0"])
    {
        if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"vType"] isEqualToString:@"Print"])
        {
            DisplayAlertWithTitle(App_Name, @"You are login with print subscribers.");
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change password" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
            alert.tag=1;
            alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            
            [alert textFieldAtIndex:0].placeholder = @"Old password";
            [alert textFieldAtIndex:1].placeholder = @"New password";
            
            [alert textFieldAtIndex:0].delegate=self;
            
            [alert textFieldAtIndex:0].secureTextEntry = YES;
            [alert textFieldAtIndex:1].secureTextEntry = YES;
            
            [alert textFieldAtIndex:0].font=[UIFont systemFontOfSize:14.0f];
            [alert textFieldAtIndex:1].font=[UIFont systemFontOfSize:14.0f];
            
            [[alert textFieldAtIndex:0] becomeFirstResponder];
            [alert show];
        }
    }
    else
    {
        DisplayAlertWithTitle(App_Name, @"Please login first to change password.");
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            [AppDel doshowHUD];
            NSString *str_DeviceToken = [NSString stringWithFormat:@"%@c=user&func=userChangePassword&iUserID=%@&vOPassword=%@&vNPassword=%@",WebURL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"],[alertView textFieldAtIndex:0].text,[alertView textFieldAtIndex:1].text];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str_DeviceToken stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
             {
                 if (error)
                 {
                     DisplayAlertWithTitle(App_Name, [error localizedDescription]);
                     return;
                 }
                 else
                 {
                     NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
                     NSString *strMsg = [dicResult valueForKey:@"msg"];
                     if ([strMsg isEqualToString:@"SUCCESS"])
                     {
                         DisplayAlertWithTitle(App_Name, @"Password changed successfully.");
                     }
                     else if ([strMsg isEqualToString:@"INCORECT OLD PASSWORD"])
                     {
                         DisplayAlertWithTitle(App_Name, @"Incorrect old password.");
                     }
                     else
                     {
                         DisplayAlertWithTitle(App_Name, strMsg);
                     }
                 }
                 
                 [AppDel dohideHUD];
             }];
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            if ([txtUserName.text isEqualToString:@""] || [txtPassword.text isEqualToString:@""])
                return;
            
            [AppDel doshowHUD];
            
            NSString *str_2 =[NSString stringWithFormat:@"%@c=user&func=login&email=%@&password=%@",WebURL,txtUserName.text,txtPassword.text];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str_2 stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
            
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
             {
                 if (error)
                 {
                     DisplayAlertWithTitle(App_Name, [error localizedDescription]);
                     [AppDel dohideHUD];
                     return;
                 }
                 else
                 {
                     NSError* err;
                     NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&err];
                     if ([[arr valueForKey:@"message"]isEqualToString:@"SUCCESS"])
                     {
                         DisplayAlert(@"SUCCESS");
                     }
                     else
                     {
                         DisplayAlert(@"Login Failed");
                     }
                     [AppDel dohideHUD];
                 }
             }];
        }
    }
}


-(void)RemoveSubscribe
{
    //[subVc.view setHidden:YES];
    if([AppDel.popOverSignInObj isPopoverVisible])
    {
        [AppDel.popOverSignInObj dismissPopoverAnimated:YES];
    }
    else if([AppDel.popOverSubscriptionObj isPopoverVisible])
    {
        [AppDel.popOverSubscriptionObj dismissPopoverAnimated:YES];
    }
    else if([AppDel.popOverUserObj isPopoverVisible])
    {
        [AppDel.popOverUserObj dismissPopoverAnimated:YES];
    }
}

#pragma mark - orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    NSUInteger orientations = UIInterfaceOrientationMaskAll;
    return orientations;
}

@end
