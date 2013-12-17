//
//  SettingsViewController.h
//  MinutesInSeconds
//
//  Created by ChintaN on 7/31/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationSubclass.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AboutUsViewController.h"
@interface SettingsViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet  UIView *mainView;
}
- (IBAction)aboutUsButtonAction:(id)sender;
- (IBAction)feedBackButtonAction:(id)sender;
- (IBAction)privacypolicyAction:(id)sender;
@property (nonatomic, strong)NavigationSubclass *titleView;
@end
