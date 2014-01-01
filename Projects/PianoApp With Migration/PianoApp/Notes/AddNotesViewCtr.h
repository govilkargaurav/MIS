//
//  AddNotesViewCtr.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
#import "NoteView.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface AddNotesViewCtr : UIViewController <UITextViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    IBOutlet UILabel *lblDate,*lblTime,*lblLockedSince;
    IBOutlet UIButton *btnEditable;
    NSString *strEdit,*strPassID,*strCompreNote;
    NoteView *note;
    IBOutlet UIToolbar *toolBar;
    NSString *strDate;
    
    NSString *strEditableStatus;
    
    //Encrypt And Send With Password
    IBOutlet UIView *ViewPass;
    IBOutlet UITextField *tfPassword;
    BOOL isPasswordInclude;
    
    IBOutlet UIButton *btnExport;
    IBOutlet UILabel *lblTopGray;
}
@property (strong , nonatomic) NSString *strEdit,*strPassID;
-(void)SaveNotes;

-(void)ResignAndSave;
@end
