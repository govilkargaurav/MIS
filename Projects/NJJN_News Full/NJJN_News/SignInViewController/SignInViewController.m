//
//  SignInViewController.m
//  NewsStand
//
//  Created by openxcell technolabs on 5/2/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "SignInViewController.h"
#import "AppDelegate.h"
#import "SignUpViewController.h"
#import "GlobalMethods.h"

@implementation SignInViewController

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

-(void)CloseSingInBarButton
{
    if([AppDel.popOverSignInObj isPopoverVisible])
    {
        [AppDel.popOverSignInObj dismissPopoverAnimated:YES];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Sign In";
    
    UIBarButtonItem* barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CloseSingInBarButton)];
    
    self.navigationItem.rightBarButtonItem = barButtonCancel;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myKeyboardWillHideHandler:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self SetInsetToTextField:txtUserName];
    [self SetInsetToTextField:txtUserPassword];
    [self SetInsetToTextField:txtAccountNo];
    [self SetInsetToTextField:tfZipCode];
    self.contentSizeForViewInPopover = CGSizeMake(399, 510);
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)SetInsetToTextField:(UITextField*)tf
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    tf.leftView = paddingView;
    tf.leftViewMode = UITextFieldViewModeAlways;
}


#pragma mark - Button action method

-(IBAction)ClickBtnSignIn:(id)sender
{
    if ([txtUserName.text isEqualToString:@""] || [txtUserPassword.text isEqualToString:@""])
        return;
    
    [AppDel doshowHUD];
    
    NSString *str_2 =[NSString stringWithFormat:@"%@c=user&func=login&email=%@&password=%@&vDeviceToken=%@&vUdid=%@",WebURL,txtUserName.text,txtUserPassword.text,[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"],[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceUDID"]];
        
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str_2 stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
        
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error) 
    {
        if (error)
        {
            [AppDel dohideHUD];
            DisplayAlertWithTitle(App_Name, [error localizedDescription]);
            return;
        }
        else
        {
            NSError* err;
            NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&err];
             
            if ([[dictData valueForKey:@"message"]isEqualToString:@"SUCCESS"]) 
            {
                if([AppDel.popOverSignInObj isPopoverVisible])
                {
                    [AppDel.popOverSignInObj dismissPopoverAnimated:YES];
                }
                
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"])
                {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                [[NSUserDefaults standardUserDefaults] setObject:dictData forKey:@"UserInfo"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                NSString *streTrialFlag = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"eTrialFlag"]];
                NSString *strisSubscribed  = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"isSubscribed"]];
                NSString *strreceipt = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"receipt"]];
                NSString *striUserID = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"iUserID"]];
                
                if ([streTrialFlag isEqualToString:@"false"] && [strisSubscribed isEqualToString:@"false"] && [strreceipt length] > 0 && ![striUserID isEqualToString:@"0"])
                {
                    [GlobalMethods VerifyReceipt:strreceipt];
                }
                else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadPDFDataAgain" object:nil];
                }
                
                if([[dictData valueForKey:@"isSubscribed"] isEqualToString:@"true"])
                {
                    DisplayAlertWithTitle(App_Name, @"Your subscription has been activated!");
                }
            }
            else
            {
                [AppDel dohideHUD];
                DisplayAlert(@"Login Failed");
            }
        }
    }];
}

-(IBAction)ClickBtnForgotPassword:(id)sender
{
    if([AppDel.popOverSignInObj isPopoverVisible])
    {
        [AppDel.popOverSignInObj dismissPopoverAnimated:YES];
    }
    UIAlertView* alertForgotPwd = [[UIAlertView alloc] initWithTitle:App_Name message:@"Please enter your Email-Id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertForgotPwd setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertForgotPwd.tag = 1005;
    [alertForgotPwd show];
}

-(IBAction)ClickBtnSignUp:(id)sender
{
    SignUpViewController* objSignUp = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:objSignUp animated:YES];
}

-(IBAction)ClickBtnCancel:(id)sender
{
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"removeSignIn" object:nil];
}

-(IBAction)ClickBtnSubmit:(id)sender
{
    if ([txtAccountNo.text isEqualToString:@""] || [tfZipCode.text isEqualToString:@""])
        return;
    
    [AppDel doshowHUD];
    
    NSString *str_2 =[NSString stringWithFormat:@"%@c=user&func=AccountLogin&accountNumber=%@&zipcode=%@&vDeviceToken=%@",WebURL,txtAccountNo.text,tfZipCode.text,[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
    
    
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
                        
                 if([AppDel.popOverSignInObj isPopoverVisible])
                 {
                     [AppDel.popOverSignInObj dismissPopoverAnimated:YES];
                 }
                 if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"])
                 {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                 }
                 [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"UserInfo"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"loadPDFDataAgain" object:nil];
                 
                 if([[arr valueForKey:@"isSubscribed"] isEqualToString:@"true"])
                 {
                     DisplayAlertWithTitle(App_Name, @"Your subscription has been activated!");
                 }

             }
             else
             {
                 [AppDel dohideHUD];
                 DisplayAlertWithTitle(App_Name, @"Login Failed please try again!");
             }
             
             
         }
    }];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    scrlObj.contentSize = CGSizeMake(399, 510);
    [textField resignFirstResponder];
    return YES;
}


- (void) myKeyboardWillHideHandler:(NSNotification *)notification
{
    scrlObj.contentSize = CGSizeMake(399, 510);
}

- (void)myNotificationMethod:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        
    if(keyboardFrameBeginRect.size.height == 1024)
    {
        [scrlObj setContentOffset:CGPointMake(0, 0) animated:YES];
        scrlObj.contentSize = CGSizeMake(399, 700);
        if ([txtAccountNo isFirstResponder] ||[tfZipCode isFirstResponder] )
        {
            [scrlObj setContentOffset:CGPointMake(0, 195) animated:YES];
        }
    }
    else
    {
        [scrlObj setContentOffset:CGPointMake(0, 0) animated:YES];
        scrlObj.contentSize = CGSizeMake(399, 510);
    }

}


#pragma mark - Alert Deleagte

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1005)
    {
        if(buttonIndex == 1)
        {
            if ([[[alertView textFieldAtIndex:0].text StringNotNullValidation] isEqualToString:@""])
            {
                DisplayAlertWithTitle(App_Name, @"Please, enter your email id!");
            }
            else if ([[alertView textFieldAtIndex:0].text StringIsValidEmail] == NO)
            {
                DisplayAlertWithTitle(App_Name, @"Please, enter a valid email id!");
            }
            else
            {
                [AppDel doshowHUD];
                
                NSString *str_DeviceToken = [NSString stringWithFormat:@"%@c=user&func=forgotPassword&email=%@",WebURL,[alertView textFieldAtIndex:0].text];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str_DeviceToken stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
                
                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:[NSOperationQueue mainQueue]
                                       completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
                 {
                     [AppDel dohideHUD];
                     if (error)
                     {
                         DisplayAlertWithTitle(App_Name, [error localizedDescription]);
                         return;
                     }
                     else
                     {
                         NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
                         
                         NSString *strMsg = [dicResult valueForKey:@"message"];
                         
                         if ([strMsg isEqualToString:@"EMAIL NOT REGISTER"])
                         {
                             DisplayAlertWithTitle(App_Name, @"Email id not registered!");
                         }
                         else if ([strMsg isEqualToString:@"SUCCESS"])
                         {
                             DisplayAlertWithTitle(App_Name, @"Password has been sent to your email id!");
                             AppDel.tabBarController.tabBar.userInteractionEnabled=YES;
                         }
                         else
                         {
                             DisplayAlertWithTitle(App_Name, strMsg);
                         }
                     }
                 }];
            }
        }
    }
}



@end
