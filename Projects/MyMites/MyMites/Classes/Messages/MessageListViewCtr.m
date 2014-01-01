//
//  MessageListViewCtr.m
//  MyMites
//
//  Created by Apple-Openxcell on 10/2/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "MessageListViewCtr.h"
#import "BusyAgent.h"
#import "AppConstat.h"
#import "JSON.h"
#import "CCellMessage.h"
#import "MessageThreadViewCtr.h"

@implementation MessageListViewCtr

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
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [tbl_Messages removeFromSuperview];
    tbl_Messages = [[UITableView alloc]initWithFrame:CGRectMake(10, 134, 300, 260) style:UITableViewStylePlain];
    tbl_Messages.delegate = self;
    tbl_Messages.dataSource = self;
    tbl_Messages.backgroundColor = [UIColor clearColor];
    tbl_Messages.separatorColor = [UIColor clearColor];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointstblbg1.png"]];
    tbl_Messages.backgroundView = tempImageView;
    [self.view addSubview:tbl_Messages];
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    responseData = [[NSMutableData alloc] init];
    ArryDicResult = [[NSMutableArray alloc] init];
    NSString *strpass = [[NSString stringWithFormat:@"%@webservices/inbox.php?iUserID=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strpass]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    [super viewWillAppear:animated];
}

-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    ArryDicResult = [responseString JSONValue];
    
    NSString *strMsg =[self removeNull:[NSString stringWithFormat:@"%@",[ArryDicResult valueForKey:@"msg"]]];
    if ([strMsg isEqualToString:@"no data found"]) 
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:APP_Name message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = 1;
        [alertView show];
    }
    else
    {
        [tbl_Messages reloadData];
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
    return [ArryDicResult count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == Nil)
     {
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       
         NSMutableDictionary *d = [ArryDicResult objectAtIndex:indexPath.row];
    
        CCellMessage *obj_CCellMessage=[[CCellMessage alloc] initWithNibName:@"CCellMessage" bundle:nil andD:d type:@"Single" rowint:indexPath.row];
        [cell addSubview:obj_CCellMessage.view];
        obj_CCellMessage=nil;
     }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageThreadViewCtr *obj_MessageThreadViewCtr = [[MessageThreadViewCtr alloc]initWithNibName:@"MessageThreadViewCtr" bundle:nil];
    
    obj_MessageThreadViewCtr.striFromId = [NSString stringWithFormat:@"%@",[[ArryDicResult objectAtIndex:indexPath.row] valueForKey:@"iFromID"]]; 
    
    obj_MessageThreadViewCtr.striToId = [NSString stringWithFormat:@"%@",[[ArryDicResult objectAtIndex:indexPath.row] valueForKey:@"iToID"]];
    
    [self.navigationController pushViewController:obj_MessageThreadViewCtr animated:YES];
    obj_MessageThreadViewCtr = nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
