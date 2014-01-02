//
//  AppConstat.h
//  FM Host
//
//  Created by Apple on 12/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


// UIAlertView methods

//alert with only message
#define DisplayAlert(msg) { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }
//alert with message and title
#define DisplayAlertWithTitle(title,msg){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }
//alert with only localized message
#define DisplayLocalizedAlert(msg){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(msg,@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }
//alert with localized message and title
#define DisplayLocalizedAlertWithTitle(msg,title){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title,@"") message:NSLocalizedString(msg,@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }

//Internet  Connection alert with only message
#define DisplayAlertconnection { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"No internet connection.You can access limited functionality." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }

//Screen size
#define screenSize  [[UIScreen mainScreen] bounds]

//Base Url
//#define WebURL @"http://openxcellaus.info/ipadmanager/ws/index.php?"
#define WebURL @"http://app.dnpsolutions.com/ipadmanager/ws/index.php?"
// App Name
#define App_Name @"DNPS"


//com.dnps.app



