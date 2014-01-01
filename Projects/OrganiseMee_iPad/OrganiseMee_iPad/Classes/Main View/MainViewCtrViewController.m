//
//  MainViewCtrViewController.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/15/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "MainViewCtrViewController.h"
#import "AppDelegate.h"
#import "LoginViewCtr.h"
#import "RegisterViewCtr.h"

@interface MainViewCtrViewController ()

@end

@implementation MainViewCtrViewController

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
    
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"];
	if ([loginStatus isEqualToString:@"LoggedIn"])
	{        
        LoginViewCtr *obj_LoginViewCtr = [[LoginViewCtr alloc]initWithNibName:@"LoginViewCtr" bundle:nil];
        [self.navigationController pushViewController:obj_LoginViewCtr animated:NO];
    }
    
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"LoginRegiVC"];
        [btnRegister setTitle:[localizationDict objectForKey:@"btnregister"] forState:UIControlStateNormal];
        lblwelcome.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblwelcome"]];
        lblthanku.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblthanku"]];
        lblorganisemee.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblorganisemee"]];
        lblyou.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblyou"]];
        lblplease.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblplease"]];
    }
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - IBAction Methods
-(IBAction)btnLoginPressed:(id)sender
{
    LoginViewCtr *obj_LoginViewCtr = [[LoginViewCtr alloc]initWithNibName:@"LoginViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_LoginViewCtr animated:YES];
}
-(IBAction)btnRegisterPressed:(id)sender
{
    RegisterViewCtr *obj_RegisterViewCtr = [[RegisterViewCtr alloc]initWithNibName:@"RegisterViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_RegisterViewCtr animated:YES];
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
