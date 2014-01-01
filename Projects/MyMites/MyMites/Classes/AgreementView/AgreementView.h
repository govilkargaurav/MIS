//
//  AgreementView.h
//  MyMite
//
//  Created by Vivek Rajput on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"
@interface AgreementView : UIViewController
{
    IBOutlet UIButton *btnCheck;
    int checkTag;
}
#pragma mark - Agreement
-(IBAction)btnCheckClick:(id)sender;
-(IBAction)btnAgreeClick:(id)sender;

@end
