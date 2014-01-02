//
//  AboutViewController.h
//  NewsStand
//
//  Created by openxcell technolabs on 4/18/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebSiteViewController.h"
#import "AppConstat.h"
#import "AppDelegate.h"
#import "PDKeychainBindings.h"
#import "NSString+Valid.h"

// Google Ad
#import "GADBannerView.h"
#import "DFPBannerView.h"
#import "GADBannerViewDelegate.h"

@interface HomeViewController : UIViewController <GADBannerViewDelegate>
{
        GADBannerView *AbMob_home;
        IBOutlet UIView *adCustomView;
        IBOutlet UIButton *btnCancelAd;
}

-(IBAction)ClickBtnGoToIssues:(id)sender;
-(IBAction)ClickBtnGoToWebsite:(id)sender;

@end
