//
//  ViewController.m
//  PropertyInspector
//
//  Created by apple on 10/15/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"

@interface ViewController ()
@property(nonatomic,retain)LoginViewController *loginViewController;
@end

@implementation ViewController

@synthesize loginViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
    [self loginAction:nil];
    
    
}


-(void)loginAction:(id)sender{
    
    self.loginViewController =[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:self.loginViewController animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
