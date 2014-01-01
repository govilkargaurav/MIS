//
//  SettingsViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DejalActivityView.h"
@interface SettingsViewController : UIViewController<RequestWrapperDelegate>

{
    WebServices *webServices;
    UIView *titleView;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UISwitch *switchPushAlerts;
    IBOutlet UISwitch *switchImgUploadPushAlerts;
    DejalBezelActivityView *loadingActivityIndicator;
    Profile *userProfile;
}

@property (nonatomic,strong)NSMutableDictionary *userInfo;
- (void)gotoFindFriendsController;
- (void)gotoFindLocationController;
- (IBAction)segmentValueChanged:(id)sender;

@end
