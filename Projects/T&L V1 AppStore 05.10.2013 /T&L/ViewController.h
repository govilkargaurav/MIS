//
//  ViewController.h
//  T&L
//
//  Created by openxcell tech.. on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabbarViewController_1.h"
#import "DatabaseAccess.h"

@interface ViewController : UIViewController
{
    AppDelegate *appDel;
    NSMutableDictionary *statuses,*dictResouctID,*dictContex,*dictTPartyReports,*dictSysValidation,*dictResults,*dictResultsOptions;
    NSMutableArray *tempArray1;
    IBOutlet UITextField *tfSearchText;
    UIPopoverController *popoverController;
    
    IBOutlet UIImageView *iv1,*iv2;
    IBOutlet UILabel *lblAssessmentResources;
    
}
@property(nonatomic,strong)NSURLRequest *request;
-(IBAction)goToResourceView:(id)sender;
@end
