//
//  TimeZoneViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeZoneViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *ArryTimeZone,*ArryretriveUserSettings;
    IBOutlet UITableView *tbl_TimeZone;
    IBOutlet UILabel *lblTitle,*lblHeading,*lblSettingHeading;
    int selectedindex;
    
    // Lang Settings
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
    IBOutlet UIScrollView *scl_bg;
}
@end
