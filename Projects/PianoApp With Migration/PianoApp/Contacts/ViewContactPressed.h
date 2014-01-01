//
//  ViewContactPressed.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
#import <MessageUI/MessageUI.h>

@interface ViewContactPressed : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    IBOutlet UITableView *tbl_ViewCont;
    NSString *strID;
    NSMutableArray *ArryViewCont,*ArryLblPhone,*ArryPhoneValue,*ArrylblEmail,*ArryEmailValue;
    NSString *strPhoneNumber;
    IBOutlet UIButton *btnFav;
}
@property(strong , nonatomic)NSString *strID;
-(void)GetValues;
-(void)CallToPhoneNumbers:(NSString*)strPhoneNumberPass;
-(void)CallToEmail:(NSString*)strEmailID;
@end
