//
//  InAppHelper.m
//  NewsStand
//
//  Created by openxcell technolabs on 4/17/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
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
    NSMutableSet * _purchasedProductIdentifiers;
    
    NSString *strReciept,*strTransactionType;
}

// Initialization methods for products specified in SubclassInAppHelper Class
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    //[AppDel doshowHUD];
    if ((self = [super init])) {
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers)
        {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

// Request products for your application 
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    
    _completionHandler = [completionHandler copy];
    
    if ([SKPaymentQueue canMakePayments]) {
        // Yes, In-App Purchase is enabled on this device.
        // Proceed to fetch available In-App Purchase items.
        // Initiate a product request of the Product ID.
        // 2
        NSLog(@"In-App Purchase is enabled.");
        _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
        _productsRequest.delegate = self;
        [_productsRequest start];
    }
    else {
        // Notify user that In-App Purchase is Disabled.
        NSLog(@"In-App Purchase is Disabled.");
        _productsRequest = nil;
        _completionHandler(NO, nil);
        _completionHandler = nil;
    }
}

#pragma mark - SKProductsRequestDelegate Methods
// This method will be called on successfull retrieval of products
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    NSLog(@"%@",response.products);
    NSArray *skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
}

// This method will be called on error geeting list of products
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    // Notify user that no products available to buy.
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    _completionHandler(NO, nil);
    _completionHandler = nil;
    [AppDel dohideHUD];
}

// Method used to check whether product is purchased or not?
- (BOOL)productPurchased:(NSString *)productIdentifier
{
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

// Call this method with prodcut from your class to buy that product
- (void)buyProduct:(SKProduct *)product
{
    NSLog(@"Buying %@...", product.productIdentifier);
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];    
}
-(void)RestoreProduct
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
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

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.transactionState == SKPaymentTransactionStateRestored)
    {
        strTransactionType = @"Restore";
    }
    else
    {
        strTransactionType = @"Buy";
    }
    NSData *dataReciept = [transaction transactionReceipt];
 
    [self VarifyPurchaseReceipt:dataReciept];
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");

    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    AppDel.isAlertFromIAP = 0;
    NSLog(@"failedTransaction...");
    [AppDel dohideHUD];
  //  NSLog(@"%@",transaction.error.localizedDescription);
   // NSData *dataReciept = [transaction transactionReceipt];
   // [self VarifyPurchaseReceipt:dataReciept];

    NSMutableDictionary *info = [[NSMutableDictionary alloc]initWithCapacity:1];
    [info setValue:@"NO" forKey:@"isAlert"];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
       // NSLog(@"Info = %@",info);
        // Technical error occured so adding YES for displaying alert
        [info setValue:@"YES" forKey:@"isAlert"];
    }
    // Post Notification with isAlert YES/NO value.
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductNotPurchasedNotification object:self userInfo:info];
  	
    // Finished transactions should be removed from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

// Add new method
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    // After completion of transaction provide purchased item to customer and also update purchased item's status in NSUserDefaults

    if (productIdentifier)
    {
        //Adding product into the list of purchased products.
        [_purchasedProductIdentifiers addObject:productIdentifier];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Send notification to update the UI or provide contents to customer.
        [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    }
    
}
-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [AppDel dohideHUD];
}


-(void)VarifyPurchaseReceipt:(NSData *)transactionReceipt
{    
    NSError *jsonError = nil;
    
    NSString * shared_secret = @"4b3be56dbb0d42318a7861ccca8d1e0b";
    
    NSString *jsonObjectString = [self base64forData:transactionReceipt];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:jsonObjectString,@"receipt-data",shared_secret,@"password",nil]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jsonError];
#warning change to live
    NSString *serverURL = ITMS_SANDBOX_VERIFY_RECEIPT_URL;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData* dataResp = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* varifivation = [[NSString alloc]initWithData:dataResp encoding:NSUTF8StringEncoding];
    
    NSDictionary* dict =  [NSDictionary dictionaryWithDictionary:[varifivation JSONValue]];
    
    if([[dict valueForKey:@"status"] integerValue] == 0)
    {
        if([dict valueForKey:@"receipt"])
        {
            NSRange textRange = [[[dict valueForKey:@"receipt"] valueForKey:@"product_id"] rangeOfString:@"WithDiscount"];
            
            if(textRange.location != NSNotFound)
            {
                AppDel.strPromoCodeTrueFalse = @"true";
            }
            else
            {
                AppDel.strPromoCodeTrueFalse = @"false";
            }
            strReciept = [jsonObjectString copy];
            [self performSelector:@selector(SendRecieptToServer:) withObject:dict afterDelay:0.1];
        }
    }
    else
    {
        if ([strTransactionType isEqualToString:@"Restore"])
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:App_Name message:@"You can not restore.Your subscription is now inactive or cancelled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}

-(NSString*)base64forData:(NSData*)theData
{
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

-(void)completePaymentTransaction:(NSDictionary *)receipt
{
    if(AppDel.isAlertFromIAP == 1)
    {
        AppDel.isAlertFromIAP = 0;
        if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"]isEqualToString:@"0"])
        {
            NSDictionary* dict = [receipt copy];
            
            NSString* strOrgEndDate = [[[dict valueForKey:@"latest_receipt_info"] valueForKey:@"expires_date_formatted"] stringByReplacingOccurrencesOfString:@" Etc/GMT" withString:@""];

            NSDateFormatter* dfEnd = [[NSDateFormatter alloc]init];
            
            [dfEnd setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate* dateEnd = [dfEnd dateFromString:strOrgEndDate];
            
    #warning Please remove once you live this app on itunes store
            dateEnd = [dateEnd dateByAddingTimeInterval:60*60*24*1];
            
            [dfEnd setDateFormat:@"yyyy-MM-dd"];
            
            NSString* finalOrgEnd = [dfEnd stringFromDate:dateEnd];
            
            NSString* strOrgStartDate = [[[dict valueForKey:@"latest_receipt_info"] valueForKey:@"original_purchase_date"] stringByReplacingOccurrencesOfString:@" Etc/GMT" withString:@""];
            
            NSDateFormatter* dfStart = [[NSDateFormatter alloc]init];
            
            [dfStart setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate* dateStart = [dfStart dateFromString:strOrgStartDate];
            
            [dfStart setDateFormat:@"yyyy-MM-dd"];
            
            NSString* finalOrgStart = [dfStart stringFromDate:dateStart];
            
            NSString* stringURl = [NSString stringWithFormat:@"http://openxcellaus.info/ipadmanager/ws/index.php?c=package&func=subscribepackage&iUserID=%@&iPackageID=%@&PromoCode=%@&dEndDate=%@&dStartDate=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"],AppDel.strPackegIdToSubscribe,AppDel.strPromoCodeTrueFalse,finalOrgEnd,finalOrgStart];
            
            NSURLRequest* req = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[stringURl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            
            [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce, NSData *response, NSError *error)
             {
                 if (error)
                 {
                     [AppDel dohideHUD];
                     DisplayAlertWithTitle(App_Name, [error localizedDescription]);
                     return;
                 }
                 else
                 {
                     NSString *strDurationType;
                     for (int i = 0; i < [AppDel.arPackageList count]; i++)
                     {
                         NSDictionary *dicPackagData = [[NSDictionary alloc]initWithDictionary:[AppDel.arPackageList objectAtIndex:i]];
                         if ([[dicPackagData valueForKey:@"iPackageID"] isEqualToString:AppDel.strPackegIdToSubscribe])
                         {
                             strDurationType = [NSString stringWithFormat:@"%@ %@",[dicPackagData valueForKey:@"vDuration"],[dicPackagData valueForKey:@"vType"]];
                             break;
                         }
                         else
                         {
                             strDurationType = @"";
                         }
                     }
                     
                     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:App_Name message:[NSString stringWithFormat:@"%@, your %@ subscription is  active until %@,This subscription will automatically renew until cancelled",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]valueForKey:@"vFirstName"],strDurationType,finalOrgEnd] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [alert show];
                     
                     NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
                     
                     if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"])
                     {
                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                     }
                     [[NSUserDefaults standardUserDefaults] setObject:dictData forKey:@"UserInfo"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                                                                             
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"loadPDFDataAgain" object:nil];
                     
                     [AppDel dohideHUD];
                     
                     if([AppDel.popOverSubscriptionObj isPopoverVisible])
                     {
                         [AppDel.popOverSubscriptionObj dismissPopoverAnimated:YES];
                     }
                 }
             }];
        }
    }
}

-(void)SendRecieptToServer:(NSDictionary*)dict
{
    if (strReciept != nil)
    {        
        NSString *strdataCP=[NSString stringWithFormat:@"iUserID=%@&receipt=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"],strReciept];
        NSString *urlStringCPData = @"http://openxcellaus.info/ipadmanager/ws/index.php?c=updatereceipt";
        NSString *postLength = [NSString stringWithFormat:@"%d", [strdataCP length]];
        NSMutableURLRequest *requestCPData = [[NSMutableURLRequest alloc] init];
        
        [requestCPData setURL:[NSURL URLWithString:urlStringCPData]];
        [requestCPData setHTTPMethod:@"POST"];
        [requestCPData setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [requestCPData setHTTPBody:[strdataCP dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [NSURLConnection sendAsynchronousRequest:requestCPData queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce, NSData *response, NSError *error)
         {
             if (error)
             {
                 [AppDel dohideHUD];
                 DisplayAlertWithTitle(App_Name, [error localizedDescription]);
                 return;
             }
             else
             {
                 NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
                 if ([[dicResponse valueForKey:@"message"] isEqualToString:@"SUCCESS"])
                 {
                     [self performSelector:@selector(completePaymentTransaction:) withObject:dict afterDelay:0.1];
                 }
             }
         }];
    }
}

@end

