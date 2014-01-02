//
//  StartPageViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "StartPageViewCtr.h"
#import "Header.h"
#import "AppDelegate.h"
#import "GlobalMethods.h"

@interface StartPageViewCtr ()

@end

@implementation StartPageViewCtr

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
    mainDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"SettingStartPageVC"];
        lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltitle"]];
        lblHeading.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblheading"]];
        lblSettingHeading.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblsettings"]];
        localizationDict = nil;
        localizationDict = [AppDel.langDict objectForKey:@"StartPageVC"];
        lblProjectVw.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblProjectVw"]];
        lblPriorityVw.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblPriorityVw"]];
        lblScheduleVw.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblScheduleVw"]];
    }
    
    scl_bg.contentSize = CGSizeMake(scl_bg.frame.size.width, 368);
    
    // Set Selected Start Page
    strTag = [[NSUserDefaults standardUserDefaults] stringForKey:@"HomePageSetting"];
    UIButton *btnCheckUncheck = (UIButton *)[self.view viewWithTag:[strTag intValue]];
    [btnCheckUncheck setImage:[UIImage imageNamed:@"radio_st.png"] forState:UIControlStateNormal];
    [btnCheckUncheck setSelected:YES];
}

#pragma mark - IBAction Methods
-(IBAction)btnYesOrCancelPressed:(id)sender
{
    if ([sender tag] == 11)
    {
        [[NSUserDefaults standardUserDefaults] setObject:strTag forKey:@"HomePageSetting"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([sender tag] != 1)
    {
        HomePageSetFlag = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnRadioPagePressed:(id)sender
{
    for (int i = 1; i<=4; i++)
    {
        UIButton *btnCheckUncheck = (UIButton *)[self.view viewWithTag:i];
        [btnCheckUncheck setImage:[UIImage imageNamed:@"radio_nl.png"] forState:UIControlStateNormal];
        [btnCheckUncheck setSelected:NO];
    }
    UIButton *btnCheckUncheck1 = (UIButton *)sender;
    [btnCheckUncheck1 setImage:[UIImage imageNamed:@"radio_st.png"] forState:UIControlStateNormal];
    [btnCheckUncheck1 setSelected:YES];
    strTag = [NSString stringWithFormat:@"%d",[btnCheckUncheck1 tag]];
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
