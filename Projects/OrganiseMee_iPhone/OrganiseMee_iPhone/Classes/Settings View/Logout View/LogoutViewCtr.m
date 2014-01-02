//
//  LogoutViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "LogoutViewCtr.h"
#import "AppDelegate.h"
#import "GlobalMethods.h"

@interface LogoutViewCtr ()

@end

@implementation LogoutViewCtr

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
    if ([GlobalMethods CheckPhoneVersionisiOS7])
    {
        scl_bg.frame = CGRectMake(scl_bg.frame.origin.x, scl_bg.frame.origin.y + 20, scl_bg.frame.size.width, scl_bg.frame.size.height  - 20);
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"SettingLogoutVC"];
        [btnLogut setTitle:[localizationDict objectForKey:@"lbllogut"] forState:UIControlStateNormal];
        lbl1.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbl1"]];
        lbl2.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbl2"]];
        lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbllogut"]];
        lblSettingHeading.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblsettings"]];
    }
    [self updateui];
}

#pragma mark - IBAction Methods

-(IBAction)btnLogoutPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"LoggedOut" forKey:@"Login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateui];
}
#pragma mark - Set Landscape Frame

-(void)updateui
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        lbl1.frame = CGRectMake(20, 115, lbl1.frame.size.width, 72);
        lbl2.frame = CGRectMake(20, 207, lbl2.frame.size.width, 111);
        btnLogut.frame = CGRectMake(btnLogut.frame.origin.x, 356, 168, 35);
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        lbl1.frame = CGRectMake(20, 95, lbl1.frame.size.width, 50);
        lbl2.frame = CGRectMake(20, 140, lbl2.frame.size.width, 70);
        btnLogut.frame = CGRectMake(btnLogut.frame.origin.x, 205, 168, 35);
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
