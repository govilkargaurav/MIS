//
//  WebSiteViewController.h
//  NewsStand
//
//  Created by openxcell technolabs on 5/7/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"
#import "AppDelegate.h"

@interface WebSiteViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *webViewObj;
    IBOutlet UIButton *btnCancel;
    
    IBOutlet UIActivityIndicatorView* actObj;
    
    int flagOrientation;
    
    IBOutlet UIImageView* imgHeader;
    
    NSString *strLink;
}

@property (nonatomic,strong)NSString *strLink;
-(IBAction)ClickBtnCancel:(id)sender;

@end
