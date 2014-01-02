//
//  DoNowViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "DoNowViewCtr.h"
#import "AppDelegate.h"
#import "GlobalMethods.h"

@interface DoNowViewCtr ()

@end

@implementation DoNowViewCtr

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
        localizationDict = [AppDel.langDict objectForKey:@"SettingDoNowVC"];
        lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltitle"]];
        lbl1.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbl1"]];
        lbl2.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbl2"]];
        lblSettingHeading.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblsettings"]];
        lblck1.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"ck1"]];
        lblck2.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"ck2"]];
        lblck3.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"ck3"]];
        lblck4.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"ck4"]];
        lblck5.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"ck5"]];
    }
    
    scl_bg.contentSize = CGSizeMake(scl_bg.frame.size.width, 410);
    
    // Set Selected Do Now Task
    NSString *strDoNow = [[NSUserDefaults standardUserDefaults] stringForKey:@"DoNowSetting"];
    
    if ([strDoNow length] > 0)
    {
        NSArray *Arry = [strDoNow componentsSeparatedByString:@","];
        ArrayTag = [[NSMutableArray alloc] initWithArray:Arry];
        for (int i = 0; i<[ArrayTag count]; i++)
        {
            NSString *strTag = [ArrayTag objectAtIndex:i];
            UIButton *btnCheckUncheck = (UIButton *)[self.view viewWithTag:[strTag intValue]];
            [btnCheckUncheck setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
            [btnCheckUncheck setSelected:YES];
        }
    }
    else
    {
        ArrayTag = [[NSMutableArray alloc] init];
    }

}

#pragma mark - IBAction Methods
-(IBAction)btnYesOrCancelPressed:(id)sender
{
    if ([sender tag] == 11)
    {
        NSString *strDoNow = [ArrayTag componentsJoinedByString:@","];
        [[NSUserDefaults standardUserDefaults] setObject:strDoNow forKey:@"DoNowSetting"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnCheckUncheckPressed:(id)sender
{
    UIButton *btnCheckUncheck = (UIButton*)sender;
    NSString *strtag = [NSString stringWithFormat:@"%d",[sender tag]];
    if (btnCheckUncheck.selected == YES)
    {
        [btnCheckUncheck setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        [btnCheckUncheck setSelected:NO];
        [ArrayTag removeObject:strtag];
    }
    else
    {
        [btnCheckUncheck setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        [btnCheckUncheck setSelected:YES];
        [ArrayTag addObject:strtag];
    }
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
