//
//  RatingViewCtr.m
//  MyMites
//
//  Created by apple on 11/2/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "RatingViewCtr.h"
#import "AppConstat.h"
#import "JSON.h"
#import "BusyAgent.h"
#import "CCellRatings.h"

@implementation RatingViewCtr

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
    tbl_Ratings.backgroundView = tempImageView;
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    responseData = [[NSMutableData alloc] init];
    DicRatings = [[NSMutableDictionary alloc] init];
    NSString *strpass = [[NSString stringWithFormat:@"%@webservices/rattings.php?iUserID=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    DicRatings = [responseString JSONValue];
    
    NSString *strMsg =[self removeNull:[NSString stringWithFormat:@"%@",[DicRatings valueForKey:@"msg"]]];
    if ([strMsg isEqualToString:@"no rating found"]) 
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:APP_Name message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = 1;
        [alertView show];
    }
    else
    {
        lblAvgRate.text = [NSString stringWithFormat:@"%@/5",[DicRatings valueForKey:@"avg_reting"]];
        NSString *strAppend;
        if ([[DicRatings valueForKey:@"reting_count"] intValue] == 1)
        {
            strAppend = @"";
        }
        else
        {
            strAppend = @"s";
        }
        lblRateCount.text = [NSString stringWithFormat:@"%@ Customer%@",[DicRatings valueForKey:@"reting_count"],strAppend];
        
        AvgRat.starImage = [UIImage imageNamed:@"star1.png"];
        AvgRat.starHighlightedImage = [UIImage imageNamed:@"starhighlighted.png"];
        AvgRat.maxRating = 5.0;
        AvgRat.horizontalMargin = 5.0;
        AvgRat.userInteractionEnabled = NO;
        AvgRat.rating = [[DicRatings valueForKey:@"avg_reting"] floatValue];
        AvgRat.displayMode = EDStarRatingDisplayHalf;

        
        [tbl_Ratings reloadData];
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
    return [[DicRatings valueForKey:@"user_ratings"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == Nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSMutableDictionary *d=[[DicRatings valueForKey:@"user_ratings"] objectAtIndex:indexPath.row];
        
        CCellRatings *obj_CCellRatings=[[CCellRatings alloc] initWithNibName:@"CCellRatings" bundle:nil andD:d];
        [cell addSubview:obj_CCellRatings.view];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}

#pragma IBAction Methods

-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
