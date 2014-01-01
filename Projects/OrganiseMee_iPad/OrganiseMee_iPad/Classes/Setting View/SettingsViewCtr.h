//
//  SettingsViewCtr.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 9/2/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewCtr : UIViewController
{
    // Lang Settings
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
    IBOutlet UILabel *lblHeader;
     IBOutlet UILabel *lblDateTime,*lblTimeZone,*lblAutoSync,*lblLang,*lblInfo,*lblLogout;
}
@end
