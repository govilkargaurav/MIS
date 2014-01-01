//
//  SingUp1ViewConroller.m
//  FitTagApp
//
//  Created by apple on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SingUp1ViewConroller.h"
#import "SignUpStep2ViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TermsAndConditionsViewController.h"
@implementation SingUp1ViewConroller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [txtUserName setFont:[UIFont fontWithName:@"DynoRegular" size:14]];
    [txtEmail setFont:[UIFont fontWithName:@"DynoRegular" size:14]];
    
    // Do any additional setup after loading the view from its nib.
    //navigation back Button- Arrow
    UIButton *btnback=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnHeaderbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
    UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
    [view123 addSubview:btnback];
    
    UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn123.width=-16;
    UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
    self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];

}
-(void)viewDidUnload{
    
    txtUserName = nil;
    txtPassword = nil;
    txtConfirmPassword = nil;
    txtEmail = nil;
    [super viewDidUnload];
 
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - textfield delegate method

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)btnSignupDonePressed:(id)sender {
    
    if([txtUserName isFirstResponder])
        [txtUserName resignFirstResponder];
    else if([txtPassword isFirstResponder])
        [txtPassword resignFirstResponder];
    else if([txtConfirmPassword isFirstResponder])
        [txtConfirmPassword resignFirstResponder];
    else if([txtEmail isFirstResponder])
        [txtEmail resignFirstResponder];
    
    if ([self validation]){
        
        //Validation for password and confirm password
        if ([txtPassword.text isEqualToString:txtConfirmPassword.text]) {
            
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = @"Loading...";
            
            //Creat user class in database and set user name,password and email//
            PFUser *user = [PFUser user];
            user.username = [[txtUserName.text lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            user.password = txtPassword.text;
            user.email = txtEmail.text;
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *errorMsg) {
                if (!errorMsg){
                    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                    
                    //Save the Flag in UserDefault for Direct Login  
                    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                    [userdefault setObject:@"1" forKey:@"isLogin"];
                    [userdefault synchronize];
                    
                    // Push notification setting
                    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                    [currentInstallation setDeviceTokenFromData:_appdelegate.dataDeviceToken];
                    [currentInstallation addUniqueObject:[NSString stringWithFormat:@"user_%@",[[PFUser currentUser]objectId]] forKey:@"channels"];
                    [currentInstallation setObject:[PFUser currentUser] forKey:@"owner"];
                    [currentInstallation saveInBackground];
                    
                    // Setup the default setting for push notification
                    [[PFUser currentUser] setObject:@"YES" forKey:@"likeNotification"];
                    [[PFUser currentUser] setObject:@"YES" forKey:@"mentionNotification"];
                    [[PFUser currentUser] setObject:@"YES" forKey:@"commentNotification"];
                    [[PFUser currentUser] setObject:@"YES" forKey:@"followNotification"];
                    [[PFUser currentUser] saveInBackground];
                    
                    SignUpStep2ViewController *signUpStep2VC=[[SignUpStep2ViewController alloc]initWithNibName:@"SignUpStep2ViewController" bundle:nil];
                    signUpStep2VC.title = @"Step 2";
                    [self.navigationController pushViewController:signUpStep2VC animated:YES];
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                    DisplayAlertWithTitle(@"FitTag",[[errorMsg userInfo] objectForKey:@"error"])  
                }
            }];
        }else{
            DisplayAlertWithTitle(@"FitTag", @"Confirm password dose not match with password")
        }
    }
    
}

- (IBAction)btnFBSignUpPressed:(id)sender {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading...";
    /*
    
    [PFFacebookUtils logInWithPermissions:FB_PERMISSIONS block:^(PFUser *user, NSError *error){
        if (user){
            if(user.isNew){
                //Save the Flag in UserDefault for Direct Login
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault setObject:@"1" forKey:@"isLogin"];
                [userdefault synchronize];
                
                // After logging in with Facebook
                FBRequest *request = [FBRequest requestForMe];
                [request startWithCompletionHandler: ^(FBRequestConnection *connection,id result,NSError *error){
                    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc]init];
                    userDictionary = (NSMutableDictionary *)result;
                    
                    PFUser *fbUser = [PFUser currentUser];
                    
                    fbUser.username = [NSString stringWithFormat:@"%@ %@",[userDictionary objectForKey:@"first_name"],[userDictionary objectForKey:@"last_name"]];
                    
                    fbUser.email = [userDictionary objectForKey:@"email"];
                    
                    NSData *imgData = [ NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[userDictionary objectForKey:@"id"]]]];
                    [fbUser saveEventually];
                    
                    PFFile *imgFile = [PFFile fileWithName:@"Image.jpg" data:imgData];
                    
                    [imgFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                        
                        if (!error) {
                            
                            PFUser *user = [PFUser currentUser];
                            
                            [user setObject:imgFile forKey:@"userPhoto"];
                            [user setObject:[userDictionary objectForKey:@"id"] forKey:@"fbId"];
                            
                            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                
                                if (!error) {
                                    
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    
                                    SignUpStep2ViewController *signUpStep2VC=[[SignUpStep2ViewController alloc]initWithNibName:@"SignUpStep2ViewController" bundle:nil];
                                    signUpStep2VC.title=@"Step 2";
                                    [self.navigationController pushViewController:signUpStep2VC animated:YES];
                                    
                                    
                                }else{
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    
                                    DisplayAlertWithTitle(@"Login",@"There is some problem occure. please try again")
                                }
                            }];
                        }
                    }];
                    
                }];
                
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                SignUpStep2ViewController *signUpStep2VC=[[SignUpStep2ViewController alloc]initWithNibName:@"SignUpStep2ViewController" bundle:nil];
                signUpStep2VC.title=@"Step 2";
                [self.navigationController pushViewController:signUpStep2VC animated:YES];
            }
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            DisplayAlertWithTitle(@"Login",@"There is some problem occure. please try again")
        }
    }];*/
}

- (IBAction)btnTwitterSignUpPressed:(id)sender {
    [_appdelegate LoginTwitterUser];
}

-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Email Validation

-(BOOL) validateEmail: (NSString *) Email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:Email];
}

-(BOOL)validation{
    NSRange range = [[txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] rangeOfString:@" "];

    if ([[txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) {
        DisplayAlertWithTitle(@"FitTag", @"Please enter username")       
        return NO;

    }else if(range.length > 0){
    DisplayAlertWithTitle(@"FitTag", @"Space is not allowed in username.")
    return NO;
   
    }else if ([[txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) {
    DisplayAlertWithTitle(@"FitTag", @"Please enter password")
    return NO;
    }

    else if ([txtConfirmPassword.text isEqualToString:@""]) {
        DisplayAlertWithTitle(@"FitTag", @"Please enter confirm password")
        return NO;
    }
    else if ([[txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) {
        DisplayAlertWithTitle(@"FitTag", @"Please enter email")
        return NO;
    }
    else if([txtPassword.text length]<6){
        DisplayAlertWithTitle(@"FitTag", @"Please enter minimum six charactors password")
        return NO;
    }
    else if([txtConfirmPassword.text length]<6){
        DisplayAlertWithTitle(@"FitTag", @"Please enter minimum six charactors confirm password")
        return NO;
    }
    else if (![self validateEmail:txtEmail.text]){
        DisplayAlertWithTitle(@"FitTag", @"Please enter valid email address")
        return NO;
    }else if ([txtUserName.text length] > 12){
        DisplayAlertWithTitle(@"FitTag", @"User name should not exceed 12 Character")
        return NO;
    }
        return YES;
}
-(IBAction)btnDisclaimerPressed:(id)sender
{
    TermsAndConditionsViewController *objTemp=[[TermsAndConditionsViewController alloc]initWithNibName:@"TermsAndConditionsViewController" bundle:nil];
    objTemp.strSetting_Name=@"Disclaimer";
    objTemp.title=@"Disclaimer";
    [self.navigationController pushViewController:objTemp animated:TRUE];
}

-(IBAction)btnTermsPressed:(id)sender{
    TermsAndConditionsViewController *objTemp=[[TermsAndConditionsViewController alloc]initWithNibName:@"TermsAndConditionsViewController" bundle:nil];
    objTemp.strSetting_Name=@"Terms & Condition Introduction";
    objTemp.title=@"Terms & Condition";
    [self.navigationController pushViewController:objTemp animated:TRUE];
    
}
@end
