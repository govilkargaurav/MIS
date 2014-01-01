//
//  MainPage.h
//  AIS
//
//  Created by apple  on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadarView.h"
#import <QuartzCore/QuartzCore.h>

@interface MainPage : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *tblView;
    IBOutlet UITabBarController *tabBar;
	IBOutlet UITextView *desclaimer;
}
@property (nonatomic,retain)IBOutlet UITabBarController *tabBar;

-(IBAction)clickStart;
@end
