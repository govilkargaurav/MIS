//
//  MainViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/10/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "MainViewCtr.h"
#import "LoginViewCtr.h"
#import "RegisterViewCtr.h"
#import "AppDelegate.h"
#import "GlobalMethods.h"

@interface MainViewCtr ()

@end

@implementation MainViewCtr

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
    
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"LoginRegiVC"];
        [btnLogin setTitle:[localizationDict objectForKey:@"btnLogin"] forState:UIControlStateNormal];
        [btnRegister setTitle:[localizationDict objectForKey:@"btnregister"] forState:UIControlStateNormal];
        lbl1.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbl1"]];
        lbl2.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbl2"]];
        lbl3.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbl3"]];
    }
    scl_bg.contentSize = CGSizeMake(scl_bg.frame.size.width, 400);
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
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
