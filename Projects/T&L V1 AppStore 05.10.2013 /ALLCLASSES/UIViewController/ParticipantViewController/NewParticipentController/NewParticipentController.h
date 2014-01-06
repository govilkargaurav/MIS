//
//  NewParticipentController.h
//  T&L
//
//  Created by openxcell tech.. on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewParticipentController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
{
    
    IBOutlet UITextField *participantsNameField,*jobTitleField,*companyField,*empIdStuIdField,*addressField,*suburbCityField,*stateField,*postcodeField,*countryField,*emailField,*phoneNoField,*superviserFiled;
    IBOutlet UILabel *lblUnitName,*lblUnitInfo,*lblIconName;
    IBOutlet UIImageView *ivIcon;
    IBOutlet UIScrollView *scrNewParticipant;
    
    UIPopoverController *popoverController;
    //---TopBar Selected
    IBOutlet UIImageView *ivTopBarSelected;

}

-(void)newView;

@end
