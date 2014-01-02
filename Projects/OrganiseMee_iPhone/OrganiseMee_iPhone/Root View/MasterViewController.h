//
//  MasterViewController.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/10/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MasterViewController : UIViewController
{
    //Label for Language Heading
    IBOutlet UILabel *lbllngEng,*lbllngGerm;
    
    //Button for Language Selection
    IBOutlet UIButton *btnEnglish,*btnGerman;
    
    IBOutlet UIScrollView *scl_bg;
}
-(void)navigationToLoginView:(NSString*)strLang;
@end
