//
//  LanguageSelectionViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "LanguageSelectionViewCtr.h"
#import "DatabaseAccess.h"

@interface LanguageSelectionViewCtr ()

@end

@implementation LanguageSelectionViewCtr
@synthesize strNav_Title;

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

-(void)DonePressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissSettingPopOver" object:nil userInfo:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 400);
    self.navigationItem.title = strNav_Title;
    
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"SettingLanguageVC"];
        lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltitle"]];
        lblHeading.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblheading"]];
        lblSettingHeading.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblsettings"]];
    }
    // Set Selected Langauge
    strLang = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    UIButton *btnCheckUncheck;
    if ([strLang isEqualToString:@"en"])
    {
        btnCheckUncheck = (UIButton *)[self.view viewWithTag:1];
    }
    else if ([strLang isEqualToString:@"de"])
    {
        btnCheckUncheck = (UIButton *)[self.view viewWithTag:2];
    }
    [btnCheckUncheck setImage:[UIImage imageNamed:@"radio_st.png"] forState:UIControlStateNormal];
    [btnCheckUncheck setSelected:YES];
}

#pragma mark - IBAction Methods

-(IBAction)btnRadioLangPressed:(id)sender
{
    for (int i = 1; i<=2; i++)
    {
        UIButton *btnCheckUncheck = (UIButton *)[self.view viewWithTag:i];
        [btnCheckUncheck setImage:[UIImage imageNamed:@"radio_nl.png"] forState:UIControlStateNormal];
        [btnCheckUncheck setSelected:NO];
    }
    
    UIButton *btnCheckUncheck1 = (UIButton *)sender;
    [btnCheckUncheck1 setImage:[UIImage imageNamed:@"radio_st.png"] forState:UIControlStateNormal];
    [btnCheckUncheck1 setSelected:YES];
    
    if ([sender tag] == 1)
    {
        strLang = @"en";
    }
    else if ([sender tag] == 2)
    {
        strLang = @"de";
    }
    [[NSUserDefaults standardUserDefaults] setObject:strLang forKey:@"LanguageSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //Send Data Of user setting from local databse
    NSString *strQuerySelectSetting = @"SELECT * FROM tbl_user_setting";
    NSMutableArray *ArryretriveUserSettings = [[NSMutableArray alloc] initWithArray:[DatabaseAccess gettbl_user_setting:strQuerySelectSetting]];
    
    NSString *strQueryUpdate = [NSString stringWithFormat:@"update tbl_user_setting Set language='%@' Where userId=%d",strLang,[[[ArryretriveUserSettings objectAtIndex:0] valueForKey:@"userId"] intValue]];
    [DatabaseAccess updatetbl:strQueryUpdate];
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
