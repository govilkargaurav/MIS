//
//  SearchResult.m
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchResult.h"
#import "BusyAgent.h"
#import "AppConstat.h"
#import "ImageViewURL.h"
#import "SearchResult_Cell.h"
#import "GlobalClass.h"
#import "MateConnDetail.h"

@implementation SearchResult
@synthesize strOccu,strLoc;
@synthesize strTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View Did Load

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblTitle.text = [NSString stringWithFormat:@"%@",strTitle];

    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
    
    responseData = [[NSMutableData alloc] init];
    ArrySearch =[[NSMutableArray alloc]init];
    NSString *strsearch;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Login"] isEqualToString:@"LoginValue"])
    {
        strsearch=[[NSString stringWithFormat:@"%@webservices/search.php?vLocation=%@&vOccupation=%@&iUserID=%@",APP_URL,strLoc,strOccu,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        strsearch=[[NSString stringWithFormat:@"%@webservices/search.php?vLocation=%@&vOccupation=%@",APP_URL,strLoc,strOccu] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:strsearch]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request1 delegate:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[MyMiteAppDelegate sharedInstance].myTabbar.tabBar.hidden=NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    ArrySearch = [responseString JSONValue];
    NSString *strMsg =[self removeNull:[NSString stringWithFormat:@"%@",[ArrySearch valueForKey:@"msg"]]];
    if ([strMsg isEqualToString:@"no data found"]) 
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:APP_Name message:@"Sorry, no results found!" delegate:self cancelButtonTitle:@"Try with alternate location/profession" otherButtonTitles:nil];
        alertView.tag = 1;
        [alertView show];
    }
    else
    {
        lblHeading.text = [NSString stringWithFormat:@"Displaying %d result(s) found for %@ in %@",[ArrySearch count],strOccu,strLoc];
        [tblView reloadData];
    }
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}

#pragma mark - Dealloc
#pragma mark - IBAction Methods
-(IBAction)ConnectClicked:(id)sender
{
    
/* Set VIewProfileString 1 to check on login that it comes from click on View Profile */
    viewprofileStr=@"1";
    
   RegisterORLogin *objRegisterORLogin = [[RegisterORLogin alloc]initWithNibName:@"RegisterORLogin" bundle:nil];
    profileId=[NSString stringWithFormat:@"%d",[sender tag]];
    [self.navigationController pushViewController:objRegisterORLogin animated:YES];
    
}
-(IBAction)MateConnPRessed:(id)sender
{
    MateConnDetail *obj_MateConnDetail = [[MateConnDetail alloc]initWithNibName:@"MateConnDetail" bundle:nil];
    obj_MateConnDetail.strID = [NSString stringWithFormat:@"%@",[[ArrySearch objectAtIndex:[sender tag] ]valueForKey:@"iUserID"]];
    obj_MateConnDetail.strName = [NSString stringWithFormat:@"%@ %@",[[ArrySearch objectAtIndex:[sender tag] ]valueForKey:@"vFirst"],[[ArrySearch objectAtIndex:[sender tag] ]valueForKey:@"vLast"]];
    [self.navigationController pushViewController:obj_MateConnDetail animated:YES];
    obj_MateConnDetail = nil;
}
-(IBAction)btnSearchMailPressed:(id)sender
{
    NSString *strEmailId = [NSString stringWithFormat:@"%@",[[ArrySearch objectAtIndex:[sender tag] ]valueForKey:@"vEmail"]];
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        NSArray *torecipients=[NSArray arrayWithObject:strEmailId];
        [controller setToRecipients:torecipients];
        [self presentModalViewController:controller animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
-(IBAction)btnSearchWebSitePressed:(id)sender
{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@",[[ArrySearch objectAtIndex:[sender tag] ]valueForKey:@"vWebsite"]];
    if (![strUrl hasPrefix:@"http://"])
    {
        strUrl = [NSString stringWithFormat:@"http://%@",[[ArrySearch objectAtIndex:[sender tag] ]valueForKey:@"vWebsite"]];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strUrl]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:APP_Name  message:@"Url is not proper" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
}
-(IBAction)btnMobileCallPressed:(id)sender
{
    NSString *strMobileno = [NSString stringWithFormat:@"%@",[[ArrySearch objectAtIndex:[sender tag] ]valueForKey:@"vMobile"]];
    [self CallToNumber:strMobileno];
}
-(IBAction)btnLandCallPressed:(id)sender
{
    NSString *strLandno = [NSString stringWithFormat:@"%@",[[ArrySearch objectAtIndex:[sender tag] ]valueForKey:@"vPhone"]];
    [self CallToNumber:strLandno];
}
-(void)CallToNumber:(NSString*)strNo
{
    NSString *strCallMsg = [NSString stringWithFormat:@"Would you like to call on %@ no?",strNo];
    UIAlertView *alertCall = [[UIAlertView alloc] initWithTitle:APP_Name message:strCallMsg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertCall.tag = 2;
    alertCall.title = strNo;
    [alertCall show];
}
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
    return [ArrySearch count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSMutableDictionary *d=[ArrySearch objectAtIndex:indexPath.row];
        SearchResult_Cell *obj_SearchResult_Cell=[[SearchResult_Cell alloc] initWithNibName:@"SearchResult_Cell" bundle:nil andD:d indexpathval:indexPath.row];
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
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            NSMutableString *strippedString = [NSMutableString
                                               stringWithCapacity:alertView.title.length];
            
            NSScanner *scanner = [NSScanner scannerWithString:alertView.title];
            NSCharacterSet *numbers = [NSCharacterSet
                                       characterSetWithCharactersInString:@"0123456789"];
            
            while ([scanner isAtEnd] == NO) {
                NSString *buffer;
                if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
                    [strippedString appendString:buffer];
                    
                } else {
                    [scanner setScanLocation:([scanner scanLocation] + 1)];
                }
            }
            
            UIDevice *device = [UIDevice currentDevice];
            if ([[device model] isEqualToString:@"iPhone"] )
            {
                NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",strippedString]];
                [[UIApplication sharedApplication] openURL:phoneNumberURL];
            }
            else
            {
                NSString *strMsg = [NSString stringWithFormat:@"You can not call from %@!",[device model]];
                DisplayAlertWithTitle(APP_Name, strMsg);
                return;
            }
        }
    }
}
#pragma mark - MFMailComposeController delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *strMailSentMsg;
	switch (result)
	{
		case MFMailComposeResultCancelled:
            strMailSentMsg = @"Mail cancelled: you cancelled the operation and no email message was queued";
            [self CallAlertView:strMailSentMsg];
			break;
		case MFMailComposeResultSaved:
            strMailSentMsg = @"Mail saved: you saved the email message in the Drafts folder";
            [self CallAlertView:strMailSentMsg];
			break;
		case MFMailComposeResultSent:
            strMailSentMsg = @"Mail send";
            [self CallAlertView:strMailSentMsg];
			break;
		case MFMailComposeResultFailed:
            strMailSentMsg = @"Mail failed: the email message was nog saved or queued, possibly due to an error";
            [self CallAlertView:strMailSentMsg];
			break;
		default:
            strMailSentMsg = @"Mail not sent";
            [self CallAlertView:strMailSentMsg];
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}
-(void)CallAlertView:(NSString *)strMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - Extra Methods
- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
