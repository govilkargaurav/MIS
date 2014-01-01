//
//  UnitsView.m
//  AIS
//
//  Created by System Administrator on 11/24/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import "UnitsView.h"


@implementation UnitsView

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title=@"Units View";
	UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain
																	  target:self action:@selector(ClickExit:)];      
	self.navigationItem.leftBarButtonItem = anotherButton1;

	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain
																	  target:self action:@selector(ClickSave:)];      
	self.navigationItem.rightBarButtonItem = anotherButton;


	if ([[NSUserDefaults standardUserDefaults] valueForKey:@"unitssettings"]) {
		unitssettings = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)[[NSUserDefaults standardUserDefaults] valueForKey:@"unitssettings"]];
		[self setValuesAsPerSettings];
	}else {
		unitssettings = [[NSMutableDictionary alloc] init];
	}
	
}
-(void)setValuesAsPerSettings{
	int posiValue = [[unitssettings valueForKey:@"posi"] intValue];
	[posi setSelectedSegmentIndex:posiValue];
	
	int disValue = [[unitssettings valueForKey:@"dis"] intValue];
	[dis setSelectedSegmentIndex:disValue];
	
	int speedValue = [[unitssettings valueForKey:@"speed"] intValue];
	[speed setSelectedSegmentIndex:speedValue];
	
	int depthValue = [[unitssettings valueForKey:@"depth"] intValue];
	[depth setSelectedSegmentIndex:depthValue];
	
}

-(void)saveSettingValue{
	
	[unitssettings setValue:[NSString stringWithFormat:@"%d",posi.selectedSegmentIndex] forKey:@"posi"];
	[unitssettings setValue:[NSString stringWithFormat:@"%d",dis.selectedSegmentIndex] forKey:@"dis"];
	[unitssettings setValue:[NSString stringWithFormat:@"%d",speed.selectedSegmentIndex] forKey:@"speed"];
	[unitssettings setValue:[NSString stringWithFormat:@"%d",depth.selectedSegmentIndex] forKey:@"depth"];
	
	[[NSUserDefaults standardUserDefaults] setValue:unitssettings forKey:@"unitssettings"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)ClickExit:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)ClickSave:(id)sender{
	[self saveSettingValue];
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Data Saved"
												  message:@"Press OK to continue" 
												 delegate:self 
										cancelButtonTitle:nil 
										otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)postionSegmentValueChange:(id)sender{
	
}
-(IBAction)distanceSegmentValueChange:(id)sender{
	
}
-(IBAction)speedSegmentValueChange:(id)sender{
	
}
-(IBAction)depthSegmentValueChange:(id)sender{
	
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
