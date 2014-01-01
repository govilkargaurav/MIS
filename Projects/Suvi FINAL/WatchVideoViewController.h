//
//  WatchVideoViewController.h
//  Suvi
//
//  Created by Vivek Rajput on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
@interface WatchVideoViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *webV;
}

@property(nonatomic,retain)NSString *imgURLPOST;
-(IBAction)Back:(id)sender;
- (void)videoFullScreen:(id)sender;
- (void)videoExitFullScreen:(id)sender;

@end
