//
//  TLISCViewController.m
//  T&L
//
//  Created by OpenXcell-Macmini3 on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TLISCViewController.h"
#import "ViewController.h"
@interface TLISCViewController ()

@end

@implementation TLISCViewController

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
    ViewController *x = [[ViewController alloc] init];
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.strWhichTabBar = @"FirstTabBar";
    [app.navigationController pushViewController: x animated:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
