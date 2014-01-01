//
//  MainViewCtrViewController.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/15/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewCtrViewController : UIViewController <UIScrollViewDelegate>
{
    
    IBOutlet UIScrollView *scl_bg;
    
    IBOutlet UILabel *lblwelcome;
    IBOutlet UILabel *lblthanku;
    IBOutlet UILabel *lblorganisemee;
    IBOutlet UILabel *lblyou;
    IBOutlet UILabel *lblplease;
    
    IBOutlet UIButton *btnLogin,*btnRegister;
    
    // Lang Settings
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
}

@end
