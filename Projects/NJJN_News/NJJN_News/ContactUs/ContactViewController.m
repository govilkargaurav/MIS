//
//  ContactViewController.m
//  NewsStand
//
//  Created by openxcell technolabs on 4/23/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "ContactViewController.h"

@implementation ContactViewController

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
    [self addGoogleAd];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateui];

    if([[NSUserDefaults standardUserDefaults] boolForKey:@"AdMobOnOff"])
    {
        [adCustomView setHidden:NO];
        [btnCancelAd setHidden:NO];
    }
    else
    {
        [adCustomView setHidden:YES];
        [btnCancelAd setHidden:YES];
    }
    [self setOrientationOfAddBanner];
}
-(IBAction)btnFeedBackPressed:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        NSArray *torecipients=[NSArray arrayWithObject:@"support@dnpsolutions.com"];
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


-(IBAction)btnLikeOnFacebook:(id)sender
{
    WebSiteViewController *wVc = [[WebSiteViewController alloc]initWithNibName:@"WebSiteViewController" bundle:nil];
    wVc.strLink = @"https://www.facebook.com/pages/DNPS/1401931783352818";
    [self presentModalViewController:wVc animated:YES];
}
-(IBAction)btnCallPressed:(id)sender
{
    NSString *strMobileNo = @"+12122101703";
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:strMobileNo.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:strMobileNo];
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
        DisplayAlertWithTitle(App_Name, strMsg);
        return;
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark - orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight
        ||interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        flagOrientation = 1;
    }
    else
    {
        flagOrientation = 0;
    }
    [self setOrientation];
	return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    NSUInteger orientations = UIInterfaceOrientationMaskAll;
    return orientations;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self setOrientationOfAddBanner];
    [self updateui];
}

-(void)updateui
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        flagOrientation = 0;
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        flagOrientation = 1;
    }
    [self setOrientation];
}


-(void)setOrientation
{
    if(flagOrientation == 0)
    {
        imgHeader.image = [UIImage imageNamed:@"TopBar.png"];
    }
    else
    {
        imgHeader.image = [UIImage imageNamed:@"L-TopBar.png"];
    }
    
}

//Google AdBanner
-(void)addGoogleAd
{
    AbMob_ContactView = [[GADBannerView alloc] init];
    [self.view bringSubviewToFront:AbMob_ContactView];
    
    AbMob_ContactView.adUnitID =@"a1514a9bada517c";
    AbMob_ContactView.rootViewController = self;
    AbMob_ContactView.delegate=self;
    
    [self setOrientationOfAddBanner];
    
    [adCustomView addSubview:AbMob_ContactView];
    
    GADRequest *r = [[GADRequest alloc] init];
    r.testing = YES;
    [AbMob_ContactView loadRequest:r];
}

#pragma mark - ADmob Method

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"AdMobOnOff"])
    {
        [adCustomView setHidden:NO];
        [btnCancelAd setHidden:NO];
    }
    else
    {
        [adCustomView setHidden:YES];
        [btnCancelAd setHidden:YES];
    }
    [self.view bringSubviewToFront:adCustomView];
    [self.view bringSubviewToFront:btnCancelAd];
}

-(void)setOrientationOfAddBanner
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        AbMob_ContactView.adSize = kGADAdSizeSmartBannerPortrait;
    }
    else
    {
        AbMob_ContactView.adSize = kGADAdSizeSmartBannerLandscape;
    }
}
- (IBAction)ClickBtnCancelAd:(id)sender
{
    [adCustomView setHidden:YES];
    [btnCancelAd setHidden:YES];
}

@end
