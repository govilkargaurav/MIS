//
//  LogoutViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoutViewCtr : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scl_bg;
    IBOutlet UIButton *btnLogut;
    IBOutlet UILabel *lbl1,*lbl2,*lblTitle,*lblSettingHeading;
    
    // Lang Settings
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
}
@end
