//
//  ProductivityWebViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/16/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductivityWebViewCtr : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webview;
    NSString *strLink;
}
@property(nonatomic,strong)NSString *strLink;
@end
