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

@end
