//
//  InAppHelper.m
//  High Frequency Sight Words
//
//  Created by Pratik Mistry on 17/12/12.
//  Copyright (c) 2012 milind.shroff@spec-india.com. All rights reserved.
//

#import "InAppHelper.h"
#import <StoreKit/StoreKit.h>
#import "AppDelegate.h"

#define ITMS_PROD_VERIFY_RECEIPT_URL        @"https://buy.itunes.apple.com/verifyReceipt"
#define ITMS_SANDBOX_VERIFY_RECEIPT_URL     @"https://sandbox.itunes.apple.com/verifyReceipt";

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
NSString *const IAPHelperProductNotPurchasedNotification = @"IAPHelperProductNotPurchasedNotification";

@interface InAppHelper () <SKProductsRequestDelegate>
@end

@implementation InAppHelper {

    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
}

// Initialization methods for products specified in SubclassInAppHelper Class
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    if ((self = [super init])) {
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        // Check for previously purchased products
        for (NSString * productIdentifier in _productIdentifiers)
        {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"IhavePurchasedApp"];
            if (productPurchased) {
               // NSLog(@"Purchased: %@", productIdentifier);
            } else {
               // NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

// Request products for your application 
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {

    // 1
    _completionHandler = [completionHandler copy];
    
    if ([SKPaymentQueue canMakePayments]) {
        // Yes, In-App Purchase is enabled on this device.
        // Proceed to fetch available In-App Purchase items.
        
        // Initiate a product request of the Product ID.
        // 2
       // NSLog(@"In-App Purchase is enabled.");
        _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
        _productsRequest.delegate = self;
        [_productsRequest start];
    }
    else {
        // Notify user that In-App Purchase is Disabled.
      //  NSLog(@"In-App Purchase is Disabled.");
        _productsRequest = nil;
        _completionHandler(NO, nil);
        _completionHandler = nil;
    }
}

#pragma mark - SKProductsRequestDelegate Methods
// This method will be called on successfull retrieval of products
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

   // NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray *skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
      //  NSLog(@"Found product: %@ %@ %0.2f",skProduct.productIdentifier,skProduct.localizedTitle,skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
}

// This method will be called on error geeting list of products
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    // Notify user that no products available to buy.
  //  NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    _completionHandler(NO, nil);
    _completionHandler = nil;
    [AppDel dohideHUD];
}

// Call this method with prodcut from your class to buy that product
- (void)buyProduct:(SKProduct *)product
{
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];    
}
// The transaction status of the SKPaymentQueue is sent here.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
            {
                [AppDel doshowHUD];
                // Item is still in the process of being purchased
				break;
            }
            case SKPaymentTransactionStatePurchased:
            {
                // Item was successfully purchased!
                // Now transaction should be finished with purchased product.
                [AppDel doshowHUD];
                [self completeTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed:
            {
             	// Purchase was either cancelled by user or an error occurred.
                [self failedTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateRestored:
            {
                // Verified that user has already paid for this item.
                // Now transaction should be finish with restoring previously purchased product.
                [AppDel doshowHUD];
                [self restoreTransaction:transaction];
                break;
            }
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
  //  NSLog(@"completeTransaction...");
    
    BOOL varification = [self VarifyPurchaseReceipt:transaction];
    
    if(varification == TRUE)
    {
        // Return transaction data. App should provide user with purchased product.
        [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
        // After completion of transaction remove the finished transaction from the payment queue.
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [AppDel dohideHUD];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Varification Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [AppDel dohideHUD];
    }

}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
  //  NSLog(@"restoreTransaction...");
    // Ideal for restoring item across all devices of this customer.
    // Return transaction data. App should provide user with purchased product.
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    // After completion of transaction remove the finished transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [AppDel dohideHUD];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    //Transaction Failed
   // NSLog(@"failedTransaction...");
    // Notification data display alert in case of transaction error due to technical reason.
    NSMutableDictionary *info = [[NSMutableDictionary alloc]initWithCapacity:1];
    [info setValue:@"NO" forKey:@"isAlert"];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Technical error occured so adding YES for displaying alert
        [info setValue:@"YES" forKey:@"isAlert"];
    }
    // Post Notification with isAlert YES/NO value.
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductNotPurchasedNotification object:self userInfo:info];
  	
    // Finished transactions should be removed from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [AppDel dohideHUD];
}
-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [AppDel dohideHUD];
}
// Add new method
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    // After completion of transaction provide purchased item to customer and also update purchased item's status in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IhavePurchasedApp"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // Send notification to update the UI or provide contents to customer.
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

-(BOOL)VarifyPurchaseReceipt:(SKPaymentTransaction *)transection
{
    BOOL isVerified = FALSE;
    
    NSString *jsonObjectString = [self base64forData:transection.transactionReceipt];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}",jsonObjectString];
    
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *serverURL = ITMS_PROD_VERIFY_RECEIPT_URL;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:payloadData];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData* dataResp = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
//    NSString* varifivation = [[NSString alloc]initWithData:dataResp encoding:NSUTF8StringEncoding];
    
    NSDictionary* dict = [NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:dataResp options:kNilOptions error:nil]];
    
    int status = [[dict valueForKey:@"status"]intValue];
    
    if(status == 0)
    {
        isVerified = TRUE;
    }
    return isVerified;
}


-(NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end

