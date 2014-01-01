//
//  MainPage.m
//  AIS
//
//  Created by apple  on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import "MainPage.h"


@implementation MainPage
@synthesize tabBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
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

     self.title=@"easy AIS";
	[tblView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [tblView.layer setBorderWidth: 1.0];
    [tblView.layer setCornerRadius:8.0f];
    [tblView.layer setMasksToBounds:YES];
	
	[desclaimer.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [desclaimer.layer setBorderWidth: 1.0];
    [desclaimer.layer setCornerRadius:8.0f];
    [desclaimer.layer setMasksToBounds:YES];
	
	// Do any additional setup after loading the view from its nib.
}


-(IBAction)clickStart{
  //  RadarView *obj=[[RadarView alloc]initWithNibName:@"RadarView" bundle:nil];
//    [self.navigationController pushViewController:obj animated:YES];
//    [obj release];
	
	[self.navigationController pushViewController:tabBar animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }  
	
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text=@"Version:";
			cell.detailTextLabel.text=@"1.0";
			break;
		case 1:
			cell.textLabel.text=@"Copyright:";
			cell.detailTextLabel.text=@"Weatherdock";			
			break;
		case 2:
			cell.textLabel.text=@"Website:";
			cell.detailTextLabel.text=@"easyAIS.de";
			break;
		default:
			break;
	}
    // Configure the cell...
	//cell.textLabel.text=@"Test";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row == 2) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.easyais.de"]];
	}
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
