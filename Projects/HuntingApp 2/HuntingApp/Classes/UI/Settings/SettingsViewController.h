//
//  SettingsViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
{
    UIView *titleView;
    IBOutlet UISegmentedControl *segmentedControl;
}


- (void)gotoFindFriendsController;
- (void)gotoFindLocationController;
- (IBAction)segmentValueChanged:(id)sender;

@end
