//
//  NavigationController.m
//  T&L
//
//  Created by openxcell tech.. on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController

@synthesize btn1,btn2,btn3,lbl1,lbl2;



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

-(void) setFocusButton:(int) btnIndex {
	
    if(btnIndex == 0) {
		[btn1 setBackgroundImage:[UIImage imageNamed:@"Participant1.png"] forState:UIControlStateNormal];
	} else if(btnIndex == 1) {
		[btn2 setBackgroundImage:[UIImage imageNamed:@"Assessor.png"] forState:UIControlStateNormal];
	}
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    // Return YES for supported orientations
	return YES;
}


@end
