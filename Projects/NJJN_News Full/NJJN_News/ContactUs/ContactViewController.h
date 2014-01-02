//
//  ContactViewController.h
//  NewsStand
//
//  Created by openxcell technolabs on 4/23/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"
#import "AppDelegate.h"
#import "WebSiteViewController.h"

// Google Ad
#import "GADBannerView.h"
#import "DFPBannerView.h"
#import "GADBannerViewDelegate.h"


#import <MessageUI/MessageUI.h>

@interface ContactViewController : UIViewController <GADBannerViewDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UIButton *btnUser;
    
    IBOutlet UIButton *btnFeedBack;
    IBOutlet UIButton *btnFB;
    IBOutlet UIButton *btnMobile;
    
    IBOutlet UIImageView *imgFeedBack;
    IBOutlet UIImageView *imgFB;
    IBOutlet UIImageView *imgMobile;
    
    IBOutlet UIImageView *imgSep;
    IBOutlet UIImageView *imgBg;
    IBOutlet UIImageView *imgHeader;
    
    //Google AdBanner
    GADBannerView *AbMob_ContactView;
    IBOutlet UIView *adCustomView;
    IBOutlet UIButton *btnCancelAd;
    
    int flagOrientation;
    
    IBOutlet UIButton* btnHiddenForSignInFrame,* btnHiddenForSubscriptionFrame;
    
}


@end
