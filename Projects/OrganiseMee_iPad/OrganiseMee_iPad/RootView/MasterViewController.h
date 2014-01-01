//
//  MasterViewController.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/15/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MasterViewController : UIViewController
{
    //Label for Language Heading
    IBOutlet UILabel *lbllngEng,*lbllngGerm;
    
    //Button for Language Selection
    IBOutlet UIButton *btnEnglish,*btnGerman;
}
-(void)navigationToLoginView:(NSString*)strLang;
@end
