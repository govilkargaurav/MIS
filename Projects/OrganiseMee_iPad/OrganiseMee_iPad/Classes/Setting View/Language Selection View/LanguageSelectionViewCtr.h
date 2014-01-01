//
//  LanguageSelectionViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageSelectionViewCtr : UIViewController
{
    NSString *strLang;
    IBOutlet UILabel *lblTitle,*lblHeading,*lblSettingHeading;
    
    // Lang Settings
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
}
@property(nonatomic,strong)NSString *strNav_Title;

@end
