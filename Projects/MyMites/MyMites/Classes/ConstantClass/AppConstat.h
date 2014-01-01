//
//  AppConstat.h
//  FM Host
//
//  Created by Surya on 12/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define kWebServiceUrl @""
// UIAlertView methods

//alert with only message
#define DisplayAlert(msg) { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }

//alert with message and title
#define DisplayAlertWithTitle(title,msg){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }

#define DisplayNoInternate {UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"My M8tes" message:@"oops!!!There is a problem in the internet connection!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }

//alert with only localized message
#define DisplayLocalizedAlert(msg){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(msg,@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }

//alert with localized message and title
#define DisplayLocalizedAlertWithTitle(msg,title){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title,@"") message:NSLocalizedString(msg,@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/256.0f green:(g)/256.0f blue:(b)/256.0f alpha:1.0f]

#define RGBCOLOR_TECT [UIColor colorWithRed:87/256.0f green:33/256.0f blue:125/256.0f alpha:1.0f]
#define APP_Name @"myM8te"
#define APP_URL @"http://mym8te.com/andy/"
