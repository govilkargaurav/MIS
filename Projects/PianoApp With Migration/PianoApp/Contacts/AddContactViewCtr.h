//
//  AddContactViewCtr.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DatabaseAccess.h"

@interface AddContactViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    AppDelegate *appdel;
    IBOutlet UITableView *tbl_AddContact;
    UILabel *lblSelect,*lblTitleSelect;
    UITextField *tfFname,*tfLname,*tfMobile,*tfHome,*tfHomePage,*tfCompany,*tfPhoneHome,*tfPhoneWork,*tfPhoneOther,*tfWorkEmail,*tfOtherEmail;
    NSString *strEdit,*strPassID;
    NSMutableArray *ArryViewCont;
    //Keyboard Done Button
    BOOL phoneTagOrNot;
    UIButton *doneButton;
    UILabel *lblTitle1,*lblTitle2,*lblTitle3,*lblTitle4,*lblTitle5,*lblTitle6,*lblTitle7,*lblTitle8;
    UIButton *btnMbile;
    
   // NSUInteger RowCountPhone,RowEmailCount;
    
}
@property (strong , nonatomic) NSString *strEdit,*strPassID;
@end
