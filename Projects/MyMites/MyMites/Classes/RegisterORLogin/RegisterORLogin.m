//
//  RegisterORLogin.m
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegisterORLogin.h"
#import "GlobalClass.h"
#import "AllProfileViewController.h"

@implementation RegisterORLogin

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}



#pragma mark - View Did Load

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *Info = [NSUserDefaults standardUserDefaults];
    if ([[Info valueForKey:@"Login"] isEqualToString:@"LoginValue"]) 
    {
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"pushIt1" object:self]; 
        if ([viewprofileStr isEqualToString:@"1"]) 
        {
            AllProfileViewController *profileView=[[AllProfileViewController alloc] initWithNibName:@"AllProfileViewController" bundle:nil];
            profileView.strConnHidden = @"HiddenNo";
            [self.navigationController pushViewController:profileView animated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Dealloc


#pragma mark - IBAction Methods
-(IBAction)LoginClicked:(id)sender
{
    Login *objLogin = [[Login alloc]initWithNibName:@"Login" bundle:nil];
    objLogin.strSetHideCancelbtn=@"No";
    objLogin.strMessageTitle = @"";
    [self presentModalViewController:objLogin animated:YES];

}
-(IBAction)RegisterClicked:(id)sender
{
    Register *objRegister = [[Register alloc]initWithNibName:@"Register" bundle:nil];
    [self presentModalViewController:objRegister animated:YES];
}

-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Extra Methods
- (void)viewDidUnload
{
    [super viewDidUnload];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
