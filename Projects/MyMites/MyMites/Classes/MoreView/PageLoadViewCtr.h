//
//  PageLoadViewCtr.h
//  MyMites
//
//  Created by Mac-i7 on 1/31/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PageLoadViewCtr : UIViewController
{
    IBOutlet UILabel *lblTitle,*lblMsg;
    IBOutlet UIWebView *webViewLoad;
    NSString *strLink,*strTitle;
}
@property(nonatomic,strong)NSString *strLink,*strTitle;
@end
