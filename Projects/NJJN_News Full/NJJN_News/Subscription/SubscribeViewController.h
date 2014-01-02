//
//  SubscribeViewController.h
//  NewsStand
//
//  Created by openxcell technolabs on 5/7/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromoCodeViewController.h"
#import <StoreKit/StoreKit.h>

@class LoginAppDelegate;

@interface SubscribeViewController : UIViewController
{
    //IBOutlet UIButton *btnCancel;
    IBOutlet UIButton *btnSubscribe1;
    IBOutlet UIButton *btnSubscribe2;
    IBOutlet UIButton *btnSubscribe3;
    
    IBOutlet UILabel *lblHeader;
    IBOutlet UIImageView *imgBg;
    IBOutlet UIImageView *imgSignIn;
    IBOutlet UILabel *lblTitle;
    
    // for promocode
    UIAlertView *alerthasPromoCode,*alertEnterPromoCode;
    
    NSDictionary* dictPackegData;
    IBOutlet UIScrollView *scl_Sub;
}

-(IBAction)ClickBtnCancel:(id)sender;
-(IBAction)ClickBtnSubscribe:(id)sender;

@end
