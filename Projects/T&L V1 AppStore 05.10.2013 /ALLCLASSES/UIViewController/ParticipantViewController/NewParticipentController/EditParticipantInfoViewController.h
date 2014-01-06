//
//  EditParticipantInfoViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 11/28/12.
//
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
@interface EditParticipantInfoViewController : UIViewController
{
    IBOutlet UITextField *participantsNameField;
    IBOutlet UITextField *jobTitleField;
    IBOutlet UITextField *companyField;
    IBOutlet UITextField *empIdStuIdField;
    IBOutlet UITextField *addressField;
    IBOutlet UITextField *suburbCityField;
    IBOutlet UITextField *stateField;
    IBOutlet UITextField *postcodeField;
    IBOutlet UITextField *countryField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *phoneNoField;
    IBOutlet UITextField *superviserFiled;
    
    NSMutableArray *aryParticipantInfoEditMode;
}
@end
