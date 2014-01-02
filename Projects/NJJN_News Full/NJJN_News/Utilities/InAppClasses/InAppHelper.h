//
//  InAppHelper.h
//  NewsStand
//
//  Created by openxcell technolabs on 4/17/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//


// Add to the top of the file
#import <StoreKit/StoreKit.h>
#import "JSON.h"


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

//Method declaration to get status of product
- (BOOL)productPurchased:(NSString *)productIdentifier;

//Method declaration to Restore product
-(void)RestoreProduct;
@end