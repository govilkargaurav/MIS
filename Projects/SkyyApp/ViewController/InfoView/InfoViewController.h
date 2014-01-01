//
//  InfoViewController.h
//  SkyyApp
//
//  Created by Vishal Jani on 9/3/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
@interface InfoViewController : UIViewController{

    IBOutlet UIScrollView *srcView;
    IBOutlet UIButton *btnStart;
}
@property(nonatomic)BOOL isSetting;
@end
