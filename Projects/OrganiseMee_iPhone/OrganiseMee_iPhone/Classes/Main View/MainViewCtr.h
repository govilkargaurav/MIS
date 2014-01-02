//
//  MainViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/10/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewCtr : UIViewController <UIScrollViewDelegate>
{
    
    IBOutlet UIScrollView *scl_bg;
    
    IBOutlet UILabel *lbl1,*lbl2,*lbl3;
    
    IBOutlet UIButton *btnLogin,*btnRegister;
    
    // Lang Settings
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
}
@end
