//
//  AssessorTypeViewController.h
//  TLISC
//
//  Created by KPIteng on 5/1/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GlobleClass.h"
@interface AssessorTypeViewController : UIViewController{
    IBOutlet UILabel *lblUnitName,*lblUnitInfo,*lblIconName;
    IBOutlet UIImageView *ivIcon;
    
    AppDelegate *appDel;
    
    //---TopBar Selected
    IBOutlet UIImageView *ivTopBarSelected;
    
    NSString *strNextPushController;
}
@property (nonatomic, strong) NSString *strNextPushController;
- (IBAction)btnNewAssessorTapped:(id)sender;
- (IBAction)btnExistingAssessorTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;
@end
