//
//  PromoCodeViewController.h
//  NewsStand
//
//  Created by KPIteng on 5/17/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>
#import "AppConstat.h"
#import "SubclassInAppHelper.h"
#import "JSON.h"

@interface PromoCodeViewController : UIViewController 
{
    int atIndex;
    IBOutlet UITextField *tfPromoCode;
    BOOL isAppliedPromoCode;
}

@property (nonatomic, readwrite) int atIndex;
@property (nonatomic, strong) NSDictionary* dictPackegData;

- (IBAction)btnApplyPromoCode:(id)sender;
- (IBAction)btnBuyTapped:(id)sender;

@end
