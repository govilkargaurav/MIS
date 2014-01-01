//
//  SettingViewController.h
//  FitTagApp
//
//  Created by apple on 2/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"


@interface SettingViewController : UIViewController<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>{
    BOOL isLogedOut;

}
@property(strong, nonatomic) IBOutlet UITableView *tblSetting;
@property(strong, nonatomic) IBOutlet UIView *viewMenu;
@property(nonatomic)bool isOpen;

-(void)viewMenuOpenAnim;
-(void)viewMenuCloseAnim;
-(void)animationForLogout;
@end
