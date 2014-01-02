//
//  MasterViewController.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/10/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "MasterViewController.h"
#import "MainViewCtr.h"
#import "HomeViewCtr.h"
#import "Header.h"
#import "AppDelegate.h"
#import "GlobalMethods.h"

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
							
- (void)viewDidLoad
{
    if ([GlobalMethods CheckPhoneVersionisiOS7])
    {
        scl_bg.frame = CGRectMake(scl_bg.frame.origin.x, scl_bg.frame.origin.y + 20, scl_bg.frame.size.width, scl_bg.frame.size.height  - 20);
    }
    NSString *strHomepage = [[NSUserDefaults standardUserDefaults] stringForKey:@"HomePageSetting"];
    if (!strHomepage)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"HomePageSetting"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        if ([strHomepage intValue] != 1)
            HomePageSetFlag = YES;
        else
            HomePageSetFlag = NO;

    }
    NSString *strDoNow = [[NSUserDefaults standardUserDefaults] stringForKey:@"DoNowSetting"];
    if (!strDoNow)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1,3" forKey:@"DoNowSetting"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *strTask = [[NSUserDefaults standardUserDefaults] stringForKey:@"TaskSetting"];
    if (!strTask)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1,2,3,4" forKey:@"TaskSetting"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"];
	if ([loginStatus isEqualToString:@"LoggedIn"])
	{
        strAckNo = [[NSUserDefaults standardUserDefaults] stringForKey:@"ACK"];
        strAccesstoken = [[NSUserDefaults standardUserDefaults] stringForKey:@"Accesstoken"];
        
        HomeViewCtr *obj_HomeViewCtr = [[HomeViewCtr alloc]init];
        [self.navigationController pushViewController:obj_HomeViewCtr animated:NO];
    }
    else
    {
        NSString *attstate1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"Time"];
		
		if (!attstate1)
		{
			[[NSUserDefaults standardUserDefaults] setObject:@"Off" forKey:@"Time"];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		
		NSString *attstate = [[NSUserDefaults standardUserDefaults] stringForKey:@"Date"];
		
		if (!attstate)
		{
			[[NSUserDefaults standardUserDefaults] setObject:@"Off" forKey:@"Date"];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
    }

    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods
-(IBAction)btnLanguagePressed:(id)sender
{
    if ([sender tag] == 1)
    {
        [self navigationToLoginView:@"en"];
    }
    else if ([sender tag] == 2)
    {
        [self navigationToLoginView:@"de"];
    }
}


#pragma mark - Self Methods
-(void)navigationToLoginView:(NSString*)strLang
{
    [[NSUserDefaults standardUserDefaults] setObject:strLang forKey:@"LanguageSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MainViewCtr *obj_MainViewCtr = [[MainViewCtr alloc]initWithNibName:@"MainViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_MainViewCtr animated:YES];
}

#pragma mark - UIInterfaceOrientation For iOS < 6

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

#pragma mark - UIInterfaceOrientation For iOS 6

- (NSUInteger) supportedInterfaceOrientations
{
        return UIInterfaceOrientationMaskAll;
}
-(BOOL)shouldAutorotate
{
    return YES;
}


@end
