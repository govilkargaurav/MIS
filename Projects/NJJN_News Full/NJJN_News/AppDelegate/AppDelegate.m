//
//  AppDelegate.m
//  NJJN_News
//
//  Created by Mac-i7 on 6/18/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalMethods.h"
#define UDIDKey @"CreatedUDID"

NSString *kDataBaseName = @"NJJN_DB";
NSString *kDataBaseExt = @"sqlite";

@implementation AppDelegate

@synthesize popOverUserObj = _popOverUserObj;
@synthesize popOverSignInObj = _popOverSignInObj;
@synthesize popOverSubscriptionObj = _popOverSubscriptionObj;

@synthesize tabBarController = _tabBarController;
@synthesize window = _window;
//@synthesize InternetConnectionFlag;
@synthesize isIndvidualPurchase;
@synthesize hud = _hud;
@synthesize imageView1 = _imageView1,imageView2 = _imageView2,imageView3 = _imageView3,imageView4 = _imageView4,imageView5 = _imageView5,imageView6 = _imageView6;
@synthesize dataBasePath;
@synthesize firstDictReceipt;
@synthesize arrPdf,downloadingArray;
@synthesize popOverFlag;
@synthesize strPurchaseOperation;
@synthesize _priceFormatter;
@synthesize isAlertFromIAP;

@synthesize arPackageList,_products,usedPromoCode,YesNo;

#pragma mark - Application Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setIdleTimerDisabled:YES];
    
     [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    
    self.isAlertFromIAP = 0;
    
    _products = [[NSArray alloc]init];
    
    self.popOverFlag = 0;
    
    self.tabBarController.delegate = self;
    
    [self finalUDIDSting];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    NSString *databaseFile=[[NSBundle mainBundle] pathForResource:kDataBaseName ofType:kDataBaseExt];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *dbPath=[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",kDataBaseName,kDataBaseExt]];
	NSFileManager *fm=[NSFileManager defaultManager];
	
	if(![fm fileExistsAtPath:dbPath])
    {
		[fm copyItemAtPath:databaseFile toPath:dbPath error:nil];
	}
	
    self.dataBasePath=dbPath;
        
    _tabBarController.selectedIndex = 0;
    
    [self.window makeKeyAndVisible];
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"])
    {
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"])
    {
        [self performSelector:@selector(finalUDIDSting) withObject:nil afterDelay:0.1];
    }
    else
    {
        [self doshowHUD];
        [self performSelector:@selector(LogoutButtonMethodLastPDF) withObject:nil afterDelay:0.1];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark - Tabbar Delegate

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self UpdateNewsStandCover];
}

#pragma mark - Tabbar Customization

-(void)TabBarCustomizationImages
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0)
    {
        _tabBarController.tabBar.backgroundImage=[UIImage imageNamed:@"tabBG.png"];
    }
    else
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBG.png"]];
        [_tabBarController.tabBar insertSubview:imageView atIndex:0];
    }
    
    _imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home.png"]];
    [_imageView1 setFrame:CGRectMake(50, 0, 60 , 49)];
    [_tabBarController.tabBar insertSubview:_imageView1 atIndex:1];

    
    _imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"issues.png"]];
    [_imageView2 setFrame:CGRectMake(150, 0, 60 , 49)];
    [_tabBarController.tabBar insertSubview:_imageView2 atIndex:2];
    
    _imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"download.png"]];
    [_imageView3 setFrame:CGRectMake(250, 0, 60 , 49)];
    [_tabBarController.tabBar insertSubview:_imageView3 atIndex:3];
    
    _imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact.png"]];
    [_imageView4 setFrame:CGRectMake(350, 0, 60 , 49)];
    [_tabBarController.tabBar insertSubview:_imageView4 atIndex:4];
    
    _imageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings.png"]];
    [_imageView5 setFrame:CGRectMake(450, 0, 60 , 49)];
    [_tabBarController.tabBar insertSubview:_imageView5 atIndex:5];
    
    _imageView6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"infoTab.png"]];
    [_imageView6 setFrame:CGRectMake(550, 0, 60 , 49)];
    [_tabBarController.tabBar insertSubview:_imageView6 atIndex:6];
}



#pragma mark - MBProgressHUD AlertHandler
- (void)doshowHUD
{
	[self performSelectorOnMainThread:@selector(doshowLoadingView) withObject:nil waitUntilDone:NO];
}
- (void)dohideHUD
{
    [self performSelectorOnMainThread:@selector(dohideLoadingView) withObject:nil waitUntilDone:NO];
    
}
- (void)showLoadingView
{
    [self performSelectorOnMainThread:@selector(doshowLoadingView) withObject:nil waitUntilDone:NO];
    
}
- (void)hideLoadingView
{
    [self performSelectorOnMainThread:@selector(dohideLoadingView) withObject:nil waitUntilDone:NO];
}

- (void)doshowLoadingView
{
    _hud=[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    _hud.mode=MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Loading...";
}

- (void)dohideLoadingView
{
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
}



#pragma mark - Push Notification

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *strDeviceToken = [[[[[deviceToken description]stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString:@" " withString: @""]copy];
    [[NSUserDefaults standardUserDefaults] setObject:strDeviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{    
    if([userInfo valueForKey:@"aps"])
    {
        if([[userInfo valueForKey:@"aps"] valueForKey:@"alert"])
        {
            self.tabBarController.selectedIndex = 1;
        }
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

#pragma mark - Update Cover Page

-(void)UpdateNewsStandCover
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_async (concurrentQueue,
    ^{
        NSString* urlString = @"";
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"])
        {
            urlString = [NSString stringWithFormat:@"%@c=pdf&func=lastPdf&vUdid=%@&iUserID=%@",WebURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceUDID"],[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"]];
        }
        else
        {
            urlString = [NSString stringWithFormat:@"%@c=pdf&func=lastPdf&vUdid=%@&iUserID=%@",WebURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceUDID"],@"0"];
        }
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        NSData *responseData1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        if(responseData1)
        {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData1 options:kNilOptions error:nil];
            
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[responseDict valueForKey:@"vPdfImage"]]];
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            [[NSUserDefaults standardUserDefaults] setObject:responseDict forKey:@"UserInfo"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [[UIApplication sharedApplication] setNewsstandIconImage:[UIImage imageWithData:image]];
 
                if([[responseDict valueForKey:@"isSubscribed"] isEqualToString:@"false"] && [[responseDict valueForKey:@"eTrialFlag"] isEqualToString:@"false"])
               {
                   if(_tabBarController.selectedIndex == 1)
                   {
                       if ([AppDel.downloadingArray count] == 0)
                       {
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"loadPDFDataAgain" object:nil];
                       }
                   }
               }
            });
        }
    });
}

-(void)LogoutButtonMethodLastPDF
{
   NSString* urlString = @"";
   if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"])
   {
       urlString = [NSString stringWithFormat:@"%@c=pdf&func=lastPdf&vUdid=%@&iUserID=%@",WebURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceUDID"],[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"]];
   }
   else
   {
       urlString = [NSString stringWithFormat:@"%@c=pdf&func=lastPdf&vUdid=%@&iUserID=%@",WebURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceUDID"],@"0"];
   }
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
     {
         if (error)
         {
             [self dohideHUD];
             UIAlertView *obj_Alert = [[UIAlertView alloc]initWithTitle:App_Name message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
             [obj_Alert show];
             return;
         }
         else
         {
             if(response)
             {
                 NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
                 
                 if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"])
                 {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                 }
                 [[NSUserDefaults standardUserDefaults] setObject:responseDict forKey:@"UserInfo"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 NSString *streTrialFlag = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"eTrialFlag"]];
                 NSString *strisSubscribed  = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"isSubscribed"]];
                 NSString *strreceipt = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"receipt"]];
                 NSString *striUserID = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"iUserID"]];
               
                 if ([streTrialFlag isEqualToString:@"false"] && [strisSubscribed isEqualToString:@"false"] && [strreceipt length] > 0 && ![striUserID isEqualToString:@"0"])
                 {
                     [GlobalMethods VerifyReceipt:strreceipt];
                 }
                 else
                 {
                     [self dohideHUD];
                 }
                 
                 if([AppDel.downloadingArray count] == 0)
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"loadPDFDataAgain" object:nil];  
                 }
                 
             }
         }
     }];
}



#pragma mark - Open User PopOverController

-(IBAction)OpenUserPopOverController:(id)sender
{
    if( ![self checkConnection])
    {
        DisplayAlertconnection;
        return;
    }
    else
    {
        if ([AppDel.downloadingArray count] > 0)
        {
            DisplayAlertWithTitle(App_Name, @"Download in progress. Please complete or cancel all downloads.");
        }
        else
        {
            self.popOverFlag = 1;
            UIButton* button = (UIButton *)sender;
            //UIView* tmpView = button.superview;
            int x = self.tabBarController.selectedIndex;
            UIViewController *viewctr = (UIViewController *)[self.tabBarController.viewControllers objectAtIndex:x];
            if([_popOverUserObj isPopoverVisible])
            {
                [_popOverUserObj presentPopoverFromRect:button.frame inView:[viewctr view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                UserInfoViewController* objUserInfoViewControlle = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
                _popOverUserObj = [[UIPopoverController alloc] initWithContentViewController:objUserInfoViewControlle];
                [self SetPopOverContentSize];
                _popOverUserObj.delegate = self;
                [_popOverUserObj presentPopoverFromRect:button.frame inView:[viewctr view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
        }
    }
}

-(void)SetPopOverContentSize
{
    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"isSubscribed"] isEqualToString:@"true"] || [[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"eTrialFlag"] isEqualToString:@"true"])
    {
        if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"vType"] isEqualToString:@"Print"])
        {
            [_popOverUserObj setPopoverContentSize:CGSizeMake(268, 180) animated:YES];
        }
        else
        {
            if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]valueForKey:@"iUserID"]isEqualToString:@"0"] )
            {
                [_popOverUserObj setPopoverContentSize:CGSizeMake(268, 285-50) animated:YES];
            }
            else
            {
                [_popOverUserObj setPopoverContentSize:CGSizeMake(268, 180) animated:YES];
            }
        }
    }
    else
    {
        if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"]valueForKey:@"iUserID"]isEqualToString:@"0"])
        {
            if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"vType"] isEqualToString:@"Print"])
            {
                [_popOverUserObj setPopoverContentSize:CGSizeMake(268, 180) animated:YES];
            }
            else
            {
                [_popOverUserObj setPopoverContentSize:CGSizeMake(268, 285) animated:YES];
            }
        }
        else
        {
            [_popOverUserObj setPopoverContentSize:CGSizeMake(268, 180) animated:YES];
        }
    }
}
-(IBAction)CloseUserPopOverController:(id)sender
{
    if([_popOverUserObj isPopoverVisible])
    {
        self.popOverFlag = 0;
        [_popOverUserObj dismissPopoverAnimated:YES];
    }

}

-(IBAction)OpenSignInPopOverController:(id)sender
{
    if(![[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] valueForKey:@"iUserID"] isEqualToString:@"0"])
    {
        [sender setTitle:@"Sign In" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"UserInfo"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self CloseUserPopOverController:self];
        [self doshowHUD];
        [self performSelector:@selector(LogoutButtonMethodLastPDF) withObject:nil afterDelay:0.1];
    }
    else
    {
        [self CloseUserPopOverController:self];
        int x = self.tabBarController.selectedIndex;
        UIViewController *viewctr = (UIViewController *)[self.tabBarController.viewControllers objectAtIndex:x];
        if([_popOverSignInObj isPopoverVisible])
        {
            [_popOverSignInObj presentPopoverFromRect:CGRectMake(viewctr.view.center.x, viewctr.view.center.y, 10, 10) inView:[viewctr view] permittedArrowDirections:0 animated:YES];
        }
        else
        {
            SignInViewController* objSignInViewController = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
            UINavigationController *obj_nav = [[UINavigationController alloc]initWithRootViewController:objSignInViewController];
            _popOverSignInObj = [[UIPopoverController alloc] initWithContentViewController:obj_nav];
            [_popOverSignInObj setPopoverContentSize:CGSizeMake(399, 550) animated:YES];
            [_popOverSignInObj presentPopoverFromRect:CGRectMake(viewctr.view.center.x, viewctr.view.center.y, 10, 10) inView:[viewctr view] permittedArrowDirections:0 animated:YES];
        }
    }
}

-(IBAction)OpenSubscriptionPopOverController:(id)sender
{
    [self CloseUserPopOverController:self];
    int x = self.tabBarController.selectedIndex;
    UIViewController *viewctr = (UIViewController *)[self.tabBarController.viewControllers objectAtIndex:x];
    if([_popOverSubscriptionObj isPopoverVisible])
    {
        [_popOverSubscriptionObj presentPopoverFromRect:CGRectMake(viewctr.view.center.x, viewctr.view.center.y, 10, 10) inView:[viewctr view] permittedArrowDirections:0 animated:YES];
    }
    else
    {
        SubscribeViewController* objSubscribeViewController = [[SubscribeViewController alloc] initWithNibName:@"SubscribeViewController" bundle:nil];
        UINavigationController *obj_nav = [[UINavigationController alloc]initWithRootViewController:objSubscribeViewController];
        _popOverSubscriptionObj = [[UIPopoverController alloc] initWithContentViewController:obj_nav];
        [_popOverSubscriptionObj setPopoverContentSize:CGSizeMake(482, 462) animated:YES];
        [_popOverSubscriptionObj presentPopoverFromRect:CGRectMake(viewctr.view.center.x, viewctr.view.center.y, 10, 10) inView:[viewctr view] permittedArrowDirections:0 animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController;
{
    if(popoverController == _popOverUserObj)
    {
        self.popOverFlag = 0;
    }
}


#pragma mark - UDID Keychain

- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

- (void)finalUDIDSting
{
    NSString *previousUDID;
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    previousUDID = [NSString stringWithFormat:@"%@",[bindings objectForKey:UDIDKey]];
    if ([[previousUDID StringNotNullValidation] isEqualToString:@""])
    {
        NSString* deviceUDID = [[self GetUUID] copy];
        [bindings setObject:deviceUDID forKey:UDIDKey];
        [[NSUserDefaults standardUserDefaults] setValue:deviceUDID forKey:@"DeviceUDID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:previousUDID forKey:@"DeviceUDID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self WSDeviceTokenCall];
}


#pragma mark - Device Token WS Call

-(void)WSDeviceTokenCall
{
    [AppDel doshowHUD];
    NSDate *now_date = [NSDate date];
    NSDateFormatter *date_format = [[NSDateFormatter alloc] init];
    [date_format setDateFormat:@"yyyy-MM-dd"];
    [date_format setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *str_current_date = [date_format stringFromDate:now_date];
    
    NSString *str_DeviceToken = [NSString stringWithFormat:@"%@c=user&func=addUdid&vUdid=%@&dDateTime=%@",WebURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceUDID"],str_current_date];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str_DeviceToken stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
     {
         if (error)
         {
             UIAlertView *obj_Alert = [[UIAlertView alloc]initWithTitle:App_Name message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Working offline", nil];
             [obj_Alert show];
             [AppDel dohideHUD];
         }
         else
         {
             if(!response)
             {
                 UIAlertView *obj_Alert = [[UIAlertView alloc]initWithTitle:App_Name message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Working offline", nil];
                 [obj_Alert show];
                  [AppDel dohideHUD];
                  return;
             }
             NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
             NSString *strMsg = [dicResult valueForKey:@"message"];
             if ([strMsg isEqualToString:@"DEVICE TOKEN ADDED"])
             {
                 [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"NotificationOnOff"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
             else if ([strMsg isEqualToString:@"DEVICE TOKEN FOUND"])
             {
                 if ([[dicResult valueForKey:@"eNotification"] isEqualToString:@"on"])
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"NotificationOnOff"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else if ([[dicResult valueForKey:@"eNotification"] isEqualToString:@"off"])
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"NotificationOnOff"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
             }
              [self performSelector:@selector(UpdateDeviceTokenWithUDID) withObject:nil afterDelay:0.2];
         }
     }];
}


#pragma mark - Update Token for UDID

-(void)UpdateDeviceTokenWithUDID
{
    NSString *str_DeviceToken = [NSString stringWithFormat:@"%@c=user&func=addDeviceToken&vDeviceToken=%@&vUdid=%@",WebURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"],[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceUDID"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[str_DeviceToken stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlresponse, NSData *response, NSError *error)
     {
         if (error)
         {
             [AppDel dohideHUD];
             DisplayAlertWithTitle(App_Name, [error localizedDescription]);
             return;
         }
         else
         {
             if(!response)
             {
                 [AppDel dohideHUD];
                 return;
             }
             NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
             if([[dicResult valueForKey:@"message"] isEqualToString:@"DEVICE TOKEN ADDED"])
             {
                [self doshowHUD];
                [self performSelector:@selector(LogoutButtonMethodLastPDF) withObject:nil afterDelay:0.1];
             }
             else
             {
                [self dohideHUD];
             }
         }
    }];
}


-(IBAction)ChangeSignInFrameInOrientation:(id)sender
{
    int x = self.tabBarController.selectedIndex;
    UIViewController *viewctr = (UIViewController *)[self.tabBarController.viewControllers objectAtIndex:x];
    [_popOverSignInObj presentPopoverFromRect:CGRectMake(viewctr.view.center.x, viewctr.view.center.y, 10, 10) inView:[viewctr view] permittedArrowDirections:0 animated:YES];
}

-(IBAction)ChangeSubscriptionFrameInOrientation:(id)sender
{
    int x = self.tabBarController.selectedIndex;
    UIViewController *viewctr = (UIViewController *)[self.tabBarController.viewControllers objectAtIndex:x];
    [_popOverSubscriptionObj presentPopoverFromRect:CGRectMake(viewctr.view.center.x, viewctr.view.center.y, 10, 10) inView:[viewctr view] permittedArrowDirections:0 animated:YES];}

/*#pragma mark - Alertview Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self WSDeviceTokenCall];
    }
    else if (alertView.tag == 20)
    {
        [self LogoutButtonMethodLastPDF];
    }
}*/
- (BOOL) checkConnection {
	const char *host_name = "www.google.com";
    BOOL _isDataSourceAvailable = NO;
    Boolean success;
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL,host_name);
	SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    _isDataSourceAvailable = success &&
	(flags & kSCNetworkFlagsReachable) &&
	!(flags & kSCNetworkFlagsConnectionRequired);
	
    CFRelease(reachability);
	
    return _isDataSourceAvailable;
}
@end
