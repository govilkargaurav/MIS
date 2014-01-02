//
//  SettingsViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "SettingsViewCtr.h"
#import "StartPageViewCtr.h"
#import "DoNowViewCtr.h"
#import "TaskSettingViewCtr.h"
#import "LogoutViewCtr.h"
#import "LanguageSelectionViewCtr.h"
#import "DateTimeViewCtr.h"
#import "TimeZoneViewCtr.h"
#import "SynchronizeViewCtr.h"
#import "AppDelegate.h"
#import "GlobalMethods.h"

@interface SettingsViewCtr ()

@end

@implementation SettingsViewCtr

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
    scl_bg.contentSize = CGSizeMake(scl_bg.frame.size.width, 416);
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"settingVC"];
    }
    else
    {
        AppDel.langDict = [mainDict objectForKey:@"en"];
        localizationDict = [AppDel.langDict objectForKey:@"settingVC"];
    }
    lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltitle"]];
    lblStartPage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblstartpage"]];
    lblDoNowPage.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbldonow"]];
    lblTaskSettings.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltasksettings"]];
    lblDateTime.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbldatetime"]];
    lblTimeZone.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltimezone"]];
    lblLang.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbllanguage"]];
    lblSync.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblsync"]];
    lblLogut.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbllogout"]];
}

#pragma mark - IBAction Methods

-(IBAction)btnStartPagePressed:(id)sender
{
    StartPageViewCtr *obj_StartPageViewCtr = [[StartPageViewCtr alloc]initWithNibName:@"StartPageViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_StartPageViewCtr animated:YES];
}
-(IBAction)btnDoNowPagePressed:(id)sender
{
    DoNowViewCtr *obj_DoNowViewCtr = [[DoNowViewCtr alloc]initWithNibName:@"DoNowViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_DoNowViewCtr animated:YES];
}
-(IBAction)btnTaskSettingPressed:(id)sender
{
    TaskSettingViewCtr *obj_TaskSettingViewCtr = [[TaskSettingViewCtr alloc]initWithNibName:@"TaskSettingViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_TaskSettingViewCtr animated:YES];
}
-(IBAction)btnDateTimePressed:(id)sender
{
    DateTimeViewCtr *obj_DateTimeViewCtr = [[DateTimeViewCtr alloc]initWithNibName:@"DateTimeViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_DateTimeViewCtr animated:YES];
}
-(IBAction)btnTimeZonePressed:(id)sender
{
    TimeZoneViewCtr *obj_TimeZoneViewCtr = [[TimeZoneViewCtr alloc]initWithNibName:@"TimeZoneViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_TimeZoneViewCtr animated:YES];
}
-(IBAction)btnSyncPressed:(id)sender
{
    SynchronizeViewCtr *obj_SynchronizeViewCtr = [[SynchronizeViewCtr alloc]initWithNibName:@"SynchronizeViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_SynchronizeViewCtr animated:YES];
}
-(IBAction)btnLogoutPressed:(id)sender
{
    LogoutViewCtr *obj_LogoutViewCtr = [[LogoutViewCtr alloc]initWithNibName:@"LogoutViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_LogoutViewCtr animated:YES];
}
-(IBAction)btnLanguagePressed:(id)sender
{
    LanguageSelectionViewCtr *obj_LanguageSelectionViewCtr = [[LanguageSelectionViewCtr alloc]initWithNibName:@"LanguageSelectionViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_LanguageSelectionViewCtr animated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
