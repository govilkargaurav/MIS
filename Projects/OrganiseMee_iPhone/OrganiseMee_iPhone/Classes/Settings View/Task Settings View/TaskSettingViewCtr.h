//
//  TaskSettingViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskSettingViewCtr : UIViewController
{
    IBOutlet UIScrollView *scl_bg;
    NSMutableArray *ArrayTag;
    IBOutlet UILabel *lblTitle,*lblHeading,*lblSettingHeading;
    IBOutlet UILabel *lblDisplayPri;
    IBOutlet UILabel *lblDisplayDueDate;
    IBOutlet UILabel *lblDisplayReminder;
    IBOutlet UILabel *lblDisplayResponsible;
    // Lang Settings
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
}
@end
