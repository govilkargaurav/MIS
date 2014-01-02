//
//  DoNowViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoNowViewCtr : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scl_bg;
    NSMutableArray *ArrayTag;
    IBOutlet UILabel *lblTitle,*lbl1,*lbl2,*lblSettingHeading;
    IBOutlet UILabel *lblck1,*lblck2,*lblck3,*lblck4,*lblck5;
    // Lang Settings
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
}
@end
