//
//  GlobalMethods.m
//  OrganiseMee_iPhone
//
//  Created by Imac 2 on 3/14/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "GlobalMethods.h"
#import "DatabaseAccess.h"

#define ITMS_PROD_VERIFY_RECEIPT_URL        @"https://buy.itunes.apple.com/verifyReceipt"
#define ITMS_SANDBOX_VERIFY_RECEIPT_URL     @"https://sandbox.itunes.apple.com/verifyReceipt";

@implementation GlobalMethods

#pragma mark - Receipt Verification

+(void)VerifyReceipt:(NSString *)receipt
{
    NSError *jsonError = nil;
    
    NSString * shared_secret = @"eb25aefe1fd543619f7497f835cd0dca";
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:receipt,@"receipt-data",shared_secret,@"password",nil] options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    NSString *serverURL = ITMS_SANDBOX_VERIFY_RECEIPT_URL;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData* dataResp = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* varifivation = [[NSString alloc]initWithData:dataResp encoding:NSUTF8StringEncoding];
    
    NSDictionary* dict =  [NSDictionary dictionaryWithDictionary:[varifivation JSONValue]];
    
    if([[dict valueForKey:@"status"] integerValue] != 0)
    {
        [self performSelector:@selector(unsubscribeFromTrasection:) withObject:dict afterDelay:0.2];
    }
    else if([[dict valueForKey:@"status"] integerValue] == 0)
    {
        [self performSelector:@selector(completePaymentTransaction:) withObject:dict afterDelay:0.2];
    }
}


#pragma mark - Transation Complete - POST Data To Server

+(void)completePaymentTransaction:(NSDictionary *)receipt
{
    
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
        
        NSString* stringURl = [NSString stringWithFormat:@"http://openxcellaus.info/ipadmanager/ws/index.php?c=package&func=subscribepackage&iUserID=%@&iPackageID=%@&PromoCode=%@&dEndDate=%@&dStartDate=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"],[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iPackageID"],[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"vPromoCodeUsed"],finalOrgEnd,finalOrgStart];

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
                 [AppDel dohideHUD];

                 NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
                 
                 if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"])
                 {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                 }
                 [[NSUserDefaults standardUserDefaults] setObject:dictData forKey:@"UserInfo"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 if([AppDel.downloadingArray count] == 0)
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"loadPDFDataAgain" object:nil];
                 }
                 
             }
         }];
    }
    else
    {
        [AppDel dohideHUD];
    }
}

+(void)unsubscribeFromTrasection:(NSDictionary *)receipt
{
    if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"]isEqualToString:@"0"])
    {
        NSDictionary* dict = [receipt copy];
        
        int receiptStatus = [[dict valueForKey:@"status"] integerValue];
        
        if(receiptStatus != 0)
        {
            NSDate* date = [NSDate date];
            
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            
            [df setDateFormat:@"yyyy-MM-dd"];
            
            NSString* dateToday = [df stringFromDate:date];
            
            NSString* stringURl = [NSString stringWithFormat:@"http://openxcellaus.info/ipadmanager/ws/index.php?c=package&func=unsubscribepackage&iUserID=%@&dDate=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]  valueForKey:@"iUserID"],dateToday];
            
            NSURLRequest* req = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[stringURl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            
            [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce, NSData *response, NSError *error)
             {
                 [AppDel dohideHUD];
                 NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
                 
                 NSString* strMsg = @"";
                 
                 if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"]isEqualToString:@"0"])
                 {
                     strMsg = [NSString stringWithFormat:@"%@, your subscription is now inactive",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]valueForKey:@"vFirstName"]];
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else
                 {
                     strMsg = [NSString stringWithFormat:@"Your one month subscription is now inactive"];
                 }
                 
                 
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:App_Name message:strMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alert show];
                 
                 if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"])
                 {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 [[NSUserDefaults standardUserDefaults] setObject:dictData forKey:@"UserInfo"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 if([AppDel.downloadingArray count] == 0)
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"loadPDFDataAgain" object:nil];
                 }
                 
             }];
        }
    }
    else
    {
        [AppDel dohideHUD];
    }
}

@end
