//
//  SettingViewController.m
//  FitTagApp
//
//  Created by apple on 2/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "TimeLineViewController.h"
#import "ProfileViewController.h"
#import "ActivityViewController.h"
#import <MessageUI/MessageUI.h>
#import "TagCustomCell.h"
#import "EditProfileViewController.h"
#import "SignUp3FindFriendViewController.h"
#import "NotificationSetViewController.h"
#import "ShareSettingViewController.h"
#import "HomeViewController.h"
#import "findInviteView.h"
#import "TermsAndConditionsViewController.h"
#import "AboutViewController.h"

@implementation SettingViewController
@synthesize tblSetting;
@synthesize isOpen,viewMenu;
NSMutableArray *mArySectionOne,*mArySectionTwo;

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

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //navigation back Button- Arrow
    UIButton *btnback=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnMenuSettingPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    [btnback setImage:[UIImage imageNamed:@"headerSetting"] forState:UIControlStateNormal];
    UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
    [view123 addSubview:btnback];
    
    UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn123.width=-16;
    UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
    self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
    
    
    // Do any additional setup after loading the view from its nib.
    mArySectionOne=[[NSMutableArray alloc]initWithObjects:@"Edit Profile",@"Share Settings",@"Find/Invite Friends",@"Push Notification Settings", nil];
    
    mArySectionTwo=[[NSMutableArray alloc]initWithObjects:@"About",@"Disclaimer",@"Privacy Policy",@"Terms & Condition Introduction",@"Feedback", nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidUnload
{
    [self setTblSetting:nil];
    [self setViewMenu:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Mark- TableView Delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;    //count of section
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return [mArySectionOne count];
            break;
        case 1:
            return [mArySectionTwo count];
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TagCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TagCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        [cell.btnAdd setHidden:YES];
        
    }
    
    switch (indexPath.section) {
        case 0:
            cell.lblTitle.text=[mArySectionOne objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.lblTitle.text=[mArySectionTwo objectAtIndex:indexPath.row];
            break;
        case 2:
            cell.lblTitle.text=@"Sign Out";
            
            break;
        default:
            break;
    }
    
    cell.lblTitle.font=[UIFont fontWithName:@"DynoBold" size:17];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    UILabel *lbltilte=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.bounds.size.width, 20)];
    
    [headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"categorydarkgraybg"]]];
    
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Account", @"Account");
            break;
        case 1:
            sectionName = NSLocalizedString(@"Misc", @"Misc");
            break;
        case 2:
            sectionName = NSLocalizedString(@"Sign Out", @"Sign Out");
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    lbltilte.text=sectionName;
    [lbltilte setBackgroundColor:[UIColor clearColor]];
    lbltilte.textColor=[UIColor whiteColor];
    lbltilte.font=[UIFont fontWithName:@"DynoRegular" size:16];
    [headerView addSubview:lbltilte];
    return headerView;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Account", @"Account");
            break;
        case 1:
            sectionName = NSLocalizedString(@"Misc", @"Misc");
            break;
        case 2:
            sectionName = NSLocalizedString(@"Sign Out", @"Sign Out");
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        
        
        switch (indexPath.row) {
            case 0:
            {
                EditProfileViewController *editProfileVC=[[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
                editProfileVC.title=@"Edit Profile";
                [self.navigationController pushViewController:editProfileVC animated:YES];
                
                
            }
                break;
            case 1:{
                ShareSettingViewController *shareVC=[[ShareSettingViewController alloc]initWithNibName:@"ShareSettingViewController" bundle:nil];
                shareVC.title=@"Share Settings";
                [self.navigationController pushViewController:shareVC animated:YES];
                
                
                
            }break;
            case 2:{
                //Find and Invite
                findInviteView *findandInviteVC=[[findInviteView alloc]initWithNibName:@"findInviteView" bundle:nil] ;
                findandInviteVC.title = @"Find/Invite";
                findandInviteVC.intInviteTag = 1;
                [self.navigationController pushViewController:findandInviteVC animated:YES];
                
            }break;
            case 3:{
                NotificationSetViewController *notiSetVC=[[NotificationSetViewController alloc]initWithNibName:@"NotificationSetViewController" bundle:nil];
                notiSetVC.title=@"Notification Settings";
                [self.navigationController pushViewController:notiSetVC animated:YES];
                
                
            }break;
            default:
                break;
        }
        
    }else if(indexPath.section==1){
        
        switch (indexPath.row) {
            case 0:{
                AboutViewController *aboutVC = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
                aboutVC.title = @"About";
                [self.navigationController pushViewController:aboutVC animated:YES];
                break;
            }
                
            case 1:
            {
                TermsAndConditionsViewController *objTemp=[[TermsAndConditionsViewController alloc]initWithNibName:@"TermsAndConditionsViewController" bundle:nil];
                objTemp.strSetting_Name=@"Disclaimer";
                objTemp.title=@"Disclaimer";
                [self.navigationController pushViewController:objTemp animated:TRUE];
            }
                break;
            case 3:{
                TermsAndConditionsViewController *objTemp=[[TermsAndConditionsViewController alloc]initWithNibName:@"TermsAndConditionsViewController" bundle:nil];
                objTemp.strSetting_Name=@"Terms & Condition Introduction";
                objTemp.title=@"Terms & Condition";
                [self.navigationController pushViewController:objTemp animated:TRUE];
                
            }break;
            case 2:{
                
                TermsAndConditionsViewController *objTemp=[[TermsAndConditionsViewController alloc]initWithNibName:@"TermsAndConditionsViewController" bundle:nil];
                objTemp.strSetting_Name=@"Privacy Policy";
                objTemp.title=@"Privacy Policy";
                [self.navigationController pushViewController:objTemp animated:TRUE];
                
            }break;
            case 4:{
                // Check that a mail account is available
                if ([MFMailComposeViewController canSendMail]) {
                    MFMailComposeViewController *emailController = [[MFMailComposeViewController alloc] init];
                    emailController.mailComposeDelegate = self;
                    NSString *subject=@"FeedBack";
                    NSString *mailBody=@"";
                    NSArray *recipients=[[NSArray alloc] initWithObjects:@"feedback@fittag.com", nil];
                    
                    [emailController setSubject:subject];
                    [emailController setMessageBody:mailBody isHTML:YES];
                    [emailController setToRecipients:recipients];
                    
                    [self presentViewController:emailController animated:TRUE completion:nil];
                    
                }
                // Show error if no mail account is active
                else {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You must have a mail account in order to send an email" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
                    [alertView show];
                    
                }
                
            }break;
            default:
                break;
        }
        
    }
    
    
    if (indexPath.section==2) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Sign out" message:@"Are you sure want to sign out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        [alert setTag:10];
        alert.delegate=self;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 10){
        if(buttonIndex == 1){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            isLogedOut = YES;
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation removeObjectForKey:@"owner"];
            currentInstallation.badge = 0;
            [currentInstallation saveInBackground];
            // Remove user setting for PFIntallation class for not get push notification
            
            [[PFUser currentUser] setObject:@"NO" forKey:@"likeNotification"];
            [[PFUser currentUser] setObject:@"NO" forKey:@"mentionNotification"];
            [[PFUser currentUser] setObject:@"NO" forKey:@"commentNotification"];
            [[PFUser currentUser] setObject:@"NO" forKey:@"followNotification"];
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL xuccess, NSError *errorSave){
                if(!errorSave){
                    if([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]] && [PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]){
                        
                        [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL Success,NSError *unlinkError){
                            if(!unlinkError){
                                if(isLogedOut == YES){
                                    [self animationForLogout];
                                }
                            }else{
                                if(isLogedOut == YES){
                                    [self animationForLogout];
                                }
                            }
                        }];
                        
                        [PFTwitterUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL Success,NSError *unlinkError){
                            if(!unlinkError){
                                if(isLogedOut == YES){
                                    [self animationForLogout];
                                }
                            }else{
                                if(isLogedOut == YES){
                                    [self animationForLogout];
                                }
                            }
                        }];
                    }else if([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
                        [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL Success,NSError *unlinkError){
                            if(!unlinkError){
                                if(isLogedOut == YES){
                                    [self animationForLogout];
                                }
                            }else{
                                if(isLogedOut == YES){
                                    [self animationForLogout];
                                }
                            }
                        }];
                    }else if([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]){
                        //                        [PFTwitterUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL Success,NSError *unlinkError){
                        //                            if(!unlinkError){
                        //
                        //                            }else{
                        //                                if(isLogedOut == YES){
                        //                                    [self animationForLogout];
                        //                                }
                        //                            }
                        //                        }];
                        if(isLogedOut == YES){
                            [self animationForLogout];
                        }
                        
                    }else{
                        if(isLogedOut == YES){
                            [self animationForLogout];
                        }
                    }
                    
                }else{
                    // Error while saving info while log out
                }
            }];
            
        }else{
            
        }
    }
}

-(void)animationForLogout{
    
    dispatch_async(dispatch_get_main_queue(),^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        isLogedOut = NO;
        [PFUser logOut];
        self.title=@"";
        HomeViewController *homeVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        [UIView beginAnimations: @"Showinfo"context: nil];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        [self.navigationController pushViewController:homeVC animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setObject:@"0" forKey:@"isLogin"];
        [userdefault synchronize];
    });
}

#pragma mark-Mail Controller Delegate Method
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }
            
            break;
    }
    // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//Navigation Menu
-(IBAction)btnMenuSettingPressed:(id)sender{
    if (!isOpen) {
        
        [self viewMenuOpenAnim];
        
    }else{
        [self viewMenuCloseAnim];
    }
    
}
-(IBAction)btnHomePressed:(id)sender{
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         
                         self.viewMenu.frame = CGRectMake(0,-176, self.viewMenu.frame.size.width,176);
                         isOpen=NO;
                     } completion:^(BOOL finished) {
                         [self.viewMenu removeFromSuperview];
                         
                         NSArray *array = [self.navigationController viewControllers];
                         for(int i=0;i<array.count;i++){
                             if([[array objectAtIndex:i] isKindOfClass:[TimeLineViewController class]]){
                                 [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                 break;
                             }
                         }
                         
                         
                     }];
    
}



- (IBAction)btnActivityPressed:(id)sender {
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         
                         self.viewMenu.frame = CGRectMake(0,-176, self.viewMenu.frame.size.width,176);
                         isOpen=NO;
                     } completion:^(BOOL finished) {
                         [self.viewMenu removeFromSuperview];
                         bool isContain=NO;
                         NSArray *array = [self.navigationController viewControllers];
                         for(int i=0;i<array.count;i++){
                             if([[array objectAtIndex:i] isKindOfClass:[ActivityViewController class]]){
                                 [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                 isContain=YES;
                                 break;
                             }
                         }
                         if(!isContain){
                             ActivityViewController *activtyVC  =[[ActivityViewController alloc]initWithNibName:@"ActivityViewController" bundle:nil];
                             activtyVC.title=@"Activity";
                             [self.navigationController pushViewController:activtyVC animated:YES];
                         }
                         
                         
                     }];
    
}

-(IBAction)btnProfileAction:(id)sender{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.viewMenu.frame = CGRectMake(0,-176, self.viewMenu.frame.size.width,176);
                         isOpen=NO;
                     } completion:^(BOOL finished) {
                         [self.viewMenu removeFromSuperview];
                         bool isContain=NO;
                         NSArray *array = [self.navigationController viewControllers];
                         for(int i=0;i<array.count;i++){
                             if([[array objectAtIndex:i] isKindOfClass:[ProfileViewController class]]){
                                 [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                 isContain=YES;
                                 break;
                             }
                         }
                         if(!isContain){
                             ProfileViewController *profileVC=[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
                             profileVC.title=@"Profile";
                             [self.navigationController pushViewController:profileVC animated:YES];
                         }
                         
                     }];
    
}
-(void)viewMenuCloseAnim{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.viewMenu.frame = CGRectMake(0,-176, self.viewMenu.frame.size.width,176);
                         isOpen=NO;
                     } completion:^(BOOL finished) {
                         [self.viewMenu removeFromSuperview];
                     }];
}
-(void)viewMenuOpenAnim{
    [self.view addSubview:viewMenu];
    viewMenu.frame=CGRectMake(0, -176, self.viewMenu.frame.size.width, 176);
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.viewMenu.frame = CGRectMake(0,64, self.viewMenu.frame.size.width,176);
                         isOpen=YES;
                     } completion:^(BOOL finished) {
                     }];
}

@end
