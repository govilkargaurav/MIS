//
//  InAppHelper.h
//  High Frequency Sight Words
//
//  Created by Pratik Mistry on 17/12/12.
//  Copyright (c) 2012 milind.shroff@spec-india.com. All rights reserved.
//


// Add to the top of the file
#import <StoreKit/StoreKit.h>


//This are the constants for Notification names
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;
UIKIT_EXTERN NSString *const IAPHelperProductNotPurchasedNotification;

//Block declaration to get products
typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface InAppHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

//Initialization methods
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;

//Method declaration for getting list of products
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

//Method declaration to buy product
- (void)buyProduct:(SKProduct *)product;

@end