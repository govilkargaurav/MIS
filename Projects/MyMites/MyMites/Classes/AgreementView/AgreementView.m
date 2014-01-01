//
//  AgreementView.m
//  MyMite
//
//  Created by Vivek Rajput on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AgreementView.h"

@implementation AgreementView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self btnCheckClick:[self.view viewWithTag:1]];
    checkTag=0;
}
#pragma mark - Agreement
-(IBAction)btnCheckClick:(id)sender
{
    UIButton *btn = sender;
    
    if (btn.tag==0)
    {
        [btnCheck setImage:[UIImage imageNamed:@"btnCheck.png"] forState:UIControlStateNormal];
        btnCheck.tag=1;
    }
    else if (btn.tag==1)
    {
        [btnCheck setImage:[UIImage imageNamed:@"btnUnCheck.png"] forState:UIControlStateNormal];
        btnCheck.tag=0;
    }
}



-(IBAction)btnAgreeClick:(id)sender
{
    
    if (btnCheck.tag==1) 
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"Read" forKey:@"TermsAndConditions"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        DisplayAlertWithTitle(APP_Name, @"Please Select Agreement");
    }
    
}
#pragma mark - Dealloc

#pragma mark - Extra
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
