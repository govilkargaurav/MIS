//
//  InfoViewController.m
//  SkyyApp
//
//  Created by Vishal Jani on 9/3/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import "InfoViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize isSetting;
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
    if (isSetting==TRUE) {
        self.navigationController.navigationBarHidden=NO;
        btnStart.hidden=YES;
    }else{
        self.navigationController.navigationBarHidden=TRUE;
        btnStart.hidden=NO;
    }
    if (![PFUser currentUser]) {
         btnStart.hidden=NO;
    }
    
    isSetting=FALSE;
    [srcView setContentSize:CGSizeMake(320, 2440)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btnStartPressed:(id)sender{
   
    LoginViewController *objLoginViewController=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:objLoginViewController animated:TRUE];

}
@end
