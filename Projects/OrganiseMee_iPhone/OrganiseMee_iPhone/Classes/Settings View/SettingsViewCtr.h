//
//  SettingsViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewCtr : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scl_bg;
    
    IBOutlet UILabel *lblTitle,*lblStartPage,*lblDoNowPage,*lblTaskSettings,*lblDateTime,*lblTimeZone,*lblLang,*lblSync,*lblLogut;
    
    // Lang Settings
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
}
@end
