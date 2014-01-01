//
//  Profile.m
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Profile.h"
#import "BusyAgent.h"
#import "AppConstat.h"
#import "JSON.h"
#import "ViewProfileViewCtr.h"
#import "ImageViewURL.h"
#import "EditProfileViewController.h"
#import "ChangePhotoViewCtr.h"
#import "GlobalClass.h"

@implementation Profile

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
    //[self CallURL];
}
-(void)CallURL
{
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    responseData = [[NSMutableData alloc] init];
    results = [[NSMutableDictionary alloc] init];
    NSString *strpass = [NSString stringWithFormat:@"%@webservices/profile.php?iUserID=%@&iSelfID=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"],[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strpass]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request delegate:self];
}
-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
    [self CallURL];
}

#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    DisplayNoInternate;

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    results = [responseString JSONValue];
    lblName.text = [NSString stringWithFormat:@"Welcome %@",[results valueForKey:@"vFirst"]];
    lblEmail.text = [NSString stringWithFormat:@"%@",[results valueForKey:@"vEmail"]];
    lblLocation.text=[NSString stringWithFormat:@"%@",[results valueForKey:@"vCity"]];
    lblOccupation.text=[NSString stringWithFormat:@"%@",[results valueForKey:@"dDOB"]];
    
    ImageViewURL *x=[[ImageViewURL alloc] init];
    x.imgV=imgProfile;
	x.strUrl=[NSURL URLWithString:[results valueForKey:@"vImage"]];
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - IBAction Methods
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnViewProfilePressed:(id)sender
{
    ViewProfileViewCtr *obj_ViewProfileViewCtr = [[ViewProfileViewCtr alloc]initWithNibName:@"ViewProfileViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_ViewProfileViewCtr animated:YES];
    obj_ViewProfileViewCtr = nil;
}

-(IBAction)editViewController:(id)sender
{
    EditProfileViewController *editView=[[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil Dic:results];
    [self.navigationController pushViewController:editView animated:YES];
    editView=nil;
}
-(IBAction)btnChangePhotoPressed:(id)sender
{
    ChangePhotoViewCtr *obj_ChangePhotoViewCtr = [[ChangePhotoViewCtr alloc]initWithNibName:@"ChangePhotoViewCtr" bundle:nil];
    obj_ChangePhotoViewCtr.strProfileLink = [NSString stringWithFormat:@"%@",[results valueForKey:@"vImage"]];
    [self presentModalViewController:obj_ChangePhotoViewCtr animated:YES];
    obj_ChangePhotoViewCtr = nil;
}

#pragma mark - Extra Methods
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
