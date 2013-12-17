//
//  AboutUsViewController.m
//  MinutesInSeconds
//
//  Created by KPIteng on 9/18/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
@synthesize titleView;

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
    txtView.font=[UIFont fontWithName:@"OpenSans-Light" size:18];
}
-(void)viewDidAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"DISABLE" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"ENABLE" object:nil];
}
-(void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    /* To add Title View on Navigation Bar */
    CGRect Frame = CGRectMake(0, 0, 320, 44);
    titleView = [[NavigationSubclass alloc] initWithFrame:Frame navigationTitleName:@"About Us"];
    [self.navigationController.navigationBar addSubview:titleView];
    /**************************************************************/
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,50, 44)];
    btn.backgroundColor=[UIColor clearColor];
    [btn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 16, 25)];
    [backImage setImage:[UIImage imageNamed:@"backBtn.png"]];
    [btn addSubview:backImage];
    
    [titleView addSubview:btn];
    
    [self.navigationItem setHidesBackButton:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end