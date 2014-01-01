//
//  LoginViewController.m
//  FitTagApp
//
//  Created by apple on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.

#import "LoginViewController.h"
#import "TimeLineViewController.h"
#import "FacebookFriendList.h"
#import "TwitterFollowerList.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIViewController+MJPopupViewController.h"
@class FindChallengesViewConroller;
@implementation LoginViewController
@synthesize txtUserName;
@synthesize txtPassword;

static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;

//MBProgressHUD *HUD;
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
    _appdelagate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
#ifdef __IPHONE_7_0
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
      //  self.edgesForExtendedLayout=UIExtendedEdgeAll;
#endif
    
    
    [txtUserName setFont:[UIFont fontWithName:@"DynoRegular" size:14]];
    
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    
    //navigation back Button- Arrow
    UIButton *btnback = [UIButton buttonWithType:UIButtonTypeCustom];
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

-(void)viewWillAppear:(BOOL)animated{
    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
}

-(void)viewDidUnload{
    [self setTxtUserName:nil];
    [self setTxtUserName:nil];
    [self setTxtPassword:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==txtUserName) {
        [txtPassword becomeFirstResponder];
    }
    if (textField==txtPassword) {
        [txtPassword resignFirstResponder];
    }
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 1.0  *textFieldRect.size.height;
    CGFloat numerator =midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    animatedDistance = floor(162.0 * heightFraction);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

#pragma mark Button Actions

-(IBAction)btnDonePressed:(id)sender{
    
    if([self validation]){ 
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    [PFUser logInWithUsernameInBackground:txtUserName.text password:txtPassword.text block:^(PFUser *user, NSError *error) {
        if (user) {
            //Save the Flag in UserDefault for Direct Login
             NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:@"1" forKey:@"isLogin"];
            [userdefault synchronize];
            
            // Setup for push notification
            [self configurePushNotificationSetting];
            
            
           TimeLineViewController *timelineViewConroller=[[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
           // timelineViewConroller.title=@"TimeLine";
            
            [self.navigationController pushViewController:timelineViewConroller animated:YES];
            [MBProgressHUD hideHUDForView:self.view animated:TRUE];
            
        } else {
            DisplayLocalizedAlert(@"The username or password you entered is incorrect")
            [MBProgressHUD hideHUDForView:self.view  animated:TRUE];
        }
    }];
  }
}  

-(void)getAllUserName{
    PFQuery * query=[PFUser query];
    [query whereKey:@"username" equalTo:fbUserName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([objects count]>0) {
            ChangeUserNameViewController *obj=[[ChangeUserNameViewController alloc]initWithNibName:@"ChangeUserNameViewController" bundle:nil];
            obj.delegate=self;
            [self presentPopupViewController:obj animationType:MJPopupViewAnimationSlideBottomBottom];
            
        }
        else{
        
            TimeLineViewController *timelineViewConroller=[[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
            
            [self.navigationController pushViewController:timelineViewConroller animated:YES];
        }
       
        
            }];

}
-(void)userName :(NSString *)strUserName{
    
    PFQuery * query=[PFUser query];
    [query whereKey:@"username" equalTo:strUserName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count]==0) {
            PFUser *user=[PFUser currentUser];
            [user setObject:strUserName forKey:@"username"];
            [user save];
            
            TimeLineViewController *timelineViewConroller=[[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
            [self.navigationController pushViewController:timelineViewConroller animated:YES];
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
        }
        else{
        
            DisplayLocalizedAlert(@"This username is already taken");
        }
    
    }];
    
    

}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{

    if (buttonIndex==1) {
        
        
        NSRange range = [[txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] rangeOfString:@" "];
        
        if ([[txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) {
            //DisplayAlertWithTitle(@"FitTag", @"Please enter username")
           
            
            [alertView setMessage:@"Please enter username"];
        }else if(range.length > 0){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Fittaf" message:@"Space is not allowed in username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
            else if ([txtUserName.text length] > 12){
                [alertView setMessage:@"User name should not exceed 12 Character"];
                // DisplayAlertWithTitle(@"FitTag", @"User name should not exceed 12 Character")
        }
            else{
        
        
        
       
            }

    }else{
        DisplayLocalizedAlert(@"Please enter user name");
    }
}*/

- (IBAction)btnFBSigninPressed:(id)sender {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading...";
    
    [PFFacebookUtils logInWithPermissions:FB_PERMISSIONS block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error) {
                DisplayAlertWithTitle(@"FitTag", @"There is some porblem occur. Please try again")
            } else {
            }
        } else if (user.isNew) {
            [self configurePushNotificationSetting];
            
            //Save the Flag in UserDefault for Direct Login
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:@"1" forKey:@"isLogin"];
            [userdefault synchronize];

            // After logging in with Facebook
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler: ^(FBRequestConnection *connection,id result,NSError *error){
//                 = [[NSMutableDictionary alloc]init];
                NSMutableDictionary *userDictionary = (NSMutableDictionary *)result;
                
                PFUser *fbUser = [PFUser currentUser];
                fbUserName=[[[NSString stringWithFormat:@"%@%@",[userDictionary objectForKey:@"first_name"],[userDictionary objectForKey:@"last_name"]] stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                
                
                [self getAllUserName];
                fbUser.username = [[[NSString stringWithFormat:@"%@%@",[userDictionary objectForKey:@"first_name"],[userDictionary objectForKey:@"last_name"]] stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                
                
                PFQuery *queryForEmail = [PFUser query];
                [queryForEmail whereKey:@"email" equalTo:[userDictionary objectForKey:@"email"]];
                NSMutableArray *arrEmailUser = [[NSMutableArray alloc]initWithArray:[[queryForEmail findObjects] mutableCopy]];
                
                
                
                if([arrEmailUser count] == 0){
                    fbUser.email = [userDictionary objectForKey:@"email"];
                }else{
                    // same Email id is already exist do not add in the database
                }
                
                
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
                                
                               
                                
                            }else{
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                
                                DisplayAlertWithTitle(@"Login",@"There is some problem occure. please try again")
                            }
                        }];
                    }
                }];
            }];
            
        } else {
            [self configurePushNotificationSetting];
            //Save the Flag in UserDefault for Direct Login
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:@"1" forKey:@"isLogin"];
            [userdefault synchronize];

            [self configurePushNotificationSetting];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            TimeLineViewController *timelineViewConroller=[[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
            [self.navigationController pushViewController:timelineViewConroller animated:YES];
        }
        
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)saveFacebookData:(NSMutableDictionary *)userDict{
    
    PFUser *fbUser = [PFUser currentUser];
    
    fbUser.username = [NSString stringWithFormat:@"%@ %@",[userDict objectForKey:@"first_name"],[userDict objectForKey:@"last_name"]];
    
    fbUser.email = [userDict objectForKey:@"email"];
    
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[userDict objectForKey:@"id"]]]];
    
    PFFile *imgFile = [PFFile fileWithData:imgData];
    
    [fbUser setObject:imgFile forKey:@"userPhoto"];
    
    [fbUser saveInBackgroundWithBlock:^(BOOL yes,NSError *erroSave){
        
        if (!erroSave){
            //pushController from here
            TimeLineViewController *timelineViewConroller=[[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
            [self.navigationController pushViewController:timelineViewConroller animated:YES];
            
        }else{
            DisplayAlertWithTitle(@"FitTag",@"There is problem occur. Please try again");
        }
    }];
}

#pragma mark Push notification setting

-(void)configurePushNotificationSetting{
    // Save the current logged in user as owner for push notification
    // Push Notification setting for user
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:_appdelagate.dataDeviceToken];
    
    /*if([[currentInstallation objectForKey:@"channels"] count] > 0){
        [currentInstallation removeObjectForKey:@"channels"];
    }*/
    
    [currentInstallation addUniqueObject:[NSString stringWithFormat:@"user_%@",[[PFUser currentUser]objectId]] forKey:@"channels"];
    
    [currentInstallation setObject:[PFUser currentUser] forKey:@"owner"];
    [currentInstallation saveInBackground];
    
    [[PFUser currentUser] setObject:@"YES" forKey:@"likeNotification"];
    [[PFUser currentUser] setObject:@"YES" forKey:@"mentionNotification"];
    [[PFUser currentUser] setObject:@"YES" forKey:@"commentNotification"];
    [[PFUser currentUser] setObject:@"YES" forKey:@"followNotification"];
    [[PFUser currentUser] saveInBackground];
}

- (IBAction)btnTwitterSignInPressed:(id)sender {
    
 /*   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FitTag" message:@"OOPS ! Sorry for inconvenience. We are having some problems with twitter for now. We are working hard to solve the issue. We will get back to you soon." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];*/
    
    // Twitter Temporary block
    [_appdelagate LoginTwitterUser];
}

#pragma mark - PFLogInViewControllerDelegate

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    // After logging in with Facebook
    //    PF_FBRequest *request = [PF_FBRequest requestForMe];
    //    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection, 
    //                                          id result, 
    //                                          NSError *error) {
    //        if(!error){
    //            NSString *facebookUsername = [result objectForKey:@"username"];
    //            [PFUser currentUser].username = facebookUsername;
    //            [[PFUser currentUser] saveEventually];
    //        }
    //
    //    }];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)validation{
    if ([[txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        DisplayAlertWithTitle(@"FitTag", @"Please enter username")       
        return NO;
    }else if ([[txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        DisplayAlertWithTitle(@"FitTag",@"Please enter password")
        return NO;
    }else if([txtPassword.text length] < 6){
        DisplayAlertWithTitle(@"FitTag", @"Please enter minimum six charactors password")
        return NO;
    }
    return YES;
}

@end
