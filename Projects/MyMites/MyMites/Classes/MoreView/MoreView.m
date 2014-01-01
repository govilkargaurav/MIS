//
//  MoreView.m
//  MyMite
//
//  Created by Vivek Rajput on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MoreView.h"
#import "PageLoadViewCtr.h"
#import "ContactUsViewCtr.h"

@implementation MoreView

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
    [tbl_MoreViewList setFrame:tbl_MoreViewList.frame]; 
    tbl_MoreViewList.backgroundView = tempImageView;
    
    ArryMoreList = [[NSMutableArray alloc]initWithObjects:@"FAQ’s",@"How it works",@"Privacy policy",@"Terms & Conditions",@"Contact us",@"About this App",@"Send us App feedback", nil];
    [tbl_MoreViewList reloadData];
    

    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark- TableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ArryMoreList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   // if (cell == nil)
    //{
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //}
    
    if (indexPath.row % 2 !=0)
    {
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg.png"]];  
        tempImageView.contentMode = UIViewContentModeScaleToFill;
        tempImageView.frame = CGRectMake(cell.frame.origin.x + 2 , 0, 296, 40);
        [cell.contentView addSubview:tempImageView];
    }
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor colorWithRed:87.0/255.0 green:42.0/255.0 blue:124.0/255.0 alpha:1.0];
    lblTitle.font = [UIFont boldSystemFontOfSize:18];
    lblTitle.frame = CGRectMake(5, 8, 290, 25);
    lblTitle.textAlignment = UITextAlignmentCenter;
    lblTitle.text = [NSString stringWithFormat:@"%@",[ArryMoreList objectAtIndex:indexPath.row]]; // i.e. array element
    [cell.contentView addSubview:lblTitle];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    @"FAQ’s",@"How it works",@"Privacy policy",@"Terms & Conditions",@"Contact us",@"About this App",@"Send us App feedback"
    if (indexPath.row == 0)
    {
        [self SelfNavigationView:@"FAQ’s" Link:@"http://mym8te.com/andy/webservices/page.php?iPageID=13"];
    }
    else if (indexPath.row == 1)
    {
        [self SelfNavigationView:@"How it works" Link:@"http://mym8te.com/andy/video/Mym8tewmvformat.mp4"];
    }
    else if (indexPath.row == 2)
    {
        [self SelfNavigationView:@"Privacy policy" Link:@"http://mym8te.com/andy/webservices/page.php?iPageID=10"];
    }
    else if (indexPath.row == 3)
    {
        [self SelfNavigationView:@"Terms & Conditions" Link:@"http://mym8te.com/andy/webservices/page.php?iPageID=8"];
    }
    else if (indexPath.row == 4)
    {
        ContactUsViewCtr *obj_ContactUsViewCtr = [[ContactUsViewCtr alloc]initWithNibName:@"ContactUsViewCtr" bundle:nil];
        [self.navigationController pushViewController:obj_ContactUsViewCtr animated:YES];
        obj_ContactUsViewCtr = nil;
    }
    else if (indexPath.row == 5)
    {
        [self SelfNavigationView:@"About this App" Link:@""];
    }
    else if (indexPath.row == 6)
    {
        if ([MFMailComposeViewController canSendMail])
        {        
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            NSArray *torecipients=[NSArray arrayWithObject:@"info@mym8te.com"];
            [controller setToRecipients:torecipients];
            [controller setSubject:@"Feedback"];
            [self presentModalViewController:controller animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}
-(void)SelfNavigationView:(NSString*)strTitle Link:(NSString*)strLink
{
    PageLoadViewCtr *obj_PageLoadViewCtr = [[PageLoadViewCtr alloc]initWithNibName:@"PageLoadViewCtr" bundle:nil];
    obj_PageLoadViewCtr.strTitle = strTitle;
    obj_PageLoadViewCtr.strLink = strLink;
    [self.navigationController pushViewController:obj_PageLoadViewCtr animated:YES];
    obj_PageLoadViewCtr = nil;
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
