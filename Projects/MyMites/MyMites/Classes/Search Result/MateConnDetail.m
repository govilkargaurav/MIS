//
//  MateConnDetail.m
//  MyMites
//
//  Created by apple on 10/29/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "MateConnDetail.h"
#import "BusyAgent.h"
#import "AppConstat.h"
#import "ImageViewURL.h"
#import "SearchResult_Cell.h"
#import "GlobalClass.h"
#import "CCellMateConn.h"

@implementation MateConnDetail
@synthesize strID,strName;

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
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
    responseData = [[NSMutableData alloc] init];
    ArryMyMates =[[NSMutableArray alloc]init];
    NSString *strsearch=[[NSString stringWithFormat:@"%@webservices/mutualmatecomments.php?iUserID1=%@&iUserID2=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"],strID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:strsearch]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request1 delegate:self];
    // Do any additional setup after loading the view from its nib.
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
        lblDisplayCount.text = [NSString stringWithFormat:@"Displaying %d connections found for %@",[ArryMyMates count],strName];
        [tblView reloadData];
    }
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}

#pragma mark - IBAction Methods

-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnViewProfilePressed:(id)sender
{
    viewprofileStr=@"1";
    
    RegisterORLogin *objRegisterORLogin = [[RegisterORLogin alloc]initWithNibName:@"RegisterORLogin" bundle:nil];
    profileId=[NSString stringWithFormat:@"%d",[sender tag]];
    [self.navigationController pushViewController:objRegisterORLogin animated:YES];
}

#pragma mark- TableView Delegate
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSMutableDictionary *d=[ArryMyMates objectAtIndex:indexPath.row];
        
        CCellMateConn *obj_SearchResult_Cell=[[CCellMateConn alloc] initWithNibName:@"CCellMateConn" bundle:nil andD:d name:strName];
        [cell addSubview:obj_SearchResult_Cell.view];
        
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155;
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
