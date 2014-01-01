//
//  SetupView.m
//  AIS
//
//  Created by System Administrator on 11/24/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import "SetupView.h"


@implementation SetupView

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title=@"Setup";
	UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain
																	  target:self action:@selector(ClickExit:)];      
	self.navigationItem.leftBarButtonItem = anotherButton1;

}

-(void)ClickExit:(id)sender{
	//[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}



-(IBAction)ClickRadarSetup{
	RadarSetup *obj=[[RadarSetup alloc]initWithNibName:@"RadarSetup" bundle:nil];
	[self.navigationController pushViewController:obj animated:YES];
	[obj release];
}

-(IBAction)ClickUnits{
	UnitsView *obj=[[UnitsView alloc]initWithNibName:@"UnitsView" bundle:nil];
	[self.navigationController pushViewController:obj animated:YES];
	[obj release];
}

-(IBAction)ClickTCP{
	
	
	TCPView *obj=[[TCPView alloc]initWithNibName:@"TCPView" bundle:nil];
	[self.navigationController pushViewController:obj animated:YES];
	[obj release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
