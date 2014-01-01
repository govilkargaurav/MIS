//
//  PointsViewCtr.m
//  MyMites
//
//  Created by Apple-Openxcell on 10/1/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "PointsViewCtr.h"
#import "BusyAgent.h"
#import "AppConstat.h"
#import "JSON.h"

@implementation PointsViewCtr

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
    [tbl_Points setFrame:tbl_Points.frame]; 
    tbl_Points.backgroundView = tempImageView;
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    responseData = [[NSMutableData alloc] init];
    results = [[NSMutableDictionary alloc] init];
    NSString *strpass = [NSString stringWithFormat:@"%@webservices/points.php?iUserID=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strpass]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    // Do any additional setup after loading the view from its nib.
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
    results = [responseString JSONValue];
    [tbl_Points reloadData];
    
    [self performSelector:@selector(PointTotalCount) withObject:nil afterDelay:0.00005];
}
-(void)PointTotalCount
{
    NSString *strurl3=[NSString stringWithFormat:@"%@webservices/total_points.php?iUserID=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
    NSURL *myurl3= [NSURL URLWithString:strurl3];
    NSString *strres3 = [[NSString alloc] initWithContentsOfURL:myurl3 encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dicLoc = [[NSDictionary alloc]init];
    dicLoc = [strres3 JSONValue];
    lblPoints.text = [NSString stringWithFormat:@"Current Balance : %@",[dicLoc valueForKey:@"tot_points"]];
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
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
        headerLabel.font = [UIFont boldSystemFontOfSize:16];
        headerLabel.frame = CGRectMake(5, 0.0, 100, 25);
        headerLabel.text = @"Profile Name"; // i.e. array element
        [customView addSubview:headerLabel];

        UILabel * headerLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel1.backgroundColor = [UIColor clearColor];
        headerLabel1.textColor = [UIColor whiteColor];
        headerLabel1.textAlignment = UITextAlignmentLeft;
        headerLabel1.font = [UIFont boldSystemFontOfSize:16];
        headerLabel1.frame = CGRectMake(150, 0.0, 100, 25);
        headerLabel1.text = @"Points"; // i.e. array element
        [customView addSubview:headerLabel1];
    
        UILabel * headerLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel2.backgroundColor = [UIColor clearColor];
        headerLabel2.textColor = [UIColor whiteColor];
        headerLabel2.textAlignment = UITextAlignmentLeft;
        headerLabel2.font = [UIFont boldSystemFontOfSize:16];
        headerLabel2.frame = CGRectMake(205, 0.0, 90, 25);
        headerLabel2.text = @"   Date"; // i.e. array element
        [customView addSubview:headerLabel2];
    
	return customView;
    
}
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
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   // if (cell == Nil)
   // {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    //}
    if (indexPath.row % 2 !=0)
    {
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg.png"]];  
        tempImageView.contentMode = UIViewContentModeScaleToFill;
        tempImageView.frame = CGRectMake(cell.frame.origin.x + 2 , 0, 296, 40);
        [cell.contentView addSubview:tempImageView];
    }
   
    UILabel * lblName = [[UILabel alloc] init];
    lblName.backgroundColor = [UIColor clearColor];
    lblName.textColor = [UIColor colorWithRed:87.0/255.0 green:42.0/255.0 blue:124.0/255.0 alpha:1.0];
    lblName.font = [UIFont boldSystemFontOfSize:13];
    lblName.frame = CGRectMake(5,7, 140, 30);
    lblName.textAlignment = UITextAlignmentLeft;
    lblName.numberOfLines = 2;
    lblName.lineBreakMode = UILineBreakModeWordWrap;
    lblName.text = [NSString stringWithFormat:@"%@",[[results valueForKey:@"vFullname"]objectAtIndex:indexPath.row]]; // i.e. array element
    [cell addSubview:lblName];
    
    UILabel * lblPoint = [[UILabel alloc] init];
    lblPoint.backgroundColor = [UIColor clearColor];
    lblPoint.textAlignment = UITextAlignmentLeft;
    lblPoint.textColor = [UIColor colorWithRed:87.0/255.0 green:42.0/255.0 blue:124.0/255.0 alpha:1.0];
    lblPoint.font = [UIFont systemFontOfSize:13];
    lblPoint.frame = CGRectMake(150, 8, 65, 25);
    if ([[[results valueForKey:@"vTransactionType"]objectAtIndex:indexPath.row] isEqualToString:@"in"])
    {
        lblPoint.text = [NSString stringWithFormat:@"+ %@",[[results valueForKey:@"iPoints"]objectAtIndex:indexPath.row]];
    }
    else
    {
        lblPoint.text = [NSString stringWithFormat:@"- %@",[[results valueForKey:@"iPoints"]objectAtIndex:indexPath.row]];
    }
    [cell addSubview:lblPoint];
    
    UILabel * lblDate = [[UILabel alloc] init];
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.textColor = [UIColor colorWithRed:84.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1.0];
    lblDate.font = [UIFont systemFontOfSize:13];
    lblDate.frame = CGRectMake(218, 8, 90, 25);
    lblDate.textAlignment = UITextAlignmentLeft;
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *DateCreat = [dateFormatter1 dateFromString:[[results valueForKey:@"dtTranDate"]objectAtIndex:indexPath.row]];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    dateFormatter2.dateFormat = @"MMM dd,yyyy";
    NSString *strDate = [dateFormatter2 stringFromDate:DateCreat];
    
    lblDate.text = [NSString stringWithFormat:@"%@",strDate]; // i.e. array element
    [cell addSubview:lblDate];
    
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
