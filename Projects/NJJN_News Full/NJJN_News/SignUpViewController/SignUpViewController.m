//
//  SignUpViewController.m
//  NewsStand
//
//  Created by openxcell technolabs on 5/3/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"
#import "NSString+Valid.h"

@implementation SignUpViewController

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

-(void)CloseSingUpBarButton
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
    
    self.title = @"Sign Up";
    
    UIBarButtonItem* barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CloseSingUpBarButton)];
    
    self.navigationItem.rightBarButtonItem = barButtonCancel;
    
    // Do any additional setup after loading the view from its nib.
    txtPassword.text = @"";
    txtLastName.text = @"";
    txtFirstName.text = @"";
    txtEmail.text = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethodForSignUp:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myKeyboardWillHideHandlerForSignUp:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight
        ||self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        flagOrientation = 1;
    }
    else
    {
        flagOrientation = 0;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [scrlObj setContentOffset:CGPointMake(0, 0) animated:YES];
    self.contentSizeForViewInPopover = CGSizeMake(399, 510);
    [self updateui];
}

#pragma mark - Button action method
-(IBAction)ClickBtnSignUp:(id)sender
{
    [self TextFieldResign];
    
    if ([txtEmail.text isEqualToString:@""] || [txtPassword.text isEqualToString:@""] || [txtFirstName.text isEqualToString:@""] || [txtLastName.text isEqualToString:@""])
    {
        if ([txtEmail.text isEqualToString:@""])
        {
            DisplayAlertWithTitle(App_Name, @"Email Id is mandatory.");
        }
        else if ([txtPassword.text isEqualToString:@""])
        {
            DisplayAlertWithTitle(App_Name, @"Password is mandatory.");
        }
        else if ([txtFirstName.text isEqualToString:@""])
        {
            DisplayAlertWithTitle(App_Name, @"First Name is mandatory.");
        }
        else if ([txtLastName.text isEqualToString:@""])
        {
            DisplayAlertWithTitle(App_Name, @"Last Name is mandatory.");
        }
        
        return;
    }
    
    if ([txtEmail.text StringIsValidEmail] == NO)
    {
        DisplayAlertWithTitle(App_Name, @"Email id is not valid.");
        return;
    }
    else
    {
        [AppDel doshowHUD];
        
        NSString *str_2 = [NSString stringWithFormat:@"%@c=user&func=adduser&email=%@&password=%@&firstname=%@&lastname=%@&address1=%@&address2=%@&city=%@&state=%@&zipcode=%@&vTrailEndDate=%@&vDeviceToken=%@",WebURL,txtEmail.text,txtPassword.text,txtFirstName.text,txtLastName.text,@"",@"",@"",@"",@"",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]valueForKey:@"dEndDate"],[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str_2 stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
        
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
                 NSError* err;
                 NSDictionary *arr = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&err];
                 NSLog(@"-- %@", [[NSString alloc] initWithData:response
                                                        encoding:NSUTF8StringEncoding]);
                 
                 if ([[arr valueForKey:@"message"]isEqualToString:@"SUCCESS"])
                 {
                     DisplayAlertWithTitle(App_Name, @"You have successfully signed up. Please sign in.");
                     if([AppDel.popOverSignInObj isPopoverVisible])
                     {
                         [AppDel.popOverSignInObj dismissPopoverAnimated:YES];
                     }
                     txtPassword.text = @"";
                     txtLastName.text = @"";
                     txtFirstName.text = @"";
                     txtEmail.text = @"";
                     [scrlObj setContentOffset:CGPointMake(0, 0) animated:YES];
                 }
                 else
                 {
                     DisplayAlertWithTitle(App_Name, [arr valueForKey:@"message"]);
                 }
             }
             
             
         }];
    }

}

-(IBAction)ClickBtnCancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma TextFiled Resign
-(void)TextFieldResign
{
    for (id textField in self.view.subviews) {
        
        if ([textField isKindOfClass:[UITextField class]] && [textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
        else if ([textField isKindOfClass:[UITextView class]] && [textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
    }
}

#pragma mark - TextField Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   // scrlObj.contentSize = CGSizeMake(399, 510);
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}

#pragma mark - KeyPad Notification

- (void) myKeyboardWillHideHandlerForSignUp:(NSNotification *)notification
{
   // scrlObj.contentSize = CGSizeMake(399, 510);
}

- (void)myNotificationMethodForSignUp:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    if(keyboardFrameBeginRect.size.height == 1024)
    {
        [scrlObj setContentOffset:CGPointMake(0, 0) animated:YES];
       // scrlObj.contentSize = CGSizeMake(399, 700);
        [scrlObj setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
        [scrlObj setContentOffset:CGPointMake(0, 0) animated:YES];
       // scrlObj.contentSize = CGSizeMake(399, 510);
    }
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}




#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight
        ||interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        flagOrientation = 1;
    }
    else
    {
        flagOrientation = 0;
    }    
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

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateui];
}

-(void)updateui
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        flagOrientation = 0;
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        flagOrientation = 1;
    }
}


@end
