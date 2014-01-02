//
//  TermsConditionViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/10/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TermsConditionViewCtr : UIViewController <UITextViewDelegate>
{
    IBOutlet UITextView *txtTerms;
    IBOutlet UILabel *lblTermsTitle;
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
    IBOutlet UIScrollView *scl_bg;
}
@end
