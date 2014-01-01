//
//  HowItWorks.m
//  MyMite
//
//  Created by Vivek Rajput on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HowItWorks.h"
#import "JSON.h"
#import "BusyAgent.h"
#import "AppConstat.h"
#import "SearchResult.h"
#import "GlobalClass.h"

@implementation HowItWorks

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
    [tbl_RecentSearch setFrame:tbl_RecentSearch.frame]; 
    tbl_RecentSearch.backgroundView = tempImageView;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *Info = [NSUserDefaults standardUserDefaults];
    if (![[Info valueForKey:@"Login"] isEqualToString:@"LoginValue"]) 
    {
        Login *objLogin = [[Login alloc]initWithNibName:@"Login" bundle:nil];
        objLogin.strSetHideCancelbtn=@"Yes";
        objLogin.strMessageTitle = @"Please login to access this feature.";
        [self presentModalViewController:objLogin animated:NO];
    }
    else
    {
        [self CallURL];  
    }
}
-(void)CallURL
{
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
    responseData = [[NSMutableData alloc] init];
    results=[[NSDictionary alloc]init];
    NSString *strLogin=[NSString stringWithFormat:@"%@webservices/recentsearch.php?iUserID=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strLogin]];
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
    results = [responseString JSONValue];
    NSString *strMsg =[self removeNull:[NSString stringWithFormat:@"%@",[results valueForKey:@"msg"]]];
    if ([strMsg isEqualToString:@"no data found"]) 
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:APP_Name message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        [tbl_RecentSearch reloadData];
    }
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}

#pragma mark- TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [results count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  //  if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (indexPath.row % 2 !=0)
        {
            UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg.png"]];  
            tempImageView.contentMode = UIViewContentModeScaleToFill;
            tempImageView.frame = CGRectMake(cell.frame.origin.x + 2 , 0, 296, 40);
            [cell.contentView addSubview:tempImageView];
        }
        
        NSString *strCity = [self removeNull:[NSString stringWithFormat:@"%@",[[results valueForKey:@"vCity"] objectAtIndex:indexPath.row]]];
        NSString *strOccu = [self removeNull:[NSString stringWithFormat:@"%@",[[results valueForKey:@"vOccupation"] objectAtIndex:indexPath.row]]];
        if ([strCity isEqualToString:@""])
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[results valueForKey:@"vOccupation"] objectAtIndex:indexPath.row]];
        }
        else if ([strOccu isEqualToString:@""])
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[results valueForKey:@"vCity"] objectAtIndex:indexPath.row]];
        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ in %@",[[results valueForKey:@"vOccupation"] objectAtIndex:indexPath.row],[[results valueForKey:@"vCity"] objectAtIndex:indexPath.row]];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        cell.textLabel.textAlignment=UITextAlignmentLeft;
        cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
   // }
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResult *obj_SearchResult = [[SearchResult alloc]initWithNibName:@"SearchResult" bundle:nil];
    obj_SearchResult.strTitle = @"Recent Search";
    obj_SearchResult.strLoc = [self removeNull:[NSString stringWithFormat:@"%@",[[results valueForKey:@"vCity"] objectAtIndex:indexPath.row]]];
    obj_SearchResult.strOccu = [self removeNull:[NSString stringWithFormat:@"%@",[[results valueForKey:@"vOccupation"] objectAtIndex:indexPath.row]]];
    [self.navigationController pushViewController:obj_SearchResult animated:YES];
    obj_SearchResult = nil;
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
