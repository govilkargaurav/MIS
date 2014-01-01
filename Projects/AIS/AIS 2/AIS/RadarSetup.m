//
//  RadarSetup.m
//  AIS
//
//  Created by System Administrator on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import "RadarSetup.h"


@implementation RadarSetup

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
	self.title=@"Radar Setup";
	UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain
																	  target:self action:@selector(ClickExit:)];      
	self.navigationItem.leftBarButtonItem = anotherButton1;
	
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain
																	 target:self action:@selector(ClickSave:)];      
	self.navigationItem.rightBarButtonItem = anotherButton;
	
	
	if ([[NSUserDefaults standardUserDefaults] valueForKey:@"radarsettings"]) {
		radarSettings = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)[[NSUserDefaults standardUserDefaults] valueForKey:@"radarsettings"]];
		[self setValuesAsPerSettings];
	}else {
		radarSettings = [[NSMutableDictionary alloc] init];
	}

	
	
}

-(void)setValuesAsPerSettings{
	
	int posi = [[radarSettings valueForKey:@"posi"] intValue];
	lblPosi.text=[NSString stringWithFormat:@"%d%",posi];
	[PosiSlider setValue:(float)posi];

	int velo = [[radarSettings valueForKey:@"velo"] intValue];
	lblVelo.text=[NSString stringWithFormat:@"%dmin",velo];
	[velocitySlider setValue:(float)velo];

	int persi = [[radarSettings valueForKey:@"persi"] intValue];
	lblPersi.text=[NSString stringWithFormat:@"%dmin",persi];
	[targetPersiSlider setValue:(float)persi];
	
}

	

-(void)saveSettingValue{
	
	[radarSettings setValue:[NSString stringWithFormat:@"%f",PosiSlider.value] forKey:@"posi"];
	[radarSettings setValue:[NSString stringWithFormat:@"%f",velocitySlider.value] forKey:@"velo"];
	[radarSettings setValue:[NSString stringWithFormat:@"%f",targetPersiSlider.value] forKey:@"persi"];
	
	[[NSUserDefaults standardUserDefaults] setValue:radarSettings forKey:@"radarsettings"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)viewWillDisappear:(BOOL)animated{

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
-(IBAction)postionSliderValueChange:(id)sender{
	int value= (int)PosiSlider.value;
	lblPosi.text=[NSString stringWithFormat:@"%d",value];
}
-(IBAction)velocitySliderValueChange:(id)sender{
	int value= (int)velocitySlider.value;
	lblVelo.text=[NSString stringWithFormat:@"%dmin",value];
}
-(IBAction)persistenceSliderValueChange:(id)sender{
	int value= (int)targetPersiSlider.value;
	lblPersi.text=[NSString stringWithFormat:@"%dmin",value];
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
