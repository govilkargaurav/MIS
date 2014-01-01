//
//  NotificationSetViewController.h
//  FitTag
//
//  Created by apple on 3/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface NotificationSetViewController : UIViewController{
    
    IBOutlet UILabel *lbl1;
    IBOutlet UILabel *lbl2;
    IBOutlet UILabel *lbl3;
        IBOutlet UILabel *lbl4;
        IBOutlet UILabel *lbl5;
    
}
@property (strong, nonatomic) IBOutlet UISwitch *switchLike;
@property (strong, nonatomic) IBOutlet UISwitch *switchMention;
@property (strong, nonatomic) IBOutlet UISwitch *switchComment;
@property (strong, nonatomic) IBOutlet UISwitch *switchFollow;

-(IBAction)chamgePushNotificationSetting:(UISwitch *)switchNotification;
-(void)changeNotificarionSettingOnOff:(NSString *)strswitchValue fieldName:(NSString *)strFieldName;

@end
