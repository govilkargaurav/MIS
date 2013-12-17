//
//  AboutUsViewController.h
//  MinutesInSeconds
//
//  Created by KPIteng on 9/18/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationSubclass.h"

@interface AboutUsViewController : UIViewController
{
    IBOutlet UITextView *txtView;
}
@property(nonatomic,strong)NavigationSubclass *titleView;
@end
