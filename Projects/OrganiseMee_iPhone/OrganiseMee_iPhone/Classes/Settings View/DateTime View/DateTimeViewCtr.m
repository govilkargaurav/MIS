//
//  DateTimeViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "DateTimeViewCtr.h"
#import "DatabaseAccess.h"
#import "AppDelegate.h"
#import "GlobalMethods.h"

@interface DateTimeViewCtr ()

@end

@implementation DateTimeViewCtr

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
        localizationDict = [AppDel.langDict objectForKey:@"SettingDateTimeVC"];
        lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltitle"]];
        lblHeading.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblheading"]];
        lblSettingHeading.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblsettings"]];
    }
    
    scl_bg.contentSize = CGSizeMake(scl_bg.frame.size.width, 378);
    
    // Set Selected Date / Time
    strDateTag = [[NSUserDefaults standardUserDefaults] stringForKey:@"DateSetting"];
    UIButton *btnCheckUncheck = (UIButton *)[self.view viewWithTag:[strDateTag intValue]+1];
    [btnCheckUncheck setImage:[UIImage imageNamed:@"radio_st.png"] forState:UIControlStateNormal];
    [btnCheckUncheck setSelected:YES];
    
    strTimeTag = [[NSUserDefaults standardUserDefaults] stringForKey:@"TimeSetting"];
    UIButton *btnCheckUncheck1 = (UIButton *)[self.view viewWithTag:[strTimeTag intValue]+3];
    [btnCheckUncheck1 setImage:[UIImage imageNamed:@"radio_st.png"] forState:UIControlStateNormal];
    [btnCheckUncheck1 setSelected:YES];
}

#pragma mark - IBAction Methods
-(IBAction)btnYesOrCancelPressed:(id)sender
{
    if ([sender tag] == 11)
    {
        [[NSUserDefaults standardUserDefaults] setObject:strDateTag forKey:@"DateSetting"];
        [[NSUserDefaults standardUserDefaults] setObject:strTimeTag forKey:@"TimeSetting"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Send Data Of user setting from local databse
        NSString *strQuerySelectSetting = @"SELECT * FROM tbl_user_setting";
        NSMutableArray *ArryretriveUserSettings = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_user_setting:strQuerySelectSetting]];
        
        NSString *strQueryUpdate = [NSString stringWithFormat:@"update tbl_user_setting Set timeFormat=%d ,dateFormat=%d Where userId=%d",[strTimeTag intValue],[strDateTag intValue],[[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"] intValue]];
        [DatabaseAccess updatetbl:strQueryUpdate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnRadioDatePressed:(id)sender
{
    for (int i =1; i<=2; i++)
    {
        UIButton *btnCheckUncheck = (UIButton *)[self.view viewWithTag:i];
        [btnCheckUncheck setImage:[UIImage imageNamed:@"radio_nl.png"] forState:UIControlStateNormal];
        [btnCheckUncheck setSelected:NO];
    }
    
    UIButton *btnCheckUncheck1 = (UIButton *)sender;
    [btnCheckUncheck1 setImage:[UIImage imageNamed:@"radio_st.png"] forState:UIControlStateNormal];
    [btnCheckUncheck1 setSelected:YES];
    
    strDateTag = [NSString stringWithFormat:@"%d",[btnCheckUncheck1 tag]-1];
}
-(IBAction)btnRadioTimePressed:(id)sender
{
    for (int i = 3; i<=4; i++)
    {
        UIButton *btnCheckUncheck = (UIButton *)[self.view viewWithTag:i];
        [btnCheckUncheck setImage:[UIImage imageNamed:@"radio_nl.png"] forState:UIControlStateNormal];
        [btnCheckUncheck setSelected:NO];
    }
    
    UIButton *btnCheckUncheck1 = (UIButton *)sender;
    [btnCheckUncheck1 setImage:[UIImage imageNamed:@"radio_st.png"] forState:UIControlStateNormal];
    [btnCheckUncheck1 setSelected:YES];
    
    strTimeTag = [NSString stringWithFormat:@"%d",[btnCheckUncheck1 tag]-3];
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
