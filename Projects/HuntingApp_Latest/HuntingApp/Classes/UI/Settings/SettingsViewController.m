//
//  SettingsViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController (Private)

- (void)gotoEditProfileController;

- (void)customizeSegmentedControl;

@end

@implementation SettingsViewController

@synthesize userInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    userProfile = [[DAL sharedInstance] getProfileByID:[Utility userID]];
    NSLog(@"%@",userProfile.user_id);
    [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:userProfile.user_id];
    titleView = [[UIView alloc]initWithFrame:CGRectMake(100, 0, 120, 44)];
    [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 120, 44)] autorelease];
    [lbl setFont:[UIFont fontWithName:@"WOODCUT" size:18]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    [lbl setText:@"Setings"];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [titleView addSubview:lbl];
    [self customizeSegmentedControl];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:FIRST_VIEW] isEqualToString:@"0"])
        [segmentedControl setSelectedSegmentIndex:0];
    else {
        [segmentedControl setSelectedSegmentIndex:1];
    }
    [self segmentValueChanged:segmentedControl];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"eNotificationOthers"] isEqualToString:@"yes"]) {
        
        switchPushAlerts.on=YES;
    }else{
        switchPushAlerts.on=NO;
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"eNotificationImageUpload"] isEqualToString:@"yes"]) {
        
        switchImgUploadPushAlerts.on=YES;
    }else{
        switchImgUploadPushAlerts.on=NO;
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:titleView];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)] autorelease];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.rightBarButtonItem = nil;
    [titleView removeFromSuperview];
    
}


- (void)viewDidUnload
{
    [segmentedControl release];
    segmentedControl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    RELEASE_SAFELY(titleView);
    [segmentedControl release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)gotoFindFriendsController
{
    [self performSegueWithIdentifier:@"FindFriends" sender:self];
}

- (void)gotoFindLocationController
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self performSegueWithIdentifier:@"AddLocation" sender:self];
}

- (IBAction)segmentValueChanged:(id)sender 
{    
    int ind = segmentedControl.selectedSegmentIndex;
    if (ind ==0)
    {
        [segmentedControl setImage:[UIImage imageNamed:@"m-active.png"] forSegmentAtIndex:0];
        [segmentedControl setImage:[UIImage imageNamed:@"t.png"] forSegmentAtIndex:1];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:FIRST_VIEW];
    }
    else {
        [segmentedControl setImage:[UIImage imageNamed:@"m.png"] forSegmentAtIndex:0];
        [segmentedControl setImage:[UIImage imageNamed:@"t-active.png"] forSegmentAtIndex:1];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:FIRST_VIEW];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)gotoEditProfileController
{
    [self performSegueWithIdentifier:@"EditProfile" sender:self];
}

- (void)logout
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"0" forKey:LOGIN_STATE];
//    [defaults removeObjectForKey:LOGIN_TOKEN];
//    [defaults removeObjectForKey:PROFILE_USER_ID_KEY];
//    [self.navigationController.tabBarController setSelectedIndex:0];
//    [[DAL sharedInstance] resetDataStore];
//    [SHK logoutOfAll];
//    [defaults synchronize];
    [Utility logout];
}

- (void)customizeSegmentedControl
{
    [segmentedControl setTintColor:[UIColor blackColor]];
    
}

-(IBAction)pushAlertOnOff:(id)sender{
    
    webServices = [[WebServices alloc] init];
    [webServices setDelegate:self];
    if (userInfo)
        RELEASE_SAFELY(userInfo);
    userInfo = [[NSMutableDictionary alloc] init];
    NSLog(@"%@",[Utility userID]);
    [userInfo setObject:[Utility userID] forKey:@"userid"];
    [userInfo setObject:@"others" forKey:@"method"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (switchPushAlerts.isOn) {
        [defaults setValue:@"yes" forKey:@"eNotificationOthers"];
        [userInfo setObject:@"yes" forKey:@"status"];
    }else{
        [defaults setValue:@"no" forKey:@"eNotificationOthers"];
        [userInfo setObject:@"no" forKey:@"status"];
    }
    [defaults synchronize];
    //loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Signing in..."];
    [webServices pushAlerts:userInfo];
    
    
}


-(IBAction)pushAlertOnOffImageUpload:(id)sender{
    
    webServices = [[WebServices alloc] init];
    [webServices setDelegate:self];
    if (userInfo)
        RELEASE_SAFELY(userInfo);
    userInfo = [[NSMutableDictionary alloc] init];
    NSLog(@"%@",[Utility userID]);
    [userInfo setObject:[Utility userID] forKey:@"userid"];
    [userInfo setObject:@"image_upload" forKey:@"method"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (switchImgUploadPushAlerts.isOn) {
        [defaults setValue:@"yes" forKey:@"eNotificationImageUpload"];
        [userInfo setObject:@"yes" forKey:@"status"];
    }else{
        [defaults setValue:@"no" forKey:@"eNotificationImageUpload"];
        [userInfo setObject:@"no" forKey:@"status"];
    }
    [defaults synchronize];
    [webServices pushAlerts:userInfo];
    
    
}



@end
