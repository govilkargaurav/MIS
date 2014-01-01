//
//  AllProfileViewController.m
//  MyMites
//
//  Created by apple on 9/13/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "AllProfileViewController.h"
#import "BusyAgent.h"
#import "AppConstat.h"
#import "JSON.h"
#import "ImageViewURL.h"
#import "ViewProfileViewCtr.h"
#import "GlobalClass.h"
#import "SBJSON.h"
#import "JSFavStarControl.h"

@implementation AllProfileViewController

@synthesize connectedMes;
@synthesize connectBtn;
@synthesize requestMain;
@synthesize statuses;
@synthesize strConnHidden;

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
    
    if ([strConnHidden isEqualToString:@"HiddenYes"])
    {
        connectBtn.hidden = YES;
    }
    else
    {
        connectBtn.hidden = NO;
    }
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    responseData = [[NSMutableData alloc] init];
    
    if (results!=nil) {
        results=nil;
        [results removeAllObjects];
        
    }
    results = [[NSMutableDictionary alloc] init];
    NSString *strpass = [NSString stringWithFormat:@"%@webservices/profile.php?iUserID=%@&iSelfID=%@",APP_URL,profileId,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
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
    results = [responseString JSONValue];
    ImageViewURL *x=[[ImageViewURL alloc] init];
    x.imgV=imgProfile;
	x.strUrl=[NSURL URLWithString:[results valueForKey:@"vImage"]];
    
    y= 96;
    
    lblFname.text = [self stringVerification:[NSString stringWithFormat:@"%@",[results valueForKey:@"vFirst"]]];
    lblLname.text = [self stringVerification:[NSString stringWithFormat:@"%@",[results valueForKey:@"vLast"]]];
    NSString *strBCoveringArea = [self stringVerification:[NSString stringWithFormat:@"%@",[results valueForKey:@"vLocation"]]];
    if (![strBCoveringArea isEqualToString:@"---"])
    {
        strBCoveringArea = [[results valueForKey:@"vLocation"] componentsJoinedByString:@","];
    }
    lblCoveringArea.text=[NSString stringWithFormat:@"%@",strBCoveringArea];
    lblEmail.text = [self stringVerification:[NSString stringWithFormat:@"%@",[results valueForKey:@"vEmail"]]];
    lblMobileNo.text = [self stringVerification:[NSString stringWithFormat:@"%@",[results valueForKey:@"vMobile"]]];
    lblPhoneno.text = [self stringVerification:[NSString stringWithFormat:@"%@",[results valueForKey:@"vPhone"]]];
    lblOccupation.text = [self stringVerification:[NSString stringWithFormat:@"%@",[results valueForKey:@"vOccupation"]]];
    
    if ([[lblEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        btnEmail.userInteractionEnabled = NO;
    }
    if ([[lblMobileNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        btnMobile.userInteractionEnabled = NO;
    }
    if ([[lblPhoneno.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        btnPhone.userInteractionEnabled = NO;
    }
    
    CGSize stringSize3 = [self text:lblCoveringArea.text];
    lblCoveringArea.frame = CGRectMake(102, y, 210, MAX( stringSize3.height, 32));
    lblCoveringAreaHeading.frame = CGRectMake(10, y, 90, 32);
    y = y + lblCoveringArea.frame.size.height + 10;
    
    CGSize stringSize4 = [self text:lblEmail.text];
    lblEmail.frame = CGRectMake(102, y, 210, MAX(stringSize4.height, 21));
    btnEmail.frame = CGRectMake(102, y, 210, MAX(stringSize4.height, 21));
    lblEmailHeading.frame = CGRectMake(10, y, 90, 21);
    y = y + lblEmail.frame.size.height + 10;
    
    CGSize stringSize41 = [self text:lblMobileNo.text];
    lblMobileNo.frame = CGRectMake(102, y, 210, MAX(stringSize41.height, 21));
    btnMobile.frame = CGRectMake(102, y, 210, MAX(stringSize41.height, 21));
    lblMobileNoHeading.frame = CGRectMake(10, y, 90, 21);
    y = y + lblMobileNo.frame.size.height + 10;
    
    CGSize stringSize42 = [self text:lblPhoneno.text];
    lblPhoneno.frame = CGRectMake(102, y, 210, MAX(stringSize42.height, 21));
    btnPhone.frame = CGRectMake(102, y, 210, MAX(stringSize42.height, 21));
    lblPhonenoHeading.frame = CGRectMake(10, y, 90, 21);
    y = y + lblPhoneno.frame.size.height + 10;
    
    CGSize stringSize6 = [self text:lblOccupation.text];
    lblOccupation.frame = CGRectMake(102, y, 210, MAX(stringSize6.height, 21));
    lblOccupationHeading.frame = CGRectMake(10, y, 90, 21);
    y = y + lblOccupation.frame.size.height + 10;
    
    NSString *strAddress = @"";
    strAddress = [self strGetAppendedstring:[results valueForKey:@"vAddress1"] forappend:strAddress];
    strAddress =  [self strGetAppendedstring:[results valueForKey:@"vAddress2"] forappend:strAddress];
    strAddress = [self strGetAppendedstring:[results valueForKey:@"vCity"] forappend:strAddress];
    strAddress = [self strGetAppendedstring:[results valueForKey:@"vState"] forappend:strAddress];
    strAddress = [self strGetAppendedstring:[results valueForKey:@"vCountry"] forappend:strAddress];
    
    if ( [strAddress length] > 0)
    {
        strAddress = [strAddress substringToIndex:[strAddress length] - 2];
    }
    
    NSString *strZip = [self removeNull:[NSString stringWithFormat:@"%@",[results valueForKey:@"vZip"]]];
    if ([strZip length ] > 0)
    {
        strAddress=[strAddress stringByAppendingString:@" - "];
        strAddress=[strAddress stringByAppendingString:strZip];
        
    }
    
    CGSize stringSize = [self text:strAddress];
    lblAddress.frame = CGRectMake(102, y , 210, MAX(stringSize.height, 21));
    lblAddressHeading.frame = CGRectMake(10, y, 90, 21);
    lblAddress.text = [self stringVerification:[NSString stringWithFormat:@"%@",strAddress]];
    
    y = y + MAX(stringSize.height, 21) + 10;
    
    scrlUserProfile.contentSize = CGSizeMake(320, y + 20);
    
    connectedMes=[NSString stringWithFormat:@"%@",[results valueForKey:@"eStatus"]];
    
    
    if ([connectedMes isEqualToString:@"Not connected"])
    {
        [connectBtn setTitle:@"Add Mate" forState:UIControlStateNormal];
        [connectBtn setFrame:CGRectMake(225, 7, 91, 30)];
    }
    else if ([connectedMes isEqualToString:@"Mate"])
    {
        [connectBtn setTitle:@"Connected" forState:UIControlStateNormal];
        [connectBtn setFrame:CGRectMake(246, 7, 70, 30)];
    }
    else if ([connectedMes isEqualToString:@"Pending"])
    {
        [connectBtn setTitle:@"Pending" forState:UIControlStateNormal];
        [connectBtn setFrame:CGRectMake(256, 7, 60, 30)];
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

#pragma mark - Self Methods

-(CGSize)text:(NSString*)strTextContent
{
    CGSize constraintSize;
    constraintSize.width = 210.0f;
    constraintSize.height = MAXFLOAT;
    CGSize stringSize1 =[strTextContent sizeWithFont: [UIFont boldSystemFontOfSize: 14] constrainedToSize: constraintSize lineBreakMode: UILineBreakModeWordWrap];
    return stringSize1;
}
-(NSString *)strGetAppendedstring:(NSString*)strFinal forappend:(NSString*)appendstr
{
    strFinal = [self removeNull:[NSString stringWithFormat:@"%@",strFinal]];
    if ([strFinal length] > 0)
    {
        appendstr=[appendstr stringByAppendingString:strFinal];
        appendstr=[appendstr stringByAppendingString:@", "];
    }
    return appendstr;
}

#pragma - mark String Verification Method
-(NSString*)stringVerification:(NSString*)str
{
    str = [[self removeNull:str] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str length] == 0)
    {
        str = @"---";
    }
    return str;
}

#pragma mark - IBAction Methods
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)connectProfile:(id)sender{
    
    if ([connectedMes isEqualToString:@"Pending"]) 
    {
        DisplayAlertWithTitle(APP_Name, @"Request sent already!!!");
    }
    else if([connectedMes isEqualToString:@"Not connected"])
    {
        [self performSelectorInBackground:@selector(busyAgent) withObject:self];
        NSString *senderEmail=[[NSUserDefaults standardUserDefaults] valueForKey:@"vEmail"];
        NSString *reciversEmail=[results valueForKey:@"vEmail"];
        NSString *sendersId=[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"];
        NSString *reciversId=profileId;
        NSString *sendersFullName=[[NSUserDefaults standardUserDefaults] valueForKey:@"vFullName"];
        
        SBJSON *parser = [[SBJSON alloc] init];
        requestMain = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@webservices/send_mate_request.php?req_sender_email=%@&req_receiver_email=%@&req_sender_id=%@&req_receiver_id=%@&sender_fullname=%@",APP_URL,senderEmail,reciversEmail,sendersId,reciversId,sendersFullName]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
        
        NSData *response = [NSURLConnection sendSynchronousRequest:requestMain returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        statuses = [parser objectWithString:json_string error:nil];

        
        if ([[statuses valueForKey:@"msg"] isEqualToString:@"Request sent"]) 
        {
            DisplayAlertWithTitle(APP_Name,@"Request Sent Successfully!!!");
            [connectBtn setFrame:CGRectMake(223,4,95,30)];
            [connectBtn setImage:[UIImage imageNamed:@"RequestSentBtn.png"] forState:UIControlStateNormal];
            //[connectBtn setEnabled:NO];
        }
        else
        {
            DisplayAlertWithTitle(APP_Name,@"oops...Problem in Internate Connection. Please try again later!!!");
        }
    }
    else if([connectedMes isEqualToString:@"Connected"])
    {
        DisplayAlertWithTitle(APP_Name,@"You are already Connected");
    }
     [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    
}
-(IBAction)btnEmailPressed:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        NSArray *torecipients=[NSArray arrayWithObject:[results valueForKey:@"vEmail"]];
        [controller setToRecipients:torecipients];
        [self presentModalViewController:controller animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
-(IBAction)btnMobilePressed:(id)sender
{
    NSString *strMobNo = [NSString stringWithFormat:@"%@",[results valueForKey:@"vMobile"]];
    [self CallToNumber:strMobNo];
}
-(IBAction)btnPhonePressed:(id)sender
{
    NSString *strLandno = [NSString stringWithFormat:@"%@",[results valueForKey:@"vPhone"]];
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
-(void)busyAgent{
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
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

#pragma mark - AlertView Delegate Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
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

-(void)viewWillDisappear:(BOOL)animated
{
    viewprofileStr=@"0";
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
