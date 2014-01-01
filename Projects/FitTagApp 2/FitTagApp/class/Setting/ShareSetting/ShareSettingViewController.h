//
//  ShareSettingViewController.h
//  FitTag
//
//  Created by apple on 3/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareSettingViewController : UIViewController{
    
}
@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;
@property (strong, nonatomic) IBOutlet UILabel *lbl3;
@property (strong, nonatomic) IBOutlet UISwitch *switchFacebook;
@property (strong, nonatomic) IBOutlet UISwitch *switchTwitter;
@property (strong, nonatomic) IBOutlet UISwitch *switchContect;

- (IBAction)facebookSettingChange:(id)sender;
- (IBAction)twitterSettingChanged:(id)sender;
- (IBAction)contactSettingZChanged:(id)sender;

@end
