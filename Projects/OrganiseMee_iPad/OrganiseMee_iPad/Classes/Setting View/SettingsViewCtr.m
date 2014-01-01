//
//  SettingsViewCtr.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 9/2/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "SettingsViewCtr.h"
#import "DateTimeViewCtr.h"
#import "TimeZoneViewCtr.h"
#import "LanguageSelectionViewCtr.h"
#import "AutoSyncViewCtr.h"

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
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(DonePressed:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
        
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.contentSizeForViewInPopover = CGSizeMake(320, 400);
    
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
    lblHeader.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblcomment"]];
    lblAutoSync.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"autosync"]];
    lblDateTime.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbldatetime"]];
    lblLang.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbllanguage"]];
    lblLogout.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbllogout"]];
    lblTimeZone.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltimezone"]];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltitle"]];

}

-(void)DonePressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissSettingPopOver" object:nil userInfo:nil];
}

-(IBAction)btnDateTimePressed:(id)sender
{
    DateTimeViewCtr *obj_DateTimeViewCtr = [[DateTimeViewCtr alloc]initWithNibName:@"DateTimeViewCtr" bundle:nil];
    obj_DateTimeViewCtr.strNav_Title = lblDateTime.text;
    [self.navigationController pushViewController:obj_DateTimeViewCtr animated:YES];
}
-(IBAction)btnTimeZonePressed:(id)sender
{
    TimeZoneViewCtr *obj_TimeZoneViewCtr = [[TimeZoneViewCtr alloc]initWithNibName:@"TimeZoneViewCtr" bundle:nil];
    obj_TimeZoneViewCtr.strNav_Title = lblTimeZone.text;
    [self.navigationController pushViewController:obj_TimeZoneViewCtr animated:YES];
}
-(IBAction)btnAutoSyncPressed:(id)sender
{
    AutoSyncViewCtr *obj_AutoSyncViewCtr = [[AutoSyncViewCtr alloc]initWithNibName:@"AutoSyncViewCtr" bundle:nil];
    obj_AutoSyncViewCtr.strNav_Title = lblAutoSync.text;
    [self.navigationController pushViewController:obj_AutoSyncViewCtr animated:YES];
}
-(IBAction)btnLanguagePressed:(id)sender
{
    LanguageSelectionViewCtr *obj_LanguageSelectionViewCtr = [[LanguageSelectionViewCtr alloc]initWithNibName:@"LanguageSelectionViewCtr" bundle:nil];
    obj_LanguageSelectionViewCtr.strNav_Title = lblLang.text;
    [self.navigationController pushViewController:obj_LanguageSelectionViewCtr animated:YES];
}
-(IBAction)btnLogoutPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogOut" object:nil userInfo:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
