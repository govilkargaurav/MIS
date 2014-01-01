//
//  ViewContactPressed.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewContactPressed.h"
#import "AddContactViewCtr.h"
#import "AppDelegate.h"

@implementation ViewContactPressed
@synthesize strID;
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
    
    /*self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(EditPressed)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor orangeColor];*/

    [self GetValues];
    
   /* UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, 320, 44)];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 44)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment=UITextAlignmentCenter;
    headerLabel.font = [UIFont boldSystemFontOfSize:24];
    headerLabel.text = @"Info";
    [customView addSubview:headerLabel];
    
    btnFav = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFav setFrame:CGRectMake(160, 8, 28, 28)];*/
    if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"viewcount"] intValue] == 0)
    {
        [btnFav setImage:[UIImage imageNamed:@"star_silver.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnFav setImage:[UIImage imageNamed:@"star_gold.png"] forState:UIControlStateNormal];
    }
   /* [btnFav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnFav addTarget:self action:@selector(btnFavPressed) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:btnFav];
    self.navigationItem.titleView=customView;*/
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    // Add iAd
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdShowSetFrame) name:@"iAdShowSetFrame" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdHideSetFrame) name:@"iAdHideSetFrame" object:nil];

    if (AppDel.isiAdVisible)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
        if (isiPhone5)
        {
            tbl_ViewCont.frame = CGRectMake(0, 44, 320, 454);
        }
        else
        {
            tbl_ViewCont.frame = CGRectMake(0, 44, 320, 366);
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
        if (isiPhone5)
        {
            tbl_ViewCont.frame = CGRectMake(0, 44, 320, 504);
        }
        else
        {
            tbl_ViewCont.frame = CGRectMake(0, 44, 320, 416);
        }
    }
    
    [self GetValues];
}
// Set Frame OF view according to iAd show/hide
-(void)iAdShowSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_ViewCont.frame = CGRectMake(0, 44, 320, 454);
    }
    else
    {
        tbl_ViewCont.frame = CGRectMake(0, 44, 320, 366);
    }
}
-(void)iAdHideSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_ViewCont.frame = CGRectMake(0, 44, 320, 504);
    }
    else
    {
        tbl_ViewCont.frame = CGRectMake(0, 44, 320, 416);
    }
}

-(void)GetValues
{
    NSString *strQuery_Select_Contact =[NSString stringWithFormat:@"SELECT * FROM tbl_addcontacts where id=%d",[strID intValue]];
    ArryViewCont = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_addcontacts:strQuery_Select_Contact]];
    ArryLblPhone=[[NSMutableArray alloc]init];
    ArrylblEmail=[[NSMutableArray alloc]init];
    ArryPhoneValue=[[NSMutableArray alloc]init];
    ArryEmailValue=[[NSMutableArray alloc]init];
    if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"Mobile"] isEqualToString:@"(null)"]) 
    {
        if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"Mobile"] isEqualToString:@""]) 
        {
            [ArryLblPhone addObject:@"mobile"];
            [ArryPhoneValue addObject:[[ArryViewCont objectAtIndex:0]valueForKey:@"Mobile"]];
        }
    }
    if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"homephone"] isEqualToString:@"(null)"]) 
    {
        if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"homephone"] isEqualToString:@""])
        {
            [ArryLblPhone addObject:@"home"];
            [ArryPhoneValue addObject:[[ArryViewCont objectAtIndex:0]valueForKey:@"homephone"]];
        }
    }
    if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"workphone"] isEqualToString:@"(null)"]) 
    {
        if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"workphone"] isEqualToString:@""])
        {
            [ArryLblPhone addObject:@"work"];
            [ArryPhoneValue addObject:[[ArryViewCont objectAtIndex:0]valueForKey:@"workphone"]];
        }
    }
    if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"otherphone"] isEqualToString:@"(null)"]) 
    {
        if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"otherphone"] isEqualToString:@""])
        {
            [ArryLblPhone addObject:@"other"];
            [ArryPhoneValue addObject:[[ArryViewCont objectAtIndex:0]valueForKey:@"otherphone"]];
        }
    }
    if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"Home"] isEqualToString:@"(null)"]) 
    {
        if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"Home"] isEqualToString:@""])
        {
            [ArrylblEmail addObject:@"home"];
            [ArryEmailValue addObject:[[ArryViewCont objectAtIndex:0]valueForKey:@"Home"]];

        }
    }
    if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"workemail"] isEqualToString:@"(null)"]) 
    {
        if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"workemail"] isEqualToString:@""])
        {
            [ArrylblEmail addObject:@"work"];
            [ArryEmailValue addObject:[[ArryViewCont objectAtIndex:0]valueForKey:@"workemail"]];
        }
    }
    if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"otheremail"] isEqualToString:@"(null)"]) 
    {
        if (![[[ArryViewCont objectAtIndex:0]valueForKey:@"otheremail"] isEqualToString:@""])
        {
            [ArrylblEmail addObject:@"other"];
            [ArryEmailValue addObject:[[ArryViewCont objectAtIndex:0]valueForKey:@"otheremail"]];
        }
    }
    [tbl_ViewCont reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        return [ArryLblPhone count];
    }
    else if (section == 3)
    {
        return [ArrylblEmail count];
    }
    else if (section == 4)
    {
        return 1;
    }
    return 0;
        
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) 
    {
        if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"LastName"] isEqualToString:@"(null)"] || [[[ArryViewCont objectAtIndex:0]valueForKey:@"LastName"] isEqualToString:@""]) 
        {
            return [NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"Firstname"]];
        }
        else
        {
            return [NSString stringWithFormat:@"%@ %@",[[ArryViewCont objectAtIndex:0]valueForKey:@"Firstname"],[[ArryViewCont objectAtIndex:0]valueForKey:@"LastName"]];
        }
    }
    else if (section == 2)
    {
        if ([ArryLblPhone count] == 0)
        {
            return nil;
        }
        else
        {
            return @"Phone";
        }
    }
    else if (section == 3)
    {
        if ([ArrylblEmail count] == 0)
        {
            return nil;
        }
        else
        {
            return @"Email";
        }
    }
    return nil;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.section == 0)
    {
        UILabel *lblTitleSelect=[[UILabel alloc] init];
        lblTitleSelect.frame=CGRectMake(18,15,70,15);
        lblTitleSelect.backgroundColor=[UIColor clearColor];
        lblTitleSelect.textColor=[UIColor orangeColor];
        lblTitleSelect.textAlignment=UITextAlignmentRight;
        lblTitleSelect.font=[UIFont boldSystemFontOfSize:14.0f];
        lblTitleSelect.lineBreakMode = UILineBreakModeTailTruncation;
        lblTitleSelect.text=@"category";
        [cell addSubview:lblTitleSelect];
        
        UILabel *lblSelect=[[UILabel alloc] init];
        lblSelect.frame=CGRectMake(100,12,200,19);
        lblSelect.backgroundColor=[UIColor clearColor];
        lblSelect.textAlignment=UITextAlignmentLeft;
        lblSelect.font=[UIFont boldSystemFontOfSize:16.0f];
        lblSelect.lineBreakMode = UILineBreakModeTailTruncation;
        lblSelect.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"Category"]];
        [cell addSubview:lblSelect];
        
    }
    if (indexPath.section == 1)
    {
        UILabel *lblTitleSelect=[[UILabel alloc] init];
        lblTitleSelect.frame=CGRectMake(18,15,70,15);
        lblTitleSelect.backgroundColor=[UIColor clearColor];
        lblTitleSelect.textColor=[UIColor orangeColor];
        lblTitleSelect.textAlignment=UITextAlignmentRight;
        lblTitleSelect.font=[UIFont boldSystemFontOfSize:14.0f];
        lblTitleSelect.lineBreakMode = UILineBreakModeTailTruncation;
        lblTitleSelect.text=@"company";
        [cell addSubview:lblTitleSelect];
        
        UILabel *lblSelect=[[UILabel alloc] init];
        lblSelect.frame=CGRectMake(100,12,200,19);
        lblSelect.backgroundColor=[UIColor clearColor];
        lblSelect.textAlignment=UITextAlignmentLeft;
        lblSelect.font=[UIFont boldSystemFontOfSize:16.0f];
        lblSelect.lineBreakMode = UILineBreakModeTailTruncation;
        if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"Company"] isEqualToString:@"(null)"] || [[[ArryViewCont objectAtIndex:0]valueForKey:@"Company"] isEqualToString:@""]) 
        {
            lblSelect.text=@"company";
            lblSelect.textColor=[UIColor lightGrayColor];
        }
        else
        {
            lblSelect.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"Company"]];
        }
        [cell addSubview:lblSelect];
    }
    else if (indexPath.section == 2)
    {
        UILabel *lblTitle=[[UILabel alloc] init];
        lblTitle.frame=CGRectMake(18,11,70,21);
        lblTitle.backgroundColor=[UIColor clearColor];
        lblTitle.textColor=[UIColor orangeColor];
        lblTitle.textAlignment=UITextAlignmentRight;
        lblTitle.font=[UIFont boldSystemFontOfSize:14.0f];
        lblTitle.lineBreakMode = UILineBreakModeTailTruncation;
        lblTitle.text=[NSString stringWithFormat:@"%@",[ArryLblPhone objectAtIndex:indexPath.row]];
        [cell addSubview:lblTitle];
        
        UILabel *lblSelect=[[UILabel alloc] init];
        lblSelect.frame=CGRectMake(100,12,200,19);
        lblSelect.backgroundColor=[UIColor clearColor];
        lblSelect.textAlignment=UITextAlignmentLeft;
        lblSelect.font=[UIFont boldSystemFontOfSize:16.0f];
        lblSelect.lineBreakMode = UILineBreakModeTailTruncation;
        lblSelect.text=[NSString stringWithFormat:@"%@",[ArryPhoneValue objectAtIndex:indexPath.row]];
        [cell addSubview:lblSelect];
        
    }
    else if (indexPath.section == 3)
    {
        UILabel *lblTitle1=[[UILabel alloc] init];
        lblTitle1.frame=CGRectMake(18,11,70,21);
        lblTitle1.backgroundColor=[UIColor clearColor];
        lblTitle1.textAlignment=UITextAlignmentRight;
        lblTitle1.textColor=[UIColor orangeColor];
        lblTitle1.font=[UIFont boldSystemFontOfSize:14.0f];
        lblTitle1.lineBreakMode = UILineBreakModeTailTruncation;
        lblTitle1.text=[NSString stringWithFormat:@"%@",[ArrylblEmail objectAtIndex:indexPath.row]];
        [cell addSubview:lblTitle1];
        
        UILabel *lblSelect=[[UILabel alloc] init];
        lblSelect.frame=CGRectMake(100,12,200,19);
        lblSelect.backgroundColor=[UIColor clearColor];
        lblSelect.textAlignment=UITextAlignmentLeft;
        lblSelect.font=[UIFont boldSystemFontOfSize:16.0f];
        lblSelect.lineBreakMode = UILineBreakModeTailTruncation;
        lblSelect.text=[NSString stringWithFormat:@"%@",[ArryEmailValue objectAtIndex:indexPath.row]];
        [cell addSubview:lblSelect];
        
    }
    else if (indexPath.section == 4)
    {
        UILabel *lblTitleSelect=[[UILabel alloc] init];
        lblTitleSelect.frame=CGRectMake(10,15,78,15);
        lblTitleSelect.backgroundColor=[UIColor clearColor];
        lblTitleSelect.textColor=[UIColor orangeColor];
        lblTitleSelect.textAlignment=UITextAlignmentRight;
        lblTitleSelect.font=[UIFont boldSystemFontOfSize:14.0f];
        lblTitleSelect.lineBreakMode = UILineBreakModeTailTruncation;
        lblTitleSelect.text=@"home page";
        [cell addSubview:lblTitleSelect];
        
        UILabel *lblSelect=[[UILabel alloc] init];
        lblSelect.frame=CGRectMake(100,12,200,19);
        lblSelect.backgroundColor=[UIColor clearColor];
        lblSelect.textAlignment=UITextAlignmentLeft;
        lblSelect.font=[UIFont boldSystemFontOfSize:16.0f];
        lblSelect.lineBreakMode = UILineBreakModeTailTruncation;
        if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"HomePage"] isEqualToString:@"(null)"] || [[[ArryViewCont objectAtIndex:0]valueForKey:@"HomePage"] isEqualToString:@""]) 
        {
            lblSelect.text=@"url";
            lblSelect.textColor=[UIColor lightGrayColor];
        }
        else
        {
            lblSelect.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"HomePage"]];
        }
        [cell addSubview:lblSelect];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the cell.
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        [self CallToPhoneNumbers:[ArryPhoneValue objectAtIndex:indexPath.row]]; 
    }
    else if (indexPath.section == 3)
    {
        [self CallToEmail:[ArryEmailValue objectAtIndex:indexPath.row]];
    }
}
-(void)CallToPhoneNumbers:(NSString*)strPhoneNumberPass
{
    strPhoneNumber = [NSString stringWithFormat:@"%@",strPhoneNumberPass];
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:APP_NAME delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Call Contact",@"Send Message",@"Cancel",nil];
    popupQuery.tag=2;
    popupQuery.destructiveButtonIndex = 2;
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [popupQuery showInView:self.view];
}
-(void)CallToEmail:(NSString*)strEmailID
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSArray *torecipients=[NSArray arrayWithObject:strEmailID];
        [mailer setToRecipients:torecipients];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet or add E-mail account from setting." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    
    if (actionSheet.tag == 2)
    {
        if (buttonIndex == 0) 
        {
            NSMutableString *strippedString = [NSMutableString 
                                               stringWithCapacity:strPhoneNumber.length];
            
            NSScanner *scanner = [NSScanner scannerWithString:strPhoneNumber];
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
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"You can not call from %@!",[device model]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }   
        else if (buttonIndex == 1)
        {
            if([MFMessageComposeViewController canSendText])
            {
                MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
                controller.recipients = [NSArray arrayWithObjects:strPhoneNumber, nil];
                controller.messageComposeDelegate = self;
                [self presentModalViewController:controller animated:YES];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" 
                                                                message:@"Your device doesn't support the sms composer" 
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }
        else if (buttonIndex == 2)
        {
            return;
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
			break;
		case MFMailComposeResultSaved:
            strMailSentMsg = @"Mail saved: you saved the email message in the Drafts folder";
			break;
		case MFMailComposeResultSent:
            strMailSentMsg = @"Mail send";
			break;
		case MFMailComposeResultFailed:
            strMailSentMsg = @"Mail failed: the email message was nog saved or queued, possibly due to an error";
			break;
		default:
            strMailSentMsg = @"Mail not sent";
			break;
	}
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strMailSentMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
	[self dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result 
{
    NSString *strSMSSentMsg;
	switch (result)
	{
		case MessageComposeResultCancelled:
            strSMSSentMsg = @"Result: canceled";
			break;
		case MessageComposeResultSent:
            strSMSSentMsg = @"Result: sent";
			break;
		case MessageComposeResultFailed:
            strSMSSentMsg = @"Result: failed";
			break;
		default:
            strSMSSentMsg = @"Result: not sent";
			break;
	}
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strSMSSentMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
	[self dismissModalViewControllerAnimated:YES];
	
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdBannerView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdShowSetFrame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdHideSetFrame" object:nil];
}
#pragma mark - IBAction Methods
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnEditPressed:(id)sender
{
    AddContactViewCtr *obj_AddContactViewCtr=[[AddContactViewCtr alloc]initWithNibName:@"AddContactViewCtr" bundle:nil];
    obj_AddContactViewCtr.strEdit=@"Edit";
    obj_AddContactViewCtr.strPassID=[NSString stringWithFormat:@"%@",strID];
    [self.navigationController pushViewController:obj_AddContactViewCtr animated:YES];
    obj_AddContactViewCtr=nil;
}
-(IBAction)btnFavPressed:(id)sender
{
    int TotalCount ;
    if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"viewcount"] intValue] == 0)
    {
        TotalCount = 1;
        [btnFav setImage:[UIImage imageNamed:@"star_gold.png"] forState:UIControlStateNormal];
    }
    else
    {
        TotalCount = 0;
        [btnFav setImage:[UIImage imageNamed:@"star_silver.png"] forState:UIControlStateNormal];
    }
    NSString *strQuery_Update_Contact = [NSString stringWithFormat:@"update tbl_addcontacts Set favstatus=%d Where id=%d",TotalCount,[strID intValue]];
    [DatabaseAccess InsertUpdateDeleteQuery:strQuery_Update_Contact];
    [self GetValues];
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
