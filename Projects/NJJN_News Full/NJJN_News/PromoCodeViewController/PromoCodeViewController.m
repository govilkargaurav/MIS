//
//  PromoCodeViewController.m
//  NewsStand
//
//  Created by KPIteng on 5/17/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "PromoCodeViewController.h"

@interface PromoCodeViewController ()

@end

@implementation PromoCodeViewController

@synthesize atIndex,dictPackegData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    isAppliedPromoCode = FALSE;
    [super viewWillAppear:animated];
    [self setTitle:@"Promo Code"];
    self.contentSizeForViewInPopover = CGSizeMake(482, 222);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    tfPromoCode = nil;
    [super viewDidUnload];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - IBAction Methods
- (IBAction)btnApplyPromoCode:(id)sender {
    
    BOOL contaiPckg = FALSE;
    NSArray* arrayPck = [dictPackegData valueForKey:@"list"];
    
    NSString* strPckgId = @"";
    for(int i=0; i<[arrayPck count]; i++)
    {
        NSString* strPckgIdTmp = [[arrayPck objectAtIndex:i] valueForKey:@"iPackageID"];
        if([strPckgIdTmp isEqualToString:[[AppDel.arPackageList objectAtIndex:atIndex] valueForKey:@"iPackageID"]])
        {
            strPckgId = @"";
            strPckgId = [[arrayPck objectAtIndex:i] valueForKey:@"vPromocode"];
            contaiPckg = TRUE;
            break;
        }
        else if(i == arrayPck.count)
        {
            contaiPckg = FALSE;
        }
    }
    
    if(contaiPckg)
    {
        if([tfPromoCode.text isEqualToString:strPckgId])
        {
            [AppDel doshowHUD];
            NSString *strURL;
            
            strURL = [NSString stringWithFormat:@"%@c=user&func=promoUsed&iUserID=%@&iPackageID=%@",WebURL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"],[[AppDel.arPackageList objectAtIndex:atIndex] valueForKey:@"iPackageID"]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
            {
                
                NSError *err;
                NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&err];
                if([[arr valueForKey:@"message"] isEqualToString:@"PROMOCODE USED"])
                {
                    isAppliedPromoCode = FALSE;
                    AppDel.usedPromoCode = TRUE;
                    AppDel.YesNo = NO;
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:App_Name message:@"Promocode is already used." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    isAppliedPromoCode = TRUE;
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:App_Name message:@"Promocode successfully applied. Please click buy button to get Discounted subscription!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                [AppDel dohideHUD];
                
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:App_Name message:@"Invalid Promocode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:App_Name message:@"Invalid Promocode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }  
}

- (IBAction)btnBuyTapped:(id)sender
{
    if([AppDel._products count] > 0)
    {
        [self BuyProductCall];
    }
    else
    {
        [AppDel doshowHUD];
        [self getProducts];
    }
    return;
}
-(void)BuyProductCall
{
    [AppDel doshowHUD];
    
    AppDel.strPackegIdToSubscribe = [[NSString stringWithFormat:@"%@",[[AppDel.arPackageList objectAtIndex:atIndex] valueForKey:@"iPackageID"]] copy];
    
    //[SubclassInAppHelper sharedInstance];
    
    AppDel.isIndvidualPurchase = 0;
    //int indexs;
    NSString *strPromoCodeUsed;
    if(isAppliedPromoCode)
    {
        AppDel.strPromoCodeTrueFalse = @"true";
        strPromoCodeUsed = @"_WithDiscount";
    }
    else
    {
        AppDel.strPromoCodeTrueFalse = @"false";
        strPromoCodeUsed = @"";
    }
    
    NSString *strProductIdentifier;
    if (atIndex == 0)
    {
        strProductIdentifier = [NSString stringWithFormat:@"com.njjn.7Days%@",strPromoCodeUsed];
    }
    else if (atIndex == 1)
    {
        strProductIdentifier = [NSString stringWithFormat:@"com.njjn.1Month%@",strPromoCodeUsed];
    }
    else if (atIndex == 2)
    {
        strProductIdentifier = [NSString stringWithFormat:@"com.njjn.2Months%@",strPromoCodeUsed];
    }
    
    if ([strProductIdentifier isEqualToString:@"com.njjn.7Days_WithDiscount"])
    {
        [self sevenDaysWithDiscount];
        return;
    }
    
    SKProduct *product;
    for (product in AppDel._products)
    {
        if ([product.productIdentifier isEqualToString:strProductIdentifier])
        {
            break;
        }
    }
    //SKProduct *product = [AppDel._products objectAtIndex:indexs];
    AppDel.isAlertFromIAP = 1;
    [[SubclassInAppHelper sharedInstance] buyProduct: product];
}
- (void)getProducts
{
    [[SubclassInAppHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
     {
         if (success)
         {
             AppDel._products = [products copy];
             [AppDel dohideHUD];
             [self BuyProductCall];

         }
         else
         {
             [AppDel dohideHUD];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get product list or no in-app purchase found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
         }
     }];
}

-(void)sevenDaysWithDiscount
{
    AppDel.isAlertFromIAP = 0;
    if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"]isEqualToString:@"0"])
        {
            NSDate *Start_Date = [NSDate date];
            NSDateFormatter *date_format = [[NSDateFormatter alloc] init];
            [date_format setTimeZone:[NSTimeZone systemTimeZone]];
            [date_format setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *End_date = [Start_Date dateByAddingTimeInterval:60*60*24*7];
            
            NSString *strStart_Date = [date_format stringFromDate:Start_Date];
            NSString *strEnd_Date = [date_format stringFromDate:End_date];
            
            NSString* stringURl = [NSString stringWithFormat:@"http://openxcellaus.info/ipadmanager/ws/index.php?c=package&func=subscribepackage&iUserID=%@&iPackageID=%@&PromoCode=%@&dEndDate=%@&dStartDate=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"],AppDel.strPackegIdToSubscribe,AppDel.strPromoCodeTrueFalse,strEnd_Date,strStart_Date];
            
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
                     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:App_Name message:[NSString stringWithFormat:@"%@, your 7 Days subscription is  active until %@.",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]valueForKey:@"vFirstName"],strEnd_Date] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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

@end
