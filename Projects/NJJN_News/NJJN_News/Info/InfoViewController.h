//
//  InfoViewController.h
//  NewsStand
//
//  Created by Gagan on 5/17/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AppConstat.h"

// Google Ad
#import "GADBannerView.h"
#import "DFPBannerView.h"
#import "GADBannerViewDelegate.h"
#import <OHAttributedLabel/OHAttributedLabel.h>

@interface InfoViewController : UIViewController <GADBannerViewDelegate>
{
    //Google AdBanner
    GADBannerView *AbMob_InfoView;
    IBOutlet UIView *adCustomView;
    IBOutlet UIButton *btnCancelAd;
    
    int flagOrientation;
    
    IBOutlet UIImageView* imgHeader;
        
    IBOutlet OHAttributedLabel *lblInfo;
}


@end
