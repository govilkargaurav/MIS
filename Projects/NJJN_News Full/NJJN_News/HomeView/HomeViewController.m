//
//  AboutViewController.m
//  NewsStand
//
//  Created by openxcell technolabs on 4/18/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "WebSiteViewController.h"



@implementation HomeViewController

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


#pragma mark - Product

/*- (void)getProducts
{
    [[SubclassInAppHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
     {
         if (success)
         {
             AppDel._products = [products copy];
         }
         else
         {
             [AppDel dohideHUD];
         }
     }];
}*/

- (void)productPurchased:(NSNotification *) notification
{
    [AppDel dohideHUD];
}

- (void)productPurchaseFailed:(NSNotification *) notification
{
    NSString *status = [[notification userInfo] valueForKey:@"isAlert"];
    
    if ([status isEqualToString: @"YES"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Unable to purchase the product.Please check your internet connection or try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    [AppDel dohideHUD];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{

    NSString *strEditionId = [[NSUserDefaults standardUserDefaults]valueForKey:@"iEditionID"];
    NSString *strZoneId = [[NSUserDefaults standardUserDefaults] valueForKey:@"iZoneID"];
    
    if (!strEditionId)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"5" forKey:@"iEditionID"];
        [[NSUserDefaults standardUserDefaults] setObject:@"Digitial Main" forKey:@"vEdition"];
    }
    
    if (!strZoneId)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"7" forKey:@"iZoneID"];
        [[NSUserDefaults standardUserDefaults] setObject:@"Main" forKey:@"vZone"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchaseFailed:) name:IAPHelperProductNotPurchasedNotification object:nil];
    
   // [self getProducts];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self addGoogleAd];
    
    [super viewDidLoad];
    
}

-(void)addGoogleAd
{
    AbMob_home = [[GADBannerView alloc] init];
    [self.view bringSubviewToFront:AbMob_home];
    
    AbMob_home.adUnitID =@"a1514a9bada517c";
    AbMob_home.rootViewController = self;
    AbMob_home.delegate=self;
    
    [self setOrientationOfAddBanner];
    
    [adCustomView addSubview:AbMob_home];
    
    GADRequest *r = [[GADRequest alloc] init];
    r.testing = YES;
    [AbMob_home loadRequest:r];
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


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Btn Action Method 
-(IBAction)ClickBtnGoToIssues:(id)sender
{
    self.tabBarController.selectedIndex = 1;
}

-(IBAction)ClickBtnGoToWebsite:(id)sender
{
    WebSiteViewController *wVc = [[WebSiteViewController alloc]initWithNibName:@"WebSiteViewController" bundle:nil];
    wVc.strLink = @"http://dnps.webs.com/";
    [self presentModalViewController:wVc animated:YES];
    //http://www.njjewishnews.com/
}

#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)setOrientationOfAddBanner
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        AbMob_home.adSize = kGADAdSizeSmartBannerPortrait;
    }
    else
    {
        AbMob_home.adSize = kGADAdSizeSmartBannerLandscape;
    }
}
- (IBAction)ClickBtnCancelAd:(id)sender
{
    [adCustomView setHidden:YES];
    [btnCancelAd setHidden:YES];
}
@end
