//
//  NewPassWordsViewCtr.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DatabaseAccess.h"
#import "AESCrypt.h"

@interface NewPassWordsViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    AppDelegate *appdel;
    IBOutlet UITableView *tbl_newPass;
    UILabel *lblSelect,*lblTitleSelect;
    UITextField *tfTitle,*tfUsrname,*tfPass,*tfHint,*tfUrl;
    NSString *strEdit,*strPassID;
    NSMutableArray *ArryViewPass;
}
@property (strong , nonatomic) NSString *strEdit,*strPassID;
@end
