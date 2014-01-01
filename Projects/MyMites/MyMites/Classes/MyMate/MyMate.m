//
//  MyMate.m
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyMate.h"
#import "BusyAgent.h"
#import "AppConstat.h"
#import "JSON.h"
#import "FullProfessionViewCtr.h"
#import "AllProfileViewController.h"
#import "GlobalClass.h"

@implementation MyMate

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
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointstblbg1.png"]];
    [tblView setFrame:tblView.frame];
    tblView.backgroundView = tempImageView;
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    responseData = [[NSMutableData alloc] init];
    ArryMyMates = [[NSMutableArray alloc] init];
    NSString *strpass = [NSString stringWithFormat:@"%@webservices/my_mates.php?iUserID=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strpass]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request delegate:self];
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
    ArryMyMates = [responseString JSONValue];
    NSString *strMsg =[self removeNull:[NSString stringWithFormat:@"%@",[ArryMyMates valueForKey:@"msg"]]];
    if ([strMsg isEqualToString:@"no data found"]) 
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:APP_Name message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = 1;
        [alertView show];
    }
    else
    {
        [tblView reloadData];
    }
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Dealloc


#pragma mark - IBAction Methods
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- TableView Delegate

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, 297, 25)];
	
    
    UIImageView * headerImage = [[UIImageView alloc] init];
    headerImage.frame = CGRectMake(0, 0.0, 300, 25);
    headerImage.image = [UIImage imageNamed:@"pointstblbg2.png"];
    [customView addSubview:headerImage];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = UITextAlignmentLeft;
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    headerLabel.frame = CGRectMake(5, 0.0, 100, 25);
    headerLabel.text = @"Name"; // i.e. array element
    [customView addSubview:headerLabel];
    
    UILabel * headerLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel1.backgroundColor = [UIColor clearColor];
    headerLabel1.textColor = [UIColor whiteColor];
    headerLabel1.textAlignment = UITextAlignmentLeft;
    headerLabel1.font = [UIFont boldSystemFontOfSize:14];
    headerLabel1.frame = CGRectMake(125, 0.0, 125, 25);
    headerLabel1.text = @"JobType"; // i.e. array element
    [customView addSubview:headerLabel1];
    
    UILabel * headerLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel2.backgroundColor = [UIColor clearColor];
    headerLabel2.textColor = [UIColor whiteColor];
    headerLabel2.textAlignment = UITextAlignmentLeft;
    headerLabel2.font = [UIFont boldSystemFontOfSize:14];
    headerLabel2.frame = CGRectMake(205, 0.0, 90, 25);
    headerLabel2.text = @"    Location"; // i.e. array element
    [customView addSubview:headerLabel2];
    
	return customView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ArryMyMates count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   // if (cell == Nil)
   // {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  //  }
    if (indexPath.row % 2 !=0)
    {
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg.png"]];
        tempImageView.contentMode = UIViewContentModeScaleToFill;
        tempImageView.frame = CGRectMake(cell.frame.origin.x + 2 , 0, 296, 35);
        [cell.contentView addSubview:tempImageView];
    }
    
    UILabel * lblName = [[UILabel alloc] initWithFrame:CGRectZero];
    lblName.backgroundColor = [UIColor clearColor];
    lblName.textColor = [UIColor colorWithRed:87.0/255.0 green:42.0/255.0 blue:124.0/255.0 alpha:1.0];
    lblName.font = [UIFont boldSystemFontOfSize:13];
    lblName.frame = CGRectMake(5, 5, 120, 25);
    lblName.textAlignment = UITextAlignmentLeft;
    lblName.text = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryMyMates objectAtIndex:indexPath.row]valueForKey:@"fullname"]]]; // i.e. array element
    [cell addSubview:lblName];
    
    UILabel * lblPoint = [[UILabel alloc] initWithFrame:CGRectZero];
    lblPoint.backgroundColor = [UIColor clearColor];
    lblPoint.textAlignment = UITextAlignmentLeft;
    lblPoint.textColor = [UIColor colorWithRed:87.0/255.0 green:42.0/255.0 blue:124.0/255.0 alpha:1.0];
    lblPoint.font = [UIFont systemFontOfSize:12];
    lblPoint.frame = CGRectMake(127, 5, 90, 25);
    lblPoint.text = [self removeNull:[NSString stringWithFormat:@"%@",[[ArryMyMates objectAtIndex:indexPath.row] valueForKey:@"vOccupation"]]]; // i.e. array element
    [cell addSubview:lblPoint];
    
    UILabel * lblDate = [[UILabel alloc] initWithFrame:CGRectZero];
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.textColor = [UIColor colorWithRed:84.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1.0];
    lblDate.font = [UIFont systemFontOfSize:12];
    lblDate.frame = CGRectMake(220, 5, 90, 25);
    lblDate.textAlignment = UITextAlignmentLeft;
    lblDate.text = [self removeNull:[NSString stringWithFormat:@"%@,%@",[[ArryMyMates objectAtIndex:indexPath.row] valueForKey:@"vLocation"],[[ArryMyMates objectAtIndex:indexPath.row] valueForKey:@"vCountry"]]]; // i.e. array element
    [cell addSubview:lblDate];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllProfileViewController *obj_AllProfileViewController = [[AllProfileViewController alloc]initWithNibName:@"AllProfileViewController" bundle:nil];
    obj_AllProfileViewController.strConnHidden = @"HiddenYes";
    profileId = [NSString stringWithFormat:@"%@",[[ArryMyMates objectAtIndex:indexPath.row]valueForKey:@"iUserID"]];
    [self.navigationController pushViewController:obj_AllProfileViewController animated:YES];
    obj_AllProfileViewController = nil;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

#pragma mark - Remove NULL

- (NSString *)removeNull:(NSString *)str
{
    str = [NSString stringWithFormat:@"%@",str];    
    if (!str) {
        return @"";
    }
    else if([str isEqualToString:@"<null>"]){
        return @"";
    }
    else if([str isEqualToString:@"(null)"]){
        return @"";
    }
    else{
        return str;
    }
}

#pragma mark - AlertView Delegate Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Extra Methods
- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
