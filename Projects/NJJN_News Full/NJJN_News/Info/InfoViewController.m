//
//  InfoViewController.m
//  NewsStand
//
//  Created by Gagan on 5/17/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *strMusic=[NSString stringWithFormat:@"%@",lblInfo.text];
    
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:strMusic];
    
    NSRange rangeFinal = [strMusic rangeOfString:lblInfo.text];
    [attString setFontName:@"Helvetica" size:18.0 range:rangeFinal];
    
    NSRange rangeFinal1 = [strMusic rangeOfString:@"General questions to understand the flow of the app"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal1];
    
    NSRange rangeFinal2 = [strMusic rangeOfString:@"How does the free trial work?"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal2];
    
    NSRange rangeFinal3 = [strMusic rangeOfString:@"Who is a print Subscriber?"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal3];
    
    NSRange rangeFinal4 = [strMusic rangeOfString:@"Who needs to sign up?"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal4];
    
    NSRange rangeFinal5 = [strMusic rangeOfString:@"What information is required to sign up?"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal5];
    
    NSRange rangeFinal6 = [strMusic rangeOfString:@"Features:"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal6];
    
    NSRange rangeFinal7 = [strMusic rangeOfString:@"Sign in process for an existing print subscriber"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal7];
    
    NSRange rangeFinal8 = [strMusic rangeOfString:@"account number and zip code "];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal8];
    
    NSRange rangeFinal9 = [strMusic rangeOfString:@"Sign in process for other users"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal9];
    
    NSRange rangeFinal10 = [strMusic rangeOfString:@"Sign up process for other users:"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal10];
    
    NSRange rangeFinal11 = [strMusic rangeOfString:@"Sign in for other users:"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal11];
    
    NSRange rangeFinal12 = [strMusic rangeOfString:@"Navigation:"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal12];
    
    NSRange rangeFinal13 = [strMusic rangeOfString:@"Zooming:"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal13];
    
    NSRange rangeFinal14 = [strMusic rangeOfString:@"Two ways to read:"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal14];
    
    NSRange rangeFinal15 = [strMusic rangeOfString:@"Download content:"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal15];

    NSRange rangeFinal16 = [strMusic rangeOfString:@"General ipad app renewal Questions"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal16];
    
    NSRange rangeFinal17 = [strMusic rangeOfString:@"Our DNPS app follows standard features of auto-renewable iTunes subscriptions:"];
    [attString setFontName:@"Helvetica-Bold" size:18.0 range:rangeFinal17];
    
    lblInfo.attributedText = attString;
    
    [self addGoogleAd];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateui];

    
    [self setOrientationOfAddBanner];
}
-(void)viewDidAppear:(BOOL)animated
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"AdMobOnOff"])
    {
        [adCustomView setHidden:NO];
        [btnCancelAd setHidden:NO];
        if(flagOrientation == 0)
            scl_Info.frame = CGRectMake(scl_Info.frame.origin.x, scl_Info.frame.origin.y, scl_Info.frame.size.width, 928);
        else
            scl_Info.frame = CGRectMake(scl_Info.frame.origin.x, scl_Info.frame.origin.y, scl_Info.frame.size.width, 672);
    }
    else
    {
        [adCustomView setHidden:YES];
        [btnCancelAd setHidden:YES];
        if(flagOrientation == 0)
            scl_Info.frame = CGRectMake(scl_Info.frame.origin.x, scl_Info.frame.origin.y, scl_Info.frame.size.width, 1028);
        else
            scl_Info.frame = CGRectMake(scl_Info.frame.origin.x, scl_Info.frame.origin.y, scl_Info.frame.size.width, 772);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Orientation

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
        scl_Info.contentSize = CGSizeMake(scl_Info.frame.size.width, 1800);
    }
    else
    {
        imgHeader.image = [UIImage imageNamed:@"L-TopBar.png"];
        scl_Info.contentSize = CGSizeMake(scl_Info.frame.size.width, 1690);
    }
    
    if(AppDel.popOverFlag == 1)
    {
        [btnUser sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    
    if([AppDel.popOverSignInObj isPopoverVisible])
    {
        [btnHiddenForSignInFrame sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    if([AppDel.popOverSubscriptionObj isPopoverVisible])
    {
        [btnHiddenForSubscriptionFrame sendActionsForControlEvents:UIControlEventTouchUpInside];
    }

}

//Google AdBanner
-(void)addGoogleAd
{
    AbMob_InfoView = [[GADBannerView alloc] init];
    [self.view bringSubviewToFront:AbMob_InfoView];
    
    AbMob_InfoView.adUnitID =@"a1514a9bada517c";
    AbMob_InfoView.rootViewController = self;
    AbMob_InfoView.delegate=self;
    
    [self setOrientationOfAddBanner];
    
    [adCustomView addSubview:AbMob_InfoView];
    
    GADRequest *r = [[GADRequest alloc] init];
    r.testing = YES;
    [AbMob_InfoView loadRequest:r];
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
        AbMob_InfoView.adSize = kGADAdSizeSmartBannerPortrait;
    }
    else
    {
        AbMob_InfoView.adSize = kGADAdSizeSmartBannerLandscape;
    }
}
- (IBAction)ClickBtnCancelAd:(id)sender
{
    [adCustomView setHidden:YES];
    [btnCancelAd setHidden:YES];
}

@end
