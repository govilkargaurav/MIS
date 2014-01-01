//
//  MateSearchViewCtr.m
//  MyMites
//
//  Created by Apple-Openxcell on 9/8/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "MateSearchViewCtr.h"
#import "AppConstat.h"
#import "JSON.h"
#import "CCellAddMate.h"
#import "BusyAgent.h"
#import "FsenetAppDelegate.h"

@implementation MateSearchViewCtr
@synthesize strName,strLocation,strOccupation;
@synthesize statuses,requestMain;

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
    ArryMyMatesSearch = [[NSMutableArray alloc] init];
    NSString *strpass = [[NSString stringWithFormat:@"%@webservices/search_mate.php?iUserID=%@&name=%@&location=%@&occupation=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"],strName,strLocation,strOccupation]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    ArryMyMatesSearch = [responseString JSONValue];
    NSString *strMsg =[self removeNull:[NSString stringWithFormat:@"%@",[ArryMyMatesSearch valueForKey:@"msg"]]];
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
#pragma mark - IBAction Methods
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ArryMyMatesSearch count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSMutableDictionary *d=[ArryMyMatesSearch objectAtIndex:indexPath.row];
        
        CCellAddMate *obj_CCellAddMate=[[CCellAddMate alloc] initWithNibName:@"CCellAddMate" bundle:nil andD:d indexpathval:indexPath.row];
        [cell addSubview:obj_CCellAddMate.view];
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
    return 90;
}


-(IBAction)btnAddMatePressed:(id)sender{
    
    UIButton *btnMate = (UIButton*)sender;
    if ([[btnMate currentTitle] isEqualToString:@"Add Mate"])
    {
        [self performSelectorInBackground:@selector(busyAgent) withObject:self];
        FsenetAppDelegate *appdel = (FsenetAppDelegate *)[[UIApplication sharedApplication]delegate];
        if( ![appdel checkConnection]) 
        {
            DisplayNoInternate;
        }
        else
        {
            NSString *senderEmail = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"vEmail"]];
            NSString *reciversEmail = [NSString stringWithFormat:@"%@",[[ArryMyMatesSearch objectAtIndex:[sender tag]] valueForKey:@"vEmail"]];
            NSString *sendersId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
            NSString *reciversId = [NSString stringWithFormat:@"%@",[[ArryMyMatesSearch objectAtIndex:[sender tag]] valueForKey:@"iUserID"]];
            NSString *sendersFullName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"vFullName"]];
            
            SBJSON *parser = [[SBJSON alloc] init];
            requestMain = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@webservices/send_mate_request.php?req_sender_email=%@&req_receiver_email=%@&req_sender_id=%@&req_receiver_id=%@&sender_fullname=%@",APP_URL,senderEmail,reciversEmail,sendersId,reciversId,sendersFullName]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
            
            NSData *response = [NSURLConnection sendSynchronousRequest:requestMain returningResponse:nil error:nil];
            NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            statuses = [parser objectWithString:json_string error:nil];
            
            
            if ([[statuses valueForKey:@"msg"] isEqualToString:@"Request sent"])
            {
                DisplayAlertWithTitle(APP_Name,@"Request Sent Successfully!!!");
                [btnMate setTitle:@"Request sent" forState:UIControlStateNormal];
            }
            else
            {
                DisplayAlertWithTitle(APP_Name,[statuses valueForKey:@"msg"]);
            }
        }

    }
    else if ([[btnMate currentTitle] isEqualToString:@"Connected"])
    {
        DisplayAlertWithTitle(APP_Name,@"You are already Connected");
    }
    else if ([[btnMate currentTitle] isEqualToString:@"Pending"] || [[btnMate currentTitle]isEqualToString:@"Request sent"])
    {
        DisplayAlertWithTitle(APP_Name, @"Request sent already!!!");
    }
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    
}

-(void)busyAgent{
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
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
