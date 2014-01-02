//
//  ProductiivyViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/16/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductivityViewCtr : UIViewController
{
    IBOutlet UILabel *lblTitle,*lblSubTitle,*lblLink1,*lblLink2,*lbllineLink2,*lbllineLink11,*lbllineLink12;
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
    IBOutlet UIScrollView *scl_bg;
}
-(UILabel *)setLabelUnderline:(UILabel *)label;
-(void)updateui;
@end
